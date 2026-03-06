# Cloudflare Deployment Guide

## wrangler.toml (Multi-Environment)

```toml
name = "{project}-api"
main = "src/index.ts"
compatibility_date = "2024-01-01"

[env.staging]
name = "{project}-api-staging"
vars = { ENVIRONMENT = "staging" }

[env.production]
name = "{project}-api-production"
vars = { ENVIRONMENT = "production" }
```

## Next.js on Cloudflare Pages

Using `@cloudflare/next-on-pages` to deploy Next.js to Cloudflare Pages.

### next.config.ts

```typescript
import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  // Required for Cloudflare Pages edge runtime
  experimental: {
    runtime: 'edge',
  },
};

export default nextConfig;
```

### Build Command

```bash
npx @cloudflare/next-on-pages
```

## GitHub Actions Workflow

`.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Install dependencies
        run: pnpm install --frozen-lockfile

      - name: Build
        run: pnpm build

      - name: Deploy Workers (API)
        run: npx wrangler deploy --env production
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}

      - name: Deploy Pages (Client)
        run: npx wrangler pages deploy .vercel/output/static --project-name={project}-client
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
```

### Required Secrets

| Secret                  | Description               |
| ----------------------- | ------------------------- |
| CLOUDFLARE_API_TOKEN    | Cloudflare API token      |
| CLOUDFLARE_ACCOUNT_ID   | Cloudflare account ID     |

## Local Development

| Service | Command         | Default URL              |
| ------- | --------------- | ------------------------ |
| API     | `wrangler dev`  | http://localhost:8787    |
| Client  | `next dev`      | http://localhost:3000    |
