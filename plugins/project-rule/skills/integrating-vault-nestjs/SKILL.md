---
name: integrating-vault-nestjs
description: Integrate HashiCorp Vault with NestJS using @rytass/secret-adapter-vault-nestjs. Use when configuring Vault secrets, setting up VaultModule, injecting VaultService, or integrating with TypeORM/JWT modules. Covers environment variable fallback, async secret retrieval, and NestJS dependency injection patterns.
---

# @rytass/secret-adapter-vault-nestjs

NestJS module for HashiCorp Vault integration with automatic environment variable fallback.

## Quick Setup

```typescript
import { Module } from '@nestjs/common';
import { VaultModule } from '@rytass/secret-adapter-vault-nestjs';

@Module({
  imports: [
    VaultModule.forRoot({
      path: process.env.VAULT_PATH || 'my-app/develop',
    }),
  ],
})
export class AppModule {}
```

## Environment Variables

Required for Vault connection (auto-configured in most deployment environments):

| Variable         | Description              |
|------------------|--------------------------|
| `VAULT_HOST`     | Vault service base URL   |
| `VAULT_ACCOUNT`  | Vault username           |
| `VAULT_PASSWORD` | Vault password           |
| `VAULT_PATH`     | Secret path (optional)   |

## VaultService Usage

```typescript
import { Injectable } from '@nestjs/common';
import { VaultService } from '@rytass/secret-adapter-vault-nestjs';

@Injectable()
export class MyService {
  constructor(private readonly vault: VaultService) {}

  async getConfig(): Promise<string> {
    // All get() calls are async
    return this.vault.get<string>('API_KEY');
  }
}
```

## Key Points

1. **Async API**: `vault.get()` returns `Promise<T>`, always use `await`
2. **Type Safety**: Use generics `vault.get<string>('KEY')` for type hints
3. **Fallback**: Automatically falls back to `process.env` when Vault unavailable
4. **Global Module**: VaultModule is global, no need to import in every module

## Integration Examples

- [TypeORM Integration](TYPEORM_INTEGRATION.md)
- [API Reference](API_REFERENCE.md)
