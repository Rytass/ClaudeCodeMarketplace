# ProjectRule Per-Project Config

> Copy this file to `.claude/project-rule.local.md` in your project and adjust settings accordingly.

## Project Topology

```yaml
topology: monorepo          # monorepo | standalone
nestjs_root: apps/api       # NestJS application root directory
nextjs_root: apps/client    # Next.js application root directory
models_module_path: libs/models/src/lib/models.module.ts  # ModelsModule path
```

## Custom Rule Overrides

```yaml
# Disable specific audit rules (enter rule IDs)
disabled_rules: []

# Additional excluded directories (glob patterns)
exclude_paths:
  - "**/generated/**"
  - "**/dist/**"
```

## Scaffolding Preferences

```yaml
# Default Enum handling strategy
enum_style: separate_file   # separate_file | inline

# Default permission decorator
default_permission: "@Authenticated()"
```
