---
name: scaffold-module
description: "Interactively guide backend NestJS module creation and launch the scaffolder agent. Use when creating a new backend module, adding a NestJS resource, or scaffolding an API entity. Trigger when user says scaffold module, create module, new module, add backend module, generate module."
argument-hint: "<module-name>"
---

# Scaffold Backend Module

Follow the workflow below to guide the user through creating a new NestJS backend module.

## Argument Parsing

{{#if args}}
Parse the user-provided arguments: `{{ args }}`

- Treat the argument as the module name (e.g., `products`, `categories`, `orders`)
- Module names MUST be plural kebab-case (e.g., `supplier-contracts`)
- If PascalCase is provided (e.g., `PurchaseOrder`), convert it to kebab-case for the module name
{{/if}}

## Guided Workflow

### 1. Confirm Module Name

{{#unless args}}
Ask the user for the module name (plural kebab-case), e.g., `products`, `categories`, `supplier-contracts`.
{{/unless}}

### 2. Collect Entity Information

Ask the user for the following information in order:

1. **Entity Name** (PascalCase)
   - Examples: `Product`, `Category`, `SupplierContract`
   - Also confirm the Chinese display name (used for comments and GraphQL descriptions)

2. **Table Name** (plural snake_case)
   - Defaults to a derivation from the Entity name (e.g., `Product` → `products`)
   - Allow the user to override

3. **Field List**
   - Each field requires: field name (camelCase), TypeORM type (`string` / `number` / `boolean` / `Date` / `enum` / `text` / `json`), nullable flag, unique flag
   - Examples: `name string required unique`, `description text nullable`, `price number required`

4. **Relation List**
   - Ask if there are relations to other Entities
   - Each relation requires: relation type (`ManyToOne` / `OneToMany` / `ManyToMany`), target Entity name
   - Examples: `ManyToOne Category`, `OneToMany OrderItem`

5. **Enum Requirements**
   - Ask if any Enum types need to be created
   - Each Enum requires: Enum name (PascalCase), list of values
   - Example: `ProductStatus: DRAFT, ACTIVE, ARCHIVED`

6. **Permission Requirements**
   - Ask which operations require RBAC permission control
   - By default, all Mutations require permissions (adjustable)
   - Confirm RESOURCE name and ACTION name

### 3. Confirm Information Summary

Compile all collected information into a summary and ask the user to confirm:

| Item           | Value                      |
| -------------- | -------------------------- |
| Module Name    | `{module-name}`            |
| Entity Name    | `{EntityName}`             |
| Table Name     | `{table_name}`             |
| Fields         | {N}                        |
| Relations      | {N}                        |
| Enums          | {N}                        |
| Permissions    | Create / Update / Delete   |

Also list the detailed field and relation definitions for confirmation.

### 4. Launch Scaffolder Agent

Once confirmed, launch the `nestjs-module-scaffolder` agent with the following complete information:

- Module name (kebab-case)
- Entity name (PascalCase) + Chinese display name
- Table name (snake_case)
- Complete field list (including name, type, nullable, unique)
- Relation list (including type, target Entity)
- Enum definition list (including name, value list)
- Permission requirements (RESOURCE + ACTION)

The agent will create all files following the `scaffolding-nestjs-module` skill templates.

## Example Usage

```
/scaffold-module
/scaffold-module products
/scaffold-module supplier-contracts
```
