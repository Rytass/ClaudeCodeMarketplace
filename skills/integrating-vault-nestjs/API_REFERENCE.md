# API Reference

## VaultModule

### `forRoot(options: VaultModuleOptions): DynamicModule`

Configures the Vault module globally.

```typescript
VaultModule.forRoot({
  path: 'my-app/production',
  fallbackFile: '.env',  // optional
})
```

#### VaultModuleOptions

| Property       | Type     | Required | Description                          |
|----------------|----------|----------|--------------------------------------|
| `path`         | `string` | Yes      | Vault secret path                    |
| `fallbackFile` | `string` | No       | Fallback env file when Vault unavailable |

---

## VaultService

Injectable service for secret management.

### `get<T>(key: string): Promise<T>`

Retrieves a secret value asynchronously.

```typescript
const host = await vault.get<string>('DB_HOST');
const port = await vault.get<number>('DB_PORT');
const config = await vault.get<DatabaseConfig>('DB_CONFIG');
```

**Important**: Always use `await` - returns a Promise.

### `set<T>(key: string, value: T, syncToOnline?: boolean): Promise<void>`

Stores a secret value.

```typescript
// Save locally only
await vault.set('API_KEY', 'new-key', false);

// Save and sync to Vault immediately
await vault.set('API_KEY', 'new-key', true);
```

| Parameter      | Type      | Default | Description                    |
|----------------|-----------|---------|--------------------------------|
| `key`          | `string`  | -       | Secret key name                |
| `value`        | `T`       | -       | Value to store                 |
| `syncToOnline` | `boolean` | `false` | Sync to Vault server immediately |

### `delete(key: string, syncToOnline?: boolean): Promise<void>`

Deletes a secret.

```typescript
// Delete locally
await vault.delete('OLD_KEY', false);

// Delete and sync to Vault
await vault.delete('OLD_KEY', true);
```

---

## Integration Patterns

### JWT Module

```typescript
JwtModule.registerAsync({
  imports: [VaultModule],
  inject: [VaultService],
  useFactory: async (vault: VaultService) => ({
    secret: await vault.get<string>('JWT_SECRET'),
    signOptions: {
      expiresIn: (await vault.get<string>('JWT_EXPIRY')) || '1h',
    },
  }),
}),
```

### Redis / Cache Module

```typescript
CacheModule.registerAsync({
  imports: [VaultModule],
  inject: [VaultService],
  useFactory: async (vault: VaultService) => ({
    store: redisStore,
    host: await vault.get<string>('REDIS_HOST'),
    port: await vault.get<number>('REDIS_PORT'),
    password: await vault.get<string>('REDIS_PASSWORD'),
  }),
}),
```

### Custom Service

```typescript
@Injectable()
export class ConfigurationService {
  constructor(private readonly vault: VaultService) {}

  async getDatabaseUrl(): Promise<string> {
    const host = await this.vault.get<string>('DB_HOST');
    const port = await this.vault.get<number>('DB_PORT');
    const user = await this.vault.get<string>('DB_USER');
    const pass = await this.vault.get<string>('DB_PASS');
    const name = await this.vault.get<string>('DB_NAME');

    return `postgresql://${user}:${pass}@${host}:${port}/${name}`;
  }
}
```

---

## Fallback Behavior

When Vault is unavailable, VaultService automatically falls back to environment variables:

1. Attempts to connect to Vault using `VAULT_HOST`, `VAULT_ACCOUNT`, `VAULT_PASSWORD`
2. If connection fails, reads from `process.env`
3. If `fallbackFile` specified, loads that file first

This ensures applications work in both production (with Vault) and local development (with `.env`).
