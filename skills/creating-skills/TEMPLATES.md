# Skill Templates

Copy these templates to quickly create new skills.

## Template 1: Minimal Skill

For simple, focused tasks.

```yaml
---
name: my-skill-name
description: [What it does]. [When to use it]. [Keywords users would say].
---

# [Skill Title]

## Instructions

[Clear, step-by-step guidance for Claude]

1. First, do this
2. Then, do that
3. Finally, verify the result

## Examples

[Concrete examples showing expected behavior]
```

**Usage:**
1. Copy to `~/.claude/skills/my-skill-name/SKILL.md`
2. Replace placeholders with your content
3. Restart Claude Code

---

## Template 2: Standard Skill (with Supporting Files)

For skills requiring detailed documentation.

### Directory Structure

```
~/.claude/skills/my-skill-name/
├── SKILL.md
├── DETAILS.md
└── EXAMPLES.md
```

### SKILL.md

```yaml
---
name: my-skill-name
description: [What it does]. [Domain terms]. Use when [trigger scenarios].
[When users mention X, Y, or Z].
---

# [Skill Title]

## Quick Start

[Minimal working example - 5-10 lines]

## Key Concepts

| Concept    | Description                |
|------------|----------------------------|
| [Term 1]   | [Brief explanation]        |
| [Term 2]   | [Brief explanation]        |

See [DETAILS.md](DETAILS.md) for comprehensive documentation.

## Common Patterns

[Most frequently used patterns - keep brief]

See [EXAMPLES.md](EXAMPLES.md) for more examples.

## Best Practices

1. [Practice 1]
2. [Practice 2]
3. [Practice 3]
```

### DETAILS.md

```markdown
# [Skill Name] - Detailed Guide

## [Section 1]

[Detailed explanation with examples]

## [Section 2]

[More detailed content]

## Reference

[API documentation, syntax reference, etc.]
```

### EXAMPLES.md

```markdown
# [Skill Name] - Examples

## Example 1: [Use Case]

[Code example with explanation]

## Example 2: [Use Case]

[Another example]

## Anti-Patterns

[What NOT to do]
```

---

## Template 3: Advanced Skill (with Scripts)

For skills requiring executable automation.

### Directory Structure

```
~/.claude/skills/my-skill-name/
├── SKILL.md
├── REFERENCE.md
└── scripts/
    ├── validate.py
    └── process.sh
```

### SKILL.md

```yaml
---
name: my-skill-name
description: [What it does]. [Domain terms]. Use when [triggers].
Requires: [dependencies if any].
allowed-tools: Read, Bash(python:*)
---

# [Skill Title]

## Quick Start

[Minimal example to get started]

## Validation

Before processing, validate input:

```bash
python scripts/validate.py input-file
```

## Processing

[Main workflow instructions]

## Reference

See [REFERENCE.md](REFERENCE.md) for API details.

## Requirements

- Python 3.8+
- `pip install [packages]`
```

### scripts/validate.py

```python
#!/usr/bin/env python3
"""Validation script for [skill name]."""

import sys

def validate(filepath: str) -> bool:
    """Validate the input file."""
    # Add validation logic
    return True

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: validate.py <file>")
        sys.exit(1)

    if validate(sys.argv[1]):
        print("Validation passed")
    else:
        print("Validation failed")
        sys.exit(1)
```

---

## Template 4: Read-Only Skill

For skills that should not modify files.

```yaml
---
name: analyzing-code
description: Analyzes code for patterns, complexity, and potential issues.
Use when reviewing code quality or understanding codebase structure.
Read-only analysis, no modifications.
allowed-tools: Read, Grep, Glob
---

# Code Analysis

## Instructions

When analyzing code:

1. Use `Glob` to find relevant files
2. Use `Grep` to search for patterns
3. Use `Read` to examine file contents
4. Report findings without making changes

## Analysis Checklist

- [ ] Code complexity
- [ ] Duplicate code
- [ ] Naming conventions
- [ ] Error handling patterns

## Output Format

Present findings as:

```markdown
## Analysis Results

### Summary
[Brief overview]

### Findings
1. [Finding with file:line reference]
2. [Another finding]

### Recommendations
[Suggested improvements]
```
```

---

## Template 5: Fork/Subagent Skill

For skills that should run in an isolated context to avoid polluting the main conversation.

```yaml
---
name: exploring-codebase
description: Explores and maps codebase structure, dependencies, and patterns. Use when analyzing unfamiliar code, understanding architecture, or mapping module relationships.
context: fork
agent: Explore
allowed-tools: Read, Grep, Glob
---

# Codebase Explorer

## Instructions

Analyze the target codebase and produce a structured report.

1. Use `Glob` to discover project structure
2. Use `Grep` to find key patterns (entry points, exports, configs)
3. Use `Read` to examine critical files

## Output Format

Return a structured summary:

- **Entry Points**: Main files and their roles
- **Dependencies**: Key packages and internal modules
- **Architecture**: High-level patterns (MVC, modular, monorepo, etc.)
- **Conventions**: Naming, file organization, coding style
```

**Key Points:**
- `context: fork` runs the skill in an isolated subagent — results are returned without polluting the main conversation context
- `agent` specifies the subagent type (e.g., `Explore`, `general-purpose`, `Plan`)
- Combine with `allowed-tools` to further restrict what the subagent can do

---

## Quick Checklist

Before using a template:

- [ ] Replace `my-skill-name` with your actual skill name
- [ ] Update description with specific triggers
- [ ] Add domain-specific content
- [ ] Test trigger phrases
- [ ] Restart Claude Code after creation
