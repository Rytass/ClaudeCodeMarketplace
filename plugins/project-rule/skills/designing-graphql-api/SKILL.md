---
name: designing-graphql-api
description: GraphQL API design principles — flatten (direct arguments) vs group (Input types) decision guide. Use when creating or modifying *.mutations.ts, *.input.ts, *.resolver.ts files, defining GraphQL mutation arguments, designing Input types, or deciding whether to wrap parameters in an Input object. Trigger words — mutation input, Input type, flatten args, GraphQL schema design, API parameter, createXxxInput, updateXxxInput.
---

# GraphQL API Design Principles

## Core Principle

Minimize unnecessary input type wrappers. Only group fields into Input types when they represent a **meaningful semantic abstraction** or object entity.

## Quick Decision Guide

| Scenario                   | Approach | Example                          |
|----------------------------|----------|----------------------------------|
| ≤3 independent scalars     | Flatten  | `login(account, password)`       |
| Authentication credentials | Flatten  | Direct args, no wrapper          |
| Search/filter params       | Flatten  | Independent conditions           |
| Addresses, contacts        | Group    | `AddressInput`, `ContactInput`   |
| Array of objects           | Group    | `items: [OrderItemInput!]!`      |
| >4 related parameters      | Group    | Maintainability                  |
| Reused across mutations    | Group    | DRY principle                    |

## When to Flatten

See [FLATTEN_EXAMPLES.md](FLATTEN_EXAMPLES.md) for detailed examples.

Use direct arguments when:
- Simple credentials (no additional metadata)
- Independent filter conditions
- ≤3-4 parameters with no intrinsic relationship
- One-time operation parameters

## When to Group

See [GROUP_EXAMPLES.md](GROUP_EXAMPLES.md) for detailed examples.

Create Input types when:
- Fields represent semantic entities (address, contact info)
- Structured object arrays (order items, cart entries)
- Same field set used across multiple mutations
- Complex nested structures
- >4 parameters that logically belong together

## Decision Table

See [DECISION_TABLE.md](DECISION_TABLE.md) for comprehensive criteria.
