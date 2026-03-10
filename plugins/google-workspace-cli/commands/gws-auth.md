---
name: gws-auth
description: "Quick re-authentication for Google Workspace CLI. Refresh tokens, switch accounts, or update scopes. Trigger when user says gws login, authenticate, refresh token, switch account."
argument-hint: "[--scopes=gmail,drive,...] [--method=oauth|service-account|token]"
---

# Google Workspace CLI Authentication

Quick authentication flow for `gws` CLI.

## Argument Parsing

{{#if args}}
Parse the user-provided arguments: `{{ args }}`

- If `--scopes=...` is present, use the specified scopes for login
- If `--method=oauth` is present, use interactive OAuth flow
- If `--method=service-account` is present, guide service account setup
- If `--method=token` is present, use pre-obtained token method
{{/if}}

## Step 1: Check Current Auth Status

```bash
gws auth status
```

Report the current authentication state:
- Whether authenticated or not
- Which scopes are currently authorized
- Token expiry status

## Step 2: Determine Action

Based on the situation:

### If Not Authenticated
Guide through first-time login (refer to ONBOARDING.md for full details):

```bash
# Default: all common scopes
gws auth login --scopes gmail,drive,calendar,sheets,docs

# Or with user-specified scopes
gws auth login --scopes <user-specified-scopes>
```

### If Token Expired
Re-authenticate with the same scopes:

```bash
gws auth login --scopes gmail,drive,calendar,sheets,docs
```

### If Switching Scopes
Login with new scopes:

```bash
gws auth login --scopes <new-scopes>
```

### If Using Service Account
```bash
export GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE=/path/to/service-account-key.json
# Verify
gws drive files list --params '{"pageSize":1}'
```

### If Using Pre-obtained Token
```bash
export GOOGLE_WORKSPACE_CLI_TOKEN=$(gcloud auth print-access-token)
# Verify
gws drive files list --params '{"pageSize":1}'
```

## Step 3: Verify Authentication

After authentication, verify with a simple API call:

```bash
gws drive files list --params '{"pageSize":2}'
```

If successful, confirm the authentication is working. If failed, refer to TROUBLESHOOTING.md.

## Scope Quick Reference

| Shortcut   | Description                  |
| ---------- | ---------------------------- |
| `gmail`    | Full Gmail access            |
| `drive`    | Full Drive access            |
| `calendar` | Full Calendar access         |
| `sheets`   | Spreadsheets access          |
| `docs`     | Documents access             |
| `chat`     | Chat messages                |
| `tasks`    | Tasks access                 |
| `forms`    | Forms access                 |
| `admin`    | Admin directory access       |
| `contacts` | People/Contacts access       |

## Example Usage

```
/gws-auth
/gws-auth --scopes=gmail,drive
/gws-auth --method=service-account
/gws-auth --method=token
```
