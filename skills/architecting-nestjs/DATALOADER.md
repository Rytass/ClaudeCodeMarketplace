# DataLoader Pattern (N+1 Prevention)

Use `dataloader` library for batch loading.

## Basic Pattern

```typescript
import DataLoader from 'dataloader';
import { Injectable, Inject } from '@nestjs/common';
import { Repository, In } from 'typeorm';
import { User, UserEntity } from '@project/models';

@Injectable()
export class UserDataLoader {
  constructor(
    @Inject(User)
    private readonly userRepo: Repository<UserEntity>,
  ) {}

  readonly loader = new DataLoader<string, UserEntity | null>(
    async (ids: readonly string[]) => {
      const users = await this.userRepo.find({
        where: { id: In([...ids]) },
      });

      const userMap = new Map(users.map(u => [u.id, u]));

      // CRITICAL: Return array matching input IDs order
      return ids.map(id => userMap.get(id) ?? null);
    },
    { cache: false }
  );
}
```

## With LRU Cache

```typescript
import LRUCache from 'lru-cache';

readonly loader = new DataLoader<string, UserEntity | null>(
  batchFn,
  {
    cache: true,
    cacheMap: new LRUCache({ ttl: 10000 })
  }
);
```

## Dynamic Parameters Pattern

When loader needs additional parameters:

```typescript
@Injectable()
export class OrderDataLoader {
  constructor(
    @Inject(Order)
    private readonly orderRepo: Repository<OrderEntity>,
  ) {}

  getOrdersByDateLoader(date: string): DataLoader<string, OrderEntity[]> {
    return new DataLoader<string, OrderEntity[]>(
      async (userIds: readonly string[]) => {
        const orders = await this.orderRepo.find({
          where: {
            userId: In([...userIds]),
            orderDate: date,
          },
        });

        const orderMap = new Map<string, OrderEntity[]>();
        orders.forEach(o => {
          const existing = orderMap.get(o.userId) ?? [];
          orderMap.set(o.userId, [...existing, o]);
        });

        return userIds.map(id => orderMap.get(id) ?? []);
      },
      { cache: false }
    );
  }
}
```

## Usage in Resolvers

```typescript
@Resolver(() => OrderEntity)
export class OrderResolvers {
  constructor(private readonly userDataLoader: UserDataLoader) {}

  @ResolveField(() => UserEntity)
  async user(@Parent() order: OrderEntity): Promise<UserEntity | null> {
    return this.userDataLoader.loader.load(order.userId);
  }
}
```

## Critical Rules

1. **Always return array matching input order**: The batch function must return results in the same order as input IDs
2. **Handle missing items**: Return `null` or empty array for IDs not found
3. **Disable caching for request-scoped data**: Use `{ cache: false }` when data changes per request
