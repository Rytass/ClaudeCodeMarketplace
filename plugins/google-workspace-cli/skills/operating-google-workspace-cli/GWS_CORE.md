# gws CLI — Core Reference

Universal command structure, flags, authentication, pagination, and schema inspection for the official Google Workspace CLI.

## Command Structure

All commands follow the pattern:

```
gws <service> <resource> <method> [flags]
```

### Examples

```bash
gws drive files list                    # List Drive files
gws gmail users messages get            # Get a Gmail message
gws sheets spreadsheets create          # Create a spreadsheet
gws calendar events insert              # Create a calendar event
gws chat spaces messages create         # Send a Chat message
gws admin directory users list          # List domain users
```

## Available Services

| Service       | Command Prefix             | Description                    |
| ------------- | -------------------------- | ------------------------------ |
| Gmail         | `gws gmail`                | Email, labels, drafts, filters |
| Drive         | `gws drive`                | Files, folders, permissions    |
| Calendar      | `gws calendar`             | Events, calendars, ACLs       |
| Sheets        | `gws sheets`               | Spreadsheets, values, sheets   |
| Docs          | `gws docs`                 | Documents, batch updates       |
| Slides        | `gws slides`               | Presentations, pages           |
| Chat          | `gws chat`                 | Spaces, messages, membership   |
| Meet          | `gws meet`                 | Conference records, spaces     |
| Tasks         | `gws tasks`                | Task lists, tasks              |
| Forms         | `gws forms`                | Forms, responses, watches      |
| People        | `gws people`               | Contacts, contact groups       |
| Admin         | `gws admin`                | Users, groups, roles, OUs      |
| Classroom     | `gws classroom`            | Courses, students, assignments |
| Keep          | `gws keep`                 | Notes, permissions             |

**Note**: `gws` uses dynamic API discovery. Any new Google API endpoint is automatically available without CLI updates.

## Key Flags

| Flag                 | Description                                          | Example                                      |
| -------------------- | ---------------------------------------------------- | -------------------------------------------- |
| `--params`           | Query/path parameters as JSON                        | `--params '{"pageSize":10}'`                 |
| `--json`             | Request body as JSON                                 | `--json '{"name":"test"}'`                   |
| `--upload`           | File to upload (multipart)                           | `--upload ./file.pdf`                        |
| `--dry-run`          | Preview HTTP request without executing               | `--dry-run`                                  |
| `--page-all`         | Auto-paginate, output NDJSON (one JSON per page)     | `--page-all`                                 |
| `--page-limit <N>`   | Max number of pages to fetch (default: 10)           | `--page-limit 50`                            |
| `--page-delay <MS>`  | Delay between paginated requests (default: 100ms)    | `--page-delay 200`                           |

## Schema Inspection

Inspect any API method's request/response schema before making calls:

```bash
# View method schema
gws schema drive.files.list
gws schema gmail.users.messages.send
gws schema sheets.spreadsheets.values.get
gws schema calendar.events.insert

# Useful for discovering required parameters and body structure
```

## Authentication

### Auth Precedence (highest to lowest)

1. `GOOGLE_WORKSPACE_CLI_TOKEN` environment variable
2. `GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE` environment variable
3. Encrypted local credentials (from `gws auth login`)
4. Plaintext config file

### Auth Commands

```bash
# Initial GCP project setup (requires gcloud)
gws auth setup

# Login with browser-based OAuth
gws auth login

# Login with specific scopes
gws auth login --scopes drive,gmail,calendar,sheets,docs

# Check current auth status
gws auth status

# Export credentials for headless use
gws auth export --unmasked > credentials.json

# Revoke current credentials
gws auth revoke
```

### Environment Variable Auth

```bash
# Use a pre-obtained token
export GOOGLE_WORKSPACE_CLI_TOKEN=$(gcloud auth print-access-token)

# Use a service account key file
export GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE=/path/to/key.json

# Use OAuth credentials file (exported from another machine)
export GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE=/path/to/credentials.json
```

## Pagination

### Auto-Pagination

```bash
# Fetch all pages as NDJSON stream
gws drive files list --params '{"pageSize":100}' --page-all

# Limit to 5 pages
gws drive files list --params '{"pageSize":100}' --page-all --page-limit 5

# Add delay between requests to avoid rate limiting
gws drive files list --params '{"pageSize":100}' --page-all --page-delay 500
```

### Processing Paginated Output

```bash
# Extract specific fields with jq
gws drive files list --params '{"pageSize":100}' --page-all | jq -r '.files[].name'

# Count total results
gws drive files list --params '{"pageSize":100}' --page-all | jq -r '.files[]' | wc -l

# Save to file
gws drive files list --page-all > all_files.ndjson
```

## Multipart Uploads

```bash
# Upload a file with metadata
gws drive files create \
  --json '{"name":"report.pdf","mimeType":"application/pdf"}' \
  --upload ./report.pdf

# Upload to a specific folder
gws drive files create \
  --json '{"name":"photo.jpg","parents":["FOLDER_ID"]}' \
  --upload ./photo.jpg
```

## Dry Run

Preview any request without executing:

```bash
gws drive files list --params '{"pageSize":5}' --dry-run
# Outputs: HTTP method, URL, headers, and body (if any)
```

## Output Format

All `gws` output is structured JSON. Use `jq` for processing:

```bash
# Pretty print
gws drive files list --params '{"pageSize":5}' | jq .

# Extract file names
gws drive files list --params '{"pageSize":10}' | jq -r '.files[].name'

# Extract specific fields
gws gmail users messages list --params '{"userId":"me","maxResults":5}' \
  | jq -r '.messages[].id'

# Filter results
gws drive files list --params '{"pageSize":50}' \
  | jq '[.files[] | select(.mimeType == "application/pdf")]'
```

## Model Armor Integration

Sanitize API responses for AI agent safety:

```bash
# Inline sanitization
gws gmail users messages get \
  --params '{"userId":"me","id":"MSG_ID"}' \
  --sanitize "projects/P/locations/L/templates/T"

# Via environment variable
export GOOGLE_WORKSPACE_CLI_SANITIZE_TEMPLATE="projects/P/locations/L/templates/T"
export GOOGLE_WORKSPACE_CLI_SANITIZE_MODE="warn"  # or "block"
```

## Shell Tips

### Quoting JSON parameters

Always use single quotes around JSON to prevent shell expansion:

```bash
# Correct
gws drive files list --params '{"pageSize":10,"q":"name contains \"report\""}'

# Incorrect — double quotes cause shell interpretation issues
gws drive files list --params "{\"pageSize\":10}"
```

### Sheets range quoting

Always quote ranges containing `!` in single quotes to prevent bash history expansion:

```bash
# Correct
gws sheets spreadsheets values get \
  --params '{"spreadsheetId":"ID","range":"Sheet1!A1:C10"}'
```

### Storing IDs in variables

```bash
# Capture a file ID
FILE_ID=$(gws drive files list --params '{"pageSize":1,"q":"name=\"my-file.txt\""}' | jq -r '.files[0].id')

# Use it in subsequent commands
gws drive files get --params "{\"fileId\":\"$FILE_ID\"}"
```

## Configuration

### Config Directory

Default: `~/.config/gws/`

Override with:

```bash
export GOOGLE_WORKSPACE_CLI_CONFIG_DIR="$HOME/.my-gws-config"
```

### Config Files

| File                      | Purpose                                    |
| ------------------------- | ------------------------------------------ |
| `client_secret.json`      | OAuth client credentials                   |
| `credentials.json`        | Encrypted OAuth tokens                     |
| `discovery_cache/`        | Cached API discovery documents (24h TTL)   |
