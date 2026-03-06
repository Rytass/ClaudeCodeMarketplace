# Cloudflare Workers API Boilerplate

Stack: Hono + graphql-yoga + drizzle-orm + Neon (Serverless Postgres)

## Directory Structure

```
apps/api/
├── src/
│   ├── index.ts          # Hono app entry
│   ├── schema.ts         # GraphQL schema (schema-first)
│   ├── resolvers/
│   │   ├── index.ts
│   │   ├── queries.ts
│   │   └── mutations.ts
│   └── db/
│       ├── schema.ts     # drizzle-orm table definitions
│       └── client.ts     # drizzle client
├── wrangler.toml
├── tsconfig.json
└── project.json
```

## src/index.ts

Hono app with CORS middleware and graphql-yoga mounted at `/graphql`:

```typescript
import { Hono } from 'hono';
import { cors } from 'hono/cors';
import { createYoga, createSchema } from 'graphql-yoga';
import { typeDefs } from './schema';
import { resolvers } from './resolvers';

type Bindings = {
  DATABASE_URL: string;
};

const app = new Hono<{ Bindings: Bindings }>();
app.use('/*', cors());

app.use('/graphql', async (c) => {
  const yoga = createYoga({
    schema: createSchema({ typeDefs, resolvers }),
    graphqlEndpoint: '/graphql',
  });
  return yoga.handle(c.req.raw, c.env);
});

export default app;
```

## src/db/schema.ts

drizzle-orm pgTable definitions:

```typescript
import { pgTable, uuid, text, timestamp } from 'drizzle-orm/pg-core';

export const users = pgTable('users', {
  id: uuid('id').primaryKey().defaultRandom(),
  email: text('email').notNull().unique(),
  name: text('name').notNull(),
  createdAt: timestamp('created_at').defaultNow().notNull(),
});
```

## src/db/client.ts

drizzle + @neondatabase/serverless:

```typescript
import { drizzle } from 'drizzle-orm/neon-http';
import { neon } from '@neondatabase/serverless';
import * as schema from './schema';

export function createDb(databaseUrl: string) {
  const sql = neon(databaseUrl);
  return drizzle(sql, { schema });
}
```

## wrangler.toml

```toml
name = "{project}-api"
main = "src/index.ts"
compatibility_date = "2024-01-01"

[vars]
ENVIRONMENT = "production"
```

## Dependencies

| Package                   | Purpose                    |
| ------------------------- | -------------------------- |
| hono                      | Web framework for Workers  |
| graphql                   | GraphQL core               |
| graphql-yoga              | GraphQL server             |
| drizzle-orm               | Type-safe ORM              |
| @neondatabase/serverless  | Serverless Postgres driver |
