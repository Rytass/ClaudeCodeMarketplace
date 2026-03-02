# Dual-Layer Module Architecture

Each feature module must contain **DataModule** and **Module**.

## DataModule (Data Access Layer)

**File**: `libs/{feature}/src/lib/{feature}-data.module.ts`

**Responsibilities**:
- Imports `ModelsModule` for Repository access via Symbol tokens
- Provides `Service` for business logic and database operations
- Provides `DataLoader` for batch loading optimization (N+1 prevention)
- Exports `Service` and `DataLoader` for use by Module layer

**Example**:
```typescript
import { Module } from '@nestjs/common';
import { ModelsModule } from '@project/models';
import { UserService } from './user.service';
import { UserDataLoader } from './user.dataloader';

@Module({
  imports: [ModelsModule],
  providers: [UserService, UserDataLoader],
  exports: [UserService, UserDataLoader],
})
export class UserDataModule {}
```

## Module (API Routing Layer)

**File**: `libs/{feature}/src/lib/{feature}.module.ts`

**Responsibilities**:
- Imports `DataModule` and other dependencies
- Provides `Queries` (@Query() decorators for GraphQL queries)
- Provides `Mutations` (@Mutation() decorators for GraphQL mutations)
- Provides `Resolvers` (@ResolveField() for field resolution)
- Does NOT export anything (final API endpoint)

**Example**:
```typescript
import { Module } from '@nestjs/common';
import { UserDataModule } from './user-data.module';
import { UserQueries } from './user.queries';
import { UserMutations } from './user.mutations';
import { UserResolvers } from './user.resolvers';

@Module({
  imports: [UserDataModule],
  providers: [UserQueries, UserMutations, UserResolvers],
})
export class UserModule {}
```

## File Naming Convention

| Purpose      | Pattern                | Example                  |
|--------------|------------------------|--------------------------|
| DataModule   | `{feature}-data.module.ts` | `user-data.module.ts`   |
| Module       | `{feature}.module.ts`  | `user.module.ts`         |
| Service      | `{feature}.service.ts` | `user.service.ts`        |
| DataLoader   | `{feature}.dataloader.ts` | `user.dataloader.ts`  |
| Queries      | `{feature}.queries.ts` | `user.queries.ts`        |
| Mutations    | `{feature}.mutations.ts` | `user.mutations.ts`    |
| Resolvers    | `{feature}.resolvers.ts` | `user.resolvers.ts`    |
