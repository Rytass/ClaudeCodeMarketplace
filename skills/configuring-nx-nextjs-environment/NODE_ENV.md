# NODE_ENV Handling in Nx + Next.js

## The Problem

When working in an **Nx Monorepo containing Next.js applications**, manually defining `NODE_ENV` in `.env` files causes build-time environment mismatch errors.

## Common Errors

- Next.js failing during prerender
- "no-document-import-in-page" errors
- Environment mismatch between build phases

## Why This Happens

Next.js automatically sets `NODE_ENV` during:
- **Development**: `NODE_ENV=development` when running `nx serve`
- **Production**: `NODE_ENV=production` when running `nx build`

If you override in `.env` (e.g., `NODE_ENV=development`), the build phase receives wrong environment context.

## Solution

**Always remove `NODE_ENV` from `.env*` files.**

```bash
# Check all .env files
grep -r "NODE_ENV" .env*

# Remove any NODE_ENV lines
```

Let Nx / Next.js handle environment phase entirely.

## Verification

Add to `next.config.js`:

```js
console.log('NODE_ENV =', process.env.NODE_ENV);
```

Expected output:
- `nx build`: prints `production`
- `nx serve`: prints `development`

## Using Custom Environment Variables

For custom configuration, use different variable names:

```bash
# .env.local
APP_ENV=staging
API_URL=https://staging-api.example.com
```

```typescript
// Access in code
const apiUrl = process.env.API_URL;
const appEnv = process.env.APP_ENV;
```
