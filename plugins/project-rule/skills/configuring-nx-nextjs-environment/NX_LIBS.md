# Nx Libs Module Exports

## Core Rule

All library exports must go through **root `src/index.ts`** only.

## Correct Pattern

```
libs/my-lib/
├── src/
│   ├── index.ts          # Only export file
│   └── lib/
│       ├── my-component.tsx
│       ├── my-service.ts
│       └── hooks/
│           └── use-my-hook.ts
```

```typescript
// libs/my-lib/src/index.ts
export { MyComponent } from './lib/my-component';
export { MyService } from './lib/my-service';
export { useMyHook } from './lib/hooks/use-my-hook';
export type { MyType } from './lib/types';
```

## Avoid These Patterns

### Nested index.ts files

```
// WRONG
libs/my-lib/
├── src/
│   ├── index.ts
│   └── lib/
│       ├── index.ts      # Don't do this
│       └── hooks/
│           └── index.ts  # Don't do this
```

### Intermediate re-export layers

```typescript
// WRONG: libs/my-lib/src/lib/index.ts
export * from './my-component';
export * from './hooks';

// WRONG: libs/my-lib/src/index.ts
export * from './lib';
```

## Why This Matters

1. **Clear dependency graph**: Single entry point makes dependencies explicit
2. **Avoid circular imports**: Nested exports can create circular dependencies
3. **Better tree-shaking**: Bundlers work better with explicit exports
4. **Consistent imports**: All consumers use same import path

## Import Pattern

```typescript
// Consumer code
import { MyComponent, useMyHook } from '@project/my-lib';
```

## tsconfig.base.json Path Mapping

```json
{
  "compilerOptions": {
    "paths": {
      "@project/my-lib": ["libs/my-lib/src/index.ts"]
    }
  }
}
```
