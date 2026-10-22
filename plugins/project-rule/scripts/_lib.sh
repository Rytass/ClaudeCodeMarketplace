#!/usr/bin/env bash
# Shared helpers for project-rule hook scripts
# Source this file: source "$(dirname "$0")/_lib.sh"
#
# IMPORTANT: This file reads stdin on source. The calling script MUST
# source this BEFORE doing any other stdin reads.
#
# Claude Code hook output contract (verified on Claude Code 2.1.308):
#   - exit 0 + plain stdout is recorded in the transcript only; the model never sees it
#   - exit 0 + JSON hookSpecificOutput.additionalContext reaches the model
#   - exit 2 + stderr blocks the tool call and reaches the model
# So every WARN-level hook must go through emit_context, never a bare echo.
# Plugins are self-contained: protoforge scripts/_lib.sh and the mezzanine-ui style
# guard carry their own copy of these emitters. Change the contract in all three.

HOOK_INPUT=$(cat 2>/dev/null || echo "")

# Pick a JSON tool once. Without one the hook cannot read its input at all,
# so say so to the user instead of silently passing every check.
if command -v python3 >/dev/null 2>&1; then
  HOOK_JSON_TOOL="python3"
elif command -v jq >/dev/null 2>&1; then
  HOOK_JSON_TOOL="jq"
else
  printf '{"systemMessage":"project-rule hook %s did not run: neither python3 nor jq is installed."}\n' \
    "$(basename "$0")"
  exit 0
fi

# Read a dotted path from the hook's JSON input.
# Strings print as-is, booleans as true/false, missing fields as "".
# Usage: FILE_PATH=$(hook_field tool_input.file_path)
hook_field() {
  local path="$1"
  if [ -z "$HOOK_INPUT" ]; then
    echo ""
    return
  fi
  if [ "$HOOK_JSON_TOOL" = "python3" ]; then
    printf '%s' "$HOOK_INPUT" | python3 -c '
import json, sys
try:
    value = json.load(sys.stdin)
    for key in sys.argv[1].split("."):
        value = value.get(key) if isinstance(value, dict) else None
except Exception:
    value = None
if value is None:
    print("")
elif isinstance(value, bool):
    print("true" if value else "false")
elif isinstance(value, str):
    print(value)
else:
    print(json.dumps(value))
' "$path" 2>/dev/null || echo ""
  else
    printf '%s' "$HOOK_INPUT" | jq -r --arg p "$path" \
      'getpath($p | split(".")) | if . == null then "" elif type == "string" then . else tojson end' \
      2>/dev/null || echo ""
  fi
}

# Send a model-visible message for the current hook event (PreToolUse, PostToolUse, Stop).
# Does nothing when the message is empty. Call at most once per hook run.
# Usage: emit_context "$MESSAGE"
emit_context() {
  local message="$1"
  local event
  [ -z "$message" ] && return 0
  event=$(hook_field hook_event_name)
  [ -z "$event" ] && event="PostToolUse"
  if [ "$HOOK_JSON_TOOL" = "python3" ]; then
    python3 -c '
import json, sys
print(json.dumps({"hookSpecificOutput": {"hookEventName": sys.argv[1], "additionalContext": sys.argv[2]}}))
' "$event" "$message"
  else
    jq -cn --arg e "$event" --arg m "$message" \
      '{hookSpecificOutput: {hookEventName: $e, additionalContext: $m}}'
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
  if [ "$HOOK_JSON_TOOL" = "python3" ]; then
    python3 -c 'import json, sys; print(json.dumps({"systemMessage": sys.argv[1]}))' "$message"
  else
    jq -cn --arg m "$message" '{systemMessage: $m}'
  fi
}
