# Environment Variables & .gitignore

Environment configuration templates for each deployment target.

## GKE `.env.example`

```env
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
JWT_ACCESS_SECRET=your-access-secret
JWT_REFRESH_SECRET=your-refresh-secret
VAULT_ENDPOINT=http://vault:8200
VAULT_TOKEN=your-vault-token
TZ=Asia/Taipei
```

## Cloudflare `.env.example`

```env
DATABASE_URL=postgresql://user:password@ep-xxx.us-east-2.aws.neon.tech/dbname
GRAPHQL_ENDPOINT=https://api.example.com/graphql
```

## Supabase `.env.example`

```env
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

## Shared Client `.env.local.example`

```env
NEXT_PUBLIC_GRAPHQL_ENDPOINT=http://localhost:6001/graphql
```

> **WARNING:** NEVER define `NODE_ENV` in `.env` files. Nx and Next.js set `NODE_ENV` automatically based on the command (`dev` = development, `build` = production). Manually setting it causes conflicts and hard-to-debug issues.

## `.gitignore`

```gitignore
# Dependencies
node_modules/

# Environment
.env
.env.local
.env.*.local

# Build output
dist/
.next/
.vercel/
out/

# Nx
.nx/
tmp/

# Coverage
coverage/

# Turbo
.turbo/

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Supabase
supabase/.temp/

# Cloudflare
.wrangler/
.dev.vars

# Docker
docker-compose.override.yml
```
