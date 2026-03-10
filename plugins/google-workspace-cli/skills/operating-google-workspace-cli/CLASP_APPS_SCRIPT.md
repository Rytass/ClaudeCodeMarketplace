# clasp — Google Apps Script CLI

Complete reference for developing Google Apps Script projects via the `clasp` CLI.

## When to Use clasp

Use `clasp` when you need to:

- Develop Apps Script projects locally with version control
- Push/pull script code between local and cloud
- Manage Apps Script deployments
- Run Apps Script functions remotely
- Manage project APIs

**Do NOT use clasp for**: general Workspace operations (email, drive, calendar, etc.) — use `gws` instead.

## Installation

```bash
npm install -g @google/clasp

# Verify
clasp --version
```

### Enable Apps Script API

Before using clasp, enable the API:

1. Go to https://script.google.com/home/usersettings
2. Toggle **Google Apps Script API** to **ON**

## Authentication

```bash
# Basic login (opens browser)
clasp login

# Login with named profile (multiple accounts)
clasp login --user work
clasp login --user personal

# Use a named profile for subsequent commands
clasp clone-script --user work SCRIPT_ID

# Login with custom OAuth credentials
clasp login --user custom --creds /path/to/client_secret.json

# Login without localhost (manual code entry)
clasp login --no-localhost

# For CI/CD: use Application Default Credentials
clasp push --adc

# Logout
clasp logout
```

## Project Management

### Create a New Project

```bash
# Create standalone script
clasp create-script --title "My Script"

# Create with specific type
clasp create-script --title "Sheet Script" --type sheets
clasp create-script --title "Doc Addon" --type docs
clasp create-script --title "Slide Addon" --type slides
clasp create-script --title "Form Script" --type forms
clasp create-script --title "Web App" --type webapp
clasp create-script --title "API Exec" --type api

# Create with specific root directory
clasp create-script --title "My Script" --rootDir ./src

# Create bound to a specific container (Sheet, Doc, etc.)
clasp create-script --title "Bound Script" --parentId "DOCUMENT_OR_SHEET_ID"
```

### Clone an Existing Project

```bash
# Clone by script ID
clasp clone-script SCRIPT_ID

# Clone specific version
clasp clone-script SCRIPT_ID 5

# Clone into specific directory
clasp clone-script SCRIPT_ID --rootDir ./my-project
```

### List Projects

```bash
# List your Apps Script projects
clasp list-scripts
```

### Open in Browser

```bash
# Open the script editor
clasp open-script
```

### Delete Project

```bash
# Delete the current project
clasp delete-script

# Force delete without confirmation
clasp delete-script --force
```

## File Operations

### Push Local Files to Cloud

```bash
# Push all files
clasp push

# Push with watch mode (auto-push on changes)
clasp push --watch

# Force push (overwrite remote without confirmation)
clasp push --force
```

### Pull Cloud Files to Local

```bash
# Pull latest version
clasp pull

# Pull a specific version
clasp pull --versionNumber 3
```

### Check File Status

```bash
# Show which files will be pushed
clasp show-file-status

# JSON output
clasp show-file-status --json
```

## Versions

```bash
# Create a new version
clasp create-version "Release v1.0 - Initial launch"

# List all versions
clasp list-versions
```

## Deployments

```bash
# List deployments
clasp list-deployments

# Create a deployment from latest version
clasp create-deployment --description "Production v1.0"

# Create deployment from specific version
clasp create-deployment --versionNumber 3 --description "Hotfix v1.1"

# Update an existing deployment
clasp update-deployment DEPLOYMENT_ID

# Delete a deployment
clasp delete-deployment DEPLOYMENT_ID

# Delete all deployments
clasp delete-deployment --all
```

## Run Functions

```bash
# Run a function (interactive function picker)
clasp run-function

# Run a specific function
clasp run-function myFunction

# Note: Requires the Apps Script API to be enabled and the function
# must be deployed as an API executable
```

