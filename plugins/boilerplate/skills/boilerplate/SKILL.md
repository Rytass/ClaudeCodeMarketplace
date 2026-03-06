---
name: boilerplate
description: Interactively guide full-stack project bootstrapping with deployment target selection. Use when creating a new project with Nx monorepo + Next.js + GraphQL. Trigger when user says init project, create project, new project, bootstrap, scaffold project.
---

# Boilerplate Skill Reference

This is the index for the boilerplate project generator. It supports 3 deployment targets, each with a distinct API framework, database strategy, and hosting model — all sharing a common Nx monorepo foundation.

## Deployment Comparison

| Aspect               | GKE (NestJS)                         | Cloudflare Workers + Pages            | Supabase                              |
| --------------------- | ------------------------------------ | ------------------------------------- | ------------------------------------- |
| API Framework         | NestJS + Apollo Server               | Hono + graphql-yoga                   | Edge Functions (Deno)                 |
| ORM / DB Client       | TypeORM                              | drizzle-orm                           | supabase-js                           |
| GraphQL Approach      | Code-first                           | Schema-first                          | Schema-first                          |
| Database              | PostgreSQL (self-managed/Cloud SQL)  | PostgreSQL (Neon)                     | Supabase PostgreSQL (managed)         |
| Frontend Deploy       | GKE Pod (same Pod)                   | Cloudflare Pages                      | Vercel                                |
| API Deploy            | GKE Pod (Docker)                     | Cloudflare Workers                    | Supabase Edge Functions               |
| Best For              | Enterprise/large platform, full ctrl | Edge computing, low latency, pay-per-req | Rapid prototyping, fully managed, built-in Auth |

## Shared Tech Stack

All targets share:

- **Monorepo**: Nx with pnpm workspaces
- **Frontend**: Next.js with Apollo Client
- **API Layer**: GraphQL
- **Language**: TypeScript (strict)
- **Package Manager**: pnpm

## File Index

| File                   | Description                                              |
| ---------------------- | -------------------------------------------------------- |
| NX_MONOREPO_BASE.md    | Shared Nx monorepo skeleton and workspace configuration  |
| NEXTJS_CLIENT.md       | Next.js + Apollo Client setup for the frontend app       |
| GRAPHQL_SCHEMA.md      | Shared GraphQL schema definitions and codegen config     |
| TOOLCHAIN.md           | ESLint, Prettier, commitlint, Husky (self-contained)     |
| ENV_CONFIG.md          | Environment variables templates and .gitignore           |
| GKE_API.md             | NestJS + Apollo Server + TypeORM API layer               |
| GKE_DEPLOY.md          | Dockerfile, K8s manifests, Traefik, GitHub Actions       |
| CLOUDFLARE_API.md      | Hono + graphql-yoga + drizzle-orm API layer              |
| CLOUDFLARE_DEPLOY.md   | wrangler.toml, Cloudflare Pages, GitHub Actions          |
| SUPABASE_API.md        | Edge Functions + supabase-js API layer                   |
| SUPABASE_DEPLOY.md     | Supabase CLI, Vercel frontend, GitHub Actions            |

## Decision Guide

### Choose GKE when you need:
- Full infrastructure control and customization
- Complex business logic with NestJS module system
- Self-managed or Cloud SQL PostgreSQL
- Enterprise-grade observability (Prometheus, Grafana)
- Long-running processes or WebSocket support

### Choose Cloudflare when you need:
- Global edge deployment with minimal latency
- Pay-per-request pricing (cost-effective for variable traffic)
- Zero cold starts (Workers runtime)
- Simple, stateless API endpoints
- Built-in CDN for static assets via Pages

### Choose Supabase when you need:
- Fastest time-to-market
- Built-in authentication, storage, and realtime
- Managed PostgreSQL with automatic backups
- Row-level security (RLS) policies
- Minimal DevOps overhead
