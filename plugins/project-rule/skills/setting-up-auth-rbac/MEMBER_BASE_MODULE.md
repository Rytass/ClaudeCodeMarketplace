# MemberBaseModule Configuration

## Full forRootAsync Configuration Template

```typescript
// apps/api/src/app/app.module.ts
import { MemberBaseModule } from '@rytass/member-base-nestjs-module';
import { VaultModule, VaultService } from '@rytass/secret-adapter-vault-nestjs';
import { MemberEntity } from '@scope/models';
import { CASBIN_MODEL_STRING } from '@scope/constants';

@Module({
  imports: [
    MemberBaseModule.forRootAsync({
      imports: [VaultModule],
      inject: [VaultService],
      useFactory: async (vault: VaultService): Promise<Parameters<typeof MemberBaseModule.forRoot>[0]> => ({
        // Entity configuration
        memberEntity: MemberEntity,

        // Cookie mode (use when frontend and backend share the same domain)
        cookieMode: true,

        // JWT Secrets (retrieved from Vault)
        accessTokenSecret: await vault.get<string>('JWT_ACCESS_SECRET'),
        refreshTokenSecret: await vault.get<string>('JWT_REFRESH_SECRET'),

        // Token expiration (in seconds)
        accessTokenExpiration: 15 * 60,           // 15 minutes
        refreshTokenExpiration: 90 * 24 * 60 * 60, // 90 days

        // Global Guard (all routes require authentication by default)
        enableGlobalGuard: true,

        // Casbin RBAC configuration
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
  ],
})
export class AppModule {}
```

## Configuration Parameters

| Parameter                 | Type              | Description                                          |
|--------------------------|-------------------|------------------------------------------------------|
| `memberEntity`           | Entity class      | User Entity (MUST inherit the required interface)     |
| `cookieMode`             | `boolean`         | `true`: store token in cookie; `false`: use header    |
| `accessTokenSecret`      | `string`          | JWT access token signing secret                       |
| `refreshTokenSecret`     | `string`          | JWT refresh token signing secret                      |
| `accessTokenExpiration`  | `number` (seconds)| Access token expiration duration                      |
| `refreshTokenExpiration` | `number` (seconds)| Refresh token expiration duration                     |
| `enableGlobalGuard`      | `boolean`         | Whether to enable the auth Guard globally             |
| `casbinAdapterOptions`   | `object`          | Database connection config for Casbin policy storage  |
| `casbinModelString`      | `string`          | Casbin model definition string                        |

## Token Refresh Middleware

Automatically attempts token refresh on every incoming request:

```typescript
// app/middleware/token-refresh.middleware.ts
import { Injectable, NestMiddleware, Logger } from '@nestjs/common';
import type { Request, Response, NextFunction } from 'express';

@Injectable()
export class TokenRefreshMiddleware implements NestMiddleware {
  private readonly logger = new Logger(TokenRefreshMiddleware.name);

  async use(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      // Attempt refresh; do not block the request on failure
      await this.authService.refreshTokens(req, res);
    } catch (error) {
      this.logger.debug('Token refresh in middleware failed:', error);
    }
    next();
  }
}
```

### Apply Middleware in AppModule

```typescript
@Module({ /* ... */ })
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer): void {
    consumer.apply(TokenRefreshMiddleware).forRoutes('*');
  }
}
```

## AuthModule Structure

AuthModule follows the Dual-Layer Module pattern:

```typescript
// auth-data.module.ts (data layer)
@Module({
  imports: [ModelsModule, VaultModule],
  providers: [AuthService, AdminSeedService],
  exports: [AuthService],
})
export class AuthDataModule {}

// auth.module.ts (presentation layer)
@Module({
  imports: [AuthDataModule],
  providers: [AuthResolver],
})
export class AuthModule {}
```

## AuthService Core Methods

```typescript
@Injectable()
export class AuthService {
  constructor(
    @Inject(Member)
    private readonly memberRepo: Repository<MemberEntity>,
    private readonly memberBaseService: MemberBaseService<MemberEntity>,
    @Inject(CASBIN_ENFORCER)
    private readonly enforcer: Enforcer | null,
  ) {}

  async getMemberById(id: string): Promise<MemberEntity | null> {
    return this.memberRepo.findOne({ where: { id } });
  }

  async getMemberRoles(memberId: string): Promise<readonly string[]> {
    if (!this.enforcer) return [];

    const groupingPolicies = await this.enforcer.getFilteredGroupingPolicy(0, memberId);
    return groupingPolicies.map(policy => policy[1]);
  }

  async addRoleToMember(memberId: string, role: string, domain = '*'): Promise<boolean> {
    if (!this.enforcer) return false;

    return this.enforcer.addGroupingPolicy(memberId, role, domain);
  }

  async removeRoleFromMember(memberId: string, role: string, domain = '*'): Promise<boolean> {
    if (!this.enforcer) return false;

    return this.enforcer.removeGroupingPolicy(memberId, role, domain);
  }
}
```