### Prerequisites for Remote Execution

1. Enable Apps Script API in GCP Console
2. Associate your script with a GCP project
3. Deploy the script as an API executable
4. Your OAuth token must have the script's required scopes

## API Management

```bash
# List available APIs
clasp list-apis

# Enable an API for the script's GCP project
clasp enable-api sheets
clasp enable-api drive
clasp enable-api gmail
clasp enable-api calendar

# Disable an API
clasp disable-api sheets
```

## Logs

```bash
# View recent logs
clasp tail-logs

# Watch logs in real-time
clasp tail-logs --watch

# JSON format
clasp tail-logs --json

# Simplified output
clasp tail-logs --simplified

# Set up logging (first-time)
clasp setup-logs
```

## Configuration

### .clasp.json

Project configuration file (created by `clasp create-script` or `clasp clone-script`):

```json
{
  "scriptId": "YOUR_SCRIPT_ID",
  "rootDir": "src/",
  "projectId": "gcp-project-id",
  "scriptExtensions": [".js", ".gs"],
  "htmlExtensions": [".html"],
  "filePushOrder": ["utils.js", "main.js"],
  "skipSubdirectories": false
}
```

| Field                | Description                                          |
| -------------------- | ---------------------------------------------------- |
| `scriptId`           | (Required) Google Apps Script project ID             |
| `rootDir`            | Local directory for script files                     |
| `projectId`          | GCP project ID                                       |
| `scriptExtensions`   | File extensions treated as scripts                   |
| `htmlExtensions`     | File extensions treated as HTML                      |
| `filePushOrder`      | Push order for dependency resolution                 |
| `skipSubdirectories` | Ignore subdirectories during push                    |

### .claspignore

Similar to `.gitignore` — controls which files are pushed:

```
# Ignore node_modules
**/node_modules/**

# Ignore build artifacts
build/temp/**
dist/**

# Ignore test files
**/*.test.js
**/*.spec.js

# Always include manifest
!appsscript.json
```

### appsscript.json

The Apps Script project manifest:

```json
{
  "timeZone": "Asia/Taipei",
  "dependencies": {
    "enabledAdvancedServices": [
      {
        "userSymbol": "Sheets",
        "serviceId": "sheets",
        "version": "v4"
      }
    ]
  },
  "exceptionLogging": "STACKDRIVER",
  "runtimeVersion": "V8",
  "oauthScopes": [
    "https://www.googleapis.com/auth/spreadsheets",
    "https://www.googleapis.com/auth/drive"
  ]
}
```

## Global Options

| Flag                 | Description                              |
| -------------------- | ---------------------------------------- |
| `--user <name>`      | Use named credentials                    |
| `--adc`              | Use Application Default Credentials      |
| `--project <file>`   | Read settings from custom .clasp.json    |
| `--ignore <file>`    | Use custom .claspignore file             |
| `--json`             | Output in JSON format                    |

## Typical Development Workflow

```bash
# 1. Clone an existing project
clasp clone-script SCRIPT_ID --rootDir ./src

# 2. Make local changes with your editor/IDE

# 3. Push changes to cloud
clasp push

# 4. Test in Apps Script editor or run directly
clasp run-function testFunction

# 5. Check logs
clasp tail-logs

# 6. Create a version for deployment
clasp create-version "v1.2 - Added email notifications"

# 7. Deploy
clasp create-deployment --versionNumber 4 --description "Production v1.2"

# 8. Optionally, watch for changes during development
clasp push --watch
```

## TypeScript Support

clasp 3.x removed built-in TypeScript transpilation. Use a bundler:

```bash
# Using Rollup (recommended)
npm install --save-dev rollup @anthropic-ai/rollup-plugin-gas

# Build TypeScript → Apps Script compatible JS
npx rollup -c rollup.config.js

# Then push the built output
clasp push
```

Starter templates:

- https://github.com/google/aside
- https://github.com/sqrrrl/apps-script-typescript-rollup-starter
