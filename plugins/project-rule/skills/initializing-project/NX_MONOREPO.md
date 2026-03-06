# Nx Monorepo Setup Guide

## Initialization

```bash
npx create-nx-workspace@latest {project-name} --preset=apps --pm=pnpm
cd {project-name}
```

## Directory Structure

```
{project-name}/
├── apps/
│   ├── api/          # NestJS backend
│   └── client/       # Next.js frontend
├── libs/
│   ├── models/       # TypeORM entities + GraphQL ObjectTypes
│   ├── auth/         # Authentication module
│   ├── constants/    # Shared constants
│   ├── graphql/      # GraphQL utilities
│   └── {domain}/     # Shared logic per business domain
├── tools/
│   └── test-utils/   # Test utilities
├── nx.json
├── tsconfig.base.json
├── eslint.config.ts
├── commitlint.config.ts
├── .prettierrc
├── pnpm-workspace.yaml
└── Dockerfile
```

## nx.json Configuration

```json
{
  "$schema": "./node_modules/nx/schemas/nx-schema.json",
  "namedInputs": {
    "default": ["{projectRoot}/**/*", "sharedGlobals"],
    "production": ["default", "!{projectRoot}/eslint.config.js"],
    "sharedGlobals": []
  },
  "plugins": [
    {
      "plugin": "@nx/eslint/plugin",
      "options": {
        "targetName": "lint"
      }
    },
    {
      "plugin": "@nx/jest/plugin",
      "options": {
        "targetName": "test"
      }
    }
  ],
  "targetDefaults": {
    "build": {
      "dependsOn": ["^build"],
      "inputs": ["production", "^production"]
    }
  },
  "generators": {
    "@nx/next:application": {
      "style": "scss",
      "linter": "eslint"
    },
    "@nx/nest:application": {
      "linter": "eslint"
    }
  },
  "tui": {
    "enabled": false
  }
}
```

## tsconfig.base.json Configuration

Path alias rule: `@{project-scope}/{lib-name}` → `libs/{lib-name}/src/index.ts`

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
    "target": "esnext",
    "module": "esnext",
    "lib": ["esnext", "dom"],
    "skipLibCheck": true,
    "skipDefaultLibCheck": true,
    "strictPropertyInitialization": false,
    "baseUrl": ".",
    "paths": {
      "@{scope}/models": ["libs/models/src/index.ts"],
      "@{scope}/auth": ["libs/auth/src/index.ts"],
      "@{scope}/constants": ["libs/constants/src/index.ts"],
      "@{scope}/graphql": ["libs/graphql/src/index.ts"]
    }
  },
  "exclude": ["node_modules", "tmp"]
}
```

> **IMPORTANT**: Each lib MUST have a single entry point at `libs/{name}/src/index.ts`. All exports MUST go through this barrel file.

## pnpm-workspace.yaml

```yaml
packages:
  - 'apps/*'
  - 'libs/*'
  - 'tools/*'
```

## Creating a New Library

```bash
# Create a NestJS library
pnpm exec nx g @nx/nest:library {lib-name} --directory=libs/{lib-name}

# Create a frontend library
pnpm exec nx g @nx/next:library {lib-name} --directory=libs/{lib-name}
```

After creation, add the path alias to `tsconfig.base.json` under `paths`:

```json
"@{scope}/{lib-name}": ["libs/{lib-name}/src/index.ts"]
```

## Build Commands

```bash
# Build a specific app
pnpm exec nx build api
pnpm exec nx build client

# Lint all projects
pnpm exec nx run-many --target=lint --all

# Test all projects
pnpm exec nx run-many --target=test --all
```
