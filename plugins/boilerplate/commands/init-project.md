---
name: init-project
description: "Interactively guide full-stack project bootstrapping with deployment target selection. Use when creating a new project with Nx monorepo + Next.js + GraphQL. Trigger when user says init project, create project, new project, bootstrap, scaffold project."
argument-hint: "[--target=gke|cloudflare|supabase] [project-name]"
---

# Initialize Full-Stack Project

Follow the workflow below to guide the user through new project initialization with deployment target selection.

## Argument Parsing

{{#if args}}
Parse the user-provided arguments: `{{ args }}`

- If `--target=gke` is present, use GKE (NestJS) deployment target directly
- If `--target=cloudflare` is present, use Cloudflare Workers + Pages target directly
- If `--target=supabase` is present, use Supabase target directly
- Treat remaining text as the project name
{{/if}}

## Guided Workflow

### Step 1: Project Name

**If no project name is provided**, ask the user for:
- **Project name**: Used for the directory name, `package.json` name, and `@{name}` package scope
- Example: `my-app` produces scope `@my-app/*`

### Step 2: Project Description

Ask the user for a one-line description of the project purpose. This will be used in:
- Root `package.json` description
- `README.md` header
- Docker image labels

### Step 3: Deployment Target

**If no target is specified**, present the comparison and ask the user to choose:

| Aspect           | GKE (NestJS)                        | Cloudflare Workers + Pages           | Supabase                             |
|------------------|-------------------------------------|--------------------------------------|--------------------------------------|
| API Framework    | NestJS + Apollo Server              | Hono + graphql-yoga                  | Edge Functions (Deno)                |
| ORM / DB Client  | TypeORM                             | drizzle-orm                          | supabase-js                          |
| GraphQL          | Code-first                          | Schema-first                         | Schema-first                         |
| Database         | PostgreSQL (self-managed/Cloud SQL) | PostgreSQL (Neon)                    | Supabase PostgreSQL (managed)        |
| Frontend Deploy  | GKE Pod (same Pod)                  | Cloudflare Pages                     | Vercel                               |
| API Deploy       | GKE Pod (Docker)                    | Cloudflare Workers                   | Supabase Edge Functions              |
| Best For         | Enterprise, full control            | Edge computing, low latency          | Rapid prototyping, fully managed     |

**Recommendations**:
- **GKE**: Choose for enterprise/large platforms requiring full infrastructure control, existing K8s experience, or complex business logic (NestJS DI, guards, interceptors)
- **Cloudflare**: Choose for edge-first applications, global low-latency APIs, pay-per-request cost model, or lightweight API layers
- **Supabase**: Choose for rapid prototyping, built-in authentication/authorization, real-time subscriptions, or fully managed database

### Step 4: Confirmation

Present a summary to the user:

```
Project Name:   {name}
Package Scope:  @{name}
Description:    {description}
Deploy Target:  {target}
Tech Stack:
  - Frontend:   Next.js + Apollo Client
  - API:        {target-specific framework}
  - Database:   {target-specific DB}
  - Monorepo:   Nx + pnpm
```

Ask the user to confirm before proceeding.

### Step 5: Launch Agent

Once confirmed, launch the `project-bootstrapper` agent with:
- `projectName`: The chosen project name
- `description`: The project description
- `target`: The deployment target (`gke` | `cloudflare` | `supabase`)

## Example Usage

```
/init-project
/init-project my-app
/init-project --target=gke
/init-project my-app --target=cloudflare
/init-project --target=supabase my-saas
```
