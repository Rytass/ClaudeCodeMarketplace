# rytass-claude-code

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Claude Code Plugin](https://img.shields.io/badge/Claude_Code-Plugin-blueviolet)](https://github.com/Rytass/ClaudeCodeMarketplace)

Claude Code plugin marketplace by Rytass.

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

| Plugin                                            | Description                                                                                          |
| ------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| [`project-rule`](./plugins/project-rule)          | Full-stack project architecture conventions. NestJS, Next.js, TypeORM, GraphQL, Mezzanine UI, Casbin RBAC, Nx monorepo, scaffolding tools, pattern auditing. |
| [`react-performance`](./plugins/react-performance)| React and Next.js performance optimization rules from Vercel Engineering. 47 actionable rules.       |
| [`boilerplate`](./plugins/boilerplate)            | Full-stack project bootstrapper with deployment-specific API (GKE, Cloudflare Workers, Supabase).    |
| [`google-workspace-cli`](./plugins/google-workspace-cli) | Google Workspace CLI operations via gws, GAM, and clasp. Gmail, Drive, Calendar, Sheets, Docs, Chat, Meet, Tasks, Forms, Admin with full onboarding. |
| [`protoforge`](./plugins/protoforge)                     | LLM-driven admin prototype generator. Reads project docs (RFP, specs) and generates interactive Next.js + mezzanine-ui admin prototypes with mock data. |

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
