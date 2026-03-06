# Transaction Handling

Use `DataSource.createQueryRunner()` pattern for transactions.

## Basic Pattern

```typescript
import { Injectable } from '@nestjs/common';
import { DataSource, QueryRunner } from 'typeorm';

@Injectable()
export class OrderService {
  constructor(private readonly dataSource: DataSource) {}

  async createOrder(data: CreateOrderDto): Promise<OrderEntity> {
    const qr: QueryRunner = this.dataSource.createQueryRunner();

    await qr.connect();
    await qr.startTransaction();

    try {
      // Create order
      const order = qr.manager.create(OrderEntity, {
        userId: data.userId,
        total: data.total,
      });
      await qr.manager.save(order);

      // Create order items
      const items = data.items.map(item =>
        qr.manager.create(OrderItemEntity, {
          orderId: order.id,
          ...item,
        })
      );
      await qr.manager.save(items);

      // Commit transaction
      await qr.commitTransaction();

      // Post-transaction operations (e.g., refresh materialized view)
      await this.refreshOrderStats();

      return order;
    } catch (error) {
      // Rollback on error
      await qr.rollbackTransaction();
      throw error;
    } finally {
      // Always release
      await qr.release();
    }
  }
}
```

## Key Rules

1. **Always call `connect()`** before `startTransaction()`
2. **Always `rollback()` in catch block**
3. **Always `release()` in finally block**
4. **Post-transaction operations** (like refreshing materialized views) should happen after `commitTransaction()` but before `release()`

## With Multiple Entities

```typescript
async transferFunds(
  fromAccountId: string,
  toAccountId: string,
  amount: number
): Promise<void> {
  const qr = this.dataSource.createQueryRunner();

  await qr.connect();
  await qr.startTransaction('SERIALIZABLE'); // Use isolation level

  try {
    const fromAccount = await qr.manager.findOne(AccountEntity, {
      where: { id: fromAccountId },
      lock: { mode: 'pessimistic_write' },
    });

    const toAccount = await qr.manager.findOne(AccountEntity, {
      where: { id: toAccountId },
      lock: { mode: 'pessimistic_write' },
    });

    if (!fromAccount || !toAccount) {
      throw new Error('Account not found');
    }

    if (fromAccount.balance < amount) {
      throw new Error('Insufficient funds');
    }

    fromAccount.balance -= amount;
    toAccount.balance += amount;

    await qr.manager.save([fromAccount, toAccount]);
    await qr.commitTransaction();
  } catch (error) {
    await qr.rollbackTransaction();
    throw error;
  } finally {
    await qr.release();
  }
}
```
