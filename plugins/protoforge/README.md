# ProtoForge Plugin

LLM-driven admin prototype generator. Reads project planning documents (RFP, specs) and generates interactive Next.js + mezzanine-ui admin prototypes with mock data.

## Installation

```
/plugin install protoforge@rytass-claude-code
```

## Usage

```
/proto
/proto --doc=./rfp.pdf
/proto --name=warehouse-admin --doc=./docs/spec.md
```

The `/proto` command guides you through:

1. **Document input** — provide a PDF, DOCX, MD file path or paste text
2. **Analysis** — extract entities, fields, pages, and navigation from the document
3. **Spec review** — confirm or adjust the extracted ProjectSpec
4. **Generation** — the `prototype-generator` agent creates a complete Next.js project
5. **Deployment (optional)** — push to GitHub and/or deploy to Cloudflare Pages

### Deploy an existing prototype

```
/proto-deploy
/proto-deploy --dir=./warehouse-admin --github=my-org
/proto-deploy --dir=./warehouse-admin --cloudflare
```

## What gets generated

- **Next.js 15** project with static export (`output: 'export'`)
- **Mezzanine-UI** admin layout composed from `@mezzanine-ui/react` primitives (`Navigation` + `Layout` + `PageHeader` + `Table` + `FormField`)
- **react-hook-form + yup** forms using the manual `register()` binding pattern (supports text / number / password / textarea, plus `useController` for Select / DatePicker / Upload / AutoComplete / RadioGroup)
- **faker.js (zh_TW)** deterministic mock data with full CRUD via useState
- **TypeScript strict** — no `any`, explicit return types
- **CSV export** for list pages with export action
- **Cross-entity referential integrity** in mock data

For a complete example from RFP to running prototype, see `skills/protoforge/references/EXAMPLE_WALKTHROUGH.md`.

## Key constraints

- No backend code (no API routes, no server actions, no database)
- `@mezzanine-ui/react` only — no raw HTML elements; deprecated Mezzanine-UI companion packages are auto-blocked by the enforce hook
- Forms use `FormField` + manual `register()` + `yup`; date/time components require a root `CalendarConfigProvider`
- Mock data only (no fetch, axios, or Apollo)

## Hook Matchers

`SubagentStop` hooks in `hooks.json` use the agent's `name` field from YAML frontmatter as the matcher value. If an agent is renamed, the corresponding `hooks.json` matcher must be updated to match.

## Components

| Type    | Name                  | Purpose                                            |
|---------|-----------------------|----------------------------------------------------|
| Skill   | `protoforge`          | Core skill with reference docs and workflow         |
| Skill   | `analyze-document`    | Extract ProjectSpec from planning documents         |
| Skill   | `deploy-prototype`    | Deploy to GitHub / Cloudflare Pages                 |
| Agent   | `prototype-generator` | Generate complete Next.js prototype from ProjectSpec |
| Agent   | `prototype-deployer`  | Handle GitHub push and Cloudflare Pages deployment  |
| Command | `/proto`              | Interactive guided prototype generation             |
| Command | `/proto-deploy`       | Deploy an existing prototype                        |
