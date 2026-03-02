# Decision Criteria Summary

## Quick Reference Table

| Scenario                    | Approach | Reasoning                          |
|-----------------------------|----------|------------------------------------|
| ≤3 independent scalars      | Flatten  | Simplicity, clear signature        |
| Authentication credentials  | Flatten  | No semantic grouping needed        |
| Search/filter params        | Flatten  | Independent conditions             |
| Addresses, contacts         | Group    | Semantic entity                    |
| Array of objects            | Group    | Structured collection              |
| >4 related parameters       | Group    | Maintainability                    |
| Reused across mutations     | Group    | DRY principle                      |
| Complex nested data         | Group    | Structure preservation             |

## Decision Flowchart

```
Start
  │
  ├─ Is it a semantic entity? (address, contact, item)
  │    └─ YES → Group into Input type
  │
  ├─ Is it an array of objects?
  │    └─ YES → Group into Input type
  │
  ├─ Are there >4 parameters?
  │    └─ YES → Consider grouping
  │
  ├─ Is the same field set used in ≥2 mutations?
  │    └─ YES → Extract to Input type
  │
  └─ Otherwise → Use direct arguments (Flatten)
```

## Additional Considerations

### Type Safety

Both approaches are type-safe. Choose based on **semantic meaning**, not safety.

### API Evolution

- **Input types**: Easier to extend (add optional fields)
- **Flattened**: Requires new parameters in mutation signature

### Reusability Rule

If the same field group appears in **≥2 mutations**, extract to Input type.

### Client Convenience

Overly granular flattening can complicate client code when related values naturally belong together (e.g., address fields from a form).

### GraphQL Best Practices

- Prefer **input coercion** for simple types (scalars, enums)
- Use **Input types** for structured data and entities
- Follow: "Make common cases easy, complex cases possible"
