# Docker Multi-Stage Build & CI/CD Guide

## Dockerfile (Universal for Nx Monorepo)

Supports building both NestJS API and Next.js Client simultaneously. Use the `TARGET` build arg to select the target app:

```dockerfile
# ============================================
# Stage 1: Production Dependencies
# ============================================
FROM node:24-alpine AS deps

RUN apk add --no-cache git

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

RUN corepack enable pnpm
RUN pnpm install --prod --frozen-lockfile --ignore-scripts

# ============================================
# Stage 2: Builder
# ============================================
FROM node:24-alpine AS builder

RUN apk add --no-cache git

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

RUN corepack enable pnpm
RUN pnpm install --frozen-lockfile

COPY . /app/

ENV NX_DAEMON=false

# Build target app
ARG TARGET
RUN pnpm exec nx build ${TARGET} --verbose

# For Next.js standalone builds, restructure the output:
# .next/standalone/ contains server.js + minimal node_modules
# .next/static/ and public/ need to be co-located
RUN if [ -d "dist/apps/${TARGET}/.next/standalone" ]; then \
  mkdir -p /tmp/standalone; \
  cp -r dist/apps/${TARGET}/.next/standalone/node_modules /tmp/standalone/; \
  cp dist/apps/${TARGET}/.next/standalone/apps/${TARGET}/server.js /tmp/standalone/; \
  sed -i 's|"distDir":"[^"]*"|"distDir":"./.next"|g' /tmp/standalone/server.js; \
  cp -r dist/apps/${TARGET}/.next /tmp/standalone/.next; \
  rm -rf /tmp/standalone/.next/standalone /tmp/standalone/.next/cache; \
  cp -r dist/apps/${TARGET}/public /tmp/standalone/; \
  rm -rf dist/apps/${TARGET}; \
  mv /tmp/standalone dist/apps/${TARGET}; \
fi

# ============================================
# Stage 3: Production Image
# ============================================
FROM node:24-alpine

WORKDIR /app

RUN apk add --no-cache git

ARG TARGET

# For API: use root prod node_modules
# For Client (standalone): node_modules already in build output
COPY --from=deps /app/node_modules ./node_modules
COPY --from=builder /app/dist/apps/${TARGET} .

ENV PORT=80
ENV TZ=Asia/Taipei
ENV NODE_ENV=production

EXPOSE 80

CMD ["node", "main.js"]
```

### Build Commands

```bash
# Build API image
docker build --build-arg TARGET=api -t {project}-api .

# Build Client image
docker build --build-arg TARGET=client -t {project}-client .
```

### Stage Summary

| Stage      | Purpose                                            |
| ---------- | -------------------------------------------------- |
| `deps`     | Install production dependencies only (cache layer) |
| `builder`  | Full install + Nx build, outputs to `dist/apps/`   |
| production | Minimal image containing only runtime files        |

- **Next.js standalone**: The builder stage automatically restructures the directory layout, placing `server.js` and `.next/` in the correct locations
- **NestJS API**: Copied directly from `dist/apps/api/`, entry point is `main.js`
- `NX_DAEMON=false`: Daemon is not needed in CI environments

---

## GitHub Actions CI/CD

Example for staging environment, triggered on push to the `staging` branch:

```yaml
name: Staging Server

on:
  push:
    branches: [staging]

jobs:
  tagging:
    runs-on: self-hosted
    outputs:
      tag: ${{ steps.tagging.outputs.tag }}
    permissions:
      contents: write
      packages: write
    steps:
      - uses: actions/checkout@v4
      - id: tagging
        uses: anothrNick/github-tag-action@1.69.0
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          DEFAULT_BUMP: patch
          DEFAULT_BRANCH: main
          WITH_V: true
          FORCE_WITHOUT_CHANGES: true
          RELEASE_BRANCHES: release

  build:
    runs-on: self-hosted
    needs: tagging
    permissions:
      contents: read
      packages: write
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          registry: asia-east1-docker.pkg.dev
          username: _json_key
          password: ${{ secrets.GAR_JSON_KEY }}

      - name: Build Client
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          cache-from: type=local,src=/tmp/runner-cache
          cache-to: type=local,dest=/tmp/runner-cache,mode=min,compression=zstd
          tags: asia-east1-docker.pkg.dev/{gcp-project}/{repo}/client:${{ needs.tagging.outputs.tag }}
          build-args: TARGET=client

      - name: Build API
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          cache-from: type=local,src=/tmp/runner-cache
          cache-to: type=local,dest=/tmp/runner-cache,mode=min,compression=zstd
          tags: asia-east1-docker.pkg.dev/{gcp-project}/{repo}/api:${{ needs.tagging.outputs.tag }}
          build-args: TARGET=api

  update-deployments:
    runs-on: self-hosted
    needs: [tagging, build]
    permissions:
      contents: read
      packages: write
    steps:
      - uses: google-github-actions/auth@v1
        with:
          credentials_json: ${{ secrets.GAR_JSON_KEY }}
      - uses: google-github-actions/setup-gcloud@v1
      - name: Update GKE
        run: |-
          gcloud components install kubectl
          gcloud container clusters get-credentials {cluster} --region {region} --project {gcp-project}
          kubectl -n {namespace} set image deployments/{deployment} client=asia-east1-docker.pkg.dev/{gcp-project}/{repo}/client:${{ needs.tagging.outputs.tag }}
          kubectl -n {namespace} set image deployments/{deployment} api=asia-east1-docker.pkg.dev/{gcp-project}/{repo}/api:${{ needs.tagging.outputs.tag }}
```

### CI/CD Flow

```
push staging → auto tag (patch) → build Docker images → push to GAR → update GKE deployment
```

### Required GitHub Secrets

| Secret          | Purpose                              |
| --------------- | ------------------------------------ |
| `GAR_JSON_KEY`  | GCP Service Account JSON key         |
| `GITHUB_TOKEN`  | Provided automatically, used for tagging |

---

## Standalone Project Docker

For standalone frontend (Next.js), the Dockerfile is simpler:

```dockerfile
FROM node:24-alpine AS deps
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN corepack enable pnpm && pnpm install --frozen-lockfile

FROM node:24-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN corepack enable pnpm && pnpm build

FROM node:24-alpine
WORKDIR /app
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

ENV PORT=80
ENV NODE_ENV=production
EXPOSE 80
CMD ["node", "server.js"]
```
