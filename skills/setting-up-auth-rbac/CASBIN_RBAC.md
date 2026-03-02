# Casbin RBAC Permission Model

## Casbin Model Definition

```typescript
// libs/constants/src/lib/rbac/casbin-model.ts
export const CASBIN_MODEL_STRING = `
[request_definition]
r = sub, dom, obj, act

[policy_definition]
p = sub, dom, obj, act

[role_definition]
g = _, _, _

[policy_effect]
e = some(where (p.eft == allow))

[matchers]
m = g(r.sub, p.sub, r.dom) && r.dom == p.dom && keyMatch(r.obj, p.obj) && keyMatch(r.act, p.act)
`.trim();
```

### Model Section Reference

| Section              | Description                                                             |
|----------------------|-------------------------------------------------------------------------|
| `request_definition` | Request format: `sub` (user), `dom` (domain), `obj` (resource), `act` (action) |
| `policy_definition`  | Policy storage format, corresponds to request fields                     |
| `role_definition`    | Role inheritance: `g = _, _, _` represents a user-role-domain triple     |
| `policy_effect`      | Allow access if at least one matching policy grants permission           |
| `matchers`           | Matching rules: role inheritance + domain match + resource/action keyMatch|

## Resources Definition

```typescript
// libs/constants/src/lib/rbac/resources.ts
export const RESOURCES = {
  ALL: '*',
  VEHICLE: 'vehicle',
  MEMBER: 'member',
  ROLE: 'role',
  CUSTOMER: 'customer',
  SUPPLIER: 'supplier',
  // ... add more as needed by business requirements
} as const;

export type Resource = (typeof RESOURCES)[keyof typeof RESOURCES];
```

## Actions Definition

```typescript
// libs/constants/src/lib/rbac/actions.ts
export const ACTIONS = {
  ALL: '*',
  READ: 'read',
  CREATE: 'create',
  UPDATE: 'update',
  DELETE: 'delete',
  LIST: 'list',
  ANALYZE: 'analyze',
} as const;

export type Action = (typeof ACTIONS)[keyof typeof ACTIONS];
```

## Roles Definition

```typescript
// libs/constants/src/lib/rbac/roles.ts
export const ROLES = {
  ADMIN: 'admin',
  USER: 'user',
} as const;

export type Role = (typeof ROLES)[keyof typeof ROLES];
```

## Permission Tokens (Composition Utility)

```typescript
// libs/constants/src/lib/rbac/permissions.ts
import { RESOURCES, type Resource } from './resources';
import { ACTIONS, type Action } from './actions';

export function createPermissionToken(resource: Resource, action: Action): [string, string] {
  return [resource, action];
}

export const PERMISSION_TOKENS = {
  SUPPLIER_LIST: createPermissionToken(RESOURCES.SUPPLIER, ACTIONS.LIST),
  SUPPLIER_READ: createPermissionToken(RESOURCES.SUPPLIER, ACTIONS.READ),
  SUPPLIER_CREATE: createPermissionToken(RESOURCES.SUPPLIER, ACTIONS.CREATE),
  SUPPLIER_UPDATE: createPermissionToken(RESOURCES.SUPPLIER, ACTIONS.UPDATE),
  SUPPLIER_DELETE: createPermissionToken(RESOURCES.SUPPLIER, ACTIONS.DELETE),
  // ...
} as const;
```

## CheckPermission Decorator

```typescript
// libs/auth/src/lib/decorators/check-permission.decorator.ts
import { SetMetadata } from '@nestjs/common';
import type { CustomDecorator } from '@nestjs/common';

export const CHECK_PERMISSION_KEY = 'check_permission';

export interface PermissionMetadata {
  readonly resource: string;
  readonly action: string;
}

export const CheckPermission = (resource: string, action: string): CustomDecorator<string> =>
  SetMetadata(CHECK_PERMISSION_KEY, { resource, action } satisfies PermissionMetadata);
```

## Usage in Resolvers

```typescript
import { Authenticated } from '@rytass/member-base-nestjs-module';
import { CheckPermission } from '@scope/auth';
import { RESOURCES, ACTIONS } from '@scope/constants';

@Resolver()
export class SupplierQueries {
  @Authenticated()
  @CheckPermission(RESOURCES.SUPPLIER, ACTIONS.LIST)
  @Query(() => SupplierCollectionDto)
  async suppliers(@Args() pagination: PaginationArgs): Promise<SupplierCollectionDto> {
    // ...
  }
}
```

### Decorator Order

```
@Authenticated()                                  ← Verify login first
@CheckPermission(RESOURCES.X, ACTIONS.Y)           ← Then check permissions
@Query(() => ReturnType) / @Mutation(() => ReturnType) ← GraphQL definition
```

## Steps to Add a New Resource Permission

1. Add the resource name to `RESOURCES`
2. Confirm required `ACTIONS` (typically READ/CREATE/UPDATE/DELETE/LIST)
3. Create token combinations in `PERMISSION_TOKENS`
4. Assign role permissions in role-permissions configuration
5. Add `@CheckPermission` decorator to Queries/Mutations

## Enforcer API Quick Reference

```typescript
// Inject Casbin Enforcer
@Inject(CASBIN_ENFORCER)
private readonly enforcer: Enforcer | null;

// Role management
await enforcer.addGroupingPolicy(memberId, role, domain);      // Add role
await enforcer.removeGroupingPolicy(memberId, role, domain);   // Remove role
await enforcer.getFilteredGroupingPolicy(0, memberId);         // Query roles

// Policy management
await enforcer.addPolicy(role, domain, resource, action);      // Add permission
await enforcer.removePolicy(role, domain, resource, action);   // Remove permission
await enforcer.enforce(sub, domain, resource, action);         // Check permission
```
