# Audit Report Format

> This is the standard output format template for the pattern-auditor agent. All audit results MUST follow this format to ensure consistency and readability.

---

## Template

### 1. Audit Scope

```
Audit Path: {audit_path}
Files Scanned: {file_count}
Audit Time: {audit_time}
```

### 2. Audit Results

List results for each check item with status indicators:

#### 2.1 DataLoader Compliance

| File                | Status | Description    |
|---------------------|--------|----------------|
| {file_path}         | {status} | {description}  |

#### 2.2 Permission Decorators

| File                | Status | Description    |
|---------------------|--------|----------------|
| {file_path}         | {status} | {description}  |

#### 2.3 Entity-as-ObjectType

| File                | Status | Description    |
|---------------------|--------|----------------|
| {file_path}         | {status} | {description}  |

#### 2.4 Symbol Injection

| File                | Status | Description    |
|---------------------|--------|----------------|
| {file_path}         | {status} | {description}  |

#### 2.5 Pagination Pattern

| File                | Status | Description    |
|---------------------|--------|----------------|
| {file_path}         | {status} | {description}  |

#### 2.6 Naming Conventions

| File                | Status | Description    |
|---------------------|--------|----------------|
| {file_path}         | {status} | {description}  |

#### 2.7 Module Structure

| File                | Status | Description    |
|---------------------|--------|----------------|
| {file_path}         | {status} | {description}  |

#### 2.8 Import Hygiene

| File                | Status | Description    |
|---------------------|--------|----------------|
| {file_path}         | {status} | {description}  |

### 3. Summary Statistics

| Check Item           | ✅ Pass | ⚠️ Warn | ❌ Fail |
|----------------------|---------|---------|---------|
| DataLoader Compliance | {pass}  | {warn}  | {fail}  |
| Permission Decorators | {pass}  | {warn}  | {fail}  |
| Entity-as-ObjectType | {pass}  | {warn}  | {fail}  |
| Symbol Injection     | {pass}  | {warn}  | {fail}  |
| Pagination Pattern   | {pass}  | {warn}  | {fail}  |
| Naming Conventions   | {pass}  | {warn}  | {fail}  |
| Module Structure     | {pass}  | {warn}  | {fail}  |
| Import Hygiene       | {pass}  | {warn}  | {fail}  |
| **Total**            | **{total_pass}** | **{total_warn}** | **{total_fail}** |

---

## Severity Reference

| Indicator | Level | Description                              |
|-----------|-------|------------------------------------------|
| ✅        | Pass  | Compliant with conventions               |
| ⚠️        | Warn  | Improvement recommended, non-blocking    |
| ❌        | Fail  | MUST be fixed, violates core architecture |
