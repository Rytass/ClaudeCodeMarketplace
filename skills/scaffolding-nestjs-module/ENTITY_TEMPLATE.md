# Entity + Symbol + ObjectType Template

## Basic Entity Template

```typescript
import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';
import { ObjectType, Field, ID } from '@nestjs/graphql';

// Symbol for ModelsModule DI injection
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

  @Column('varchar', { nullable: true })
  @Field(() => String, { nullable: true })
  phone: string | null;

  @Column('varchar', { nullable: true })
  @Field(() => String, { nullable: true })
  email: string | null;

  @Column('varchar', { nullable: true })
  @Field(() => String, { nullable: true })
  address: string | null;

  @Column('boolean', { default: true })
  @Field(() => Boolean)
  isActive: boolean;
}
```

## Column Type Reference

| TypeORM Column Type                       | GraphQL Type                         | TypeScript Type        | Notes                                   |
|-------------------------------------------|--------------------------------------|------------------------|-----------------------------------------|
| `'uuid'`                                  | `ID`                                 | `string`               | Primary key, with `@PrimaryGeneratedColumn` |
| `'varchar'`                               | `String`                             | `string`               | General text                            |
| `'varchar', { nullable: true }`           | `String, { nullable: true }`         | `string \| null`       | Nullable text                           |
| `'text'`                                  | `String`                             | `string`               | Long text                               |
| `'int'`                                   | `Int`                                | `number`               | Integer                                 |
| `'numeric', { precision, scale }`         | `Float`                              | `number`               | Precise decimal (monetary)              |
| `'boolean'`                               | `Boolean`                            | `boolean`              | Boolean                                 |
| `'boolean', { default: true }`            | `Boolean`                            | `boolean`              | Boolean with default                    |
| `'date'`                                  | `Date`                               | `Date`                 | Date                                    |
| `'enum', { enum: MyEnum }`               | `MyEnum`                             | `MyEnum`               | Enum, requires `registerEnumType`       |
| `@CreateDateColumn()`                     | `Date`                               | `Date`                 | Auto-generated created timestamp        |
| `@UpdateDateColumn()`                     | `Date`                               | `Date`                 | Auto-generated updated timestamp        |

## Complete Entity Template with Relations

```typescript
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  OneToMany,
  JoinColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Relation,
} from 'typeorm';
import { ObjectType, Field, ID, Float, Int } from '@nestjs/graphql';
import { PurchaseOrderStatus, PaymentTerms } from '@scope/constants';

export const PurchaseOrderHeader = Symbol('PurchaseOrderHeader');

@Entity('purchase_order_headers')
@ObjectType('PurchaseOrderHeader')
export class PurchaseOrderHeaderEntity {
  @PrimaryGeneratedColumn('uuid')
  @Field(() => ID)
  id: string;

  @Column('varchar', { unique: true })
  @Field(() => String)
  code: string;

  // --- FK field: explicitly declare Column + Field ---
  @Column('uuid')
  @Field(() => String)
  supplierId: string;

  // --- Enum field: use 'enum' column type ---
  @Column('enum', { enum: PurchaseOrderStatus, default: PurchaseOrderStatus.DRAFT })
  @Field(() => PurchaseOrderStatus)
  status: PurchaseOrderStatus;

  // --- Precise decimal field: precision + scale ---
  @Column('numeric', { precision: 14, scale: 2, nullable: true })
  @Field(() => Float, { nullable: true })
  totalAmount: number | null;

  // --- Timestamps ---
  @CreateDateColumn()
  @Field(() => Date)
  createdAt: Date;

  @UpdateDateColumn()
  @Field(() => Date)
  updatedAt: Date;

  // --- Relations ---
  @ManyToOne('SupplierEntity')
  @JoinColumn({ name: 'supplierId' })
  supplier: Relation<import('./supplier.entity').SupplierEntity>;

  @OneToMany('PurchaseOrderDetailEntity', 'header')
  details: Relation<import('./purchase-order-detail.entity').PurchaseOrderDetailEntity[]>;
}
```

## Relation Quick Reference

### ManyToOne + JoinColumn (Most Common)

```typescript
// FK field
@Column('uuid')
@Field(() => String)
supplierId: string;

// Relation (use string reference to avoid circular dependencies)
@ManyToOne('SupplierEntity')
@JoinColumn({ name: 'supplierId' })
supplier: Relation<import('./supplier.entity').SupplierEntity>;
```

### OneToMany (Inverse Relation)

```typescript
@OneToMany('PurchaseOrderDetailEntity', 'header')
details: Relation<import('./purchase-order-detail.entity').PurchaseOrderDetailEntity[]>;
```

### FK Naming Conventions

| Relation Target  | FK Column Name           | JoinColumn name            |
|------------------|--------------------------|----------------------------|
| SupplierEntity   | `supplierId`             | `'supplierId'`             |
| ProjectEntity    | `projectId`              | `'projectId'`              |
| HeaderEntity     | `headerId`               | `'headerId'`               |
| Custom prefix    | `poDetailId`             | `'poDetailId'`             |

Naming rule: `{camelCase target name}Id`. The JoinColumn `name` MUST match the Column property name.
