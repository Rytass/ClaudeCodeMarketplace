---
name: syncing-project-conventions
description: Project convention sync mechanism. Automatically updates project-scoped CLAUDE.md when establishing project-wide conventions (naming rules, file structures, coding style, documentation formats). Use when creating new conventions, defining project patterns, or setting team standards.
---

# Project Convention Sync

## Trigger Condition

When a user request is **not a one-off fix** but a **project-wide convention/pattern/process**:
- Naming conventions
- File structures
- Coding style
- Generation/testing rules
- Documentation formats

## Update Behavior

### 1. Inline Edit

Insert or adjust rules in the most relevant section of project-scoped CLAUDE.md.

If a rule already exists, **merge and deduplicate** instead of duplicating.

### 2. Change Notification

After editing, always report the update:

**Summary**: One-liner summary + bullet list (max 5 items)

**Diff**:
```diff
+ Added lines
- Removed lines
```

**Next**: Provide suggested actions

### 3. No Auto-Commit

Respect "Push/Commit Restriction" — do **not** commit/push automatically.

Only commit when user explicitly approves.

## Writing Rules

- Rules must be **actionable and concrete**, not vague
- Always state **priority and scope** (Global > Project > Module)
- Resolve conflicts with existing rules by clarifying **override order**

## Example Notification

**Summary**: Added API response format convention
- All API responses use `{ data, error, meta }` structure
- Error codes follow RFC 7807 format
- Pagination uses cursor-based approach

```diff
+ ## API Response Format
+ - All responses: `{ data, error, meta }`
+ - Errors: RFC 7807 format
+ - Pagination: cursor-based
```

**Next**:
- Run `pnpm format` to check formatting
- Commit when ready: `git commit -m "docs: add API response convention"`

## Idempotency

On repeated similar requests, merge into the **existing rule** and update its date instead of duplicating.
