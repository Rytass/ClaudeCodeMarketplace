# Module Template

## DataModule Template

DataModule imports ModelsModule and exports DataService + DataLoader for reuse by other modules.

```typescript
// libs/suppliers/src/lib/supplier-data.module.ts
import { Module } from '@nestjs/common';
import { ModelsModule } from '@scope/models';
import { SupplierDataService } from './supplier-data.service';
import { SupplierDataLoader } from './supplier.dataloader';

@Module({
  imports: [ModelsModule],
  providers: [SupplierDataService, SupplierDataLoader],
  exports: [SupplierDataService, SupplierDataLoader],
})
export class SupplierDataModule {}
```

## DataService Template

Injects Repository via `@Inject(Symbol)` and implements CRUD operations.

```typescript
// libs/suppliers/src/lib/supplier-data.service.ts
import { Injectable, Inject, BadRequestException } from '@nestjs/common';
import { Repository, In } from 'typeorm';
import { Supplier, SupplierEntity } from '@scope/models';
import { CreateSupplierInput } from './dto/create-supplier.input';
import { UpdateSupplierInput } from './dto/update-supplier.input';

@Injectable()
export class SupplierDataService {
  constructor(
    @Inject(Supplier)
    private readonly repo: Repository<SupplierEntity>,
  ) {}

  async findById(id: string): Promise<SupplierEntity> {
    const supplier = await this.repo.findOne({ where: { id } });

    if (!supplier) {
      throw new BadRequestException(`Supplier not found: ${id}`);
    }

    return supplier;
  }

  async findByIds(ids: readonly string[]): Promise<SupplierEntity[]> {
    if (ids.length === 0) return [];

    return this.repo.find({ where: { id: In([...ids]) } });
  }

  async findAll(args: {
    readonly offset: number;
    readonly limit: number;
  }): Promise<{ items: SupplierEntity[]; total: number }> {
    const qb = this.repo.createQueryBuilder('supplier');

    qb.skip(args.offset).take(args.limit).orderBy('supplier.code', 'ASC');

    const [items, total] = await qb.getManyAndCount();

    return { items, total };
  }

  async create(input: CreateSupplierInput): Promise<SupplierEntity> {
    const supplier = this.repo.create(input);

    return this.repo.save(supplier);
  }

  async update(id: string, input: UpdateSupplierInput): Promise<SupplierEntity> {
    const supplier = await this.findById(id);

    this.repo.merge(supplier, input);

    return this.repo.save(supplier);
  }
}
```

## DataLoader Template

Uses the `dataloader` package for batch loading to avoid N+1 problems.

```typescript
// libs/suppliers/src/lib/supplier.dataloader.ts
import { Injectable } from '@nestjs/common';
import DataLoader from 'dataloader';
import { SupplierEntity } from '@scope/models';
import { SupplierDataService } from './supplier-data.service';

@Injectable()
export class SupplierDataLoader {
  constructor(private readonly service: SupplierDataService) {}

  createByIdLoader(): DataLoader<string, SupplierEntity | null> {
    return new DataLoader<string, SupplierEntity | null>(
      async ids => {
        const items = await this.service.findByIds(ids);
        const map = new Map(items.map(x => [x.id, x]));

        return ids.map(id => map.get(id) ?? null);
      },
      { cache: false },
    );
  }
}
```

## DTO Template

### CreateInput

```typescript
// libs/suppliers/src/lib/dto/create-supplier.input.ts
import { InputType, Field } from '@nestjs/graphql';

@InputType()
export class CreateSupplierInput {
  @Field(() => String)
  code: string;

  @Field(() => String)
  name: string;

  @Field(() => String, { nullable: true })
  contactPerson?: string;

  @Field(() => String, { nullable: true })
  phone?: string;
}
```

### UpdateInput

```typescript
// libs/suppliers/src/lib/dto/update-supplier.input.ts
import { InputType, Field, PartialType, OmitType } from '@nestjs/graphql';
import { CreateSupplierInput } from './create-supplier.input';

@InputType()
export class UpdateSupplierInput extends PartialType(OmitType(CreateSupplierInput, ['code'] as const)) {
  @Field(() => Boolean, { nullable: true })
  isActive?: boolean;
}
```

### CollectionDto

