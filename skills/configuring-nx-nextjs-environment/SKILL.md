---
name: configuring-nx-nextjs-environment
description: Nx Monorepo + Next.js environment configuration guide. NODE_ENV handling (NEVER define in .env), Nx Libs export conventions (root src/index.ts only). Use when working with .env files, nx.json, tsconfig.base.json, Next.js config, or creating Nx libraries. Pair with nx-monorepo-expert agent for complex configurations.
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
