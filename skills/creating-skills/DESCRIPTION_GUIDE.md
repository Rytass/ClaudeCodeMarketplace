# Writing Effective Skill Descriptions

The `description` field is the most important part of your skill. It determines whether Claude will activate your skill when users make requests.

## How Trigger Matching Works (Two-Phase Loading)

1. **Startup**: Skill descriptions are loaded into context (lightweight index)
2. **Request**: Claude compares user request against all descriptions to determine relevance
3. **Activation**: If matched, Claude invokes the skill via the Skill tool — full `SKILL.md` content loads into context
4. **Execution**: Claude follows the instructions in the loaded `SKILL.md`

## The Description Formula

```
[Action Verbs] + [Domain Terms] + [Trigger Phrases] + [Use Cases]
```

### Components

| Component       | Purpose                                    | Examples                              |
|-----------------|--------------------------------------------|---------------------------------------|
| Action Verbs    | What the skill does                        | generates, extracts, validates, reviews |
| Domain Terms    | Specific technology/area                   | PDF, GraphQL, TypeScript, database    |
| Trigger Phrases | Natural language users would say           | "when working with", "use when"       |
| Use Cases       | Specific scenarios                         | "writing commits", "reviewing PRs"    |

## Good vs Bad Examples

### Example 1: Commit Messages

```yaml
# Bad - too vague
description: Helps with git

# Better - more specific
description: Generates commit messages

# Best - complete with triggers
description: Generates commit messages from git diffs. Use when writing
commits, reviewing staged changes, or mentioning commits. Follows
commitlint standards with type(scope): subject format.
```

### Example 2: PDF Processing

```yaml
# Bad
description: Works with documents

# Best
description: Extract text and tables from PDF files, fill forms, merge
documents. Use when working with PDFs, mentioning forms, or document
extraction. Requires: pip install pypdf pdfplumber
```

### Example 3: Code Review

```yaml
# Bad
description: Reviews code

# Best
description: Reviews code changes for quality, security vulnerabilities,
and best practices. Use when reviewing PRs, checking code quality, or
before merging. Focuses on OWASP top 10 and common anti-patterns.
```

## Writing Tips

### 1. Start with Verbs

Begin with what the skill actually does:
- Generates, Creates, Builds
- Extracts, Parses, Analyzes
- Validates, Reviews, Checks
- Converts, Transforms, Processes

### 2. Include Domain Keywords

Add specific technical terms users would mention:
- File types: PDF, JSON, YAML, CSV
- Technologies: React, NestJS, GraphQL
- Concepts: authentication, caching, testing

### 3. Add "Use When" Phrases

Explicitly state triggering scenarios:
- "Use when creating..."
- "Use when working with..."
- "Use when mentioning..."
- "Trigger when user asks about..."

### 4. Mention Dependencies

If your skill requires packages:
```yaml
description: ... Requires: pip install package-name
```

## Testing Your Description

After creating a skill:

1. **Restart Claude Code** to load the skill
2. **Ask Claude**: "What skills are available?"
3. **Verify** your skill appears with its description
4. **Test triggers** with natural phrases:
   - "Help me create a commit message"
   - "I need to work with PDFs"
   - "Review this code for me"

## Common Mistakes

| Mistake                    | Impact                          | Fix                                |
|----------------------------|---------------------------------|------------------------------------|
| Too generic                | Never triggers                  | Add specific domain terms          |
| Too long (>1024 chars)     | Truncated, loses context        | Focus on key triggers              |
| Missing "use when"         | Unclear trigger conditions      | Add explicit trigger phrases       |
| Similar to other skills    | Wrong skill activated           | Make each description unique       |
| No action verbs            | Weak semantic matching          | Start with strong verbs            |

## Description Length Guidelines

| Length    | Characters | Use Case                          |
|-----------|------------|-----------------------------------|
| Minimal   | 50-100     | Very focused, single-purpose      |
| Standard  | 150-300    | Most skills, good trigger coverage|
| Extended  | 300-500    | Complex domains, many triggers    |
| Maximum   | 1024       | Only when absolutely necessary    |

Keep descriptions as concise as possible while including all necessary trigger keywords.
