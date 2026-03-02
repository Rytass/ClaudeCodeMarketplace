# Standalone Project Setup Guide

For projects where frontend and backend are in separate, independent repositories.

## Frontend Project (Next.js App Router)

### Initialization

```bash
npx create-next-app@latest {project-name} --typescript --app --src-dir --tailwind
cd {project-name}
```

### Directory Structure

```
{project-name}/
├── src/
│   ├── app/              # Next.js App Router
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   └── (routes)/
│   ├── components/       # React components
│   ├── hooks/            # Custom hooks
│   ├── services/         # API call layer
│   ├── types/            # TypeScript types
│   └── utils/            # Utility functions
├── public/
├── next.config.ts
├── tsconfig.json
├── eslint.config.ts
├── .prettierrc
└── package.json
```

### next.config.ts — API Proxy Configuration

Use `rewrites` to proxy `/graphql` to the backend, avoiding CORS issues:

```typescript
import type { NextConfig } from 'next';
import path from 'path';

function getApiUrl(): string {
  return process.env.API_URL ?? 'http://localhost:6100';
}

const nextConfig: NextConfig = {
  output: 'standalone',
  sassOptions: {
    includePaths: [
      path.join(process.cwd(), 'src/app'),
      path.join(process.cwd(), 'node_modules'),
    ],
    silenceDeprecations: ['legacy-js-api'],
  },
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: '*.public.blob.vercel-storage.com',
      },
    ],
    formats: ['image/avif', 'image/webp'],
  },
  async rewrites() {
    const apiUrl = getApiUrl();
    return [
      {
        source: '/graphql',
        destination: `${apiUrl}/graphql`,
      },
      {
        source: '/graphql/:path*',
        destination: `${apiUrl}/graphql/:path*`,
      },
    ];
  },
};

export default nextConfig;
```

> **Key point**: `output: 'standalone'` produces a self-contained Node.js server, suitable for Docker deployment.

---

## Backend Project (NestJS)

### Initialization

```bash
npx @nestjs/cli new {api-name} --strict --package-manager pnpm
cd {api-name}
```

### Directory Structure

```
{api-name}/
├── src/
│   ├── app.module.ts         # Root module
│   ├── main.ts
│   ├── constants/            # Global constants (e.g. Casbin model)
│   └── modules/
│       ├── models/           # TypeORM entities + ModelsModule
│       │   ├── index.ts      # Barrel export
│       │   ├── models.module.ts
│       │   └── entities/
│       ├── auth/             # Authentication module
│       ├── member/           # Member module
│       ├── rbac/             # Permission module
│       ├── services/         # Shared services
│       └── {domain}/         # Business domain modules
├── tsconfig.json
├── eslint.config.ts
├── .prettierrc
└── package.json
```

### app.module.ts — Root Module Example

```typescript
import { Module } from '@nestjs/common';
import { GraphQLModule } from '@nestjs/graphql';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ApolloDriver } from '@nestjs/apollo';
import type { ApolloDriverConfig } from '@nestjs/apollo';
import { MemberBaseModule } from '@rytass/member-base-nestjs-module';
import { ModelsModule } from './modules/models';
import { AuthModule } from './modules/auth';
import { MemberModule } from './modules/member';
import { RbacModule } from './modules/rbac';

@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      useFactory: () => ({
        type: 'postgres' as const,
        url: process.env.DATABASE_URL,
        autoLoadEntities: true,
        synchronize: process.env.NODE_ENV !== 'production',
        logging: process.env.NODE_ENV !== 'production',
        extra: {
          max: 3,
          idleTimeoutMillis: 5000,
          connectionTimeoutMillis: 5000,
        },
      }),
    }),
    ModelsModule,
    GraphQLModule.forRoot<ApolloDriverConfig>({
      driver: ApolloDriver,
      autoSchemaFile: true,
      sortSchema: true,
      playground: process.env.NODE_ENV !== 'production',
      introspection: true,
    }),
    MemberBaseModule.forRootAsync({
      useFactory: () => ({
        memberEntity: MemberEntity,
        accessTokenSecret: process.env.JWT_ACCESS_SECRET,
        accessTokenExpiration: 60 * 15,        // 15 minutes
        refreshTokenSecret: process.env.JWT_REFRESH_SECRET,
        refreshTokenExpiration: 60 * 60 * 24 * 90, // 90 days
        enableGlobalGuard: true,
        cookieMode: true,
        casbinAdapterOptions: {
          type: 'postgres' as const,
          url: process.env.DATABASE_URL,
        },
        casbinModelString: CASBIN_MODEL_STRING,
      }),
    }),
    AuthModule,
    MemberModule,
    RbacModule,
  ],
})
export class AppModule {}
```

> **Key point**: Use `@rytass/member-base-nestjs-module` to integrate JWT + Casbin RBAC. Use `forRootAsync` to dynamically inject environment variables.

---

## Frontend–Backend Connection

| Environment | Frontend API_URL             | Description                    |
| ----------- | ---------------------------- | ------------------------------ |
| Development | `http://localhost:6100`      | next.config rewrites proxy     |
| Staging     | Internal service URL         | K8s / Docker Compose           |
| Production  | Internal service URL         | API not publicly exposed       |
