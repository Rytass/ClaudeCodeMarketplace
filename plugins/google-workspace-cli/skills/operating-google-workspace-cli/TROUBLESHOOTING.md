# Google Workspace CLI — Troubleshooting

Common issues and solutions when working with Google Workspace CLI tools.

---

## Authentication Issues

### "Access blocked: This app's request is invalid" or "Access blocked"

**Cause**: Your Google account is not listed as a test user in the OAuth consent screen.

**Fix**:
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to **APIs & Services → OAuth consent screen**
3. Scroll to **Test users**
4. Click **Add users** and add your Google account email
5. Save and retry `gws auth login`

---

### "Google hasn't verified this app"

**Cause**: Normal for apps in testing mode. Not an error.

**Fix**:
1. Click **Advanced** (or "Show Advanced")
2. Click **Go to \<app name\> (unsafe)**
3. Grant the requested permissions

This is expected for personal/development OAuth apps. For production, submit your app for Google verification.

---

### "redirect_uri_mismatch"

**Cause**: Your OAuth client is not of type "Desktop app".

**Fix**:
1. Go to **APIs & Services → Credentials**
2. Delete the existing OAuth client
3. Click **Create Credentials → OAuth client ID**
4. Select **Desktop app** as application type
5. Download the new JSON and save to `~/.config/gws/client_secret.json`
6. Retry `gws auth login`

---

### "Too many scopes" or Scope Limit Exceeded

**Cause**: Testing-mode OAuth apps are limited to approximately 25 scopes.

**Fix**: Request only the scopes you need:

```bash
# Instead of all scopes:
gws auth login

# Use specific scopes:
gws auth login --scopes drive,gmail,calendar
```

Common scope groups:

| Use Case                | Scopes                              |
| ----------------------- | ----------------------------------- |
| Email only              | `gmail`                             |
| Files only              | `drive`                             |
| Productivity suite      | `gmail,drive,calendar,sheets,docs`  |
| Chat + Meet             | `chat`                              |
| Admin operations        | `admin`                             |

---

### "Token has been expired or revoked"

**Cause**: OAuth tokens expire or were manually revoked.

**Fix**:
```bash
# Re-authenticate
gws auth login --scopes drive,gmail,calendar

# Or if using environment variable:
export GOOGLE_WORKSPACE_CLI_TOKEN=$(gcloud auth print-access-token)
```

---

### "invalid_grant" Error

**Cause**: Refresh token is invalid (credentials file is stale).

**Fix**:
```bash
# Revoke and re-login
gws auth revoke
gws auth login --scopes drive,gmail,calendar
```

---

## API Enablement Issues

### "accessNotConfigured" (403) or "API not enabled"

**Cause**: The required Google API is not enabled in your GCP project.

**Fix**:
1. Check the error response — it usually contains an `enable_url` link
2. Click the link or go to **APIs & Services → Library**
3. Search for and enable the required API

Common APIs to enable:

| API                       | Required For                      |
| ------------------------- | --------------------------------- |
| Gmail API                 | Email operations                  |
| Google Drive API          | File operations                   |
| Google Calendar API       | Calendar events                   |
| Google Sheets API         | Spreadsheet operations            |
| Google Docs API           | Document operations               |
| Google Chat API           | Chat messages and spaces          |
| Google Meet REST API      | Meeting management                |
| Tasks API                 | Task management                   |
| Google Forms API          | Form management                   |
| Google Keep API           | Notes (Enterprise/Education only) |
| Admin SDK API             | User/group/device management      |
| Google Slides API         | Presentation operations           |
| People API                | Contacts management               |
| Google Classroom API      | Course management                 |

```bash
# After enabling, verify:
gws drive files list --params '{"pageSize":1}'
```

---

### "The caller does not have permission" (403)

**Cause**: The authenticated user lacks the required permissions (not an admin, no access to the resource, etc.).

**Fix**:
- Verify you're logged in as the correct user: `gws auth status`
- For admin operations, ensure your account has admin privileges
- For shared files, verify you have access to the specific resource
- For domain-wide delegation, verify the service account scopes are authorized in Admin Console

---

## Service-Specific Issues

### Gmail: Base64 Encoding Issues

