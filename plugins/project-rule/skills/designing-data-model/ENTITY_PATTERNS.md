# Entity Field Patterns

## Standard Entity Template

```typescript
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';
import { ObjectType, Field, ID } from '@nestjs/graphql';

export const Supplier = Symbol('Supplier');

@Entity('suppliers')
@ObjectType('Supplier')
export class SupplierEntity {
  @PrimaryGeneratedColumn('uuid')
  @Field(() => ID)
  id: string;

  @Column('varchar', { unique: true })
  @Field(() => String)
  code: string;

  @Column('varchar')
  @Field(() => String)
  name: string;

  @Column('varchar', { nullable: true })
  @Field(() => String, { nullable: true })
  contactPerson: string | null;

  @Column('boolean', { default: true })
  @Field(() => Boolean)
  isActive: boolean;

  @CreateDateColumn()
  @Field(() => Date)
  createdAt: Date;

  @UpdateDateColumn()
  @Field(() => Date)
  updatedAt: Date;
}
```

## Column Type Reference

### Text Types

| TypeORM                                          | GraphQL                                            | TypeScript          | Use Case                   |
|--------------------------------------------------|----------------------------------------------------|---------------------|----------------------------|
| `@Column('varchar')`                             | `@Field(() => String)`                             | `string`            | Short text (name, code)    |
| `@Column('varchar', { nullable: true })`         | `@Field(() => String, { nullable: true })`         | `string \| null`    | Optional short text        |
| `@Column('varchar', { unique: true })`           | `@Field(() => String)`                             | `string`            | Unique value (code)        |
| `@Column('text')`                                | `@Field(() => String)`                             | `string`            | Long text (notes, desc)    |
| `@Column('text', { nullable: true })`            | `@Field(() => String, { nullable: true })`         | `string \| null`    | Optional long text         |

### Numeric Types

| TypeORM                                                 | GraphQL                                  | TypeScript       | Use Case                       |
|---------------------------------------------------------|------------------------------------------|------------------|--------------------------------|
| `@Column('int')`                                        | `@Field(() => Int)`                      | `number`         | Integer (sequence, quantity)   |
| `@Column('numeric', { precision: 14, scale: 2 })`      | `@Field(() => Float)`                    | `number`         | Monetary amount                |
| `@Column('numeric', { precision: 12, scale: 2 })`      | `@Field(() => Float)`                    | `number`         | Quantity (with decimals)       |
| `@Column('numeric', { precision: 5, scale: 2 })`       | `@Field(() => Float)`                    | `number`         | Percentage                     |

### Other Types

| TypeORM                                                    | GraphQL                                           | TypeScript     | Use Case              |
|------------------------------------------------------------|---------------------------------------------------|----------------|-----------------------|
| `@Column('boolean')`                                       | `@Field(() => Boolean)`                           | `boolean`      | Boolean               |
| `@Column('boolean', { default: true })`                    | `@Field(() => Boolean)`                           | `boolean`      | Boolean with default  |
| `@Column('date')`                                          | `@Field(() => Date)`                              | `Date`         | Date                  |
| `@Column('date', { nullable: true })`                      | `@Field(() => Date, { nullable: true })`          | `Date \| null` | Optional date         |
| `@Column('uuid')`                                          | `@Field(() => String)`                            | `string`       | FK field              |
| `@Column('enum', { enum: MyEnum })`                        | `@Field(() => MyEnum)`                            | `MyEnum`       | Enum field            |
| `@Column('enum', { enum: MyEnum, default: MyEnum.X })`    | `@Field(() => MyEnum)`                            | `MyEnum`       | Enum with default     |
| `@PrimaryGeneratedColumn('uuid')`                          | `@Field(() => ID)`                                | `string`       | UUID primary key      |
| `@CreateDateColumn()`                                      | `@Field(() => Date)`                              | `Date`         | Created timestamp     |
| `@UpdateDateColumn()`                                      | `@Field(() => Date)`                              | `Date`         | Updated timestamp     |

## Design Decision Guide

### When to Use `varchar` vs `text`

- **`varchar`**: Short text with length limits (name, code, phone, email)
- **`text`**: Long text with no length limit (notes, description, address)

### When to Use `numeric` vs `int`

- **`int`**: Integer values (sequence numbers, integer-only quantities)
- **`numeric(14,2)`**: Monetary amounts (precise to 2 decimal places)
- **`numeric(12,2)`**: Quantities (may have decimals)
- **`numeric(5,2)`**: Percentages (e.g., 99.99%)

### Nullable Field Notes

- TypeScript type uses `string | null` (NOT `string | undefined`)
- Both Column and Field MUST be marked `{ nullable: true }`
- Optional fields in DTOs use `?` (`string?`), NOT `| null`
