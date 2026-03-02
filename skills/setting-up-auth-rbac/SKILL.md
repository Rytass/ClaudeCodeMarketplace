---
name: setting-up-auth-rbac
description: Authentication and authorization setup guide. @rytass/member-base-nestjs-module JWT configuration, Casbin RBAC permission model, Vault secret management integration, token refresh middleware. Use when setting up auth systems, RBAC, Casbin, JWT, Vault, or permission decorators.
---

# Authentication & Authorization Setup Guide

Complete auth setup using `@rytass/member-base-nestjs-module` with Casbin RBAC.

## Architecture Overview

```
AppModule
├── VaultModule.forRoot()           ← Secret management
├── TypeOrmModule.forRootAsync()    ← Database (Vault provides connection info)
├── MemberBaseModule.forRootAsync() ← JWT + Casbin (Vault provides secret)
├── GraphQLModule.forRoot()         ← API layer
└── AuthModule                      ← Auth business logic
    ├── AuthDataModule              ← Data access layer
    │   ├── AuthService
    │   └── AdminSeedService
    └── AuthResolver                ← GraphQL resolver
```

## Quick Reference

- **MemberBaseModule configuration** → [MEMBER_BASE_MODULE.md](./MEMBER_BASE_MODULE.md)
- **Casbin RBAC permissions** → [CASBIN_RBAC.md](./CASBIN_RBAC.md)
- **Vault integration** → [VAULT_INTEGRATION.md](./VAULT_INTEGRATION.md)

## Auth Decorator Quick Reference

| Decorator                                     | Purpose              | Source                                  |
|-----------------------------------------------|----------------------|-----------------------------------------|
| `@Authenticated()`                            | Require login        | `@rytass/member-base-nestjs-module`     |
| `@CheckPermission(RESOURCES.X, ACTIONS.Y)`    | RBAC permission check | Project custom decorator               |
| `@Public()`                                   | Skip auth (if applicable) | `@rytass/member-base-nestjs-module` |

## Basic Usage

```typescript
import { Authenticated } from '@rytass/member-base-nestjs-module';
import { CheckPermission } from '@scope/auth';
import { RESOURCES, ACTIONS } from '@scope/constants';

@Resolver()
export class SupplierQueries {
  @Authenticated()
  @CheckPermission(RESOURCES.SUPPLIER, ACTIONS.LIST)
  @Query(() => SupplierCollectionDto)
  async suppliers(): Promise<SupplierCollectionDto> {
    // ...
  }
}
```
