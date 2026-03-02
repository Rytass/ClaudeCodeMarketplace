# TypeORM Integration

## Basic Setup

```typescript
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { VaultModule, VaultService } from '@rytass/secret-adapter-vault-nestjs';

@Module({
  imports: [
    VaultModule.forRoot({
      path: process.env.VAULT_PATH || 'my-app/develop',
    }),

    TypeOrmModule.forRootAsync({
      imports: [VaultModule],
      inject: [VaultService],
      useFactory: async (vault: VaultService) => ({
        type: 'postgres' as const,
        host: await vault.get<string>('DB_HOST'),
        port: await vault.get<number>('DB_PORT'),
        username: await vault.get<string>('DB_USER'),
        password: await vault.get<string>('DB_PASS'),
        database: await vault.get<string>('DB_NAME'),
        autoLoadEntities: true,
        synchronize: (await vault.get<string>('NODE_ENV')) !== 'production',
      }),
    }),
  ],
})
export class AppModule {}
```

## Required Vault Secrets

Store these in your Vault path:

| Key         | Example Value    | Description           |
|-------------|------------------|-----------------------|
| `DB_HOST`   | `localhost`      | Database host         |
| `DB_PORT`   | `5432`           | Database port         |
| `DB_USER`   | `postgres`       | Database username     |
| `DB_PASS`   | `password`       | Database password     |
| `DB_NAME`   | `my_database`    | Database name         |
| `NODE_ENV`  | `development`    | Environment (optional)|

## Multiple Databases

```typescript
TypeOrmModule.forRootAsync({
  name: 'secondary',
  imports: [VaultModule],
  inject: [VaultService],
  useFactory: async (vault: VaultService) => ({
    type: 'mysql' as const,
    host: await vault.get<string>('SECONDARY_DB_HOST'),
    port: await vault.get<number>('SECONDARY_DB_PORT'),
    username: await vault.get<string>('SECONDARY_DB_USER'),
    password: await vault.get<string>('SECONDARY_DB_PASS'),
    database: await vault.get<string>('SECONDARY_DB_NAME'),
    autoLoadEntities: true,
  }),
}),
```

## Common Patterns

### With SSL Configuration

```typescript
useFactory: async (vault: VaultService) => ({
  type: 'postgres' as const,
  host: await vault.get<string>('DB_HOST'),
  port: await vault.get<number>('DB_PORT'),
  username: await vault.get<string>('DB_USER'),
  password: await vault.get<string>('DB_PASS'),
  database: await vault.get<string>('DB_NAME'),
  ssl: (await vault.get<string>('DB_SSL')) === 'true' ? { rejectUnauthorized: false } : false,
  autoLoadEntities: true,
}),
```

### With Connection Pool

```typescript
useFactory: async (vault: VaultService) => ({
  type: 'postgres' as const,
  host: await vault.get<string>('DB_HOST'),
  port: await vault.get<number>('DB_PORT'),
  username: await vault.get<string>('DB_USER'),
  password: await vault.get<string>('DB_PASS'),
  database: await vault.get<string>('DB_NAME'),
  autoLoadEntities: true,
  extra: {
    max: await vault.get<number>('DB_POOL_MAX') || 10,
    idleTimeoutMillis: 30000,
  },
}),
```
