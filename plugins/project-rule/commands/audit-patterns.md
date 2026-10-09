---
name: audit-patterns
description: "Launches the read-only pattern-auditor agent to audit NestJS backend code against project-rule conventions — DataLoader on @ResolveField, permission decorators, Entity-as-ObjectType, Symbol injection, pagination DTOs, naming and dual-layer module structure — and returns a pass, warning and violation report. Use after finishing a backend module or before a PR or code review of NestJS code. Trigger words — audit patterns, check architecture, 檢查架構規範, 後端 code review, 模組有沒有照規範. For UI and accessibility review, use reviewing-web-design."
argument-hint: "[path]"
---

# Audit Code Patterns

Launch the pattern-auditor agent to scan backend code for compliance with established architectural patterns and conventions.

## Argument Parsing

{{#if args}}
Parse the user-provided arguments: `{{ args }}`

- Treat the argument as the audit target path (e.g., `libs/suppliers`, `src/modules/products`)
- If a relative path is given, resolve it from the current working directory
- Glob patterns are supported (e.g., `libs/suppliers/**/*.ts`)
{{else}}
No path specified. The audit will cover all backend code under the current working directory.
{{/if}}

## Audit Checks

This command launches the `pattern-auditor` agent to perform the following 8 checks:

| Audit Item         | Description                                                     |
| ------------------ | --------------------------------------------------------------- |
| DataLoader         | `@ResolveField` MUST use DataLoader to load relations            |
| Permission Guards  | `@Mutation` / sensitive `@Query` MUST have permission protection |
| Entity Pattern     | Entities MUST use both `@Entity` + `@ObjectType`                 |
| Symbol Injection   | MUST use Symbol-based injection (not string tokens)              |
| Pagination Pattern | List queries MUST use ConnectionArgs + CollectionDto             |
| Naming Conventions | kebab-case filenames, PascalCase classes, correct suffixes       |
| Module Structure   | Dual-Layer (DataModule + Module) architecture required           |
| Import Hygiene     | No circular dependencies, module boundary compliance             |

## Execution Flow

1. Launch the `pattern-auditor` agent targeting {{#if args}}`{{ args }}`{{else}}the current working directory{{/if}}
2. The agent scans all `.ts` files (excluding `node_modules`, `dist`, `generated`)
3. Produces a structured audit report containing:
   - ✅ Passed checks
   - ⚠️ Warnings (suggested improvements, not mandatory)
   - ❌ Violations (issues that MUST be fixed)
   - Summary statistics table

## Example Usage

```
/audit-patterns
/audit-patterns libs/suppliers
/audit-patterns src/modules
```
