# Vault Integration Configuration

## VaultModule Initialization

```typescript
// apps/api/src/app/app.module.ts
import { VaultModule } from '@rytass/secret-adapter-vault-nestjs';

@Module({
  imports: [
    VaultModule.forRoot({
      path: process.env.VAULT_PATH || 'project-name/develop',
    }),
  ],
})
export class AppModule {}
```

`VAULT_PATH` format: `{project}/{environment}`, e.g. `mogist/develop`, `shuttle/production`.

## TypeORM Async Configuration (Retrieve Connection Info from Vault)

```typescript
import { TypeOrmModule } from '@nestjs/typeorm';
import { VaultModule, VaultService } from '@rytass/secret-adapter-vault-nestjs';

TypeOrmModule.forRootAsync({
  imports: [VaultModule],
  inject: [VaultService],
  useFactory: async (vault: VaultService): Promise<Parameters<typeof TypeOrmModule.forRoot>[0]> => ({
    type: 'postgres' as const,
    host: await vault.get<string>('DB_HOST'),
    port: 5432,
    username: await vault.get<string>('DB_USER'),
    password: await vault.get<string>('DB_PASS'),
    database: await vault.get<string>('DB_NAME'),
    schema: await vault.get<string>('DB_SCHEMA'),
    autoLoadEntities: true,
    synchronize: (await vault.get<string>('DB_SYNC')) === 'true',
  }),
}),
```

## MemberBaseModule Async Configuration (JWT + Casbin)

```typescript
import { MemberBaseModule } from '@rytass/member-base-nestjs-module';
import { VaultModule, VaultService } from '@rytass/secret-adapter-vault-nestjs';

MemberBaseModule.forRootAsync({
  imports: [VaultModule],
  inject: [VaultService],
  useFactory: async (vault: VaultService): Promise<Parameters<typeof MemberBaseModule.forRoot>[0]> => ({
    memberEntity: MemberEntity,
    cookieMode: true,
    accessTokenSecret: await vault.get<string>('JWT_ACCESS_SECRET'),
    refreshTokenSecret: await vault.get<string>('JWT_REFRESH_SECRET'),
    accessTokenExpiration: 15 * 60,
    refreshTokenExpiration: 90 * 24 * 60 * 60,
    enableGlobalGuard: true,
    casbinAdapterOptions: {
      type: 'postgres',
      host: await vault.get<string>('DB_HOST'),
      port: 5432,
      username: await vault.get<string>('DB_USER'),
      password: await vault.get<string>('DB_PASS'),
      database: await vault.get<string>('DB_NAME'),
    },
    casbinModelString: CASBIN_MODEL_STRING,
  }),
}),
```

## Vault Secrets Reference

| Secret Key           | Purpose                    | Example Value                |
|---------------------|---------------------------|------------------------------|
| `DB_HOST`           | Database host              | `localhost`                  |
| `DB_USER`           | Database user              | `postgres`                   |
| `DB_PASS`           | Database password          | `password`                   |
| `DB_NAME`           | Database name              | `mogist`                     |
| `DB_SCHEMA`         | Database schema            | `public`                     |
| `DB_SYNC`           | Auto-sync schema           | `true` (dev environment only)|
| `JWT_ACCESS_SECRET` | Access token signing secret | Long random string           |
| `JWT_REFRESH_SECRET`| Refresh token signing secret| Long random string           |

## Using VaultModule in a DataModule

When a DataModule needs to access Vault secrets (e.g. for admin seed):

```typescript
// auth-data.module.ts
import { Module } from '@nestjs/common';
import { VaultModule } from '@rytass/secret-adapter-vault-nestjs';
import { ModelsModule } from '@scope/models';
import { AuthService } from './auth.service';
import { AdminSeedService } from './admin-seed.service';

@Module({
  imports: [ModelsModule, VaultModule],
  providers: [AuthService, AdminSeedService],
  exports: [AuthService],
})
export class AuthDataModule {}
```

## Full AppModule Configuration Template

```typescript
@Module({
  imports: [
    // 1. Secret management
    VaultModule.forRoot({
      path: process.env.VAULT_PATH || 'project/develop',
    }),

    // 2. Database
    TypeOrmModule.forRootAsync({
      imports: [VaultModule],
      inject: [VaultService],
      useFactory: async (vault: VaultService) => ({ /* ... */ }),
    }),

    // 3. Authentication & authorization
    MemberBaseModule.forRootAsync({
      imports: [VaultModule],
      inject: [VaultService],
      useFactory: async (vault: VaultService) => ({ /* ... */ }),
    }),

    // 4. GraphQL
    GraphQLModule.forRoot<ApolloDriverConfig>({
      driver: ApolloDriver,
      autoSchemaFile: join(process.cwd(), 'tools/schema.gql'),
      playground: true,
      introspection: true,
      context: ({ req, res }: { req: Request; res: Response }) => ({ req, res }),
    }),

    // 5. Business modules
    AuthModule,
    MemberModule,
    SupplierModule,
    // ...
  ],
  providers: [AppResolver, DateOnlyScalar, TokenRefreshMiddleware],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer): void {
    consumer.apply(TokenRefreshMiddleware).forRoutes('*');
  }
}
```

Module import order: VaultModule → TypeOrmModule → MemberBaseModule → GraphQLModule → Business modules.
