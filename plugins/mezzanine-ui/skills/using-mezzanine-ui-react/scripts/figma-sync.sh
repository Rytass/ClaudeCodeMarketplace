#!/bin/bash

# Mezzanine-UI Figma Cache Sync Script
# Purpose: Fetch the latest component and design token information from the Figma REST API

set -e

# Fixed Figma File Keys
COMPONENT_FILE_KEY="gjGdP49GQZzOeQf0bNOFlt"
DOCUMENT_FILE_KEY="VgnrTeu6oOSE0giftMw1Oy"

# Cache directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="$SCRIPT_DIR/../cache"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check Token
check_token() {
    if [ -z "$MEZZANINE_FIGMA_TOKEN" ]; then
        error "MEZZANINE_FIGMA_TOKEN environment variable is required"
        echo ""
        echo "Follow these steps to set it up:"
        echo "1. Go to https://www.figma.com/developers/api#authentication"
        echo "2. Click 'Get personal access token'"
        echo "3. Set scopes: file_content:read (file_variables:read is optional)"
        echo "4. Run: export MEZZANINE_FIGMA_TOKEN=\"your-token\""
        echo ""
        echo "Note: file_variables:read permission may be restricted by your Figma plan."
        echo "      If unavailable, default design token values will be used."
        echo ""
        exit 1
    fi
}

ensure_cache_dir() {
    mkdir -p "$CACHE_DIR"
}

# Check if Figma files have updates
check_updates() {
    info "Checking Figma file update status..."

    local sync_file="$CACHE_DIR/figma-sync.json"
    local needs_update=false

    # Fetch component file metadata
    local component_meta=$(curl -s -H "X-Figma-Token: $MEZZANINE_FIGMA_TOKEN" \
        "https://api.figma.com/v1/files/$COMPONENT_FILE_KEY/meta")

    if echo "$component_meta" | jq -e '.err' > /dev/null 2>&1; then
        error "Failed to fetch component file metadata: $(echo "$component_meta" | jq -r '.err')"
        return 1
    fi

    local component_modified=$(echo "$component_meta" | jq -r '.file.last_touched_at // empty')

    # Fetch document file metadata
    local document_meta=$(curl -s -H "X-Figma-Token: $MEZZANINE_FIGMA_TOKEN" \
        "https://api.figma.com/v1/files/$DOCUMENT_FILE_KEY/meta")

    if echo "$document_meta" | jq -e '.err' > /dev/null 2>&1; then
        error "Failed to fetch document file metadata: $(echo "$document_meta" | jq -r '.err')"
        return 1
    fi

    local document_modified=$(echo "$document_meta" | jq -r '.file.last_touched_at // empty')

    # Compare update timestamps
    if [ -f "$sync_file" ]; then
        local last_component=$(jq -r '.files.component.lastModified // ""' "$sync_file")
        local last_document=$(jq -r '.files.document.lastModified // ""' "$sync_file")

        if [ "$component_modified" != "$last_component" ]; then
            warn "Component file has been updated ($last_component → $component_modified)"
            needs_update=true
        fi

        if [ "$document_modified" != "$last_document" ]; then
            warn "Document file has been updated ($last_document → $document_modified)"
            needs_update=true
        fi

        if [ "$needs_update" = false ]; then
            info "Cache is up to date, no update needed"
            return 0
        fi
    else
        warn "Sync status file not found, performing full sync"
        needs_update=true
    fi

    if [ "$needs_update" = true ]; then
        echo ""
        read -p "Do you want to update the cache? [y/N] " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            return 1
        else
            info "Skipping update"
            return 0
        fi
    fi
}

