---
name: initializing-project
description: "Reference guide for project topology and toolchain setup — Nx monorepo vs standalone decision matrix, required packages, ESLint flat config, Prettier, commitlint, Husky + lint-staged, Docker multi-stage build, CI/CD. Use when deciding between monorepo and separate repos, or when adding or fixing ESLint, Prettier, commitlint, Husky, Dockerfile or CI config in a project; also the reference for the project-initializer agent. Trigger words — monorepo 還是分 repo, eslint flat config, commitlint, husky, lint-staged, Dockerfile, CI 設定. To run full interactive initialization, use /scaffold-project."
---

# Project Initialization Guide

## Topology Selection Matrix

| Factor              | Nx Monorepo                             | Standalone (separate repos)         |
| ------------------- | --------------------------------------- | ----------------------------------- |
| Team size           | 3+ developers, shared libs needed       | 1-2 developers, independent deploy  |
| Frontend-backend coupling | Shared TypeORM entities / GraphQL types | API-only communication          |
| Deployment strategy | Unified CI/CD, same-version releases    | Independent deploy cycles           |
| Code sharing        | `libs/` shared modules, path alias `@{scope}/*` | npm packages or copy         |
| Use cases           | ERP, CMS, large platforms               | Landing page + standalone API       |

## Required Packages

### Common (both topologies)

```
# Linting & Formatting
eslint @eslint/js @typescript-eslint/eslint-plugin @typescript-eslint/parser
eslint-plugin-prettier eslint-config-prettier prettier globals

# Git Hooks & Commit Convention
husky lint-staged
@commitlint/cli @commitlint/config-conventional

# TypeScript
typescript
```

### Nx Monorepo Additional Packages

```
nx @nx/workspace @nx/eslint @nx/eslint-plugin @nx/jest @nx/nest @nx/next
```

### Standalone Additional Packages

```
# Frontend
next react react-dom @types/react @types/react-dom

# Backend
@nestjs/core @nestjs/common @nestjs/platform-express
@nestjs/graphql @nestjs/apollo @nestjs/typeorm
apollo-server-express typeorm pg
```

## Quick Start

1. **Choose topology** → Refer to the matrix above
2. **Monorepo** → See [NX_MONOREPO.md](./NX_MONOREPO.md)
3. **Standalone** → See [STANDALONE.md](./STANDALONE.md)
4. **Configure toolchain** → See [ESLINT_PRETTIER.md](./ESLINT_PRETTIER.md)
5. **Docker & CI/CD** → See [DOCKER.md](./DOCKER.md)
