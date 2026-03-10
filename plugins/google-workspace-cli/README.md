# Google Workspace CLI Plugin

Operate all Google Workspace services from the terminal via Claude Code. Supports the official `gws` CLI, `GAM` for bulk admin operations, and `clasp` for Apps Script development.

## Installation

```
/plugin install google-workspace-cli@rytass-claude-code
```

## Supported Tools

| Tool    | Install                              | Use Case                                          |
| ------- | ------------------------------------ | ------------------------------------------------- |
| `gws`   | `npm i -g @googleworkspace/cli`      | All Workspace operations (primary tool)           |
| `GAM`   | `bash <(curl -s -S -L https://git.io/install-gam)` | Bulk admin: users, groups, devices    |
| `clasp` | `npm i -g @google/clasp`             | Apps Script development                           |

## Quick Start

```bash
# 1. Install
npm install -g @googleworkspace/cli

# 2. Authenticate
gws auth setup    # One-time GCP project setup (requires gcloud)
gws auth login --scopes gmail,drive,calendar,sheets,docs

# 3. Use
gws drive files list --params '{"pageSize":5}'
gws gmail users messages list --params '{"userId":"me","maxResults":5}'
```

Or use the setup command for guided onboarding:

```
/gws-setup
```

## Supported Services

| Service       | Operations                                                      |
| ------------- | --------------------------------------------------------------- |
| **Gmail**     | Send, search, read, reply, forward, labels, drafts, filters     |
| **Drive**     | List, upload, download, share, move, copy, folders, permissions  |
| **Calendar**  | Create/update/delete events, agenda, attendees, free/busy       |
| **Sheets**    | Read/write ranges, append rows, batch update, formatting        |
| **Docs**      | Create, read, insert/replace text, formatting, tables           |
| **Chat**      | Spaces, messages, threads, reactions, membership                |
| **Meet**      | Conference records, meeting spaces, recordings, transcripts     |
| **Tasks**     | Task lists, create/update/complete tasks                        |
| **Forms**     | Create forms, add questions, view responses                     |
| **Slides**    | Create presentations, add slides, insert content                |
| **Keep**      | Notes management (Enterprise/Education only)                    |
| **Admin**     | Users, groups, OUs, devices, reports, audit logs                |

## Commands

| Command       | Description                                    |
| ------------- | ---------------------------------------------- |
| `/gws-setup`  | Interactive tool installation and auth setup    |
| `/gws-auth`   | Quick re-authentication and scope management    |

## Usage Examples

### Send an email
```
"Send an email to alice@example.com with subject 'Q1 Report' and attach report.pdf"
```

### Manage Drive files
```
"List all PDF files in my Drive modified this month"
"Upload ./presentation.pptx to the 'Shared' folder and share it with the team"
```

### Calendar operations
```
"Show me my calendar for this week"
"Create a recurring weekly meeting with the engineering team every Monday at 10am"
```

### Sheets operations
```
"Read the data from Sheet1!A1:D20 in spreadsheet ID xxx"
"Append a new row with today's sales data to the Sales spreadsheet"
```

### Admin operations
```
"List all suspended users in the domain"
"Create a new group engineering@company.com and add these members"
```

### Apps Script
```
"Clone the Apps Script project with ID xxx and set up local development"
"Push my local changes and create a new deployment"
```

## File Reference

| File                    | Description                                           |
| ----------------------- | ----------------------------------------------------- |
| SKILL.md                | Main skill entry point and tool selection guide        |
| ONBOARDING.md           | Complete first-time setup guide                        |
| GWS_CORE.md             | Universal gws command structure and flags              |
| GWS_GMAIL.md            | Gmail operations reference                             |
| GWS_DRIVE.md            | Drive operations reference                             |
| GWS_CALENDAR.md         | Calendar operations reference                          |
| GWS_SHEETS.md           | Sheets operations reference                            |
| GWS_DOCS.md             | Docs operations reference                              |
| GWS_CHAT.md             | Chat operations reference                              |
| GWS_ADMIN.md            | Admin operations reference                             |
| GWS_MEET_TASKS_FORMS.md | Meet, Tasks, Forms, Keep, Slides reference             |
| GAM_ADMIN.md            | GAM bulk admin operations reference                    |
| CLASP_APPS_SCRIPT.md    | clasp Apps Script development reference                |
| TROUBLESHOOTING.md      | Common issues and solutions                            |
