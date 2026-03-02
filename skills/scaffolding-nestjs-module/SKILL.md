---
name: scaffolding-nestjs-module
description: Backend NestJS module scaffolding. Full 11-step creation workflow — Entity + Symbol, ModelsModule, Enum, DTOs, DataService, DataLoader, DataModule, Queries, Mutations, Resolver, Module. Use when creating NestJS modules, scaffolding modules, adding backend features, or creating entity/service/resolver files.
---

# NestJS Module Scaffolding

Complete 11-step workflow to create a NestJS module. Each step corresponds to one file or code modification.

## Creation Workflow Overview

| Step | Action                     | File                                       | Description                                     |
|------|----------------------------|--------------------------------------------|-------------------------------------------------|
| 1    | Entity + Symbol            | `libs/models/src/lib/entities/X.entity.ts` | Define table structure with `@ObjectType` dual decoration |
| 2    | ModelsModule registration  | `libs/models/src/lib/models.module.ts`     | Add `[Symbol, Entity]` to `models` array        |
| 3    | Enum (if needed)           | `libs/constants/src/lib/enum/X.enum.ts`    | Define status/type enums + `registerEnumType`   |
| 4    | DTOs                       | `libs/X/src/lib/dto/`                      | CreateInput, UpdateInput, CollectionDto         |
| 5    | DataService                | `libs/X/src/lib/X-data.service.ts`         | CRUD logic, inject Symbol Repository            |
| 6    | DataLoader                 | `libs/X/src/lib/X.dataloader.ts`           | Batch loading with `dataloader` package         |
| 7    | DataModule                 | `libs/X/src/lib/X-data.module.ts`          | Import ModelsModule, export DataService         |
| 8    | Queries                    | `libs/X/src/lib/X.queries.ts`              | `@Query` methods + permission decorators        |
| 9    | Mutations                  | `libs/X/src/lib/X.mutations.ts`            | `@Mutation` methods + permission decorators     |
| 10   | Resolver (Field Resolver)  | `libs/X/src/lib/X.resolver.ts`             | `@ResolveField` for relation fields             |
| 11   | Module                     | `libs/X/src/lib/X.module.ts`               | Import DataModule, register Queries/Mutations   |

## File Naming Convention Quick Reference

| Type          | Naming Pattern                | Example                        |
|---------------|-------------------------------|--------------------------------|
| Entity        | `X.entity.ts`                 | `supplier.entity.ts`           |
| DataService   | `X-data.service.ts`           | `supplier-data.service.ts`     |
| DataLoader    | `X.dataloader.ts`             | `supplier.dataloader.ts`       |
| DataModule    | `X-data.module.ts`            | `supplier-data.module.ts`      |
| Module        | `X.module.ts`                 | `supplier.module.ts`           |
| Queries       | `X.queries.ts`                | `supplier.queries.ts`          |
| Mutations     | `X.mutations.ts`              | `supplier.mutations.ts`        |
| Resolver      | `X.resolver.ts`               | `supplier.resolver.ts`         |
| CreateInput   | `dto/create-X.input.ts`       | `dto/create-supplier.input.ts` |
| UpdateInput   | `dto/update-X.input.ts`       | `dto/update-supplier.input.ts` |
| CollectionDto | `dto/X-collection.dto.ts`     | `dto/supplier-collection.dto.ts` |

## Step-by-Step Details

### Steps 1-2: Entity + ModelsModule Registration

Create the Entity file using the Entity-as-ObjectType pattern (`@Entity` + `@ObjectType` dual decoration), and export a Symbol for DI. Then register `[Symbol, Entity]` in the ModelsModule `models` array.

→ See [ENTITY_TEMPLATE.md](./ENTITY_TEMPLATE.md)

### Step 3: Enum (Optional)

If the Entity contains status or type fields, create an enum in `libs/constants` and call `registerEnumType` in `libs/graphql`.

### Step 4: DTOs

- **CreateInput**: `@InputType()` decorated, includes fields required for creation
- **UpdateInput**: Extends `PartialType(OmitType(CreateInput, ['immutableField']))` + additional updatable fields
- **CollectionDto**: `@ObjectType()` containing `items: Entity[]` + `total: number`

### Steps 5-7: DataService + DataLoader + DataModule

DataService obtains the Repository via `@Inject(Symbol)` and implements CRUD. DataLoader uses the `dataloader` package for batch loading. DataModule imports ModelsModule and exports Service/DataLoader.

→ See [MODULE_TEMPLATE.md](./MODULE_TEMPLATE.md)

### Steps 8-9: Queries + Mutations

Separate queries and mutations into independent classes. Each method MUST have `@Authenticated()` + `@CheckPermission()` decorators.

### Steps 10-11: Resolver + Module

Resolver handles `@ResolveField` (relation field resolution). Module imports DataModule and registers Queries, Mutations, Resolver. Finally, add to `AppModule` imports.

→ See [MODULE_TEMPLATE.md](./MODULE_TEMPLATE.md)

## Post-Creation Checklist

→ See [CHECKLIST.md](./CHECKLIST.md)
