# project-rule

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Claude Code Plugin](https://img.shields.io/badge/Claude_Code-Plugin-blueviolet)](https://github.com/Rytass/ClaudeCodeMarketplace)

Full-stack project architecture convention plugin for Claude Code.

Covers NestJS dual-layer modules, Next.js App Router, TypeORM, GraphQL Code-First, Mezzanine UI, Casbin RBAC, Nx monorepo, and Quadrats editor. Provides scaffolding tools and pattern auditing capabilities.

## Installation

```bash
claude plugin marketplace add Rytass/ClaudeCodeMarketplace
claude plugin install project-rule@rytass-claude-code --scope user
```

## Skills

### Backend

| Skill                        | Description                                                              |
| ---------------------------- | ------------------------------------------------------------------------ |
| `architecting-nestjs`        | NestJS Dual-Layer Module architecture, GraphQL Code-First, TypeORM entity patterns |
| `scaffolding-nestjs-module`  | Backend NestJS module scaffolding, 11-step complete setup process         |
| `designing-data-model`       | TypeORM Entity data model design, Entity-as-ObjectType pattern           |
| `designing-graphql-api`      | GraphQL API design principles, Mutation Input flatten vs group decisions  |
| `setting-up-auth-rbac`       | JWT authentication + Casbin RBAC permission setup                        |
| `integrating-vault-nestjs`   | HashiCorp Vault integration with NestJS                                  |
| `developing-backend`         | Backend development conventions, @rytass npm scope packages preferred    |

### Frontend

| Skill                          | Description                                                    |
| ------------------------------ | -------------------------------------------------------------- |
| `using-mezzanine-ui`           | Mezzanine-UI v2 design system development guide                |
| `scaffolding-nextjs-page`      | Frontend Next.js page scaffolding, 9-step setup process        |
| `building-quadrats-editor`     | Quadrats rich editor setup for admin panels                    |
| `serializing-quadrats`         | Quadrats frontend content serialization and JSX/HTML rendering |
| `optimizing-react-performance` | React / Next.js performance optimization                       |
| `reviewing-web-design`         | Web Interface Guidelines UI review                             |

### Infrastructure

| Skill                                | Description                                              |
| ------------------------------------ | -------------------------------------------------------- |
| `initializing-project`               | Project initialization, Nx monorepo / standalone topology selection |
| `configuring-nx-nextjs-environment`  | Nx Monorepo + Next.js environment setup, NODE_ENV handling |

### Meta

| Skill                         | Description                                 |
| ----------------------------- | ------------------------------------------- |
| `creating-skills`             | Claude Code skill authoring guide           |
| `syncing-project-conventions` | Auto-sync project conventions to CLAUDE.md  |

## Agents

| Agent                      | Model  | Description                                                             |
| -------------------------- | ------ | ----------------------------------------------------------------------- |
| `project-initializer`      | sonnet | Initialize new projects, configure Nx/standalone, ESLint, TypeORM, Casbin, CI/CD |
| `nestjs-module-scaffolder`  | sonnet | Scaffold complete NestJS backend modules (dual-layer architecture)      |
| `nextjs-page-scaffolder`    | sonnet | Scaffold Next.js frontend pages (GraphQL + Mezzanine UI)               |
| `pattern-auditor`          | sonnet | Read-only audit agent, checks code compliance with architecture conventions |

## Commands

| Command            | Arguments                            | Description                        |
| ------------------ | ------------------------------------ | ---------------------------------- |
| `/init-project`    | `[--topology=monorepo\|standalone]`  | Interactive guided project initialization |
| `/scaffold-module` | `<module-name>`                      | Interactive guided NestJS backend module creation |
| `/scaffold-page`   | `<page-path>`                        | Interactive guided Next.js frontend page creation |
| `/audit-patterns`  | `[path]`                             | Audit code architecture convention compliance |

## Hooks

14 hooks are automatically loaded when this plugin is enabled, enforcing architecture conventions and safety guards at runtime.

### Behavior Modes

- **BLOCK (exit 2)**: Blocks operation execution, used only for irreversible safety-critical operations
- **WARN (exit 0 + message)**: Outputs warning messages, agent can self-correct in subsequent steps

### Safety Guards (PreToolUse — BLOCK)

| Hook                         | Matcher          | Description                                                      |
| ---------------------------- | ---------------- | ---------------------------------------------------------------- |
| `guard-readonly-auditor.sh`  | `Bash\|Write\|Edit` | pattern-auditor agent is only allowed to use Glob/Grep/Read  |
| `block-dangerous-commands.sh`| `Bash`           | Blocks `rm -rf /`, `DROP DATABASE`, `git push --force main`, etc. |
| `protect-critical-files.sh`  | `Write\|Edit`    | Blocks emptying models.module.ts, app.module.ts, .env, and other critical files |

### Code Quality (PostToolUse — WARN)

| Hook                              | Matcher        | Description                                                 |
| --------------------------------- | -------------- | ----------------------------------------------------------- |
| `lint-typescript-no-any.sh`       | `Write\|Edit`  | Detects `: any`, `as any`, `<any>` in .ts/.tsx files        |
| `enforce-kebab-case-files.sh`     | `Write`        | Warns when new .ts/.tsx files do not follow kebab-case       |
| `enforce-symbol-injection.sh`     | `Write\|Edit`  | Detects `@Inject('string')` string injection                 |
| `enforce-entity-objecttype.sh`    | `Write\|Edit`  | .entity.ts has @Entity but missing @ObjectType or Symbol     |
| `enforce-return-types.sh`         | `Write\|Edit`  | TypeScript functions missing explicit return types           |
| `enforce-dataloader-resolve.sh`   | `Write\|Edit`  | @ResolveField uses repository.find instead of DataLoader     |
| `enforce-permission-decorators.sh`| `Write\|Edit`  | @Mutation missing @Authenticated() decorator                 |
| `verify-dual-layer-structure.sh`  | `Write`        | Creating .module.ts without a corresponding -data.module.ts  |

### Workflow Validation (SubagentStop — WARN)

| Hook                          | Matcher                    | Description                               |
| ----------------------------- | -------------------------- | ----------------------------------------- |
| `verify-nestjs-scaffolder.sh` | `nestjs-module-scaffolder` | Checks 11-step NestJS workflow completeness |
| `verify-nextjs-scaffolder.sh` | `nextjs-page-scaffolder`   | Checks 9-step Next.js workflow completeness |

### Session Integrity (Stop — prompt)

Uses LLM evaluation before session ends to check whether scaffolding workflows were fully completed.

### Disabling Individual Hooks

To disable a specific hook, edit `hooks/hooks.json` and remove the corresponding entry. All scripts are located in the `scripts/` directory.

## MCP Tools

Architecture inspection tools provided via MCP (Model Context Protocol), enabling agents to proactively invoke code analysis.

Server: `architecture-inspector` (Python3 stdlib, no external dependencies required)

| Tool                        | Input                                    | Description                                           |
| --------------------------- | ---------------------------------------- | ----------------------------------------------------- |
| `scan-entities`             | `root: string`                           | Scans Entity files, checks @ObjectType/Symbol compliance |
| `scan-modules`              | `root: string`                           | Scans Module files, checks dual-layer completeness    |
| `check-scaffolding-status`  | `root, moduleName, type: nestjs\|nextjs` | Checks scaffolding step completion status and missing items |
| `resolve-symbol-map`        | `modelsModulePath: string`               | Resolves ModelsModule Symbol-to-Entity mapping table  |

## LSP Config

Declares recommended language server settings (users must install manually).

| Language   | Server                       | Install Command                                       |
| ---------- | ---------------------------- | ----------------------------------------------------- |
| TypeScript | `typescript-language-server`  | `npm install -g typescript-language-server typescript` |

## Output Styles

Standardized output format templates for consistent reports from agents and commands.

| Template                      | Description                                      |
| ----------------------------- | ------------------------------------------------ |
| `styles/audit-report.md`     | Pattern audit report format (used by pattern-auditor) |
| `styles/scaffold-summary.md` | Scaffolding progress report format (used by scaffolders) |

## Per-Project Config

Provides a project-level configuration template. Copy it to the target project to customize plugin behavior.

```bash
# Copy the config template to your project (run from the plugin directory)
cp docs/project-rule.local.md /your-project/.claude/project-rule.local.md
```

Configuration includes: project topology, directory paths, audit rule overrides, and scaffolding preferences.

## Quick Start

```bash
# 1. Install the plugin
claude plugin marketplace add Rytass/ClaudeCodeMarketplace
claude plugin install project-rule@rytass-claude-code --scope user

# 2. Initialize a new project
/init-project --topology=monorepo

# 3. Create a backend module
/scaffold-module orders

# 4. Create a frontend page
/scaffold-page orders
```

## Architecture Overview

This plugin's conventions are extracted from various real-world project topologies:

| Topology                | Description                                      |
| ----------------------- | ------------------------------------------------ |
| **Nx Monorepo**         | Frontend and backend in same repo (NestJS API + Next.js Client) |
| **Standalone Frontend** | Standalone Next.js frontend project              |
| **Standalone Backend**  | Standalone NestJS backend project                |

Core tech stack:

- **Monorepo**: Nx + pnpm workspace
- **Backend**: NestJS + TypeORM + PostgreSQL + GraphQL Code-First
- **Frontend**: Next.js App Router + Mezzanine UI + SCSS Modules
- **Auth**: @rytass/member-base-nestjs-module + Casbin RBAC
- **Editor**: Quadrats rich text editor
- **CI/CD**: Docker multi-stage build + GitHub Actions + GKE
