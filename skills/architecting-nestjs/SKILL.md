---
name: architecting-nestjs
description: NestJS project architecture guide. Covers Dual-Layer Module (DataModule + Module), ModelsModule Symbol injection, GraphQL Code-First, DataLoader, TypeORM entity, ABAC permission control, transaction handling, Entity-as-ObjectType pattern. Use when creating or modifying *.module.ts, *.service.ts, *.resolver.ts, *.queries.ts, *.mutations.ts, *.dataloader.ts, TypeORM entities, or GraphQL ObjectType/DTO. Pair with nestjs-module-scaffolder agent for module creation.
---

# NestJS Project Architecture

## Layered Design

- **Service Layer (Injectable)** → Handles all DB access, business logic, and transactions
- **Controller / GraphQL (Query / Mutation / Resolver)** → Routing only; must not directly use Repository

## Dual-Layer Module Architecture

Each feature module must contain **DataModule** and **Module**. See [DUAL_LAYER.md](DUAL_LAYER.md) for details.

### Quick Reference

| Layer      | File Pattern           | Responsibilities                  | Exports       |
|------------|------------------------|-----------------------------------|---------------|
| DataModule | `*-data.module.ts`     | Service, DataLoader, Repository   | Service, DataLoader |
| Module     | `*.module.ts`          | Queries, Mutations, Resolvers     | Nothing (API endpoint) |

## ModelsModule (Central Repository)

Symbol Token Pattern for type-safe injection. See [MODELS_MODULE.md](MODELS_MODULE.md).

```typescript
// Entity: export const User = Symbol('User');
// Service: @Inject(User) private readonly userRepo: Repository<UserEntity>
```

## GraphQL Code-First Integration

- **Entity**: `@Entity()` + `@ObjectType()`
- **Fields**: `@Column()` + `@Field()` for exposed fields
- **Relations**: Use `Relation<T>` type, NO `@Field()` decorator
- **Resolvers**: `@ResolveField()` for relationships and computed fields

### File Pattern (See [GRAPHQL_FILE_PATTERN.md](GRAPHQL_FILE_PATTERN.md))

| File | Content |
|------|---------|
| `*.queries.ts` | `@Query()` methods |
| `*.mutations.ts` | `@Mutation()` methods |
| `{object-type}.resolver.ts` | `@ResolveField()` only (create when needed)

## DataLoader Pattern (N+1 Prevention)

See [DATALOADER.md](DATALOADER.md) for patterns.

```typescript
readonly loader = new DataLoader<string, Entity>(batchFn, { cache: false });
```

## Transaction Handling

See [TRANSACTION.md](TRANSACTION.md) for patterns.

```typescript
const qr = dataSource.createQueryRunner();
await qr.connect();
await qr.startTransaction();
try { /* save, commit */ } catch { /* rollback */ } finally { /* release */ }
```

## ABAC Permission Control

See [ABAC.md](ABAC.md) for decorators.

- `@HasPermission(object, action)`
- `@WasLoggedIn()`, `@CurrentUserId()`, `@IsConform()`, `@ManagedCostCenters()`

## TypeORM Rules

See [TYPEORM.md](TYPEORM.md) for relationship patterns.

## Agent Integration

When creating new NestJS modules, pair with the `nestjs-module-scaffolder` agent for the full 11-step scaffolding workflow:
- Detect project topology (Nx Monorepo / Standalone)
- Create Entity, Symbol, DataService, DataLoader, DataModule
- Create Queries, Mutations, Resolver, Module
- Register in ModelsModule and AppModule
