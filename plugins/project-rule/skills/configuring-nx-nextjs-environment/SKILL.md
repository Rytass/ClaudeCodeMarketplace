---
name: configuring-nx-nextjs-environment
description: "Environment and Nx library rules for Next.js apps in an Nx monorepo — never set NODE_ENV in any .env file (Next.js sets it, and defining it breaks builds), and export everything from a lib's root src/index.ts only (no nested index.ts barrels). Use when adding or editing .env files or environment variables, touching next.config, nx.json, project.json or tsconfig.base.json paths, creating an Nx library, or debugging build errors such as no-document-import-in-page. Trigger words — 環境變數, .env, NODE_ENV, Nx lib, barrel export, path alias, nx build 失敗."
---

# Nx Monorepo + Next.js Environment

## Critical: NODE_ENV Handling

See [NODE_ENV.md](NODE_ENV.md) for details.

**NEVER define `NODE_ENV` in any `.env` file.**

Next.js automatically sets `NODE_ENV`:
- `development` for `nx serve`
- `production` for `nx build`

Manually setting it causes build-time errors like "no-document-import-in-page".

## Nx Libs Module Exports

See [NX_LIBS.md](NX_LIBS.md) for details.

**All exports must go through root `src/index.ts` only.**

```typescript
// Correct: libs/my-lib/src/index.ts
export { MyComponent } from './lib/my-component';
export { useMyHook } from './lib/hooks/use-my-hook';
export type { MyType } from './lib/types';
```

Never create nested `index.ts` files.

## Agent Integration

For complex Nx configuration tasks, use `nx-monorepo-expert` agent via Task tool:
- Workspace configuration
- TypeScript path mapping
- ESLint flat config setup
- lint-staged workflows
- Husky git hooks
