# Mock Data Generation Strategy

Generated prototypes use `@faker-js/faker` with `zh_TW` locale to produce realistic Traditional Chinese mock data, and `useState`-based hooks for full CRUD interactivity.

## Package Dependency

```json
{
  "@faker-js/faker": "^9.0.0"
}
```

## Hook Pattern

Each entity generates a `useMock{Entity}` hook:

```tsx
'use client';

import { useState, useCallback } from 'react';
import { faker } from '@faker-js/faker/locale/zh_TW';
import type { Mock{Entity} } from '@/types';

function createMock{Entity}(): Mock{Entity} {
  return {
    id: faker.string.uuid(),
    // ... fields mapped by type (see Field Type → Faker Mapping below)
  };
}

const initialData: readonly Mock{Entity}[] = Array.from(
  { length: 50 },
  createMock{Entity},
);

export function useMock{Entity}(): {
  items: readonly Mock{Entity}[];
  create: (values: Omit<Mock{Entity}, 'id'>) => void;
  update: (id: string, values: Partial<Mock{Entity}>) => void;
  remove: (id: string) => void;
} {
  const [items, setItems] = useState<readonly Mock{Entity}[]>(initialData);

  const create = useCallback((values: Omit<Mock{Entity}, 'id'>): void => {
    const newItem: Mock{Entity} = { ...values, id: faker.string.uuid() };
    setItems((prev) => [newItem, ...prev]);
  }, []);

  const update = useCallback((id: string, values: Partial<Mock{Entity}>): void => {
    setItems((prev) =>
      prev.map((item) => (item.id === id ? { ...item, ...values } : item)),
    );
  }, []);

  const remove = useCallback((id: string): void => {
    setItems((prev) => prev.filter((item) => item.id !== id));
  }, []);

  return { items, create, update, remove } as const;
}
```

## Field Type → Faker Mapping

| Field Type | Faker Call | Example Output |
|------------|-----------|----------------|
| `string` (name) | `faker.person.fullName()` | "陳建宏" |
| `string` (company) | `faker.company.name()` | "台灣積體電路製造股份有限公司" |
| `string` (generic) | `faker.lorem.words(3)` | "有限公司管理" |
| `string` (code/sku) | `faker.string.alphanumeric(8).toUpperCase()` | "A3K9M2P1" |
| `string` (email) | `faker.internet.email()` | "jianming@example.com" |
| `string` (phone) | `faker.phone.number()` | "02-2345-6789" |
| `string` (address) | `faker.location.streetAddress()` | "台北市信義區松仁路100號" |
| `text` | `faker.lorem.paragraphs(2)` | Long text |
| `number` (count) | `faker.number.int({ min: 1, max: 1000 })` | 42 |
| `number` (price) | `faker.number.int({ min: 100, max: 99999 })` | 12500 |
| `number` (percentage) | `faker.number.float({ min: 0, max: 100, fractionDigits: 1 })` | 87.3 |
| `date` | `faker.date.past().toISOString()` | "2024-03-15T..." |
| `datetime` | `faker.date.recent().toISOString()` | "2024-06-20T14:30:..." |
| `boolean` | `faker.datatype.boolean({ probability: 0.8 })` | true |
| `enum` | `faker.helpers.arrayElement(['option1', 'option2'])` | "option1" |
| `select` (ref) | Referenced entity's id from its mock data | "uuid-of-related" |

## Type Definition Pattern

Each entity generates a TypeScript type in `src/types/index.ts`:

```typescript
export interface Mock{Entity} {
  readonly id: string;
  readonly name: string;
  readonly category: string;
  readonly price: number;
  readonly isActive: boolean;
  readonly createdAt: string;
  // ... all fields from EntitySpec
}
```

## Contextual Faker Selection

The LLM should choose the most appropriate faker method based on the field's semantic meaning, not just its type. Guidelines:

- Field named `name` + entity is a person → `faker.person.fullName()`
- Field named `name` + entity is a company → `faker.company.name()`
- Field named `name` + entity is a product → `faker.commerce.productName()`
- Field named `email` → `faker.internet.email()`
- Field named `phone` → `faker.phone.number()`
- Field named `address` → `faker.location.streetAddress()`
- Field named `price` or `amount` → `faker.number.int({ min: 100, max: 99999 })`
- Field named `quantity` or `count` → `faker.number.int({ min: 1, max: 1000 })`
- Field named `description` or `note` → `faker.lorem.sentences(2)`
- Field named `createdAt` or `updatedAt` → `faker.date.past().toISOString()`

## Initial Data Count

- Generate **50 items** per entity by default (enough for 5 pages of 10-item pagination)
- For entities that are "reference data" (categories, warehouses) generate **5-10 items**
- Dashboard stats should be derived from actual mock data counts
