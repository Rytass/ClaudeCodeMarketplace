#!/usr/bin/env bash
# Shared helper functions for protoforge hook scripts
# Source this file: source "$(dirname "$0")/_lib.sh"
#
# IMPORTANT: This file reads stdin on source. The calling script MUST
# source this BEFORE doing any other stdin reads. All hook scripts in
# this plugin follow this pattern — the hook runner pipes JSON to stdin.

# Read stdin once and store it for reuse by helper functions.
# If stdin is empty or unavailable, HOOK_INPUT will be empty and
# all extract_field calls will return empty strings (safe fallthrough).
HOOK_INPUT=$(cat 2>/dev/null || echo "")

# Extract a field from the hook's JSON input using jq.
# Falls back to empty string if jq is unavailable or field is missing.
# Usage: VALUE=$(extract_field ".toolInput.file_path")
extract_field() {
  local field="$1"
  if [ -z "$HOOK_INPUT" ]; then
    echo ""
    return
  fi
  echo "$HOOK_INPUT" | jq -r "$field // \"\"" 2>/dev/null || echo ""
}

# Commonly used field extractors
get_file_path() {
  extract_field ".toolInput.file_path"
}

get_content() {
  extract_field ".toolInput.content"
}

get_new_string() {
  extract_field ".toolInput.new_string"
}

# Check if a path should be skipped (build artifacts, node_modules, etc.)
is_skip_path() {
  local path="$1"
  case "$path" in
    */node_modules/*|*/dist/*|*/.next/*|*/out/*) return 0 ;;
    *) return 1 ;;
  esac
}

# Find a prototype project directory by looking for package.json with mezzanine-ui.
# Searches: CWD itself, CWD children, parent's children (one level up).
# Returns absolute path on success, empty string on failure.
find_proto_dir() {
  # Check CWD itself
  if [ -f "$PWD/package.json" ] && grep -q 'mezzanine-ui' "$PWD/package.json" 2>/dev/null; then
    echo "$PWD"
    return 0
  fi

  # Search CWD children, then parent children
  local search_dirs=("$PWD" "$PWD/..")
  for base in "${search_dirs[@]}"; do
    for dir in "$base"/*/; do
      if [ -f "${dir}package.json" ] && grep -q 'mezzanine-ui' "${dir}package.json" 2>/dev/null; then
        echo "$(cd "${dir%/}" && pwd)"
        return 0
      fi
    done
  done

  return 1
}
