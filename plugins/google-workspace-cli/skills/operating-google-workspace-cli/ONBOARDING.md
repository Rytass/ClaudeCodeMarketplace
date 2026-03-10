# Google Workspace CLI — First-Time Setup

Complete onboarding guide for users who have no Google Workspace CLI tools installed. Follow this guide step-by-step.

## Prerequisites Check

Run these checks to determine what needs to be installed:

```bash
# Check Node.js (required for gws and clasp)
node --version    # Requires v18+

# Check npm
npm --version

# Check Python (required for GAM only)
python3 --version  # Requires 3.9+

# Check gcloud CLI (optional, speeds up gws auth setup)
gcloud --version
```

**If Node.js is missing**, install it first:

| Platform | Command                                              |
| -------- | ---------------------------------------------------- |
| macOS    | `brew install node`                                  |
| Ubuntu   | `curl -fsSL https://deb.nodesource.com/setup_22.x \| sudo -E bash - && sudo apt-get install -y nodejs` |
| Windows  | Download from https://nodejs.org                     |
| Any      | `nvm install 22` (if nvm is available)               |

---

## Tool 1: `gws` — Official Google Workspace CLI (Recommended)

The primary tool for all Google Workspace operations. Dynamic API discovery means it automatically supports new Google APIs without updates.

### Installation

```bash
# Via npm (recommended)
npm install -g @googleworkspace/cli

# Verify installation
gws --version
```

Alternative installation methods:

```bash
# Via Nix flake
nix run github:googleworkspace/cli -- --version

# Pre-built binaries: download from GitHub Releases page
# https://github.com/googleworkspace/cli/releases
```

### Authentication Setup

#### Option A: Interactive Setup (Recommended for first-time users)

Requires `gcloud` CLI installed:

```bash
# One-time GCP project setup — creates OAuth credentials automatically
gws auth setup

# Login with default scopes
gws auth login

# Or login with specific scopes only (recommended to avoid 25-scope limit)
gws auth login --scopes drive,gmail,calendar,sheets,docs,chat
```

#### Option B: Manual OAuth Setup (No gcloud required)

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project (or select existing)
3. Navigate to **APIs & Services → Credentials**
4. Click **Create Credentials → OAuth client ID**
5. Select **Desktop app** as application type
6. Download the JSON file
7. Save it to `~/.config/gws/client_secret.json`

```bash
# Enable required APIs in the project
# Go to APIs & Services → Library and enable:
#   - Gmail API
#   - Google Drive API
#   - Google Calendar API
#   - Google Sheets API
#   - Google Docs API
#   - Google Chat API
#   - Admin SDK API (if admin operations needed)

# Set up OAuth consent screen:
# APIs & Services → OAuth consent screen → External → Add test users

# Login
gws auth login
```

#### Option C: Service Account (CI/CD and automation)

```bash
# 1. Create a service account in Google Cloud Console
# 2. Download the key JSON file
# 3. Set environment variable:
export GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE=/path/to/service-account-key.json

# For domain-wide delegation (accessing user data):
# Admin Console → Security → API controls → Domain-wide delegation
# Add the service account client ID with required scopes
```

#### Option D: Pre-obtained Token (Quick testing)

```bash
# Using gcloud
export GOOGLE_WORKSPACE_CLI_TOKEN=$(gcloud auth print-access-token)

# Now all gws commands use this token
gws drive files list --params '{"pageSize":5}'
```

#### Option E: Headless / Remote Server

```bash
# On a machine WITH a browser:
gws auth login
gws auth export --unmasked > credentials.json

# Copy credentials.json to the headless machine, then:
export GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE=/path/to/credentials.json
```

### Verify gws Setup

```bash
# Check auth status
gws auth status

# Test with a simple API call
gws drive files list --params '{"pageSize":3}'

# If you see your Drive files, setup is complete!
```

### OAuth Consent Screen — Important Notes

- **Testing mode** apps are limited to ~25 OAuth scopes
- You must add yourself as a **test user** in the OAuth consent screen
- If you see "Access blocked" or "Google hasn't verified this app", click **Advanced → Go to app (unsafe)**
- For production use, submit your app for verification

---

## Tool 2: `GAM` — Google Workspace Admin Manager (Optional)

Install GAM only if you need bulk admin operations (user provisioning, group management, device policies). Skip this if you only need individual file/email/calendar operations.

### Installation

```bash
# Linux / macOS — automated installer
bash <(curl -s -S -L https://git.io/install-gam)

# This installs GAM7 (GAMADV-XTD3) to ~/bin/gam/

# Add to PATH
export PATH="$HOME/bin/gam:$PATH"

# Verify
gam version
```

