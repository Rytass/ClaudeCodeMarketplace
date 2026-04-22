#!/bin/bash

# Mezzanine-UI Version Upgrade Analysis Script
# Purpose: Compare component structure between two versions, fetch changelogs,
#          and generate a work manifest for .md documentation updates.
#
# Usage: ./scripts/upgrade-version.sh --from 1.0.0-rc.5 --to 1.0.0-rc.6

set -euo pipefail

# ─── Paths ────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CACHE_DIR="$SKILL_DIR/cache"
COMPONENTS_DIR="$SKILL_DIR/references/components"
MANIFEST_FILE="$SCRIPT_DIR/upgrade-manifest.json"

# ─── Color output ─────────────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1" >&2; }
step()    { echo -e "${CYAN}${BOLD}[STEP]${NC} $1"; }
detail()  { echo -e "       $1"; }
dry_run() { echo -e "${BLUE}[DRY-RUN]${NC} $1"; }

# ─── Globals ──────────────────────────────────────────────────────────────────

FROM_VERSION=""
TO_VERSION=""
DRY_RUN=false

GITHUB_RAW_BASE="https://raw.githubusercontent.com/Mezzanine-UI/mezzanine/v2"
GITHUB_API_BASE="https://api.github.com/repos/Mezzanine-UI/mezzanine"

# ─── Helpers ──────────────────────────────────────────────────────────────────

show_help() {
    echo ""
    echo -e "${BOLD}Mezzanine-UI Version Upgrade Analysis Script${NC}"
    echo ""
    echo "Usage:"
    echo "  $0 --from <version> --to <version> [options]"
    echo ""
    echo "Required arguments:"
    echo "  --from <version>   Current version (e.g. 1.0.0-rc.5)"
    echo "  --to   <version>   Target version (e.g. 1.0.0-rc.6)"
    echo ""
    echo "Options:"
    echo "  --dry-run          Show what would be done without writing any files"
    echo "  --help             Show this help message"
    echo ""
    echo "Output:"
    echo "  $MANIFEST_FILE"
    echo ""
    echo "Examples:"
    echo "  $0 --from 1.0.0-rc.5 --to 1.0.0-rc.6"
    echo "  $0 --from 1.0.0-rc.5 --to 1.0.0-rc.6 --dry-run"
    echo ""
}

