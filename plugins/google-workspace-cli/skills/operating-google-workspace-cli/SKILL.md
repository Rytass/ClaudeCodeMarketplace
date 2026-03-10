---
name: operating-google-workspace-cli
description: Operate Google Workspace services from the command line. Gmail send search read, Drive upload download share, Calendar events agenda, Sheets read write append, Docs create edit, Chat messages spaces, Meet create, Tasks manage, Forms create, Admin users groups reports. Use gws CLI, GAM, or clasp. Trigger when user says google workspace, gmail, drive, calendar, sheets, docs, chat, meet, tasks, forms, admin, gws, send email, upload file, create event, read spreadsheet, apps script.
---

# Google Workspace CLI — Skill Reference

Operate all Google Workspace services from the terminal using CLI tools. This skill covers **every operation** available through the official `gws` CLI, supplemented by `GAM` for bulk admin tasks and `clasp` for Apps Script development.

## Quick Start

Before any operation, verify the user has tools installed and authenticated:

```bash
# Check if gws is installed
command -v gws && gws auth status

# If not installed, guide through ONBOARDING.md
```

**If the user has never set up any Google Workspace CLI tool**, follow `ONBOARDING.md` for complete first-time setup.

## Tool Selection Guide

| Scenario                                | Recommended Tool | Why                                        |
| --------------------------------------- | ---------------- | ------------------------------------------ |
| Any Google Workspace API operation      | `gws`            | Dynamic API discovery, structured JSON     |
| Send/read email, manage Drive, Calendar | `gws`            | Primary tool for all services              |
| Bulk user/group/device administration   | `GAM`            | Purpose-built for bulk admin operations    |
| CSV-based batch operations (100+ items) | `GAM`            | Native CSV import/export                   |
| Google Apps Script development          | `clasp`          | Only tool for Apps Script push/pull/deploy |
| CI/CD pipeline automation               | `gws`            | Service account + env var auth             |

## Tool Comparison

| Feature              | `gws`                          | `GAM`                        | `clasp`                      |
| -------------------- | ------------------------------ | ---------------------------- | ---------------------------- |
| Install              | `npm i -g @googleworkspace/cli`| Python installer             | `npm i -g @google/clasp`     |
| Auth                 | OAuth / Service Account / Token| Domain-wide delegation       | OAuth (per-user)             |
| API Coverage         | All Workspace APIs (dynamic)   | Admin SDK focus              | Apps Script only             |
| Output Format        | Structured JSON                | Text / CSV / JSON            | Text                         |
| Pagination           | Built-in `--page-all`          | Automatic                    | N/A                          |
| Batch Operations     | Manual scripting               | Native CSV batch             | Push/pull only               |
| Best For             | General operations + agents    | IT admin bulk tasks          | Script development           |

## Service File Index

| File                       | Services Covered                                              |
| -------------------------- | ------------------------------------------------------------- |
| GWS_CORE.md                | Universal command structure, flags, auth, pagination, schema  |
| GWS_GMAIL.md               | Send, search, read, label, draft, filter, forward, triage     |
| GWS_DRIVE.md               | List, upload, download, share, move, copy, folders, revisions |
| GWS_CALENDAR.md            | Agenda, create/update/delete events, attendees, free/busy     |
| GWS_SHEETS.md              | Read/write ranges, append rows, batch update, formatting      |
| GWS_DOCS.md                | Create, read, insert/replace text, formatting, batch update   |
| GWS_CHAT.md                | Spaces, send messages, threads, membership                    |
| GWS_ADMIN.md               | Users, groups, OUs, reports, audit logs, domain settings      |
| GWS_MEET_TASKS_FORMS.md    | Meet conferences, Tasks CRUD, Forms, Keep, Slides             |
| GAM_ADMIN.md               | Bulk admin via GAM: users, groups, devices, CSV ops           |
| CLASP_APPS_SCRIPT.md       | Apps Script: create, clone, push, pull, deploy, run           |
| ONBOARDING.md              | First-time setup: install, auth, GCP project, verification    |
| TROUBLESHOOTING.md         | OAuth errors, API enablement, scope limits, token issues      |

## Standard Workflow

1. **Check tool availability** — run `command -v gws` (or `gam` / `clasp`)
2. **If missing** — follow ONBOARDING.md for installation and auth
3. **Check auth status** — `gws auth status`
4. **If not authenticated** — run `gws auth login` with required scopes
5. **Execute operation** — refer to the appropriate service file above
6. **Handle errors** — see TROUBLESHOOTING.md for common issues

## Common Operations Quick Reference

### Gmail
```bash
gws gmail users messages list --params '{"userId":"me","q":"is:unread","maxResults":10}'
gws gmail users messages send --params '{"userId":"me"}' --json '{"raw":"BASE64_ENCODED_MESSAGE"}'
```

### Drive
```bash
gws drive files list --params '{"pageSize":10,"q":"mimeType=\"application/pdf\""}'
gws drive files create --json '{"name":"report.pdf"}' --upload ./report.pdf
```

### Calendar
```bash
gws calendar events list --params '{"calendarId":"primary","timeMin":"2025-01-01T00:00:00Z","maxResults":10}'
gws calendar events insert --params '{"calendarId":"primary"}' --json '{"summary":"Meeting","start":{"dateTime":"2025-01-15T10:00:00+08:00"},"end":{"dateTime":"2025-01-15T11:00:00+08:00"}}'
```

### Sheets
```bash
gws sheets spreadsheets values get --params '{"spreadsheetId":"SHEET_ID","range":"Sheet1!A1:C10"}'
gws sheets spreadsheets values append --params '{"spreadsheetId":"SHEET_ID","range":"Sheet1!A1","valueInputOption":"USER_ENTERED"}' --json '{"values":[["col1","col2","col3"]]}'
```

### Docs
```bash
gws docs documents get --params '{"documentId":"DOC_ID"}'
gws docs documents batchUpdate --params '{"documentId":"DOC_ID"}' --json '{"requests":[{"insertText":{"location":{"index":1},"text":"Hello World"}}]}'
```

For complete reference on each service, consult the corresponding file listed in the Service File Index above.