### Authentication

GAM requires domain-wide delegation for admin operations:

```bash
# Initial setup — follow the interactive prompts
gam setup

# This will:
# 1. Create a GCP project
# 2. Create a service account
# 3. Enable Admin SDK APIs
# 4. Guide you through domain-wide delegation setup in Admin Console

# After setup, verify:
gam info domain
gam print users maxresults 5
```

### Domain-Wide Delegation Setup

1. `gam setup` generates a service account
2. Go to **Google Admin Console → Security → API controls → Domain-wide delegation**
3. Add the service account client ID
4. Add required scopes (GAM will list them during setup)
5. Authorize and test: `gam info user admin@yourdomain.com`

---

## Tool 3: `clasp` — Apps Script CLI (Optional)

Install clasp only if you develop Google Apps Script projects. Skip this for regular Workspace operations.

### Installation

```bash
npm install -g @google/clasp

# Verify
clasp --version
```

### Enable Apps Script API

Before using clasp, enable the Apps Script API:

1. Go to https://script.google.com/home/usersettings
2. Toggle **Google Apps Script API** to **ON**

### Authentication

```bash
# Basic login — opens browser for OAuth
clasp login

# Login with named profile (for multiple accounts)
clasp login --user work-account

# Login with custom OAuth credentials
clasp login --user custom --creds /path/to/client_secret.json

# For CI/CD with service account
clasp [command] --adc
```

### Verify clasp Setup

```bash
# List your Apps Script projects
clasp list-scripts

# If projects appear, setup is complete
```

---

## Scope Reference

When running `gws auth login --scopes`, use these scope shortcuts:

| Shortcut     | Full Scope                                                    | Use For                      |
| ------------ | ------------------------------------------------------------- | ---------------------------- |
| `gmail`      | `https://mail.google.com/`                                    | Full Gmail access            |
| `drive`      | `https://www.googleapis.com/auth/drive`                       | Full Drive access            |
| `calendar`   | `https://www.googleapis.com/auth/calendar`                    | Full Calendar access         |
| `sheets`     | `https://www.googleapis.com/auth/spreadsheets`                | Full Sheets access           |
| `docs`       | `https://www.googleapis.com/auth/documents`                   | Full Docs access             |
| `chat`       | `https://www.googleapis.com/auth/chat.messages`               | Chat messages                |
| `admin`      | `https://www.googleapis.com/auth/admin.directory.user`        | Admin user management        |
| `tasks`      | `https://www.googleapis.com/auth/tasks`                       | Tasks access                 |
| `forms`      | `https://www.googleapis.com/auth/forms.body`                  | Forms access                 |
| `contacts`   | `https://www.googleapis.com/auth/contacts`                    | People/Contacts access       |

**Tip**: Start with only the scopes you need to stay under the 25-scope testing limit:

```bash
# Minimal common setup
gws auth login --scopes gmail,drive,calendar,sheets

# Full setup
gws auth login --scopes gmail,drive,calendar,sheets,docs,chat,tasks,forms
```

---

## Environment Variables Reference

Set these in your shell profile (`~/.bashrc`, `~/.zshrc`) or `.env` file:

```bash
# Pre-obtained access token (highest priority)
export GOOGLE_WORKSPACE_CLI_TOKEN="ya29.xxx"

# Path to OAuth or service account credentials JSON
export GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE="/path/to/credentials.json"

# Override config directory (default: ~/.config/gws)
export GOOGLE_WORKSPACE_CLI_CONFIG_DIR="$HOME/.gws"

# GCP project ID override
export GOOGLE_WORKSPACE_PROJECT_ID="my-project-123"

# OAuth client credentials (alternative to JSON file)
export GOOGLE_WORKSPACE_CLI_CLIENT_ID="123456.apps.googleusercontent.com"
export GOOGLE_WORKSPACE_CLI_CLIENT_SECRET="GOCSPX-xxx"

# Model Armor sanitization (optional)
export GOOGLE_WORKSPACE_CLI_SANITIZE_TEMPLATE="projects/P/locations/L/templates/T"
export GOOGLE_WORKSPACE_CLI_SANITIZE_MODE="warn"  # or "block"
```

---

## Quick Verification Checklist

After setup, run these commands to confirm everything works:

```bash
# ✓ gws installed and authenticated
gws --version
gws auth status
gws drive files list --params '{"pageSize":2}'

# ✓ GAM installed and authenticated (if installed)
gam version
gam info domain

# ✓ clasp installed and authenticated (if installed)
clasp --version
clasp list-scripts
```

If any command fails, see TROUBLESHOOTING.md for solutions.
