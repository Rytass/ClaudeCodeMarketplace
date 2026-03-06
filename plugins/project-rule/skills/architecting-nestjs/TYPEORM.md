# TypeORM Usage Rules

## @ManyToOne Relationship

Must define `@JoinColumn` explicitly and declare FK column with `@Column`.

### Correct Pattern

```typescript
@Entity('orders')
@ObjectType()
export class OrderEntity {
  @PrimaryGeneratedColumn('uuid')
  @Field(() => ID)
  id: string;

  // Explicit FK column
  @Column('uuid')
  userId: string;

  // Relationship with explicit JoinColumn
  @ManyToOne(() => UserEntity, (user) => user.orders)
  @JoinColumn({ name: 'userId', referencedColumnName: 'id' })
  user: Relation<UserEntity>;
}
```

### Why?

- TypeORM auto-generated FK names can conflict
- Explicit FK column enables direct queries without loading relation
- Clear schema definition

## @ManyToMany Relationship

Only **one side** should define `@JoinTable`.

### Correct Pattern

```typescript
// Owner side (defines JoinTable)
@Entity('users')
export class UserEntity {
  @ManyToMany(() => RoleEntity, (role) => role.users)
  @JoinTable({
    name: 'user_roles',
    joinColumn: { name: 'userId', referencedColumnName: 'id' },
    inverseJoinColumn: { name: 'roleId', referencedColumnName: 'id' },
  })
  roles: Relation<RoleEntity[]>;
}

// Inverse side (NO JoinTable)
@Entity('roles')
export class RoleEntity {
  @ManyToMany(() => UserEntity, (user) => user.roles)
  users: Relation<UserEntity[]>;
}
```

### Why?

- Defining `@JoinTable` on both sides causes TypeORM bugs
- Only owner side manages the junction table

## GraphQL Integration

Use `Relation<T>` type for relationship fields, do NOT add `@Field()`:

```typescript
@Entity('orders')
@ObjectType()
export class OrderEntity {
  @Column('uuid')
  userId: string;

  // NO @Field() - handle in @ResolveField()
  @ManyToOne(() => UserEntity)
  @JoinColumn({ name: 'userId' })
  user: Relation<UserEntity>;
}
```

Then expose via resolver:

```typescript
@Resolver(() => OrderEntity)
export class OrderResolvers {
  @ResolveField(() => UserEntity)
  async user(@Parent() order: OrderEntity): Promise<UserEntity> {
    return this.userDataLoader.loader.load(order.userId);
  }
}
```