check_dependencies() {
    local missing=()

    if ! command -v curl &> /dev/null; then
        missing+=("curl")
    fi

    if ! command -v jq &> /dev/null; then
        missing+=("jq")
    fi

    if [ ${#missing[@]} -gt 0 ]; then
        error "Missing required dependencies: ${missing[*]}"
        echo "  macOS:  brew install ${missing[*]}"
        echo "  Linux:  apt install ${missing[*]}"
        exit 1
    fi
}

parse_args() {
    if [ $# -eq 0 ]; then
        show_help
        exit 1
    fi

    while [[ $# -gt 0 ]]; do
        case $1 in
            --from)
                FROM_VERSION="${2:-}"
                if [ -z "$FROM_VERSION" ]; then
                    error "--from requires a version argument"
                    exit 1
                fi
                shift 2
                ;;
            --to)
                TO_VERSION="${2:-}"
                if [ -z "$TO_VERSION" ]; then
                    error "--to requires a version argument"
                    exit 1
                fi
                shift 2
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --help|-h)
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

    if [ -z "$FROM_VERSION" ] || [ -z "$TO_VERSION" ]; then
        error "Both --from and --to are required"
        show_help
        exit 1
    fi
}

# Compare two semver strings. Returns 0 if $1 < $2, 1 otherwise.
# Used to filter releases between from/to versions.
semver_lt() {
    local a="$1"
    local b="$2"

    # Normalize: strip leading 'v', replace pre-release '-' with '~' for sort order
    local na nb
    na=$(echo "$a" | sed 's/^v//' | sed 's/-/~/')
    nb=$(echo "$b" | sed 's/^v//' | sed 's/-/~/')

    [ "$na" != "$nb" ] && [ "$(printf '%s\n%s\n' "$na" "$nb" | sort -V | head -n1)" = "$na" ]
}

# ─── Step 1: Fetch target index.ts and compare component list ─────────────────

fetch_and_compare_components() {
    step "Step 1: Comparing component list from index.ts"

    local index_url="$GITHUB_RAW_BASE/packages/react/src/index.ts"
    detail "Fetching: $index_url"

    local index_content
    if ! index_content=$(curl -sf "$index_url" 2>/dev/null); then
        warn "Could not fetch index.ts from GitHub. Skipping component list comparison."
        echo "[]"
        return
    fi

    # Extract exported component names (uppercase-starting exports)
    # Handles both: export * from './ComponentName/...'  and  export { Foo } from './ComponentName'
    # Excludes utils/ and hooks/ sub-paths
    local target_components
    target_components=$(echo "$index_content" \
        | grep -oE "from '\./([A-Z][A-Za-z0-9]+)(/|')" \
        | grep -oE "[A-Z][A-Za-z0-9]+" \
        | sort -u)

    # Get current components from .md filenames
    local current_components
    current_components=$(ls "$COMPONENTS_DIR"/*.md 2>/dev/null \
        | xargs -I{} basename {} .md \
        | sort -u)

    # Compute diff
    local added=()
    local removed=()
    local unchanged=()

    while IFS= read -r comp; do
        if echo "$current_components" | grep -qx "$comp"; then
            unchanged+=("$comp")
        else
            added+=("$comp")
        fi
    done <<< "$target_components"

    while IFS= read -r comp; do
        if ! echo "$target_components" | grep -qx "$comp"; then
            removed+=("$comp")
        fi
    done <<< "$current_components"

    echo ""
    info "Component list comparison (${#added[@]} added, ${#removed[@]} removed, ${#unchanged[@]} unchanged):"

    if [ ${#added[@]} -gt 0 ]; then
        echo -e "  ${GREEN}ADDED:${NC}"
        for c in "${added[@]}"; do detail "  + $c"; done
    fi

    if [ ${#removed[@]} -gt 0 ]; then
        echo -e "  ${RED}REMOVED:${NC}"
        for c in "${removed[@]}"; do detail "  - $c"; done
    fi

    if [ ${#unchanged[@]} -gt 0 ]; then
        echo -e "  ${NC}UNCHANGED: ${#unchanged[@]} components${NC}"
    fi

    # Return JSON arrays for manifest
    local added_json removed_json unchanged_json
    added_json=$(printf '%s\n' "${added[@]+"${added[@]}"}" | jq -R . | jq -sc .)
    removed_json=$(printf '%s\n' "${removed[@]+"${removed[@]}"}" | jq -R . | jq -sc .)
    unchanged_json=$(printf '%s\n' "${unchanged[@]+"${unchanged[@]}"}" | jq -R . | jq -sc .)

    # Write temp file for downstream consumption
    jq -n \
        --argjson added "$added_json" \
        --argjson removed "$removed_json" \
        --argjson unchanged "$unchanged_json" \
        '{added: $added, removed: $removed, unchanged: $unchanged}' \
        > /tmp/mzn_component_diff.json

    info "Component diff written to /tmp/mzn_component_diff.json"
}

# ─── Step 2: Fetch release changelog between versions ─────────────────────────

fetch_changelog() {
    step "Step 2: Fetching release changelog from GitHub API"

    local releases_url="$GITHUB_API_BASE/releases"
    detail "Fetching: $releases_url"

    local releases_raw
    if ! releases_raw=$(curl -sf \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "$releases_url" 2>/dev/null); then
        warn "Could not fetch releases from GitHub API. Skipping changelog."
        echo "[]" > /tmp/mzn_changelog.json
        return
    fi

    # Filter releases: tag_name >= v{FROM_VERSION} and tag_name <= v{TO_VERSION}
    # We keep releases strictly after FROM_VERSION up to and including TO_VERSION
    local filtered_releases
    filtered_releases=$(echo "$releases_raw" | jq --arg from "v$FROM_VERSION" --arg to "v$TO_VERSION" '
        map(select(
            (.tag_name | ltrimstr("v")) as $v |
            ($v != "") and
            (.tag_name == $to or .tag_name == ("v" + $v))
        )) |
        map({
            tag:        .tag_name,
            name:       .name,
            published:  .published_at,
            url:        .html_url,
            body:       .body
        })
    ')

    # More robust: pick releases where tag sorts between from (exclusive) and to (inclusive)
    # Use jq with shell-level version comparison is tricky; apply a simpler approach:
    # collect all release tags and filter with bash semver_lt
    local all_tags
    all_tags=$(echo "$releases_raw" | jq -r '.[].tag_name')

    local relevant_tags=()
    while IFS= read -r tag; do
        local ver="${tag#v}"
        # Include if ver > FROM_VERSION and ver <= TO_VERSION
        if semver_lt "$FROM_VERSION" "$ver" || [ "$ver" = "$TO_VERSION" ]; then
            if semver_lt "$ver" "$TO_VERSION" || [ "$ver" = "$TO_VERSION" ]; then
                if ! semver_lt "$ver" "$FROM_VERSION" && [ "$ver" != "$FROM_VERSION" ] || [ "$ver" = "$TO_VERSION" ]; then
                    relevant_tags+=("$tag")
                fi
            fi
        fi
    done <<< "$all_tags"

    # Build filtered JSON from relevant tags
    local tags_json
    tags_json=$(printf '%s\n' "${relevant_tags[@]+"${relevant_tags[@]}"}" | jq -R . | jq -sc .)

    local changelog_json
    changelog_json=$(echo "$releases_raw" | jq --argjson tags "$tags_json" '
        map(select(.tag_name as $t | $tags | index($t) != null)) |
        map({
            tag:       .tag_name,
            name:      .name,
            published: .published_at,
            url:       .html_url,
            body:      .body
        })
    ')

    echo "$changelog_json" > /tmp/mzn_changelog.json

    local count
    count=$(echo "$changelog_json" | jq 'length')
    info "Found $count release(s) between v$FROM_VERSION and v$TO_VERSION"

    if [ "$count" -gt 0 ]; then
        echo "$changelog_json" | jq -r '.[] | "  \(.tag): \(.name // "(no title)")"'
    fi
}

# ─── Step 3: Fetch component source and diff props ────────────────────────────

fetch_component_props_diff() {
    step "Step 3: Analyzing component props changes"

    local api_index_file="$CACHE_DIR/component-api-index.json"

    if [ ! -f "$api_index_file" ]; then
        warn "component-api-index.json not found. Skipping props diff."
        echo "[]" > /tmp/mzn_props_diff.json
        return
    fi

    # Get list of components to check from current .md files
    local components
    components=$(ls "$COMPONENTS_DIR"/*.md 2>/dev/null | xargs -I{} basename {} .md | sort -u)

    local props_diff_entries=()

    while IFS= read -r component; do
        local source_url="$GITHUB_RAW_BASE/packages/react/src/${component}/${component}.tsx"
        local source_content

        if ! source_content=$(curl -sf "$source_url" 2>/dev/null); then
            # Component source file not found under expected path
            continue
        fi

        # Extract Props interface/type names from source
        local source_props
        source_props=$(echo "$source_content" \
            | grep -oE '(interface|type)[[:space:]]+[A-Za-z0-9]+Props' \
            | grep -oE '[A-Za-z0-9]+Props' \
            | sort -u)

        # Extract prop field names from the main Props interface (first one found)
        local main_props_block
        main_props_block=$(echo "$source_content" \
            | grep -A 60 "interface ${component}Props" \
            | awk '/^\}[[:space:]]*$/{exit} {print}')

        # Parse individual prop names (lines like: propName?: or propName:)
        local source_prop_names
        source_prop_names=$(echo "$main_props_block" \
            | grep -oE '^[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*[?]?:' \
            | grep -oE '[a-zA-Z_][a-zA-Z0-9_]*' \
            | sort -u)

        # Get current props from component-api-index.json
        local current_prop_names
        current_prop_names=$(jq -r \
            --arg comp "$component" \
            '.[$comp].props // {} | keys[]' \
            "$api_index_file" 2>/dev/null | sort -u || true)

        # Compute prop-level diff
        local props_added=()
        local props_removed=()

        if [ -n "$source_prop_names" ]; then
            while IFS= read -r prop; do
                [ -z "$prop" ] && continue
                if ! echo "$current_prop_names" | grep -qx "$prop"; then
                    props_added+=("$prop")
                fi
            done <<< "$source_prop_names"
        fi

        if [ -n "$current_prop_names" ]; then
            while IFS= read -r prop; do
                [ -z "$prop" ] && continue
                if [ -n "$source_prop_names" ] && ! echo "$source_prop_names" | grep -qx "$prop"; then
                    props_removed+=("$prop")
                fi
            done <<< "$current_prop_names"
        fi

        # Only record components with actual changes
        if [ ${#props_added[@]} -gt 0 ] || [ ${#props_removed[@]} -gt 0 ]; then
            local added_json removed_json
            added_json=$(printf '%s\n' "${props_added[@]+"${props_added[@]}"}" | jq -R . | jq -sc .)
            removed_json=$(printf '%s\n' "${props_removed[@]+"${props_removed[@]}"}" | jq -R . | jq -sc .)

            local entry
            entry=$(jq -n \
                --arg comp "$component" \
                --argjson added "$added_json" \
                --argjson removed "$removed_json" \
                '{component: $comp, propsAdded: $added, propsRemoved: $removed}')
            props_diff_entries+=("$entry")

            local label=""
            [ ${#props_added[@]} -gt 0 ]   && label+="${GREEN}+${#props_added[@]} props${NC} "
            [ ${#props_removed[@]} -gt 0 ]  && label+="${RED}-${#props_removed[@]} props${NC}"
            echo -e "  ${BOLD}$component${NC}: $label"
        fi

    done <<< "$components"

    # Write to temp file
    if [ ${#props_diff_entries[@]} -eq 0 ]; then
        echo "[]" > /tmp/mzn_props_diff.json
        info "No prop-level changes detected"
    else
        printf '%s\n' "${props_diff_entries[@]}" | jq -sc . > /tmp/mzn_props_diff.json
        info "${#props_diff_entries[@]} component(s) have prop changes"
    fi
}

# ─── Step 4: Update version metadata in cache files ───────────────────────────

update_cache_metadata() {
    step "Step 4: Updating cache file version metadata"

    local now
    now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local today
    today=$(date -u +"%Y-%m-%d")

    # Map of cache files and their version/date field paths (jq path expressions)
    # Each entry: "file_basename|jq_update_expression"
    local cache_updates=(
        "component-api-index.json|._meta.version = \"$TO_VERSION\" | ._meta.generatedAt = \"$today\""
        "import-paths-index.json|.meta.sourceVersion = \"$TO_VERSION\" | .meta.generatedAt = \"$today\""
        "component-index.json|.lastUpdated = \"$now\""
        "design-tokens-index.json|.lastUpdated = \"$now\" // ."
        "figma-sync.json|.lastSync = \"$now\""
        "token-values.json|.lastUpdated = \"$now\""
    )

    for entry in "${cache_updates[@]}"; do
        local filename="${entry%%|*}"
        local jq_expr="${entry#*|}"
        local filepath="$CACHE_DIR/$filename"

        if [ ! -f "$filepath" ]; then
            warn "Cache file not found, skipping: $filename"
            continue
        fi

        if [ "$DRY_RUN" = true ]; then
            dry_run "Would update $filename: $jq_expr"
        else
            local updated
            if updated=$(jq "$jq_expr" "$filepath" 2>/dev/null); then
                echo "$updated" > "$filepath"
                info "Updated $filename"
            else
                warn "Failed to apply jq update to $filename — skipping"
            fi
        fi
    done
}

# ─── Step 5: Generate work manifest ───────────────────────────────────────────

generate_manifest() {
    step "Step 5: Generating work manifest"

    local component_diff="{}"
    local changelog="[]"
    local props_diff="[]"

    [ -f /tmp/mzn_component_diff.json ] && component_diff=$(cat /tmp/mzn_component_diff.json)
    [ -f /tmp/mzn_changelog.json ]      && changelog=$(cat /tmp/mzn_changelog.json)
    [ -f /tmp/mzn_props_diff.json ]     && props_diff=$(cat /tmp/mzn_props_diff.json)

    # Build per-component work items with priority
    local work_items
    work_items=$(jq -n \
        --argjson comp_diff "$component_diff" \
        --argjson props_diff "$props_diff" \
        '
        # New components need docs created — HIGH priority
        ($comp_diff.added // []) | map({
            component:  .,
            action:     "CREATE",
            reason:     "New component not yet documented",
            priority:   "HIGH"
        }) as $new_items |

        # Removed components — HIGH priority (mark as deprecated or remove)
        ($comp_diff.removed // []) | map({
            component:  .,
            action:     "REMOVE_OR_DEPRECATE",
            reason:     "Component no longer exported from index.ts",
            priority:   "HIGH"
        }) as $removed_items |

        # Components with prop changes — MEDIUM priority
        ($props_diff // []) | map({
            component:  .component,
            action:     "UPDATE",
            reason:     (
                (if (.propsAdded | length) > 0 then
                    "Props added: " + (.propsAdded | join(", "))
                else "" end) +
                (if (.propsAdded | length) > 0 and (.propsRemoved | length) > 0 then "; " else "" end) +
                (if (.propsRemoved | length) > 0 then
                    "Props removed: " + (.propsRemoved | join(", "))
                else "" end)
            ),
            priority:   (if (.propsRemoved | length) > 0 then "HIGH" else "MEDIUM" end),
            propsAdded:   .propsAdded,
            propsRemoved: .propsRemoved
        }) as $changed_items |

        $new_items + $removed_items + $changed_items
        ')

    local manifest
    manifest=$(jq -n \
        --arg from_ver "$FROM_VERSION" \
        --arg to_ver "$TO_VERSION" \
        --arg generated_at "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
        --argjson comp_diff "$component_diff" \
        --argjson changelog "$changelog" \
        --argjson props_diff "$props_diff" \
        --argjson work_items "$work_items" \
        '{
            meta: {
                fromVersion:  $from_ver,
                toVersion:    $to_ver,
                generatedAt:  $generated_at,
                description:  "Mezzanine-UI upgrade work manifest. Consume this file to drive .md documentation updates."
            },
            summary: {
                componentsAdded:    ($comp_diff.added   // [] | length),
                componentsRemoved:  ($comp_diff.removed // [] | length),
                componentsUnchanged:($comp_diff.unchanged // [] | length),
                componentsWithPropChanges: ($props_diff | length),
                releasesCovered:    ($changelog | length),
                workItemsTotal:     ($work_items | length),
                workItemsHigh:      ($work_items | map(select(.priority == "HIGH"))   | length),
                workItemsMedium:    ($work_items | map(select(.priority == "MEDIUM")) | length),
                workItemsLow:       ($work_items | map(select(.priority == "LOW"))    | length)
            },
            componentDiff: $comp_diff,
            changelog:     $changelog,
            propsDiff:     $props_diff,
            workItems:     $work_items
        }')

    if [ "$DRY_RUN" = true ]; then
        dry_run "Would write manifest to: $MANIFEST_FILE"
        echo ""
        echo "$manifest" | jq .
    else
        echo "$manifest" | jq . > "$MANIFEST_FILE"
        info "Manifest written to: $MANIFEST_FILE"
    fi
}

# ─── Cleanup temp files ───────────────────────────────────────────────────────

cleanup() {
    rm -f /tmp/mzn_component_diff.json
    rm -f /tmp/mzn_changelog.json
    rm -f /tmp/mzn_props_diff.json
}

# ─── Main ─────────────────────────────────────────────────────────────────────

main() {
    parse_args "$@"
    check_dependencies

    echo ""
    echo -e "${BOLD}Mezzanine-UI Upgrade Analysis${NC}"
    echo -e "  From: ${YELLOW}v$FROM_VERSION${NC}  →  To: ${GREEN}v$TO_VERSION${NC}"
    if [ "$DRY_RUN" = true ]; then
        echo -e "  Mode: ${BLUE}DRY RUN${NC} (no files will be written)"
    fi
    echo ""

    fetch_and_compare_components
    echo ""

    fetch_changelog
    echo ""

    fetch_component_props_diff
    echo ""

    update_cache_metadata
    echo ""

    generate_manifest

    cleanup

    echo ""
    info "Done! Review the manifest before running the agent team update."
    if [ "$DRY_RUN" = false ]; then
        echo ""
        echo "  Manifest: $MANIFEST_FILE"
    fi
    echo ""
}

main "$@"
