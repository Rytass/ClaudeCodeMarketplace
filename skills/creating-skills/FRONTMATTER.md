# YAML Frontmatter Reference

The frontmatter section at the top of `SKILL.md` controls how Claude discovers and uses your skill.

## Required Fields

### `name`

The unique identifier for your skill.

**Rules:**
- Lowercase letters, numbers, and hyphens only
- Maximum 64 characters
- Must match the directory name exactly
- Use gerund (verb-ing) form for clarity

**Examples:**
```yaml
# Good
name: generating-commits
name: reviewing-code
name: pdf-processing

# Bad
name: GenerateCommits    # No uppercase
name: generate_commits   # No underscores
name: commits            # Not descriptive
```

### `description`

The most critical field - determines when Claude activates your skill.

**Rules:**
- Maximum 1024 characters
- Claude uses semantic similarity to match user requests
- Include action verbs, domain terms, and trigger phrases

**Structure:**
```
[What it does] + [When to use it] + [Keywords users would say]
```

**Examples:**
```yaml
# Good - specific and trigger-rich
description: Generates commit messages from git diffs. Use when writing
commits, reviewing staged changes, or mentioning commits. Follows
commitlint standards with type(scope): subject format.

# Bad - too vague
description: Helps with git operations
```

## Optional Fields

### `allowed-tools`

Restricts which tools Claude can use when this skill is active.

**Syntax:**
- Comma-separated tool names
- Supports wildcards for Bash: `Bash(command:*)`

**Use Cases:**
- Read-only skills: `allowed-tools: Read, Grep, Glob`
- Python-only: `allowed-tools: Bash(python:*)`
- Multiple commands: `allowed-tools: Read, Bash(npm:*), Bash(node:*)`

**Example:**
```yaml
---
name: safe-file-reader
description: Read files without making changes. Use for read-only file access.
allowed-tools: Read, Grep, Glob
---
```

### `model`

Override the model used for this skill.

**Format:**
- **Aliases** (recommended): `opus`, `sonnet`, `haiku` — auto-resolves to the latest version
- **Full model ID**: e.g., `claude-opus-4-6` — use only when a specific version is required

> Prefer aliases to avoid hardcoding model IDs that become outdated.
> To look up the latest full model IDs, use the `claude-code-guide` agent or check the system prompt's model information.

**Example:**
```yaml
---
name: complex-analysis
description: Deep code analysis requiring extensive reasoning.
model: opus
---
```

### `argument-hint`

Hint text shown in the autocomplete menu after the skill name.

**Example:**
```yaml
---
name: reviewing-code
description: Reviews code for quality and best practices.
argument-hint: "<pr-number or file path>"
---
```

### `disable-model-invocation`

When `true`, prevents Claude from automatically invoking this skill based on description matching. The skill can only be triggered explicitly via `/skill-name`.

**Example:**
```yaml
---
name: dangerous-cleanup
description: Deletes temporary files and caches.
disable-model-invocation: true
---
```

### `user-invocable`

When `false`, hides the skill from the `/` slash command menu. Useful for skills that should only be triggered programmatically or by other skills.

**Example:**
```yaml
---
name: internal-helper
description: Internal utility used by other skills.
user-invocable: false
---
```

### `context`

Controls execution isolation. Set to `fork` to run the skill in an isolated subagent context, preventing it from polluting the main conversation.

**Example:**
```yaml
---
name: heavy-analysis
description: Performs resource-intensive analysis in isolation.
context: fork
---
```

### `agent`

Specifies the subagent type when using `context: fork`. Must be paired with `context: fork`.

**Example:**
```yaml
---
name: code-exploration
description: Explores codebase structure and patterns.
context: fork
agent: Explore
---
```

### `hooks`

Defines lifecycle hooks for the skill. Hooks run shell commands at specific points during skill execution.

**Example:**
```yaml
---
name: building-project
description: Builds the project with validation.
hooks:
  pre: "echo 'Starting build...'"
  post: "echo 'Build complete'"
---
```

> **Note:** Frontmatter fields may evolve. If you need to verify newly added fields or check for undocumented options, use the `claude-code-guide` agent to query the latest official documentation.

## Frontmatter Syntax Rules

1. Must start with `---` on line 1 (no blank lines before)
2. Must end with `---` before Markdown content
3. Use spaces, not tabs, for indentation
4. Description must be a **single-line string** (no YAML multiline indicators)

**Correct Format:**
```yaml
---
name: my-skill
description: Single line description here.
---

# Skill Content
```

**WARNING — Multi-line Description:**

The skill indexer does **NOT** support YAML multiline indicators (`>-`, `|`, `>`, etc.). The `description` field must be a **single-line string**.

```yaml
# WRONG — will break skill loading
description: >-
  This spans multiple lines.
  It will NOT work correctly.

# CORRECT — single line (can be long)
description: This is a longer description that covers all trigger scenarios. Use when you need detailed matching. Include action verbs and domain terms.
```

## Common Mistakes

| Mistake                           | Fix                                    |
|-----------------------------------|----------------------------------------|
| Blank line before first `---`     | Remove all lines before frontmatter    |
| Tabs instead of spaces            | Use spaces for indentation             |
| Missing closing `---`             | Add `---` after last field             |
| Uppercase in name                 | Use lowercase with hyphens             |
| Directory name doesn't match      | Ensure name field = directory name     |
