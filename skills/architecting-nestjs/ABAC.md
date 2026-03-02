# ABAC Permission Control

Attribute-Based Access Control using Casbin.

## Global Guard Setup

```typescript
import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { ABACGuard } from './guards/abac.guard';

@Module({
  providers: [
    {
      provide: APP_GUARD,
      useClass: ABACGuard,
    },
  ],
})
export class AppModule {}
```

## Casbin Integration

Casbin enforcer is integrated in GraphQL context:

```typescript
// In GraphQL context factory
context: ({ req }) => ({
  enforcer: req.casbinEnforcer,
  userId: req.userId,
  // ... other context
})
```

## Custom Decorators

### @HasPermission(object, action)

Check if user has permission on object:

```typescript
@Query(() => [UserEntity])
@HasPermission('user', 'read')
async users(): Promise<UserEntity[]> {
  return this.userService.findAll();
}

@Mutation(() => UserEntity)
@HasPermission('user', 'write')
async createUser(@Args('input') input: CreateUserInput): Promise<UserEntity> {
  return this.userService.create(input);
}
```

### @WasLoggedIn()

Ensure user was authenticated:

```typescript
@Query(() => UserEntity)
@WasLoggedIn()
async me(@CurrentUserId() userId: string): Promise<UserEntity> {
  return this.userService.findById(userId);
}
```

### @CurrentUserId()

Extract current user ID from context:

```typescript
@Mutation(() => OrderEntity)
@HasPermission('order', 'write')
async createOrder(
  @CurrentUserId() userId: string,
  @Args('input') input: CreateOrderInput,
): Promise<OrderEntity> {
  return this.orderService.create(userId, input);
}
```

### @IsConform()

Check conformity status:

```typescript
@Mutation(() => ContractEntity)
@IsConform()
async signContract(@Args('id') id: string): Promise<ContractEntity> {
  return this.contractService.sign(id);
}
```

### @ManagedCostCenters()

Get cost centers managed by user:

```typescript
@Query(() => [ExpenseEntity])
@HasPermission('expense', 'read')
async expenses(
  @ManagedCostCenters() costCenters: string[],
): Promise<ExpenseEntity[]> {
  return this.expenseService.findByCostCenters(costCenters);
}
```

## Apply to ResolveFields

```typescript
@Resolver(() => UserEntity)
export class UserResolvers {
  @ResolveField(() => [OrderEntity])
  @HasPermission('order', 'read')
  async orders(@Parent() user: UserEntity): Promise<OrderEntity[]> {
    return this.orderService.findByUserId(user.id);
  }
}
```
