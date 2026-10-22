#!/usr/bin/env bash
# Shared helper functions for protoforge hook scripts
# Source this file: source "$(dirname "$0")/_lib.sh"
#
# IMPORTANT: This file reads stdin on source. The calling script MUST
# source this BEFORE doing any other stdin reads. All hook scripts in
# this plugin follow this pattern — the hook runner pipes JSON to stdin.

#
# Claude Code hook output contract (verified on Claude Code 2.1.308):
#   - exit 0 + plain stdout is recorded in the transcript only; the model never sees it
#   - exit 0 + JSON hookSpecificOutput.additionalContext reaches the model
#   - exit 2 + stderr blocks the tool call and reaches the model
# So every SOFT REMIND hook must go through emit_context, never a bare echo.
# Plugins are self-contained: project-rule scripts/_lib.sh and the mezzanine-ui style
# guard carry their own copy of these emitters. Change the contract in all three.

# Read stdin once and store it for reuse by helper functions.
# If stdin is empty or unavailable, HOOK_INPUT will be empty and
# all extract_field calls will return empty strings (safe fallthrough).
HOOK_INPUT=$(cat 2>/dev/null || echo "")

# Pick a JSON tool once. Without one the hook cannot read its input at all,
# so say so to the user instead of silently passing every check.
if command -v jq >/dev/null 2>&1; then
  HOOK_JSON_TOOL="jq"
elif command -v python3 >/dev/null 2>&1; then
  HOOK_JSON_TOOL="python3"
else
  printf '{"systemMessage":"protoforge hook %s did not run: neither jq nor python3 is installed."}\n' \
    "$(basename "$0")"
  exit 0
fi

# Extract a string field from the hook's JSON input (jq-style path).
# Returns empty string if the field is missing. Unlike project-rule's hook_field,
# non-string values are not serialized; protoforge only reads string fields.
# Usage: VALUE=$(extract_field ".tool_input.file_path")
extract_field() {
  local field="$1"
  if [ -z "$HOOK_INPUT" ]; then
    echo ""
    return
  fi
  if [ "$HOOK_JSON_TOOL" = "jq" ]; then
    printf '%s' "$HOOK_INPUT" | jq -r "$field // \"\"" 2>/dev/null || echo ""
  else
    printf '%s' "$HOOK_INPUT" | python3 -c '
import json, sys
try:
    value = json.load(sys.stdin)
    for key in sys.argv[1].lstrip(".").split("."):
        value = value.get(key) if isinstance(value, dict) else None
except Exception:
    value = None
print(value if isinstance(value, str) else "")
' "$field" 2>/dev/null || echo ""
  fi
}

# Send a model-visible message for the current hook event (PreToolUse, PostToolUse).
# Does nothing when the message is empty. Call at most once per hook run.
# Usage: emit_context "$MESSAGE"
emit_context() {
  local message="$1"
  local event
  [ -z "$message" ] && return 0
  event=$(extract_field ".hook_event_name")
  [ -z "$event" ] && event="PostToolUse"
  if [ "$HOOK_JSON_TOOL" = "jq" ]; then
    jq -cn --arg e "$event" --arg m "$message" \
      '{hookSpecificOutput: {hookEventName: $e, additionalContext: $m}}'
  else
    python3 -c '
import json, sys
print(json.dumps({"hookSpecificOutput": {"hookEventName": sys.argv[1], "additionalContext": sys.argv[2]}}))
' "$event" "$message"
  fi
}

# Send a systemMessage. The model never sees it. On PreToolUse/PostToolUse it is
# shown to the user; on SubagentStop it is only recorded in the subagent's
# transcript (verified on Claude Code 2.1.308), but nothing else reaches anyone
# there: the subagent has already handed back its result before the hook runs.
# Usage: emit_system_message "$MESSAGE"
emit_system_message() {
  local message="$1"
  [ -z "$message" ] && return 0
  if [ "$HOOK_JSON_TOOL" = "jq" ]; then
    jq -cn --arg m "$message" '{systemMessage: $m}'
  else
    python3 -c 'import json, sys; print(json.dumps({"systemMessage": sys.argv[1]}))' "$message"
  fi
}

# Commonly used field extractors
get_file_path() {
  extract_field ".tool_input.file_path"
}

get_content() {
  extract_field ".tool_input.content"
}

get_new_string() {
  extract_field ".tool_input.new_string"
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
