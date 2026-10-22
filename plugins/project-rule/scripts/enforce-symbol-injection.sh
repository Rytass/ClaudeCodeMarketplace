#!/usr/bin/env bash
set -euo pipefail

# Detect string-based @Inject() — should use Symbol injection instead
# Event: PostToolUse | Matcher: Write|Edit | Action: WARN

source "$(dirname "$0")/_lib.sh"

FILE_PATH=$(hook_field tool_input.file_path)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only check service and module files
case "$FILE_PATH" in
  *.service.ts|*.module.ts) ;;
  *) exit 0 ;;
esac

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Detect @Inject('...') or @Inject("...")
VIOLATIONS=$(grep -nE "@Inject\s*\(\s*['\"]" "$FILE_PATH" 2>/dev/null | head -5 || true)

if [ -n "$VIOLATIONS" ]; then
  emit_context "WARNING: String-based @Inject() detected in $(basename "$FILE_PATH"):
$VIOLATIONS

Use Symbol injection instead: @Inject(MY_SYMBOL) with export const MY_SYMBOL = Symbol('...')"
fi

exit 0
