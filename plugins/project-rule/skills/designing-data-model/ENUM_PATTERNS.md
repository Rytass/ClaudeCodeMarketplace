# Enum Handling Patterns

## Standard Enum Definition + Registration

### Step 1: Define the Enum (in constants lib)

```typescript
// libs/constants/src/lib/enum/payment-terms.enum.ts
export enum PaymentTerms {
  AFTER_DELIVERY_ONE_WEEK = 'AFTER_DELIVERY_ONE_WEEK',
  PREPAID = 'PREPAID',
  NET_30 = 'NET_30',
  AUTO_DEDUCT_MONTHLY = 'AUTO_DEDUCT_MONTHLY',
}
```

**Naming conventions:**
- Enum name: PascalCase (`PaymentTerms`, `PurchaseOrderStatus`)
- Enum values: UPPER_SNAKE_CASE, value equals key (`'PREPAID' = 'PREPAID'`)
- File name: kebab-case (`payment-terms.enum.ts`)

### Step 2: Register GraphQL Enum (in graphql lib)

```typescript
// libs/graphql/src/lib/enums.ts
import { registerEnumType } from '@nestjs/graphql';
import { PaymentTerms } from '@scope/constants';

registerEnumType(PaymentTerms, {
  name: 'PaymentTerms',
});
```

Every Enum MUST call `registerEnumType` to be available in the GraphQL schema. Centralize all registrations in `libs/graphql/src/lib/enums.ts`.

### Step 3: Use in Entity

```typescript
import { PaymentTerms } from '@scope/constants';

// Use 'enum' column type
@Column('enum', { enum: PaymentTerms })
@Field(() => PaymentTerms)
paymentTerms: PaymentTerms;

// With default value
@Column('enum', { enum: PurchaseOrderStatus, default: PurchaseOrderStatus.DRAFT })
@Field(() => PurchaseOrderStatus)
status: PurchaseOrderStatus;
```

## Text Column Alternative

When Enum values may change frequently or require more flexibility, use a `text` column with a TypeScript enum:

```typescript
// Use text column for storage (does not create a database enum type)
@Column('text')
@Field(() => MyStatus)
status: MyStatus;
```

**Selection criteria:**

| Approach          | Pros                          | Cons                          | Use When                            |
|-------------------|-------------------------------|-------------------------------|-------------------------------------|
| `'enum'` column   | Database-level validation     | Adding values requires migration | Status fields, infrequent changes |
| `'text'` column   | Adding values needs no migration | No database validation       | Category fields, frequent changes |

## Complete Example

```typescript
// 1. Define Enum
// libs/constants/src/lib/enum/purchase-order-status.enum.ts
export enum PurchaseOrderStatus {
  DRAFT = 'DRAFT',
  SUBMITTED = 'SUBMITTED',
  APPROVED = 'APPROVED',
  REJECTED = 'REJECTED',
  CANCELLED = 'CANCELLED',
}

// 2. Register
// libs/graphql/src/lib/enums.ts
import { registerEnumType } from '@nestjs/graphql';
import { PurchaseOrderStatus } from '@scope/constants';

registerEnumType(PurchaseOrderStatus, {
  name: 'PurchaseOrderStatus',
});

// 3. Use
// libs/models/src/lib/entities/purchase-order.entity.ts
@Column('enum', { enum: PurchaseOrderStatus, default: PurchaseOrderStatus.DRAFT })
@Field(() => PurchaseOrderStatus)
status: PurchaseOrderStatus;
```

## Common Enum Design Patterns

### Status Flow Enum

```typescript
export enum OrderStatus {
  DRAFT = 'DRAFT',
  SUBMITTED = 'SUBMITTED',
  APPROVED = 'APPROVED',
  IN_PROGRESS = 'IN_PROGRESS',
  COMPLETED = 'COMPLETED',
  CANCELLED = 'CANCELLED',
}
```

### Type Classification Enum

```typescript
export enum MaterialType {
  RAW_MATERIAL = 'RAW_MATERIAL',
  CONSUMABLE = 'CONSUMABLE',
  ASSET = 'ASSET',
}
```

### Enum Usage in DTOs

```typescript
// For filtering
@Args('status', { type: () => PurchaseOrderStatus, nullable: true })
status?: PurchaseOrderStatus;

// For input
@InputType()
export class UpdateOrderInput {
  @Field(() => PurchaseOrderStatus, { nullable: true })
  status?: PurchaseOrderStatus;
}
```
