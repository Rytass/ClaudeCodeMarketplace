---
name: gws-setup
description: "Interactive setup for Google Workspace CLI tools. Checks installed tools, guides through installation and authentication. Trigger when user says setup google workspace, install gws, configure workspace cli."
argument-hint: "[--tool=gws|gam|clasp] [--auth-only]"
---

# Google Workspace CLI Setup

Guide the user through installing and authenticating Google Workspace CLI tools.

## Argument Parsing

{{#if args}}
Parse the user-provided arguments: `{{ args }}`

- If `--tool=gws` is present, focus on `gws` setup only
- If `--tool=gam` is present, focus on `GAM` setup only
- If `--tool=clasp` is present, focus on `clasp` setup only
- If `--auth-only` is present, skip installation and go directly to authentication
{{/if}}

## Step 1: Environment Detection

Run these checks and report the results:

```bash
# Check Node.js
node --version 2>/dev/null || echo "NOT_INSTALLED"

# Check npm
npm --version 2>/dev/null || echo "NOT_INSTALLED"

# Check gws
command -v gws && gws --version 2>/dev/null || echo "NOT_INSTALLED"

# Check gam
command -v gam && gam version 2>/dev/null || echo "NOT_INSTALLED"

# Check clasp
command -v clasp && clasp --version 2>/dev/null || echo "NOT_INSTALLED"

# Check gcloud (optional, helps with gws auth setup)
command -v gcloud && gcloud --version 2>/dev/null || echo "NOT_INSTALLED"

# Check Python (needed for GAM)
python3 --version 2>/dev/null || echo "NOT_INSTALLED"
```

Present a summary table of what is installed and what needs to be set up.

## Step 2: Determine What to Install

If no `--tool` flag is specified, ask the user what they need:

| Tool    | Use Case                                        | Requires    |
| ------- | ----------------------------------------------- | ----------- |
| `gws`   | All Workspace operations (email, drive, etc.)   | Node.js 18+ |
| `GAM`   | Bulk admin operations (users, groups, devices)   | Python 3.9+ |
| `clasp` | Apps Script development (push/pull/deploy)       | Node.js 18+ |

Recommend `gws` as the primary tool for most users.

## Step 3: Install Missing Prerequisites

If Node.js is missing and `gws` or `clasp` is needed:

- macOS: `brew install node`
- Ubuntu/Debian: `curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - && sudo apt-get install -y nodejs`
- Other: Direct the user to https://nodejs.org

If Python is missing and GAM is needed:

- macOS: `brew install python`
- Ubuntu/Debian: `sudo apt-get install -y python3`

## Step 4: Install Tools

### gws
```bash
npm install -g @googleworkspace/cli
gws --version
```

### GAM
```bash
bash <(curl -s -S -L https://git.io/install-gam)
export PATH="$HOME/bin/gam:$PATH"
gam version
```

### clasp
```bash
npm install -g @google/clasp
clasp --version
# Remind user: Enable Apps Script API at https://script.google.com/home/usersettings
```

## Step 5: Authentication

### gws Authentication

Ask the user which auth method they prefer:

1. **Interactive setup** (recommended, requires `gcloud`): `gws auth setup && gws auth login`
2. **Manual OAuth**: Guide through GCP Console OAuth client creation, then `gws auth login`
3. **Service Account**: `export GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE=/path/to/key.json`
4. **Pre-obtained token**: `export GOOGLE_WORKSPACE_CLI_TOKEN=$(gcloud auth print-access-token)`

For interactive or manual OAuth, ask which scopes they need:

```bash
# Minimal
gws auth login --scopes gmail,drive,calendar

# Standard
gws auth login --scopes gmail,drive,calendar,sheets,docs

# Full
gws auth login --scopes gmail,drive,calendar,sheets,docs,chat,tasks,forms
```

### GAM Authentication
```bash
gam setup
# Follow interactive prompts, then configure domain-wide delegation
```

### clasp Authentication
```bash
clasp login
```

## Step 6: Verification

Run verification commands for each installed tool:

```bash
# gws
gws auth status
gws drive files list --params '{"pageSize":2}'

# GAM
gam info domain

# clasp
clasp list-scripts
```

Report the results and confirm setup is complete.

## Example Usage

```
/gws-setup
/gws-setup --tool=gws
/gws-setup --tool=gam
/gws-setup --auth-only
/gws-setup --tool=clasp --auth-only
```
