# ClaudeCodeMarketplace

Rytass Claude Code Plugin Marketplace — a multi-plugin repository providing full-stack development tools, architecture patterns, and productivity integrations for Claude Code.

## Project Structure

```
ClaudeCodeMarketplace/
├── plugins/                          # All plugins live here
│   ├── project-rule/                 # Full-stack architecture patterns (v0.3.1)
│   ├── boilerplate/                  # Project bootstrapper (v0.1.0)
│   ├── react-performance/            # React/Next.js perf rules (v0.1.0)
│   └── google-workspace-cli/         # Google Workspace CLI ops (v0.1.0)
├── .mcp.json                         # MCP server registration (architecture-inspector)
├── README.md                         # Marketplace installation guide
└── CLAUDE.md                         # This file
```

Each plugin is **self-contained** under `plugins/<name>/` with its own `.claude-plugin/plugin.json` manifest.

## Git Conventions

- **Commit style**: commitlint convention, written in **English**
- **Scope format**: `type(scope): description`
  - Scopes: plugin name (`project-rule`, `boilerplate`, `react-performance`, `google-workspace-cli`) or `marketplace`
  - Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `style`, `test`
- **Atomic commits**: Split changes by scope — each commit should be self-contained and represent a single logical change
- **Never** commit/push without explicit user instruction

## Plugin Development Rules

### Version Bump (CRITICAL)

When modifying **any** plugin content under `plugins/*/`, you **MUST** bump the plugin version in its `.claude-plugin/plugin.json` before committing. This is how Claude Code Marketplace detects updates.

- **Version file**: `plugins/<plugin-name>/.claude-plugin/plugin.json` → `"version"` field
- **Patch bump** (`0.3.0` → `0.3.1`): Content updates, bug fixes, documentation changes, reference upgrades
- **Minor bump** (`0.3.0` → `0.4.0`): New skills, agents, hooks, commands, or significant feature additions
- **Major bump** (`0.x` → `1.0.0`): Breaking changes to plugin structure or behavior
- **Separate commit**: Always use a dedicated atomic commit: `chore(<plugin-name>): bump version to <new-version>`

### Plugin Anatomy

Each plugin follows this structure:

```
plugins/<name>/
├── .claude-plugin/
│   └── plugin.json          # Manifest (name, version, description, keywords)
├── skills/                   # Skill definitions (SKILL.md + references/)
├── agents/                   # Agent definitions (AGENT.md)
├── commands/                 # Slash commands (COMMAND.md)
├── hooks/                    # Hook definitions (hooks.json + scripts/)
├── styles/                   # Output style templates
├── servers/                  # MCP server implementations
└── scripts/                  # Hook enforcement scripts
```

### Skill Conventions

- Use the `creating-skills` skill for latest SKILL.md format and best practices
- Follow progressive disclosure: SKILL.md as entry point, reference docs for details
- Cache files (JSON) are auto-generated — always rebuild after updating references
- Component references should include: import path, props table, usage examples

## Coding Rules

- Do **NOT** use `any` type in TypeScript
- Every function must declare a **return type**
- Prefer **immutable data** and **functional programming** (map/filter/reduce over mutation)
- Comply with project eslint rules
- Clean up temporary/debug scripts after completion

## MCP Servers

- `architecture-inspector`: Python-based server registered in `.mcp.json` (from project-rule plugin)
  - Runs via: `python3 "${CLAUDE_PLUGIN_ROOT}/servers/architecture-inspector.py"`