# Sync component index
sync_components() {
    info "Syncing component index..."

    local response=$(curl -s -H "X-Figma-Token: $MEZZANINE_FIGMA_TOKEN" \
        "https://api.figma.com/v1/files/$COMPONENT_FILE_KEY")

    if echo "$response" | jq -e '.err' > /dev/null 2>&1; then
        error "Failed to fetch component file: $(echo "$response" | jq -r '.err')"
        return 1
    fi

    local version=$(echo "$response" | jq -r '.version // "unknown"')
    local components=$(echo "$response" | jq '.components // {}')
    local component_count=$(echo "$components" | jq 'length')

    local component_index=$(cat <<EOF
{
  "version": "$version",
  "lastUpdated": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "figmaFileKey": "$COMPONENT_FILE_KEY",
  "componentCount": $component_count,
  "components": $components
}
EOF
)

    echo "$component_index" | jq '.' > "$CACHE_DIR/component-index.json"
    info "Updated component-index.json ($component_count components total)"
}

# Sync design tokens
sync_tokens() {
    info "Syncing design tokens..."

    local response=$(curl -s -H "X-Figma-Token: $MEZZANINE_FIGMA_TOKEN" \
        "https://api.figma.com/v1/files/$DOCUMENT_FILE_KEY/variables/local")

    # Check for errors (insufficient permissions or other reasons)
    if echo "$response" | jq -e '.error' > /dev/null 2>&1; then
        local error_msg=$(echo "$response" | jq -r '.message // .error')
        warn "Failed to fetch design variables: $error_msg"
        warn "Using default design token values"

        # Use default design tokens (based on Mezzanine-UI standard values)
        use_default_tokens
        return 0
    fi

    local variables=$(echo "$response" | jq '.meta.variables // {}')
    local collections=$(echo "$response" | jq '.meta.variableCollections // {}')

    local token_values=$(cat <<EOF
{
  "version": "$(date +%Y%m%d)",
  "lastUpdated": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "figmaFileKey": "$DOCUMENT_FILE_KEY",
  "source": "figma-api",
  "variables": $variables,
  "collections": $collections
}
EOF
)

    echo "$token_values" | jq '.' > "$CACHE_DIR/token-values.json"
    info "Updated token-values.json (from Figma API)"
}

# Use default design tokens
use_default_tokens() {
    local token_values=$(cat <<'EOF'
{
  "version": "default",
  "lastUpdated": "TIMESTAMP_PLACEHOLDER",
  "figmaFileKey": "FILEKEY_PLACEHOLDER",
  "source": "default-values",
  "note": "These are default values, not fetched from Figma API (possibly due to plan restrictions lacking file_variables:read permission)",
  "colors": {
    "primary": "#465BC7",
    "primary-light": "#7B8FE5",
    "primary-dark": "#2E3F9E",
    "secondary": "#6B7280",
    "success": "#10B981",
    "warning": "#F59E0B",
    "error": "#EF4444",
    "info": "#3B82F6",
    "text-primary": "#1F2937",
    "text-secondary": "#6B7280",
    "text-disabled": "#9CA3AF",
    "border": "#E5E7EB",
    "divider": "#F3F4F6",
    "background": "#FFFFFF",
    "surface": "#F9FAFB"
  },
  "spacing": {
    "1": "4px",
    "2": "8px",
    "3": "12px",
    "4": "16px",
    "5": "20px",
    "6": "24px",
    "8": "32px",
    "10": "40px",
    "12": "48px"
  },
  "typography": {
    "h1": { "fontSize": "32px", "fontWeight": "700", "lineHeight": "40px" },
    "h2": { "fontSize": "28px", "fontWeight": "700", "lineHeight": "36px" },
    "h3": { "fontSize": "24px", "fontWeight": "600", "lineHeight": "32px" },
    "h4": { "fontSize": "20px", "fontWeight": "600", "lineHeight": "28px" },
    "h5": { "fontSize": "16px", "fontWeight": "600", "lineHeight": "24px" },
    "h6": { "fontSize": "14px", "fontWeight": "600", "lineHeight": "20px" },
    "body1": { "fontSize": "16px", "fontWeight": "400", "lineHeight": "24px" },
    "body2": { "fontSize": "14px", "fontWeight": "400", "lineHeight": "20px" },
    "caption": { "fontSize": "12px", "fontWeight": "400", "lineHeight": "16px" }
  },
  "radius": {
    "none": "0",
    "sm": "2px",
    "md": "4px",
    "lg": "8px",
    "xl": "16px",
    "full": "9999px"
  },
  "shadow": {
    "1": "0 1px 2px 0 rgba(0, 0, 0, 0.05)",
    "2": "0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px -1px rgba(0, 0, 0, 0.1)",
    "3": "0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1)",
    "4": "0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1)",
    "5": "0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1)"
  }
}
EOF
)

    # Replace placeholders
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    token_values=$(echo "$token_values" | sed "s/TIMESTAMP_PLACEHOLDER/$timestamp/g")
    token_values=$(echo "$token_values" | sed "s/FILEKEY_PLACEHOLDER/$DOCUMENT_FILE_KEY/g")

    echo "$token_values" | jq '.' > "$CACHE_DIR/token-values.json"
    info "Created token-values.json (using default values)"
}

