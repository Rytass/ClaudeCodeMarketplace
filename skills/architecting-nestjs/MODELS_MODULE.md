# ModelsModule (Central Repository Management)

Central module for managing **all TypeORM Entities**.

## Symbol Token Pattern

```typescript
// In entity file (e.g., user.entity.ts)
export const User = Symbol('User');

@Entity('users')
@ObjectType()
export class UserEntity {
  @PrimaryGeneratedColumn('uuid')
  @Field(() => ID)
  id: string;

  @Column()
  @Field()
  name: string;
}
```

## ModelsModule Configuration

```typescript
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { User, UserEntity } from './entities/user.entity';
// ... other entities

const entities = [UserEntity, /* other entities */];

@Module({
  imports: [TypeOrmModule.forFeature(entities)],
  providers: [
    {
      provide: User,
      useFactory: (dataSource: DataSource) =>
        dataSource.getRepository(UserEntity),
      inject: [DataSource],
    },
    // ... other providers
  ],
  exports: [User, /* other symbols */],
})
export class ModelsModule {}
```

## Usage in Services

```typescript
import { Injectable, Inject } from '@nestjs/common';
import { Repository } from 'typeorm';
import { User, UserEntity } from '@project/models';

@Injectable()
export class UserService {
  constructor(
    @Inject(User)
    private readonly userRepo: Repository<UserEntity>,
  ) {}

  async findById(id: string): Promise<UserEntity | null> {
    return this.userRepo.findOne({ where: { id } });
  }
}
```

## Benefits

1. **Type-safe injection**: Repository type is explicitly declared
2. **No circular dependencies**: Symbol tokens break circular import chains
3. **Centralized entity management**: All entities registered in one place
4. **Easy testing**: Mock repositories by providing Symbol token
