# GraphQL File Pattern

## File Separation Principle

Separate GraphQL operations by type into different files. Do NOT use a single `*.resolver.ts` file mixing all operations.

## File Naming Convention

| File Type  | Naming Pattern               | Content                                      |
|------------|------------------------------|----------------------------------------------|
| Queries    | `{domain}.queries.ts`        | All `@Query()` methods                       |
| Mutations  | `{domain}.mutations.ts`      | All `@Mutation()` methods                    |
| Resolver   | `{object-type}.resolver.ts`  | `@Resolver(() => Entity)` + `@ResolveField()`|

## Structure Example

```
src/modules/auth/
├── auth.module.ts
├── auth.service.ts
├── auth.queries.ts       ← @Query
├── auth.mutations.ts     ← @Mutation
├── dto/
└── interceptors/

src/modules/article/
├── article.module.ts
├── article.service.ts
├── article.queries.ts    ← @Query
├── article.mutations.ts  ← @Mutation
├── article.resolver.ts   ← @Resolver(() => ArticleEntity) + @ResolveField
└── dto/
```

## Implementation Patterns

### Queries File

```typescript
import { Resolver, Query } from '@nestjs/graphql';

@Resolver()
export class ArticleQueries {
  constructor(private readonly articleService: ArticleService) {}

  @Query(() => ArticleEntity)
  async article(@Args('id') id: string): Promise<ArticleEntity> {
    return this.articleService.findById(id);
  }

  @Query(() => [ArticleEntity])
  async articles(): Promise<ArticleEntity[]> {
    return this.articleService.findAll();
  }
}
```

### Mutations File

```typescript
import { Resolver, Mutation, Args } from '@nestjs/graphql';

@Resolver()
export class ArticleMutations {
  constructor(private readonly articleService: ArticleService) {}

  @Mutation(() => ArticleEntity)
  async createArticle(@Args('input') input: CreateArticleInput): Promise<ArticleEntity> {
    return this.articleService.create(input);
  }
}
```

### Resolver File (Only for ResolveField)

Create only when `@ResolveField()` is needed. File name uses the target ObjectType name (without Entity suffix):

```typescript
import { Resolver, ResolveField, Parent } from '@nestjs/graphql';

@Resolver(() => ArticleEntity)
export class ArticleResolver {
  constructor(private readonly authorDataLoader: AuthorDataLoader) {}

  @ResolveField(() => AuthorEntity)
  async author(@Parent() article: ArticleEntity): Promise<AuthorEntity> {
    return this.authorDataLoader.loader.load(article.authorId);
  }
}
```

## When to Create a Resolver File

- **Create**: When `@ResolveField()` is needed (relations, computed fields)
- **Do not create**: When there are only Query/Mutation operations with no ResolveField

## Module Registration

```typescript
@Module({
  providers: [
    ArticleService,
    ArticleQueries,
    ArticleMutations,
    ArticleResolver,  // Include only when ResolveField exists
  ],
})
export class ArticleModule {}
```

## Naming Reference

| Concept           | Class Name         | File Name               |
|-------------------|--------------------|-------------------------|
| Auth Query        | `AuthQueries`      | `auth.queries.ts`       |
| Auth Mutation     | `AuthMutations`    | `auth.mutations.ts`     |
| Article Resolver  | `ArticleResolver`  | `article.resolver.ts`   |
| Member Resolver   | `MemberResolver`   | `member.resolver.ts`    |

## Input Type vs Root Args

Prefer root args (flat parameters) unless you need to construct an object.

### Using Root Args (Default)

Use `@Args()` directly for simple parameter lists:

```typescript
@Mutation(() => LoginResponse)
async login(
  @Args('account') account: string,
  @Args('password') password: string,
): Promise<LoginResponse> {
  return this.authService.login(account, password);
}

@Mutation(() => Boolean)
async resetPassword(
  @Args('token') token: string,
  @Args('newPassword') newPassword: string,
): Promise<boolean> {
  return this.authService.resetPassword(token, newPassword);
}
```

### Using Input Type

Use `@InputType()` only when constructing complex objects:

```typescript
// Use Input when there are nested structures or many fields
@InputType()
export class CreateArticleInput {
  @Field()
  title: string;

  @Field()
  content: string;

  @Field(() => [String])
  tags: string[];

  @Field(() => ArticleMetadataInput, { nullable: true })
  metadata?: ArticleMetadataInput;  // Nested object
}

@Mutation(() => ArticleEntity)
async createArticle(@Args('input') input: CreateArticleInput): Promise<ArticleEntity> {
  return this.articleService.create(input);
}
```

### Decision Guidelines

| Scenario                            | Approach   |
|-------------------------------------|------------|
| 1–3 simple parameters              | Root Args  |
| Simple key-value pairs             | Root Args  |
| Nested object structures           | Input Type |
| Reusable parameter combinations    | Input Type |
| Many fields (>5)                   | Input Type |
