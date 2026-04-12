---
name: protoforge
description: "LLM-driven admin prototype generator. Reads RFP/project specs and generates Next.js + mezzanine-ui admin prototypes with mock data. Use when user says /proto, generate prototype, create admin UI, proto from document, build admin from spec, scaffold prototype, protoforge, or wants to turn requirements into a working admin interface."
user-invocable: true
---

# ProtoForge — Admin Prototype Generator

Generate interactive admin prototypes from project planning documents using mezzanine-ui components.

## Overview

ProtoForge transforms RFP / project specification documents into fully functional Next.js admin prototypes with:
- **mezzanine-ui-admin-components** for layout (AuthorizedAdminPageWrapper, PageWrapper, AdminTable)
- **@mezzanine-ui/react-hook-form-v2** for form fields
- **@faker-js/faker (zh_TW)** for realistic mock data
- **useState-based CRUD** for full interactivity without a backend

## Workflow

1. **Analyze Document** — Read the RFP/spec, extract entities, fields, pages, and navigation structure into a `ProjectSpec` (see `references/PROJECT_SPEC.md`)
2. **Generate Prototype** — Launch the `prototype-generator` agent to create a complete Next.js project
3. **Deploy (Optional)** — Use `/proto-deploy` to push to GitHub and/or Cloudflare Pages

## Reference Files

| File | Content |
|------|---------|
| `references/PROJECT_SPEC.md`      | ProjectSpec intermediate representation format                        |
| `references/ADMIN_TEMPLATES.md`   | mezzanine-ui-admin-components API reference                           |
| `references/COMPONENT_MAPPING.md` | Field type → mezzanine-ui component mapping                           |
| `references/PAGE_PATTERNS.md`     | Four page patterns (list, detail, form, dashboard) with code templates |
| `references/MOCK_DATA.md`         | Mock data generation strategy with faker.js                           |
| `references/DEPLOY_GUIDE.md`      | Cloudflare Pages + GitHub deployment guide                            |
| `references/EXAMPLE_WALKTHROUGH.md` | End-to-end example: RFP → ProjectSpec → generated code → running prototype |

## Quick Start

Use the `/proto` command for interactive guided flow, or directly:

1. Read the user's document (PDF, DOCX, MD, or pasted text)
2. Extract a `ProjectSpec` following `references/PROJECT_SPEC.md` format
3. Present the spec summary for user confirmation
4. Launch the `prototype-generator` agent with the confirmed spec

## Key Constraints

- **No backend code** — no API routes, no server actions, no database
- **mezzanine-ui only** — no raw HTML elements (`<input>`, `<button>`, `<table>`), no third-party UI libs
- **Admin components first** — prefer `AdminTable` over raw `Table`, `PageWrapper` over custom headers
- **Mock data only** — no fetch/axios/Apollo, use faker.js + useState hooks
- **Static export** — `next.config.js` must use `output: 'export'`
