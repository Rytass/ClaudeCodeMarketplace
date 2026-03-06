# GKE API Boilerplate — NestJS + Apollo Server + TypeORM

## Directory Structure

```
apps/api/
├── src/
│   ├── main.ts
│   ├── app.module.ts
│   ├── modules/
│   │   └── models/
│   │       ├── models.module.ts
│   │       ├── member/
│   │       │   ├── member.entity.ts
│   │       │   └── member.resolver.ts
│   │       └── index.ts
│   └── healthcheck/
│       ├── healthcheck.controller.ts
│       └── healthcheck.module.ts
├── tsconfig.json
└── project.json
```

## Bootstrap — `src/main.ts`

```typescript
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create(AppModule);
  await app.listen(process.env.PORT ?? 6001);
}

bootstrap();
```

## App Module — `src/app.module.ts`

```typescript
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { GraphQLModule } from '@nestjs/graphql';
import { ApolloDriver, ApolloDriverConfig } from '@nestjs/apollo';
import { MemberBaseModule } from '@rytass/member-base-nestjs-module';
import { HealthcheckModule } from './healthcheck/healthcheck.module';
import { ModelsModule } from './modules/models/models.module';

@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      useFactory: () => ({
        type: 'postgres',
        url: process.env.DATABASE_URL,
        autoLoadEntities: true,
        synchronize: false,
      }),
    }),
    GraphQLModule.forRoot<ApolloDriverConfig>({
      driver: ApolloDriver,
      autoSchemaFile: true,
      sortSchema: true,
      playground: process.env.NODE_ENV !== 'production',
    }),
    MemberBaseModule,
    HealthcheckModule,
    ModelsModule,
  ],
})
export class AppModule {}
```

## Entity-as-ObjectType Pattern — `modules/models/member/member.entity.ts`

The same class serves as both the TypeORM entity and the GraphQL ObjectType. This eliminates duplication between the database schema and the API schema.

```typescript
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { ObjectType, Field, ID } from '@nestjs/graphql';

@ObjectType()
@Entity('members')
export class MemberEntity {
  @Field(() => ID)
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Field()
  @Column({ type: 'varchar', length: 255 })
  name: string;

  @Field()
  @Column({ type: 'varchar', length: 255, unique: true })
  email: string;

  @Field()
  @CreateDateColumn({ type: 'timestamptz' })
  createdAt: Date;

  @Field()
  @UpdateDateColumn({ type: 'timestamptz' })
  updatedAt: Date;
}
```

## Resolver — `modules/models/member/member.resolver.ts`

```typescript
import { Resolver, Query } from '@nestjs/graphql';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { MemberEntity } from './member.entity';

@Resolver(() => MemberEntity)
export class MemberResolver {
  constructor(
    @InjectRepository(MemberEntity)
    private readonly memberRepository: Repository<MemberEntity>,
  ) {}

  @Query(() => [MemberEntity])
  async members(): Promise<readonly MemberEntity[]> {
    return this.memberRepository.find();
  }
}
```

## ModelsModule — Symbol-Based Injection

Uses a Symbol to provide the entity class, enabling loose coupling across modules.

```typescript
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MemberEntity } from './member/member.entity';
import { MemberResolver } from './member/member.resolver';

const MemberSymbol = Symbol('Member');

@Module({
  imports: [TypeOrmModule.forFeature([MemberEntity])],
  providers: [
    { provide: MemberSymbol, useValue: MemberEntity },
    MemberResolver,
  ],
  exports: [MemberSymbol, TypeOrmModule],
})
export class ModelsModule {}
```

### Re-export — `modules/models/index.ts`

```typescript
export { ModelsModule } from './models.module';
export { MemberEntity } from './member/member.entity';
```

## Healthcheck

### Controller — `healthcheck/healthcheck.controller.ts`

```typescript
import { Controller, Get } from '@nestjs/common';

@Controller('healthcheck')
export class HealthcheckController {
  @Get()
  check(): { status: string } {
    return { status: 'ok' };
  }
}
```

### Module — `healthcheck/healthcheck.module.ts`

```typescript
import { Module } from '@nestjs/common';
import { HealthcheckController } from './healthcheck.controller';

@Module({
  controllers: [HealthcheckController],
})
export class HealthcheckModule {}
```

## Dependencies

| Package                            | Purpose                          |
| ---------------------------------- | -------------------------------- |
| `@nestjs/core`                     | NestJS core framework            |
| `@nestjs/common`                   | Common decorators and utilities   |
| `@nestjs/platform-express`         | Express HTTP adapter             |
| `@nestjs/graphql`                  | GraphQL integration for NestJS   |
| `@nestjs/apollo`                   | Apollo Driver for @nestjs/graphql |
| `@nestjs/typeorm`                  | TypeORM integration for NestJS   |
| `@apollo/server`                   | Apollo Server v4                 |
| `typeorm`                          | TypeORM — database ORM           |
| `pg`                               | PostgreSQL driver                |
| `graphql`                          | GraphQL JS reference impl        |
| `@rytass/member-base-nestjs-module` | Rytass member/auth base module   |

## GraphQL Approach

This boilerplate uses **Code-First** GraphQL (via NestJS decorators like `@ObjectType`, `@Field`, `@Resolver`, `@Query`, `@Mutation`). The GraphQL schema is **auto-generated** by NestJS at runtime — there is no hand-written `.graphql` schema file. This is configured by `autoSchemaFile: true` in the `GraphQLModule` options.
