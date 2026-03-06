# Next.js + Apollo Client

Frontend app setup shared across all deployment targets.

## Directory Structure

```
apps/client/
├── next.config.ts
├── tsconfig.json
├── project.json
├── src/
│   ├── app/
│   │   ├── layout.tsx
│   │   └── page.tsx
│   └── lib/
│       ├── apollo-client.ts
│       └── apollo-provider.tsx
└── public/
```

## `next.config.ts`

```ts
import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  output: 'standalone',
  async rewrites() {
    return [
      {
        source: '/graphql',
        // GKE:        http://localhost:6001/graphql
        // Cloudflare: https://api.{project}.workers.dev/graphql
        // Supabase:   https://{ref}.supabase.co/functions/v1/graphql
        destination: process.env.NEXT_PUBLIC_GRAPHQL_ENDPOINT || 'http://localhost:6001/graphql',
      },
    ];
  },
};

export default nextConfig;
```

## `lib/apollo-client.ts`

```ts
import { ApolloClient, HttpLink, InMemoryCache } from '@apollo/client';

export function createApolloClient(): ApolloClient<unknown> {
  const httpLink = new HttpLink({
    uri: '/graphql',
    credentials: 'same-origin',
  });

  return new ApolloClient({
    link: httpLink,
    cache: new InMemoryCache(),
    defaultOptions: {
      watchQuery: { fetchPolicy: 'cache-and-network' },
    },
  });
}
```

## `lib/apollo-provider.tsx`

```tsx
'use client';

import { ApolloProvider } from '@apollo/client';
import { type ReactNode, useMemo } from 'react';

import { createApolloClient } from './apollo-client';

interface ApolloWrapperProps {
  readonly children: ReactNode;
}

export function ApolloWrapper({ children }: ApolloWrapperProps): ReactNode {
  const client = useMemo(() => createApolloClient(), []);

  return <ApolloProvider client={client}>{children}</ApolloProvider>;
}
```

## `app/layout.tsx`

```tsx
import type { Metadata } from 'next';
import type { ReactNode } from 'react';

import { ApolloWrapper } from '../lib/apollo-provider';

export const metadata: Metadata = {
  title: '{Project Name}',
  description: '{Project description}',
};

interface RootLayoutProps {
  readonly children: ReactNode;
}

export default function RootLayout({ children }: RootLayoutProps): ReactNode {
  return (
    <html lang="zh-Hant">
      <body>
        <ApolloWrapper>{children}</ApolloWrapper>
      </body>
    </html>
  );
}
```

## `app/page.tsx`

```tsx
'use client';

import { gql, useQuery } from '@apollo/client';
import type { ReactNode } from 'react';

const ME_QUERY = gql`
  query Me {
    me {
      id
      email
      name
    }
  }
`;

export default function HomePage(): ReactNode {
  const { data, loading, error } = useQuery(ME_QUERY);

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error: {error.message}</p>;

  return (
    <main>
      <h1>Welcome, {data?.me?.name ?? 'Guest'}</h1>
    </main>
  );
}
```

## Dependencies

```bash
pnpm add next react react-dom @apollo/client graphql
pnpm add -D @types/react @types/react-dom typescript
```
