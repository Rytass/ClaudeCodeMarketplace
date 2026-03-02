# Scaffold Progress Report Format

> This is the standard progress output format for the scaffolding generator. Used to track the completion status of each step when creating NestJS and Next.js modules.

---

## NestJS 11-Step Progress

| Step | Action                 | Expected File                            | Status   |
|------|------------------------|------------------------------------------|----------|
| 1    | Create Entity          | `{name}.entity.ts`                       | {status} |
| 2    | Create Symbol          | `export const` in Entity file            | {status} |
| 3    | Register ModelsModule  | `models.module.ts` updated               | {status} |
| 4    | Create Enum            | `{name}.enum.ts` (if needed)             | {status} |
| 5    | Create DTOs            | `*.dto.ts` / `*.input.ts` / `*.args.ts`  | {status} |
| 6    | Create DataService     | `{name}-data.service.ts`                 | {status} |
| 7    | Create DataLoader      | `{name}.dataloader.ts`                   | {status} |
| 8    | Create DataModule      | `{name}-data.module.ts`                  | {status} |
| 9    | Create Queries         | `{name}.queries.ts`                      | {status} |
| 10   | Create Mutations       | `{name}.mutations.ts`                    | {status} |
| 11   | Create Resolver + Module | `{name}.resolver.ts` + `{name}.module.ts` | {status} |

---

## Next.js 9-Step Progress

| Step | Action             | Expected File                                         | Status   |
|------|--------------------|-------------------------------------------------------|----------|
| 1    | Create Fragment    | `{entity}-fields.fragment.graphql`                     | {status} |
| 2    | Create Query       | `get-{entities}.query.graphql`                         | {status} |
| 3    | Create Mutations   | `create/update/delete-{entity}.mutation.graphql`       | {status} |
| 4    | Run Codegen        | `generated/graphql.ts` updated                         | {status} |
| 5    | Create Page        | `page.tsx`                                             | {status} |
| 6    | Create Styles      | `page.module.scss`                                     | {status} |
| 7    | Create Table Component | `{Entity}Table/`                                   | {status} |
| 8    | Create FormModal   | `{Entity}FormModal/`                                   | {status} |
| 9    | Integrate Mutations | hooks invocation in `page.tsx`                        | {status} |

---

## Completion Summary

```
Completion: {done}/{total} ({pct}%)
Missing Items: {missing_items}
```

---

## Status Indicator Reference

| Indicator | Status      |
|-----------|-------------|
| ✅        | Completed   |
| ⏳        | In Progress |
| ⬜        | Not Started |
