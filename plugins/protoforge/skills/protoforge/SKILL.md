---
name: protoforge
description: "LLM-driven admin prototype generator. Reads RFP/project specs and generates Next.js + mezzanine-ui admin prototypes with mock data. Use when user says /proto, generate prototype, create admin UI, proto from document, build admin from spec, scaffold prototype, protoforge, or wants to turn requirements into a working admin interface."
user-invocable: true
---

# ProtoForge — Admin Prototype Generator

Generate interactive admin prototypes from project planning documents using mezzanine-ui components.

## Overview

ProtoForge transforms RFP / project specification documents into fully functional Next.js admin prototypes with:
- **`@mezzanine-ui/react`** primitives composed directly (`Navigation`, `Layout`, `Table`, `Tab`, `PageHeader`, `FormField`, `Input`, `Select`, `DatePicker`, `Modal`, …)
- **`react-hook-form` + `yup`** forms using the manual `register()` binding pattern (see `plugin:project-rule:scaffolding-nextjs-page` → `FORM_MODAL_TEMPLATE.md`)
- **@faker-js/faker (zh_TW)** for realistic mock data
- **useState-based CRUD** for full interactivity without a backend

Component APIs are not repeated here — defer to `plugin:project-rule:using-mezzanine-ui` for all primitives.

## Workflow

1. **Analyze Document** — Read the RFP/spec, extract entities, fields, pages, and navigation structure into a `ProjectSpec` (see `references/PROJECT_SPEC.md`)
2. **Generate Prototype** — Launch the `prototype-generator` agent to create a complete Next.js project
3. **Deploy (Optional)** — Use `/proto-deploy` to push to GitHub and/or Cloudflare Pages

## Reference Files

| File | Content |
|------|---------|
| `references/PROJECT_SPEC.md`      | ProjectSpec intermediate representation format                                                 |
| `references/LAYOUT_TEMPLATE.md`   | Admin layout skeleton (CalendarConfigProvider + Navigation + Layout) — defers to using-mezzanine-ui |
| `references/COMPONENT_MAPPING.md` | Field type → Mezzanine-UI primitive mapping + react-hook-form binding recipes                    |
| `references/PAGE_PATTERNS.md`     | Four page patterns (list, detail, form, dashboard) with code templates                          |
| `references/MOCK_DATA.md`         | Mock data generation strategy with faker.js                                                    |
| `references/DEPLOY_GUIDE.md`      | Cloudflare Pages + GitHub deployment guide                                                     |
| `references/EXAMPLE_WALKTHROUGH.md` | End-to-end example: RFP → ProjectSpec → generated code → running prototype                   |

## Quick Start

Use the `/proto` command for interactive guided flow, or directly:

1. Read the user's document (PDF, DOCX, MD, or pasted text)
2. Extract a `ProjectSpec` following `references/PROJECT_SPEC.md` format
3. Present the spec summary for user confirmation
4. Launch the `prototype-generator` agent with the confirmed spec

## Key Constraints

- **No backend code** — no API routes, no server actions, no database
- **Mezzanine-UI only** — use `@mezzanine-ui/react` primitives directly; do not add any deprecated companion packages (the enforce hook will block them)
- **No raw HTML form/table elements** (`<input>`, `<button>`, `<table>`, `<select>`, `<textarea>`) and no third-party UI libs
- **Form binding** — `<form>` + `FormField` + Mezzanine primitives with manual `register()` (or `useController` for Select / DatePicker / Upload / AutoComplete); schema validation with `yup`
- **Calendar provider** — root layout wraps `<CalendarConfigProvider methods={CalendarMethodsMoment}>` whenever date/time pickers are reachable
- **Mock data only** — no fetch/axios/Apollo, use faker.js + useState hooks
- **Static export** — `next.config.js` must use `output: 'export'`