```typescript
// libs/suppliers/src/lib/dto/supplier-collection.dto.ts
import { ObjectType, Field, Int } from '@nestjs/graphql';
import { SupplierEntity } from '@scope/models';

@ObjectType('SupplierCollection')
export class SupplierCollectionDto {
  @Field(() => [SupplierEntity])
  items: SupplierEntity[];

  @Field(() => Int)
  total: number;
}
```

## Queries Template

```typescript
// libs/suppliers/src/lib/supplier.queries.ts
import { Resolver, Query, Args, ID } from '@nestjs/graphql';
import { Authenticated } from '@rytass/member-base-nestjs-module';
import { SupplierEntity } from '@scope/models';
import { RESOURCES, ACTIONS } from '@scope/constants';
import { PaginationArgs } from '@scope/graphql';
import { CheckPermission } from '@scope/auth';
import { SupplierDataService } from './supplier-data.service';
import { SupplierCollectionDto } from './dto/supplier-collection.dto';

@Resolver()
export class SupplierQueries {
  constructor(private readonly supplierDataService: SupplierDataService) {}

  @Authenticated()
  @CheckPermission(RESOURCES.SUPPLIER, ACTIONS.LIST)
  @Query(() => SupplierCollectionDto)
  async suppliers(
    @Args() pagination: PaginationArgs,
  ): Promise<SupplierCollectionDto> {
    return this.supplierDataService.findAll({
      offset: pagination.offset,
      limit: pagination.limit,
    });
  }

  @Authenticated()
  @CheckPermission(RESOURCES.SUPPLIER, ACTIONS.READ)
  @Query(() => SupplierEntity)
  async supplier(@Args('id', { type: () => ID }) id: string): Promise<SupplierEntity> {
    return this.supplierDataService.findById(id);
  }
}
```

## Mutations Template

```typescript
// libs/suppliers/src/lib/supplier.mutations.ts
import { Resolver, Mutation, Args, ID } from '@nestjs/graphql';
import { Authenticated } from '@rytass/member-base-nestjs-module';
import { SupplierEntity } from '@scope/models';
import { RESOURCES, ACTIONS } from '@scope/constants';
import { CheckPermission } from '@scope/auth';
import { SupplierDataService } from './supplier-data.service';
import { CreateSupplierInput } from './dto/create-supplier.input';
import { UpdateSupplierInput } from './dto/update-supplier.input';

@Resolver()
export class SupplierMutations {
  constructor(private readonly supplierDataService: SupplierDataService) {}

  @Authenticated()
  @CheckPermission(RESOURCES.SUPPLIER, ACTIONS.CREATE)
  @Mutation(() => SupplierEntity)
  async createSupplier(@Args('input') input: CreateSupplierInput): Promise<SupplierEntity> {
    return this.supplierDataService.create(input);
  }

  @Authenticated()
  @CheckPermission(RESOURCES.SUPPLIER, ACTIONS.UPDATE)
  @Mutation(() => SupplierEntity)
  async updateSupplier(
    @Args('id', { type: () => ID }) id: string,
    @Args('input') input: UpdateSupplierInput,
  ): Promise<SupplierEntity> {
    return this.supplierDataService.update(id, input);
  }
}
```

## Resolver Template (Field Resolver)

```typescript
// libs/suppliers/src/lib/supplier.resolver.ts
import { Resolver } from '@nestjs/graphql';
import { SupplierEntity } from '@scope/models';

@Resolver(() => SupplierEntity)
export class SupplierResolver {}
```

## Module Template

```typescript
// libs/suppliers/src/lib/supplier.module.ts
import { Module } from '@nestjs/common';
import { SupplierDataModule } from './supplier-data.module';
import { SupplierQueries } from './supplier.queries';
import { SupplierMutations } from './supplier.mutations';
import { SupplierResolver } from './supplier.resolver';

@Module({
  imports: [SupplierDataModule],
  providers: [SupplierQueries, SupplierMutations, SupplierResolver],
})
export class SupplierModule {}
```

## ModelsModule Registration

Add the new Entity to `libs/models/src/lib/models.module.ts`:

```typescript
import { Supplier, SupplierEntity } from './entities/supplier.entity';

const models: readonly EntityTuple[] = [
  // ... existing entities
  [Supplier, SupplierEntity],  // ← Add this line
] as const;
```

## AppModule Import

Add the new Module to `apps/api/src/app/app.module.ts`:

```typescript
import { SupplierModule } from '@scope/suppliers';

@Module({
  imports: [
    // ... base configuration modules
    SupplierModule,  // ← Add this line
  ],
})
export class AppModule {}
```
