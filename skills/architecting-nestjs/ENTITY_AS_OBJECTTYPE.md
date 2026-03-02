# Entity as GraphQL ObjectType Pattern

## Core Concept

A TypeORM Entity simultaneously serves as a GraphQL ObjectType. Selectively add `@Field()` to control which columns are publicly exposed.

## Naming Convention

- Entity class name: `*Entity` (e.g. `MemberEntity`)
- GraphQL type name: Remove the `Entity` suffix (e.g. `Member`)

```typescript
@ObjectType('Member')  // GraphQL type name
@Entity('members')     // Database table name
export class MemberEntity { ... }
```

## Implementation Pattern

### Basic Structure

```typescript
import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';
import { ObjectType, Field, ID } from '@nestjs/graphql';

@ObjectType('User')
@Entity('users')
export class UserEntity {
  // Public field: add @Field
  @Field(() => ID)
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Field(() => String)
  @Column('varchar')
  name: string;

  // Private field: do NOT add @Field
  @Column('varchar')
  password: string;  // Will not appear in the GraphQL schema
}
```

### Inheriting Parent Class Fields

Use the `declare` keyword to override parent class fields, adding only `@Field()` without duplicating `@Column()`:

```typescript
@ObjectType('Member')
@ChildEntity()
export class MemberEntity extends BaseMemberEntity {
  // Override parent field — add @Field only (no @Column)
  @Field(() => ID)
  declare id: string;

  @Field(() => String)
  declare account: string;

  @Field(() => Date)
  declare createdAt: Date;

  // Custom field: add both @Field and @Column
  @Field(() => String, { nullable: true })
  @Column('varchar', { nullable: true })
  displayName: string | null;
}
```

## Field Exposure Guidelines

| Field Type                    | Add @Field? | Description                            |
|-------------------------------|-------------|----------------------------------------|
| ID, account, name             | Yes         | Basic identification info              |
| Created/updated timestamps    | Case by case| Typically exposed                      |
| Deleted timestamp             | No          | Typically not exposed                  |
| Password-related              | No          | Sensitive information                  |
| Internal state counters       | No          | Internal use only                      |
| Relation fields               | No          | Handle via @ResolveField instead       |

## When to Use

Suitable scenarios:
- Entity fields and API response fields largely overlap
- Reduce redundant DTO definitions
- Need precise control over which fields are publicly exposed

Not suitable scenarios:
- API response requires many computed fields
- Need to combine data from multiple Entities
- Response structure differs significantly from the Entity

## Usage with Resolvers

Entities can be used directly as Query/Mutation return types:

```typescript
@Resolver()
export class UserResolver {
  @Query(() => UserEntity)
  async me(@MemberId() id: string): Promise<UserEntity> {
    return this.userService.findById(id);
  }
}
```

## Important Notes

1. **NEVER add @Field to sensitive columns**: password, token, etc. must never be exposed
2. **Use @ResolveField for relation fields**: Avoid N+1 problems by using DataLoader
3. **Keep nullable settings consistent**: `@Column` and `@Field` nullable values MUST match
