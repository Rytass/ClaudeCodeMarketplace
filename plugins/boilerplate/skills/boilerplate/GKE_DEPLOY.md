# GKE Deployment Boilerplate — Docker, Kubernetes, Traefik, GitHub Actions

## Multi-Stage Dockerfile

Supports both API and Client builds via the `TARGET` build arg.

```dockerfile
# Stage 1: Dependencies
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN corepack enable && pnpm install --frozen-lockfile

# Stage 2: Builder
FROM node:20-alpine AS builder
ARG TARGET
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN corepack enable && pnpm exec nx build ${TARGET}

# Stage 3: Production (API)
FROM node:20-alpine AS production-api
WORKDIR /app
COPY --from=builder /app/dist/apps/api ./
RUN corepack enable && pnpm install --prod --frozen-lockfile
EXPOSE 6001
CMD ["node", "main.js"]

# Stage 3: Production (Client - Next.js standalone)
FROM node:20-alpine AS production-client
WORKDIR /app
COPY --from=builder /app/apps/client/.next/standalone ./
COPY --from=builder /app/apps/client/.next/static ./apps/client/.next/static
COPY --from=builder /app/apps/client/public ./apps/client/public
EXPOSE 7001
ENV PORT=7001
CMD ["node", "apps/client/server.js"]
```

Build commands:

```bash
# API image
docker build --target production-api --build-arg TARGET=api -t my-project-api:latest .

# Client image
docker build --target production-client --build-arg TARGET=client -t my-project-client:latest .
```

## Kubernetes Deployment — `k8s/deployment.yaml`

Dual-container Pod with API and Client sharing localhost. Includes Vault env injection via annotations.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {project}-deployment
  labels:
    app: {project}
spec:
  replicas: 2
  selector:
    matchLabels:
      app: {project}
  template:
    metadata:
      labels:
        app: {project}
      annotations:
        vault.hashicorp.com/agent-inject: "true"
        vault.hashicorp.com/role: "{project}"
        vault.hashicorp.com/agent-inject-secret-config: "secret/data/{project}"
        vault.hashicorp.com/agent-inject-template-config: |
          {{- with secret "secret/data/{project}" -}}
          {{- range $k, $v := .Data.data }}
          export {{ $k }}={{ $v }}
          {{- end }}
          {{- end }}
    spec:
      imagePullSecrets:
        - name: gar-pull-secret
      containers:
        - name: api
          image: {gar-registry}/{project}-api:{tag}
          ports:
            - containerPort: 6001
              name: api
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 500m
              memory: 512Mi
          livenessProbe:
            httpGet:
              path: /healthcheck
              port: 6001
            initialDelaySeconds: 15
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /healthcheck
              port: 6001
            initialDelaySeconds: 5
            periodSeconds: 5
        - name: client
          image: {gar-registry}/{project}-client:{tag}
          ports:
            - containerPort: 7001
              name: client
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 500m
              memory: 512Mi
          livenessProbe:
            httpGet:
              path: /
              port: 7001
            initialDelaySeconds: 15
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /
              port: 7001
            initialDelaySeconds: 5
            periodSeconds: 5
```

## Kubernetes Service — `k8s/service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: {project}-service
spec:
  type: ClusterIP
  selector:
    app: {project}
  ports:
    - name: api
      port: 6001
      targetPort: 6001
    - name: client
      port: 7001
      targetPort: 7001
```

## Traefik IngressRoute — `k8s/ingress-route.yaml`

Routes `/graphql` to API and all other traffic to Client.

```yaml
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: {project}-ingress
spec:
  entryPoints:
    - websecure
  routes:
    - match: Host(`{domain}`) && PathPrefix(`/graphql`)
      kind: Rule
      priority: 10
      services:
        - name: {project}-service
          port: 6001
    - match: Host(`{domain}`)
      kind: Rule
      priority: 5
      services:
        - name: {project}-service
          port: 7001
  tls:
    certResolver: letsencrypt
```

## GitHub Actions Workflow — `.github/workflows/staging.yml`

```yaml
name: Deploy to Staging

on:
  push:
    branches:
      - main

env:
  GAR_REGISTRY: {region}-docker.pkg.dev/{gcp-project}/{repository}
  PROJECT_NAME: {project}

jobs:
  deploy:
    runs-on: self-hosted
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Authenticate to Google Artifact Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.GAR_REGISTRY }}
          username: _json_key
          password: ${{ secrets.GAR_JSON_KEY }}

      - name: Set version tag
        id: version
        run: echo "tag=$(git describe --tags --always)" >> "$GITHUB_OUTPUT"

      - name: Build API image
        run: |
          docker build \
            --target production-api \
            --build-arg TARGET=api \
            --cache-from type=local,src=/tmp/runner-cache \
            --cache-to type=local,dest=/tmp/runner-cache,mode=max \
            -t ${{ env.GAR_REGISTRY }}/${{ env.PROJECT_NAME }}-api:${{ steps.version.outputs.tag }} \
            .

      - name: Build Client image
        run: |
          docker build \
            --target production-client \
            --build-arg TARGET=client \
            --cache-from type=local,src=/tmp/runner-cache \
            --cache-to type=local,dest=/tmp/runner-cache,mode=max \
            -t ${{ env.GAR_REGISTRY }}/${{ env.PROJECT_NAME }}-client:${{ steps.version.outputs.tag }} \
            .

      - name: Push images to GAR
        run: |
          docker push ${{ env.GAR_REGISTRY }}/${{ env.PROJECT_NAME }}-api:${{ steps.version.outputs.tag }}
          docker push ${{ env.GAR_REGISTRY }}/${{ env.PROJECT_NAME }}-client:${{ steps.version.outputs.tag }}

      - name: Deploy to GKE
        run: |
          kubectl set image deployment/${{ env.PROJECT_NAME }}-deployment \
            api=${{ env.GAR_REGISTRY }}/${{ env.PROJECT_NAME }}-api:${{ steps.version.outputs.tag }} \
            client=${{ env.GAR_REGISTRY }}/${{ env.PROJECT_NAME }}-client:${{ steps.version.outputs.tag }}
```

## Vault Secret — `k8s/vault-secret.yaml`

Stores Vault connection credentials as a Kubernetes Secret for the Vault agent injector.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: {project}-vault
type: Opaque
data:
  VAULT_ENDPOINT: <base64-encoded-vault-endpoint>
  VAULT_TOKEN: <base64-encoded-vault-token>
```

Generate base64 values:

```bash
echo -n "https://vault.example.com" | base64
echo -n "hvs.your-vault-token" | base64
```
