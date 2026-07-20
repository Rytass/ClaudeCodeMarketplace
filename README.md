# rytass-claude-code

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Claude Code Plugin](https://img.shields.io/badge/Claude_Code-Plugin-blueviolet)](https://github.com/Rytass/ClaudeCodeMarketplace)

Claude Code plugin marketplace by Rytass — 7 plugins covering full-stack architecture conventions, design system tooling, prototype generation, and productivity integrations.

## Installation

### Add Marketplace

```bash
/plugin marketplace add Rytass/ClaudeCodeMarketplace
```

This registers the marketplace catalog only — no plugins are installed yet.

### Install a Plugin

```bash
/plugin install <plugin-name>@rytass-claude-code
```

You can also install via the interactive UI: run `/plugin` → **Discover** tab → select the plugin → choose scope.

#### Installation Scopes

| Scope       | Command                                                            | Effect                                                                |
| ----------- | ------------------------------------------------------------------ | --------------------------------------------------------------------- |
| **User**    | `/plugin install <name>@rytass-claude-code`                        | Available across all projects (default)                               |
| **Project** | `/plugin install <name>@rytass-claude-code --scope project`        | Current repo only; stored in `.claude/settings.json` for team sharing |
| **Local**   | Select "Local" scope via `/plugin` interactive UI                  | Current repo + current user only                                      |

## Plugins

| Plugin                                                                 | Version | Description                                                                                                                       |
| ---------------------------------------------------------------------- | ------- | --------------------------------------------------------------------------------------------------------------------------------- |
| [`project-rule`](./plugins/project-rule)                               | 0.8.0   | Full-stack architecture patterns: NestJS dual-layer modules, Next.js App Router, TypeORM, GraphQL Code-First, Casbin RBAC, Nx monorepo. |
| [`mezzanine-ui`](./plugins/mezzanine-ui)                               | 0.4.3   | Mezzanine-UI design system skills for React/Next.js and Angular 21+, with a sync orchestrator that refreshes docs from the monorepo.    |
| [`protoforge`](./plugins/protoforge)                                   | 0.3.2   | LLM-driven admin prototype generator. Reads RFP/spec docs and generates interactive Next.js + Mezzanine UI prototypes with mock data.   |
| [`mezzanine-ui-icon-creator`](./plugins/mezzanine-ui-icon-creator)     | 0.2.1   | Author custom SVG icons that visually match `@mezzanine-ui/icons`: style-locked rules, `IconDefinition` scaffolding, verification.      |
| [`react-performance`](./plugins/react-performance)                     | 0.1.0   | React and Next.js performance optimization rules from Vercel Engineering — 47 actionable rules.                                         |
| [`boilerplate`](./plugins/boilerplate)                                 | 0.1.0   | Full-stack project bootstrapper with deployment-specific API (GKE + NestJS, Cloudflare Workers + Hono, or Supabase Edge Functions).     |
| [`google-workspace-cli`](./plugins/google-workspace-cli)               | 0.1.0   | Google Workspace CLI operations via `gws`, GAM, and `clasp` — Gmail, Drive, Calendar, Sheets, Docs, Chat, Meet, Tasks, Forms, Admin.    |

### What Each Plugin Ships

| Plugin                      | Skills | Agents | Commands                                                        |
| --------------------------- | ------ | ------ | ---------------------------------------------------------------- |
| `project-rule`              | 15     | 4      | `/scaffold-project` `/scaffold-module` `/scaffold-page` `/audit-patterns` |
| `mezzanine-ui`              | 2      | 12     | `/sync-mezzanine-ui`                                             |
| `protoforge`                | 3      | 2      | `/proto` `/proto-deploy`                                         |
| `mezzanine-ui-icon-creator` | 1      | —      | —                                                                |
| `react-performance`         | 1      | —      | —                                                                |
| `boilerplate`               | 1      | 1      | `/init-project`                                                  |
| `google-workspace-cli`      | 1      | 1      | `/gws-setup` `/gws-auth`                                         |

`project-rule` additionally provides the `architecture-inspector` MCP server, output styles, and hook enforcement scripts. `protoforge` and `google-workspace-cli` also ship hooks.

## Repository Layout

```
ClaudeCodeMarketplace/
├── .claude-plugin/
│   └── marketplace.json      # Marketplace catalog (plugin registry)
├── plugins/
│   └── <name>/
│       ├── .claude-plugin/
│       │   └── plugin.json   # Plugin manifest (name, version, keywords)
│       ├── skills/           # Skill definitions (SKILL.md + references/)
│       ├── agents/           # Agent definitions
│       ├── commands/         # Slash commands
│       ├── hooks/            # Hook definitions + scripts
│       ├── styles/           # Output style templates
│       ├── servers/          # MCP server implementations
│       └── scripts/          # Hook enforcement scripts
├── .mcp.json                 # Local MCP registration (architecture-inspector)
└── CLAUDE.md                 # Contributor guide for this repo
```

Each plugin is self-contained. Adding a plugin means creating `plugins/<name>/` with its own manifest and registering it in `.claude-plugin/marketplace.json`.

## Contributing

- Commit messages follow **commitlint** convention, written in English: `type(scope): description` where scope is a plugin name or `marketplace`.
- Any change under `plugins/*/` **must** bump that plugin's `version` in its `.claude-plugin/plugin.json` — this is how Claude Code detects updates. Use a dedicated commit: `chore(<plugin>): bump version to <version>`.
- Split changes into atomic commits by scope.

## Update

### Update Marketplace Catalog

```bash
/plugin marketplace update rytass-claude-code
```

### Update Installed Plugin

Via the interactive UI: `/plugin` → **Marketplaces** tab → select the marketplace → Update.

Or reinstall manually:

```bash
/plugin uninstall <plugin-name>@rytass-claude-code
/plugin install <plugin-name>@rytass-claude-code
```

## Auto-Update

Claude Code checks for plugin updates on startup. Third-party marketplaces require manual opt-in.

**Enable auto-update:** `/plugin` → **Marketplaces** tab → select the marketplace → **Enable auto-update**

| Variable                                                | Effect                                                        |
| ------------------------------------------------------- | ------------------------------------------------------------- |
| `DISABLE_AUTOUPDATER`                                   | Disables all auto-updates (Claude Code + plugins)             |
| `FORCE_AUTOUPDATE_PLUGINS=true` + `DISABLE_AUTOUPDATER` | Disables Claude Code auto-update but keeps plugin auto-update |

## Uninstall

```bash
# Remove a plugin
/plugin uninstall <plugin-name>@rytass-claude-code

# Remove the marketplace (also removes all plugins installed from it)
/plugin marketplace remove rytass-claude-code
```

## License

[MIT](LICENSE)