**Problem**: Sent emails arrive garbled or fail with encoding errors.

**Fix**: Ensure proper base64url encoding:

```bash
# Correct encoding pipeline (Linux):
printf 'From: me\r\nTo: to@example.com\r\nSubject: Test\r\n\r\nBody' \
  | base64 -w 0 | tr '+/' '-_' | tr -d '='

# macOS (no -w flag):
printf 'From: me\r\nTo: to@example.com\r\nSubject: Test\r\n\r\nBody' \
  | base64 | tr -d '\n' | tr '+/' '-_' | tr -d '='
```

Key points:
- Use `\r\n` (CRLF) for line endings in RFC 2822
- Use base64url encoding (replace `+` with `-`, `/` with `_`, remove `=`)
- Remove all newlines from the base64 output

---

### Sheets: "Unable to parse range" or Shell History Expansion

**Problem**: Ranges with `!` cause errors in bash.

**Fix**: Always use single quotes around JSON containing `!`:

```bash
# Correct — single quotes prevent ! interpretation
--params '{"range":"Sheet1!A1:C10"}'

# Wrong — bash interprets ! in double quotes
--params "{"range":"Sheet1!A1:C10"}"
```

---

### Drive: "File not found" (404)

**Problem**: The file ID is incorrect or you don't have access.

**Fix**:
1. Verify the file ID (from the URL: `docs.google.com/document/d/FILE_ID/edit`)
2. Check your access: `gws drive files get --params '{"fileId":"FILE_ID"}'`
3. If shared with you, ensure the owner hasn't revoked access

---

### Chat: "PERMISSION_DENIED" for Message Operations

**Problem**: Chat API requires a Chat app (bot) or Google Workspace account.

**Fix**:
- Consumer Gmail accounts cannot use the Chat API
- Create a Chat app in GCP Console → APIs & Services → Chat API → Configuration
- For user-context operations, use a Google Workspace account

---

## Rate Limiting

### "Rate Limit Exceeded" (429)

**Cause**: Too many API requests in a short time.

**Fix**:
```bash
# Use page-delay for paginated operations
gws drive files list --page-all --page-delay 200

# Reduce page size
gws drive files list --params '{"pageSize":50}' --page-all --page-delay 500
```

Default rate limits vary by API:

| API          | Default Limit              |
| ------------ | -------------------------- |
| Gmail        | 250 quota units/second     |
| Drive        | 1000 queries/100 seconds   |
| Sheets       | 300 requests/minute        |
| Calendar     | Varies by operation        |
| Admin SDK    | Varies by method           |

---

## GAM-Specific Issues

### "Domain-wide delegation not configured"

**Fix**:
1. Run `gam setup` to get the service account Client ID and required scopes
2. Go to **Admin Console → Security → API controls → Domain-wide delegation**
3. Add the Client ID with the listed scopes
4. Wait 1-2 minutes for propagation
5. Retry: `gam info domain`

### "gam: command not found"

**Fix**:
```bash
# Add GAM to PATH
export PATH="$HOME/bin/gam:$PATH"

# Make it permanent
echo 'export PATH="$HOME/bin/gam:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

## clasp-Specific Issues

### "Script API not enabled"

**Fix**: Go to https://script.google.com/home/usersettings and toggle **Google Apps Script API** to **ON**.

### "Push failed: No files to push"

**Fix**:
- Check `.claspignore` is not excluding all files
- Ensure `rootDir` in `.clasp.json` points to the correct directory
- Verify script files have valid extensions (`.js`, `.gs`, `.html`)

### "Unauthorized"

**Fix**:
```bash
clasp logout
clasp login
```

---

## General Debugging

### Use Dry Run

Preview what any `gws` command will send without executing:

```bash
gws drive files list --params '{"pageSize":5}' --dry-run
```

### Check Schema

Inspect any method's expected parameters:

```bash
gws schema drive.files.list
gws schema gmail.users.messages.send
```

### Verbose Auth Status

```bash
gws auth status
```

### Test Connectivity

```bash
# Simple test — list 1 Drive file
gws drive files list --params '{"pageSize":1}'

# If this fails, the issue is auth or API enablement
# If this succeeds, the issue is with a specific service or parameters
```
