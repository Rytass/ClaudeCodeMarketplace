# Relation Design Patterns

## ManyToOne (Most Common)

Use for FK associations. You MUST declare both the FK Column and the Relation.

```typescript
// FK Column (database layer)
@Column('uuid')
@Field(() => String)
supplierId: string;

// Relation (ORM layer — use string references to avoid circular dependencies)
@ManyToOne('SupplierEntity')
@JoinColumn({ name: 'supplierId' })
supplier: Relation<import('./supplier.entity').SupplierEntity>;
```

### Nullable ManyToOne

```typescript
@Column('varchar', { nullable: true })
@Field(() => String, { nullable: true })
projectId: string | null;

@ManyToOne('ProjectEntity')
@JoinColumn({ name: 'projectId' })
project: Relation<import('./project.entity').ProjectEntity | null>;
```

### ManyToOne with Inverse Reference

```typescript
// Child side (PurchaseOrderHeader)
@ManyToOne('PurchaseRequisitionHeaderEntity', 'purchaseOrders')
@JoinColumn({ name: 'purchaseRequisitionId' })
purchaseRequisition: Relation<import('./purchase-requisition-header.entity').PurchaseRequisitionHeaderEntity>;
```

## OneToMany (Inverse Relation)

No `@JoinColumn` required. The second argument specifies the child-side property name.

```typescript
// Parent side (PurchaseRequisitionHeader)
@OneToMany('PurchaseOrderHeaderEntity', 'purchaseRequisition')
purchaseOrders: Relation<import('./purchase-order-header.entity').PurchaseOrderHeaderEntity[]>;
```

## OneToOne

```typescript
@OneToOne('PaymentProgressEntity', 'purchaseOrder')
paymentProgress: Relation<import('./payment-progress.entity').PaymentProgressEntity>;
```

## onDelete Strategy Reference

| Strategy      | When to Use                                    | Example                                      |
|---------------|------------------------------------------------|----------------------------------------------|
| `CASCADE`     | Delete child records when parent is deleted    | Order details deleted with the order         |
| `SET NULL`    | Set FK to null when parent is deleted          | Orders retained after project deletion       |
| `RESTRICT`    | Prevent parent deletion while children exist (default) | Cannot delete supplier with existing orders |

```typescript
// CASCADE example
@ManyToOne('PurchaseOrderHeaderEntity', 'details', { onDelete: 'CASCADE' })
@JoinColumn({ name: 'headerId' })
header: Relation<import('./purchase-order-header.entity').PurchaseOrderHeaderEntity>;

// SET NULL example
@ManyToOne('ProjectEntity', { onDelete: 'SET NULL' })
@JoinColumn({ name: 'projectId' })
project: Relation<import('./project.entity').ProjectEntity | null>;
```

## FK Naming Conventions

| Rule                                                     | Example                  |
|----------------------------------------------------------|--------------------------|
| Target Entity name in camelCase + `Id`                   | `supplierId`             |
| Use prefix to disambiguate (multiple FKs to same Entity) | `poDetailId`             |
| JoinColumn `name` MUST match the Column property name    | `{ name: 'supplierId' }` |

## Why Relations Use String References

TypeORM Relations use string Entity names (instead of direct class imports) to avoid circular dependencies:

```typescript
// ✅ Use string reference
@ManyToOne('SupplierEntity')

// ❌ Avoid direct reference (may cause circular dependencies)
@ManyToOne(() => SupplierEntity)
```

For TypeScript type hints, use the `Relation<>` wrapper with dynamic `import()`:

```typescript
supplier: Relation<import('./supplier.entity').SupplierEntity>;
```

## Header-Detail Pattern

Use for master-detail data structures (order-line items, quote-line items):

```typescript
// Header Entity
@OneToMany('PurchaseOrderDetailEntity', 'header')
details: Relation<import('./purchase-order-detail.entity').PurchaseOrderDetailEntity[]>;

// Detail Entity
@Column('uuid')
@Field(() => String)
headerId: string;

@ManyToOne('PurchaseOrderHeaderEntity', 'details', { onDelete: 'CASCADE' })
@JoinColumn({ name: 'headerId' })
header: Relation<import('./purchase-order-header.entity').PurchaseOrderHeaderEntity>;
```
