---
name: creating-skills
description: Claude Code skill authoring guide. Covers SKILL.md format, YAML frontmatter fields, description writing techniques, progressive disclosure patterns, trigger optimization. Use when creating new skills, modifying existing skills, designing skill structure, writing skill descriptions.
---

# Creating Claude Code Skills

## Quick Start

Minimal skill structure:

```
~/.claude/skills/my-skill-name/
└── SKILL.md
```

Minimal `SKILL.md`:

```yaml
---
name: my-skill-name
description: What this skill does. When to use it. Include keywords users would say.
---

# My Skill Name

Instructions for Claude go here.
```

After creating, **restart Claude Code** to load the skill.

## Frontmatter Fields

| Field                      | Required | Description                                                    |
|----------------------------|----------|----------------------------------------------------------------|
| `name`                     | Yes      | Lowercase, hyphens only, max 64 chars                          |
| `description`              | Yes      | What + When + Keywords, max 1024 chars (**must be single-line**)|
| `allowed-tools`            | No       | Comma-separated tool names to restrict access                  |
| `model`                    | No       | Override model — prefer aliases (`opus`, `sonnet`, `haiku`)    |
| `argument-hint`            | No       | Autocomplete hint text (e.g., `"<file path>"`)                 |
| `disable-model-invocation` | No       | `true` to disable auto-trigger, only manual `/name`            |
| `user-invocable`           | No       | `false` to hide from `/` menu                                  |
| `context`                  | No       | `fork` to run in isolated subagent context                     |
| `agent`                    | No       | Subagent type when `context: fork` (e.g., `Explore`)           |
| `hooks`                    | No       | Lifecycle hooks (`pre`/`post` shell commands)                  |

See [FRONTMATTER.md](FRONTMATTER.md) for detailed rules and examples.

## Writing Effective Descriptions

**Formula**: `[Action verbs] + [Domain terms] + [Trigger phrases]`

```yaml
# Bad - too vague
description: Helps with code

# Good - specific and trigger-rich
description: Generates commit messages from git diffs. Use when writing commits,
reviewing staged changes, or mentioning commits. Follows commitlint standards.
```

See [DESCRIPTION_GUIDE.md](DESCRIPTION_GUIDE.md) for more examples and techniques.

## Directory Structure Patterns

| Pattern      | Use Case                          | Files                        |
|--------------|-----------------------------------|------------------------------|
| Single-file  | Simple, focused tasks             | `SKILL.md` only              |
| Multi-file   | Complex domain knowledge          | `SKILL.md` + supporting `.md`|
| With scripts | Executable automation             | + `scripts/` directory       |

See [STRUCTURE_PATTERNS.md](STRUCTURE_PATTERNS.md) for detailed patterns.

## Templates

Ready-to-copy templates available in [TEMPLATES.md](TEMPLATES.md):

- Minimal skill (single file)
- Standard skill (with supporting files)
- Advanced skill (with scripts)

## Checklist

Before creating a skill, use the checklist in [CHECKLIST.md](CHECKLIST.md) to ensure:

1. **Before**: Task repeated 5+ times, clear scope defined
2. **During**: Correct structure, effective description, < 500 lines
3. **After**: Restart Claude Code, test triggers, verify activation

## Dynamic Context Injection

Use `` !`command` `` syntax in `SKILL.md` to inject dynamic output at activation time:

```markdown
Current git branch: !`git branch --show-current`
```

This runs the shell command when the skill activates and inlines the result, enabling skills to adapt to the current environment.

## Key Principles

1. **Single Responsibility**: One skill = one clear purpose
2. **Progressive Disclosure**: Keep `SKILL.md` concise, details in linked files
3. **Trigger Optimization**: Description determines when Claude uses the skill
4. **Gerund Naming**: Use `verb-ing` form (e.g., `generating-commits`)
5. **Test Before Committing**: Always verify the skill triggers correctly
6. **Query Latest Info**: For dynamic information (model IDs, new fields), use the `claude-code-guide` agent to query official docs rather than relying on local cache
