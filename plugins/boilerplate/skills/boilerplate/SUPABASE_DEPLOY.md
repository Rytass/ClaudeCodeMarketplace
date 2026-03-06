# Supabase Deployment Guide

## Supabase CLI Commands

| Command                                    | Description              |
| ------------------------------------------ | ------------------------ |
| `supabase init`                            | Initialize project       |
| `supabase link --project-ref <ref>`        | Link to remote project   |
| `supabase functions deploy graphql`        | Deploy edge function     |
| `supabase db push`                         | Apply migrations         |

## Vercel Deployment for Next.js

### vercel.json

```json
{
  "framework": "nextjs",
  "buildCommand": "pnpm exec nx build client",
  "outputDirectory": "apps/client/.next"
}
```

### Environment Variables (Vercel Dashboard)

| Variable                        | Description          |
| ------------------------------- | -------------------- |
| NEXT_PUBLIC_SUPABASE_URL        | Supabase project URL |
| NEXT_PUBLIC_SUPABASE_ANON_KEY   | Supabase anon key    |

## GitHub Actions Workflow

`.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy-supabase:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Supabase CLI
        uses: supabase/setup-cli@v1

      - name: Link Supabase project
        run: supabase link --project-ref ${{ secrets.SUPABASE_PROJECT_REF }}
        env:
          SUPABASE_ACCESS_TOKEN: ${{ secrets.SUPABASE_ACCESS_TOKEN }}

      - name: Deploy migrations
        run: supabase db push
        env:
          SUPABASE_ACCESS_TOKEN: ${{ secrets.SUPABASE_ACCESS_TOKEN }}

      - name: Deploy Edge Functions
        run: supabase functions deploy graphql
        env:
          SUPABASE_ACCESS_TOKEN: ${{ secrets.SUPABASE_ACCESS_TOKEN }}

  deploy-vercel:
    runs-on: ubuntu-latest
    needs: deploy-supabase
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Install dependencies
        run: pnpm install --frozen-lockfile

      - name: Deploy to Vercel
        run: vercel deploy --prod --token ${{ secrets.VERCEL_TOKEN }}
        env:
          VERCEL_ORG_ID: ${{ secrets.VERCEL_ORG_ID }}
          VERCEL_PROJECT_ID: ${{ secrets.VERCEL_PROJECT_ID }}
```

### Required Secrets

| Secret                 | Description                |
| ---------------------- | -------------------------- |
| SUPABASE_ACCESS_TOKEN  | Supabase access token      |
| SUPABASE_PROJECT_REF   | Supabase project reference |
| VERCEL_TOKEN           | Vercel deploy token        |
| VERCEL_ORG_ID          | Vercel organization ID     |
| VERCEL_PROJECT_ID      | Vercel project ID          |

## Local Development

| Service          | Command                              | Default URL            |
| ---------------- | ------------------------------------ | ---------------------- |
| Supabase (all)   | `supabase start`                     | http://localhost:54321 |
| Edge Functions   | `supabase functions serve graphql`   | http://localhost:54321 |
| Next.js Client   | `pnpm exec nx dev client`           | http://localhost:3000  |
