# When to Group (Use Input Types)

## Semantic Entities

```graphql
# Address is a semantic entity
mutation {
  createOrder(
    payment: PaymentChannel!
    items: [OrderItemInput!]!
    shippingAddress: AddressInput
  ): Order!
}

input AddressInput {
  street: String!
  city: String!
  postalCode: String!
  country: String!
}
```

## Structured Object Arrays

```graphql
# Order items represent line items
input OrderItemInput {
  productId: ID!
  quantity: Int!
  customization: String
}

mutation {
  createOrder(
    payment: PaymentChannel!
    items: [OrderItemInput!]!
  ): Order!
}
```

## Reusable Patterns

```graphql
# Pagination used across many queries
input PaginationInput {
  page: Int = 1
  limit: Int = 20
}

input SortInput {
  field: String!
  order: SortOrder = ASC
}

query {
  listProducts(pagination: PaginationInput, sorting: SortInput): ProductConnection!
  listOrders(pagination: PaginationInput, sorting: SortInput): OrderConnection!
}
```

## Complex Creation

```graphql
# User creation with multiple related fields
input CreateUserInput {
  email: String!
  name: String!
  profile: ProfileInput
  preferences: PreferencesInput
  address: AddressInput
}

input ProfileInput {
  bio: String
  avatar: String
  socialLinks: [SocialLinkInput!]
}

mutation {
  createUser(input: CreateUserInput!): User!
}
```

## Avoid Flattening Entities

```graphql
# Wrong - flattening destroys semantic structure
mutation {
  createOrder(
    payment: PaymentChannel!
    productId: ID!
    quantity: Int!
    # What about multiple items?
  ): Order!
}

# Wrong - flattening address loses entity abstraction
mutation {
  createOrder(
    payment: PaymentChannel!
    items: [OrderItemInput!]!
    street: String
    city: String
    postalCode: String
    country: String
  ): Order!
}
```

## Why Group?

1. **Semantic meaning**: Address, Contact, LineItem are meaningful abstractions
2. **Structure preservation**: Maintains entity boundaries
3. **Reusability**: Same Input type across mutations
4. **Evolution**: Easier to add optional fields without breaking changes
5. **Client convenience**: Form data naturally maps to Input types
