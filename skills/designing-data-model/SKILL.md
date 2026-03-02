---
name: designing-data-model
description: TypeORM Entity data model design guide. Entity-as-ObjectType pattern, Column type mapping, Relation patterns, Enum handling, FK naming conventions. Use when designing data models, creating entities, adding database tables, or working with TypeORM columns and relations.
---

# TypeORM Entity Data Model Design Guide

Complete reference for designing TypeORM Entities, covering Entity-as-ObjectType dual decoration pattern, column type mapping, relation design, and Enum handling.

## Core Principles

1. **Entity-as-ObjectType**: Every Entity is also a GraphQL ObjectType, using `@Entity` + `@ObjectType` dual decoration
2. **Symbol DI**: Each Entity exports a companion Symbol for ModelsModule dependency injection
3. **Explicit types**: All Columns MUST explicitly specify type strings (`'varchar'`, `'uuid'`, `'int'`) — never rely on auto-inference
4. **Nullable consistency**: Column and Field nullable settings MUST match

## Quick Reference

- **Entity field patterns** → [ENTITY_PATTERNS.md](./ENTITY_PATTERNS.md)
- **Relation design** → [RELATION_PATTERNS.md](./RELATION_PATTERNS.md)
- **Enum handling** → [ENUM_PATTERNS.md](./ENUM_PATTERNS.md)

## Entity Basic Structure

```typescript
import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';
import { ObjectType, Field, ID } from '@nestjs/graphql';

export const MyEntity = Symbol('MyEntity');

@Entity('my_entities')        // Table name: plural snake_case
@ObjectType('MyEntity')       // GraphQL name: PascalCase singular
export class MyEntityEntity {
  @PrimaryGeneratedColumn('uuid')
  @Field(() => ID)
  id: string;

  // ... columns
}
```

## Naming Conventions

| Item               | Format            | Example                         |
|--------------------|-------------------|---------------------------------|
| Symbol             | PascalCase        | `Supplier`                      |
| Entity class       | PascalCase+Entity | `SupplierEntity`                |
| `@Entity` table    | snake_case plural | `'suppliers'`                   |
| `@ObjectType` name | PascalCase        | `'Supplier'`                    |
| Column property    | camelCase         | `contactPerson`                 |
| FK Column          | camelCase+Id      | `supplierId`                    |
| Entity filename    | kebab-case        | `supplier.entity.ts`            |
