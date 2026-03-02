# Module Scaffolding Checklist

## Pre-Creation Confirmation

- [ ] Has the Entity name been decided? (singular form, e.g., `Supplier`, `PurchaseOrder`)
- [ ] Has the table name been decided? (plural snake_case, e.g., `suppliers`, `purchase_orders`)
- [ ] Are Enum fields needed? (status fields, type fields)
- [ ] How many Relations? List all ManyToOne / OneToMany associations
- [ ] Is permission control needed? Confirm RESOURCES / ACTIONS definitions
- [ ] Is a DataLoader needed? (Required when referenced by ResolveField in other modules)
- [ ] Which Queries are needed? (single record, list, filter conditions)
- [ ] Which Mutations are needed? (create, update, delete, status change)

## During Creation

### Entity + Symbol (Steps 1-2)

- [ ] Symbol name matches Entity class name (`Supplier` / `SupplierEntity`)
- [ ] `@Entity` table name uses plural snake_case
- [ ] `@ObjectType` name uses PascalCase singular
- [ ] All Columns have corresponding `@Field` decorators
- [ ] Nullable fields are marked nullable on both Column and Field
- [ ] FK fields have both `@Column('uuid')` and `@ManyToOne` + `@JoinColumn`
- [ ] Registered as `[Symbol, Entity]` in the ModelsModule `models` array
- [ ] Exported in `libs/models/src/index.ts`

### Enum (Step 3, if applicable)

- [ ] Enum defined in `libs/constants`
- [ ] `registerEnumType` called in `libs/graphql`
- [ ] Entity uses `@Column('enum', { enum: MyEnum })` and `@Field(() => MyEnum)`

### DTOs (Step 4)

- [ ] CreateInput uses `@InputType()` decorator
- [ ] UpdateInput extends `PartialType(OmitType(CreateInput, ['immutableFields']))`
- [ ] CollectionDto includes `items` and `total` fields

### DataService + DataLoader + DataModule (Steps 5-7)

- [ ] DataService uses `@Inject(Symbol)` to inject Repository
- [ ] `findByIds` method handles empty array case
- [ ] DataLoader uses `{ cache: false }` to prevent cross-request caching
- [ ] DataModule imports ModelsModule
- [ ] DataModule exports DataService and DataLoader

### Queries + Mutations (Steps 8-9)

- [ ] Every Query/Mutation method has `@Authenticated()` decorator
- [ ] Every Query/Mutation method has `@CheckPermission(RESOURCES.X, ACTIONS.Y)` decorator
- [ ] List queries use `PaginationArgs` and `CollectionDto`
- [ ] Single-record queries use `@Args('id', { type: () => ID })`

### Module + AppModule (Steps 10-11)

- [ ] Module imports DataModule
- [ ] Module registers Queries, Mutations, Resolver
- [ ] AppModule imports the new Module
- [ ] `libs/X/src/index.ts` exports all public APIs

## Post-Creation Verification

- [ ] Run `nx build api` to confirm compilation passes
- [ ] After starting the dev server, verify schema correctness in GraphQL Playground
- [ ] Test Query and Mutation functionality