# Update sync status
update_sync_status() {
    info "Updating sync status..."

    local component_meta=$(curl -s -H "X-Figma-Token: $MEZZANINE_FIGMA_TOKEN" \
        "https://api.figma.com/v1/files/$COMPONENT_FILE_KEY/meta")
    local document_meta=$(curl -s -H "X-Figma-Token: $MEZZANINE_FIGMA_TOKEN" \
        "https://api.figma.com/v1/files/$DOCUMENT_FILE_KEY/meta")

    local component_modified=$(echo "$component_meta" | jq -r '.file.last_touched_at // ""')
    local document_modified=$(echo "$document_meta" | jq -r '.file.last_touched_at // ""')

    local sync_status=$(cat <<EOF
{
  "lastSync": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "files": {
    "component": {
      "fileKey": "$COMPONENT_FILE_KEY",
      "lastModified": "$component_modified",
      "url": "https://www.figma.com/design/$COMPONENT_FILE_KEY"
    },
    "document": {
      "fileKey": "$DOCUMENT_FILE_KEY",
      "lastModified": "$document_modified",
      "url": "https://www.figma.com/design/$DOCUMENT_FILE_KEY"
    }
  }
}
EOF
)

    echo "$sync_status" | jq '.' > "$CACHE_DIR/figma-sync.json"
    info "Updated figma-sync.json"
}

show_help() {
    echo "Mezzanine-UI Figma Cache Sync Script"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --check     Only check for updates, do not sync"
    echo "  --force     Force update without confirmation"
    echo "  --help      Show this help message"
    echo ""
    echo "Environment variables:"
    echo "  MEZZANINE_FIGMA_TOKEN  Figma Personal Access Token (required)"
    echo ""
    echo "Examples:"
    echo "  $0              # Interactive sync"
    echo "  $0 --check      # Check for updates"
    echo "  $0 --force      # Force sync"
}

main() {
    local check_only=false
    local force=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            --check)
                check_only=true
                shift
                ;;
            --force)
                force=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                error "Unknown argument: $1"
                show_help
                exit 1
                ;;
        esac
    done

    if ! command -v jq &> /dev/null; then
        error "jq is required"
        echo "Run: brew install jq (macOS) or apt install jq (Linux)"
        exit 1
    fi

    check_token
    ensure_cache_dir

    if [ "$check_only" = true ]; then
        check_updates
        exit $?
    fi

    if [ "$force" = false ]; then
        if check_updates; then
            exit 0
        fi
    fi

    echo ""
    info "Starting Figma data sync..."
    echo ""

    sync_components
    sync_tokens
    update_sync_status

    echo ""
    info "Sync complete!"
    echo ""
    echo "Cache file locations:"
    echo "  - $CACHE_DIR/component-index.json"
    echo "  - $CACHE_DIR/token-values.json"
    echo "  - $CACHE_DIR/figma-sync.json"
}

main "$@"
