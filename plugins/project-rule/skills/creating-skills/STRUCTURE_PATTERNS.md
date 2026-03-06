# Skill Directory Structure Patterns

Choose the right structure based on your skill's complexity.

## Pattern 1: Single-File Skill

Best for simple, focused tasks.

```
~/.claude/skills/my-skill/
└── SKILL.md
```

**Use When:**
- Instructions fit in < 200 lines
- No complex reference material needed
- Single, focused purpose

**Example:**
```yaml
---
name: formatting-json
description: Formats and validates JSON files. Use when working with JSON,
prettifying data, or validating JSON syntax.
---

# JSON Formatting

When formatting JSON:
1. Use 2-space indentation
2. Sort keys alphabetically
3. Remove trailing commas

## Validation Rules
- Check for duplicate keys
- Verify UTF-8 encoding
- Validate against schema if provided
```

## Pattern 2: Multi-File Skill (Progressive Disclosure)

Best for complex domains requiring detailed reference material.

```
~/.claude/skills/my-skill/
├── SKILL.md           # Main file (< 500 lines)
├── DETAILS.md         # Extended documentation
├── EXAMPLES.md        # Code examples
└── REFERENCE.md       # API/syntax reference
```

**Use When:**
- Full content exceeds 500 lines
- Multiple sub-topics to cover
- Reference material users might need

**Key Rules:**
- Keep `SKILL.md` under 500 lines
- Reference files one level deep (avoid A→B→C chains)
- Use forward slashes in paths: `docs/guide.md`

**Example `SKILL.md`:**
```yaml
---
name: architecting-nestjs
description: NestJS project architecture guide. Dual-layer modules,
DataLoader patterns, ABAC permissions. Use when creating NestJS modules.
---

# NestJS Architecture

## Quick Reference

| Layer      | Responsibilities              |
|------------|-------------------------------|
| DataModule | Service, DataLoader, Repository|
| Module     | Queries, Mutations, Resolvers  |

See [DUAL_LAYER.md](DUAL_LAYER.md) for details.
See [DATALOADER.md](DATALOADER.md) for patterns.
```

## Pattern 3: Skill with Scripts

Best for skills that need executable automation.

```
~/.claude/skills/my-skill/
├── SKILL.md
├── scripts/
│   ├── validate.py
│   ├── process.sh
│   └── helper.js
└── docs/
    └── api.md
```

**Use When:**
- Need to execute validation or processing
- Complex operations better as code than instructions
- Want to keep script code out of context

**Key Rules:**
- Scripts execute without loading source into context
- Make scripts executable: `chmod +x scripts/*.py`
- Document script usage in `SKILL.md`

**Example:**
```yaml
---
name: pdf-processing
description: Extract and process PDF files. Use when working with PDFs.
allowed-tools: Read, Bash(python:*)
---

# PDF Processing

## Quick Extract

```python
import pdfplumber
with pdfplumber.open("doc.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

## Validation

Run the validation script before processing:

```bash
python scripts/validate.py input.pdf
```

This checks for required fields without loading script code.
```

## Pattern 4: Team/Project Skill

For skills shared across a team via version control.

```
project-root/
└── .claude/
    └── skills/
        └── team-skill/
            ├── SKILL.md
            └── docs/
```

**Workflow:**
1. Create skill in `.claude/skills/`
2. Commit to git
3. Team members pull
4. Skills load automatically on Claude Code restart

## Choosing the Right Pattern

| Requirement                        | Recommended Pattern    |
|------------------------------------|------------------------|
| Simple task, few instructions      | Single-file            |
| Detailed domain knowledge          | Multi-file             |
| Needs validation/automation        | With scripts           |
| Team standards/conventions         | Project skill          |
| Personal workflow                  | User skill (~/.claude) |

## File Naming Conventions

| File Type        | Convention              | Example                |
|------------------|-------------------------|------------------------|
| Main file        | `SKILL.md`              | Always required        |
| Documentation    | `SCREAMING_CASE.md`     | `DETAILS.md`, `API.md` |
| Scripts          | `lowercase.ext`         | `validate.py`          |
| Directories      | `lowercase`             | `scripts/`, `docs/`    |

## Progressive Disclosure Best Practices

1. **Overview First**: `SKILL.md` should be scannable in 30 seconds
2. **Link to Details**: Use `See [FILE.md](FILE.md) for details`
3. **One Level Deep**: Avoid chaining A→B→C references
4. **Context Budget**: Claude loads files on-demand, keep each focused
