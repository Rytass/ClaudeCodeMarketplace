# GraphQL Schema & Codegen

Shared GraphQL type definitions and code generation configuration.

## Two Approaches

### Code-first (GKE / NestJS)

NestJS decorators define the schema. The framework auto-generates `schema.gql` at build time. Codegen reads that file to produce client-side TypeScript types.

```ts
// Example NestJS resolver (apps/api/src/users/user.model.ts)
@ObjectType()
export class User {
  @Field(() => ID)
  id!: string;

  @Field()
  email!: string;

  @Field()
  name!: string;

  @Field(() => GraphQLISODateTime)
  createdAt!: Date;
}
```

### Schema-first (Cloudflare / Supabase)

`.graphql` files in `libs/graphql/src/` are the source of truth. Codegen produces TypeScript types for both server resolvers and client queries.

## `libs/graphql/` Structure

```
libs/graphql/
├── src/
│   ├── index.ts              # re-exports generated types and scalars
│   ├── schema.graphql        # schema-first only
│   ├── generated/
│   │   └── graphql.ts        # codegen output (do not edit)
│   └── scalars/
│       └── date-time.ts      # DateTime scalar implementation
└── codegen.ts
```

## Schema Definition (Schema-first)

`libs/graphql/src/schema.graphql`:

```graphql
scalar DateTime

type User {
  id: ID!
  email: String!
  name: String!
  createdAt: DateTime!
}

type AuthPayload {
  accessToken: String!
  refreshToken: String!
  user: User!
}

type Query {
  me: User!
  users: [User!]!
}

type Mutation {
  login(email: String!, password: String!): AuthPayload!
}
```

## `codegen.ts`

```ts
import type { CodegenConfig } from '@graphql-codegen/cli';

const config: CodegenConfig = {
  // Code-first (GKE): point to the auto-generated schema file
  // schema: 'apps/api/src/schema.gql',

  // Schema-first (Cloudflare / Supabase): point to .graphql files
  schema: 'libs/graphql/src/**/*.graphql',

  documents: 'apps/client/src/**/*.{ts,tsx}',
  generates: {
    'libs/graphql/src/generated/graphql.ts': {
      plugins: [
        'typescript',
        'typescript-operations',
        'typescript-resolvers',
      ],
      config: {
        scalars: {
          DateTime: 'string',
        },
        strictScalars: true,
        enumsAsTypes: true,
        skipTypename: false,
      },
    },
  },
};

export default config;
```

## DateTime Scalar

`libs/graphql/src/scalars/date-time.ts`:

```ts
import { GraphQLScalarType, Kind } from 'graphql';

export const DateTimeScalar = new GraphQLScalarType({
  name: 'DateTime',
  description: 'ISO 8601 date-time string',

  serialize(value: unknown): string {
    if (value instanceof Date) {
      return value.toISOString();
    }
    throw new Error('DateTimeScalar can only serialize Date objects');
  },

  parseValue(value: unknown): Date {
    if (typeof value === 'string') {
      return new Date(value);
    }
    throw new Error('DateTimeScalar can only parse string values');
  },

  parseLiteral(ast): Date {
    if (ast.kind === Kind.STRING) {
      return new Date(ast.value);
    }
    throw new Error('DateTimeScalar can only parse string values');
  },
});
```

## `libs/graphql/src/index.ts`

```ts
export * from './generated/graphql';
export { DateTimeScalar } from './scalars/date-time';
```

## Dependencies

```bash
pnpm add graphql
pnpm add -D @graphql-codegen/cli @graphql-codegen/typescript @graphql-codegen/typescript-operations @graphql-codegen/typescript-resolvers
```
