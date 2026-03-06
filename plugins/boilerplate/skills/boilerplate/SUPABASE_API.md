# Supabase API Boilerplate

Stack: Supabase Edge Functions (Deno) + graphql-yoga + supabase-js

## Directory Structure

```
supabase/
├── config.toml
├── functions/
│   └── graphql/
│       └── index.ts       # Deno Edge Function
├── migrations/
│   └── 00001_initial.sql  # Initial migration
└── seed.sql               # Optional seed data
libs/supabase/
└── src/
    ├── index.ts
    └── client.ts           # supabase-js client factory
```

## supabase/functions/graphql/index.ts

Deno Edge Function with graphql-yoga:

```typescript
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import { createYoga, createSchema } from 'graphql-yoga';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const yoga = createYoga({
  schema: createSchema({
    typeDefs: /* GraphQL */ `
      type User {
        id: ID!
        email: String!
        name: String!
        created_at: String!
      }
      type Query {
        users: [User!]!
        me: User
      }
    `,
    resolvers: {
      Query: {
        users: async (_parent, _args, context) => {
          const { data } = await context.supabase.from('users').select('*');
          return data ?? [];
        },
        me: async (_parent, _args, context) => {
          const { data: { user } } = await context.supabase.auth.getUser();
          if (!user) return null;
          const { data } = await context.supabase
            .from('users')
            .select('*')
            .eq('id', user.id)
            .single();
          return data;
        },
      },
    },
  }),
  context: (req) => {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_ANON_KEY')!,
      {
        global: {
          headers: {
            Authorization: req.request.headers.get('Authorization')!,
          },
        },
      },
    );
    return { supabase };
  },
});

serve(yoga);
```

## supabase/migrations/00001_initial.sql

Initial table with Row Level Security:

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own data"
  ON users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own data"
  ON users FOR UPDATE
  USING (auth.uid() = id);
```

## libs/supabase/src/client.ts

Client factory for Next.js:

```typescript
import { createBrowserClient } from '@supabase/ssr';

export function createSupabaseClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
  );
}
```

## supabase/config.toml

```toml
[api]
port = 54321

[db]
port = 54322

[studio]
port = 54323
```

## Deno Import Map

`supabase/functions/import_map.json`:

```json
{
  "imports": {
    "graphql-yoga": "https://esm.sh/graphql-yoga@5",
    "graphql": "https://esm.sh/graphql@16",
    "@supabase/supabase-js": "https://esm.sh/@supabase/supabase-js@2"
  }
}
```
