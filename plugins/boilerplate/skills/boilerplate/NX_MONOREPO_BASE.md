# Nx Monorepo Base

Shared Nx monorepo skeleton used by all deployment targets.

## Directory Structure

```
{project-root}/
├── apps/
│   ├── client/              # Next.js frontend (all targets)
│   └── api/                 # API server (GKE and Cloudflare targets)
├── supabase/                # Supabase target only (at repo root)
│   ├── functions/           # Edge Functions
│   ├── migrations/          # SQL migrations
│   └── config.toml
├── libs/
│   └── graphql/             # Shared GraphQL types and codegen output
├── nx.json
├── package.json
├── pnpm-workspace.yaml
├── tsconfig.base.json
└── .gitignore
```

> **Note:** The `supabase/` directory sits at the repo root (not inside `apps/`) because the Supabase CLI expects this location. The `apps/api/` directory is not used when targeting Supabase.

## Root `package.json`

```json
{
  "name": "@{scope}/source",
  "private": true,
  "scripts": {
    "build:client": "nx build client",
    "build:api": "nx build api",
    "dev:client": "nx dev client",
    "dev:api": "nx serve api",
    "lint": "nx run-many -t lint",
    "codegen": "graphql-codegen"
  }
}
```

Replace `{scope}` with your project's npm scope (e.g., `@acme`).

## `nx.json`

```json
{
  "$schema": "./node_modules/nx/schemas/nx-schema.json",
  "namedInputs": {
    "default": ["{projectRoot}/**/*", "sharedGlobals"],
    "sharedGlobals": []
  },
  "plugins": [
    {
      "plugin": "@nx/next/plugin",
      "options": {
        "startTargetName": "start",
        "buildTargetName": "build",
        "devTargetName": "dev",
        "serveStaticTargetName": "serve-static"
      }
    },
    {
      "plugin": "@nx/eslint/plugin",
      "options": {
        "targetName": "lint"
      }
    }
  ],
  "targetDefaults": {
    "build": {
      "dependsOn": ["^build"],
      "cache": true
    },
    "lint": {
      "cache": true
    }
  }
}
```

> **GKE target** additionally includes `@nx/nest` plugin for the API app.

## `tsconfig.base.json`

```json
{
  "compileOnSave": false,
  "compilerOptions": {
    "rootDir": ".",
    "sourceMap": true,
    "declaration": false,
    "moduleResolution": "node",
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "importHelpers": true,
    "target": "es2015",
    "module": "esnext",
    "lib": ["es2017", "dom"],
    "skipLibCheck": true,
    "skipDefaultLibCheck": true,
    "baseUrl": ".",
    "strict": true,
    "paths": {
      "@{scope}/graphql": ["libs/graphql/src/index.ts"],
      "@{scope}/models": ["libs/graphql/src/generated/graphql.ts"]
    }
  },
  "exclude": ["node_modules", "tmp"]
}
```

## `pnpm-workspace.yaml`

```yaml
packages:
  - 'apps/*'
  - 'libs/*'
```

## Installation

```bash
pnpm add -D nx @nx/next @nx/eslint @nx/workspace typescript
```

GKE target additionally requires:

```bash
pnpm add -D @nx/nest @nx/node
```
