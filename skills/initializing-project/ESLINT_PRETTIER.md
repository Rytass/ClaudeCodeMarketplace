# ESLint / Prettier / Commitlint / Husky Setup Guide

## ESLint Flat Config (eslint.config.ts)

Uses ESLint v9+ flat config format. Applicable to both Nx monorepo and standalone projects:

```typescript
import js from '@eslint/js';
import tsPlugin from '@typescript-eslint/eslint-plugin';
import tsParser from '@typescript-eslint/parser';
import prettierPlugin from 'eslint-plugin-prettier';
import prettierConfig from 'eslint-config-prettier';
import globals from 'globals';
import { dirname } from 'path';
import { fileURLToPath } from 'url';
import type { Linter } from 'eslint';

// Additional import for Nx monorepo:
// import nxPlugin from '@nx/eslint-plugin';

const __dirname = dirname(fileURLToPath(import.meta.url));

const config: Linter.Config[] = [
  js.configs.recommended,
  prettierConfig,
  {
    ignores: [
      'node_modules/',
      'dist/',
      '**/.**',
      '**/.generated/**',
      '**/.next/**',
      'build/',
      '**/*.generated.ts',
      '**/*.generated.tsx',
      'generated/**',
      'eslint.config.ts',
      '**/next-env.d.ts',
    ],
  },
  // TypeScript file rules
  {
    files: ['**/*.ts', '**/*.tsx'],
    languageOptions: {
      parser: tsParser,
      parserOptions: {
        project: ['./tsconfig.json'],
        // For Nx monorepo, change to:
        // project: [
        //   './tsconfig.base.json',
        //   './apps/*/tsconfig.json',
        //   './apps/*/tsconfig.app.json',
        //   './libs/*/tsconfig.json',
        //   './libs/*/tsconfig.lib.json',
        //   './libs/*/tsconfig.spec.json',
        // ],
        tsconfigRootDir: __dirname,
      },
      globals: {
        ...globals.node,
        ...globals.browser,
      },
    },
    plugins: {
      '@typescript-eslint': tsPlugin,
      // Additional for Nx monorepo:
      // '@nx': nxPlugin,
      prettier: prettierPlugin,
    },
    rules: {
      // Disable base rule in favor of TypeScript version
      'no-unused-vars': 'off',

      // TypeScript strict rules
      '@typescript-eslint/no-explicit-any': 'error',
      '@typescript-eslint/explicit-function-return-type': 'error',
      '@typescript-eslint/explicit-module-boundary-types': 'error',
      '@typescript-eslint/prefer-readonly': 'error',
      '@typescript-eslint/prefer-as-const': 'error',
      '@typescript-eslint/no-unused-vars': [
        'error',
        {
          argsIgnorePattern: '^_',
          varsIgnorePattern: '^_',
        },
      ],

      // General rules
      'prefer-const': 'error',
      'no-var': 'error',
      semi: ['error', 'always'],
      'comma-dangle': ['error', 'always-multiline'],
      'no-multiple-empty-lines': ['error', { max: 1 }],

      // Additional for Nx monorepo:
      // '@nx/enforce-module-boundaries': [
      //   'error',
      //   {
      //     enforceBuildableLibDependency: true,
      //     allow: [],
      //     depConstraints: [
      //       { sourceTag: '*', onlyDependOnLibsWithTags: ['*'] },
      //     ],
      //   },
      // ],

      // Prettier
      'prettier/prettier': 'error',
    },
  },
  // Relaxed rules for test files
  {
    files: ['**/*.spec.ts', '**/*.test.ts'],
    languageOptions: {
      globals: {
        ...globals.jest,
      },
    },
    rules: {
      '@typescript-eslint/explicit-function-return-type': 'off',
      '@typescript-eslint/explicit-module-boundary-types': 'off',
    },
  },
  // JavaScript files (configs, etc.)
  {
    files: ['**/*.js', '**/*.jsx', '**/*.cjs', '**/*.mjs'],
    languageOptions: {
      globals: {
        ...globals.node,
        ...globals.commonjs,
      },
    },
    plugins: {
      prettier: prettierPlugin,
    },
    rules: {
      'prettier/prettier': 'error',
    },
  },
];

export default config;
```

---

## Prettier (.prettierrc)

```json
{
  "semi": true,
  "trailingComma": "all",
  "singleQuote": true,
  "printWidth": 120,
  "tabWidth": 2,
  "useTabs": false,
  "endOfLine": "lf",
  "arrowParens": "avoid",
  "bracketSpacing": true,
  "jsxSingleQuote": false,
  "quoteProps": "as-needed"
}
```

---

## Commitlint (commitlint.config.ts)

```typescript
import type { UserConfig } from '@commitlint/types';

const config: UserConfig = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      ['feat', 'fix', 'docs', 'style', 'refactor', 'perf', 'test', 'chore', 'ci', 'build', 'revert'],
    ],
    'subject-case': [2, 'never', ['pascal-case', 'upper-case']],
    'subject-max-length': [2, 'always', 100],
    'subject-min-length': [2, 'always', 3],
    'body-max-line-length': [2, 'always', 100],
  },
};

export default config;
```

---

## Husky + lint-staged

### Installation and Initialization

```bash
pnpm add -D husky lint-staged
pnpm exec husky init
```

### .husky/commit-msg

```bash
pnpm exec commitlint --edit "$1"
```

### .husky/pre-commit

```bash
pnpm exec lint-staged
```

### package.json lint-staged Configuration

```json
{
  "lint-staged": {
    "*.{ts,tsx}": ["eslint --fix"],
    "*.{ts,tsx,js,jsx,json,md,scss,css}": ["prettier --write"]
  }
}
```

---

## Installation Command Summary

```bash
# ESLint + Prettier
pnpm add -D eslint @eslint/js @typescript-eslint/eslint-plugin @typescript-eslint/parser \
  eslint-plugin-prettier eslint-config-prettier prettier globals

# Commitlint
pnpm add -D @commitlint/cli @commitlint/config-conventional

# Husky + lint-staged
pnpm add -D husky lint-staged
pnpm exec husky init
```
