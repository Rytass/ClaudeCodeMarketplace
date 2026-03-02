# When to Flatten (Use Direct Arguments)

## Simple Authentication

```graphql
# Correct - independent credentials
mutation {
  login(account: String!, password: String!): AuthResponse!
}
```

```graphql
# Avoid - unnecessary wrapper
mutation {
  login(input: LoginInput!): AuthResponse!
}
```

## Search with Independent Filters

```graphql
# Correct - independent conditions
query {
  searchUsers(name: String, email: String, role: UserRole): [User!]!
}
```

```graphql
# Avoid - over-abstraction
query {
  searchUsers(filters: UserSearchInput!): [User!]!
}
```

## Simple Update with Scalar ID

```graphql
# Correct - clear signature
mutation {
  updateUserStatus(userId: ID!, status: UserStatus!): User!
}
```

## Token Operations

```graphql
# Correct - single-use values
mutation {
  verifyEmail(token: String!): Boolean!
  resetPassword(token: String!, newPassword: String!): Boolean!
}
```

## Simple Toggle/Action

```graphql
# Correct - minimal params
mutation {
  toggleFeature(featureId: ID!, enabled: Boolean!): Feature!
  archiveItem(itemId: ID!): Item!
}
```

## Why Flatten?

1. **Simplicity**: Clear, self-documenting signatures
2. **GraphQL idiom**: Follows input coercion for simple types
3. **Client convenience**: No need to construct wrapper objects
4. **Readability**: Mutation signature shows all parameters
