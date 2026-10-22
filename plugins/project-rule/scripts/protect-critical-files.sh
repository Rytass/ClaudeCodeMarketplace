#!/usr/bin/env bash
set -euo pipefail

# Protect critical files from being emptied or deleted
# Event: PreToolUse | Matcher: Write|Edit | Action: BLOCK

source "$(dirname "$0")/_lib.sh"

FILE_PATH=$(hook_field tool_input.file_path)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

BASENAME=$(basename "$FILE_PATH")

case "$BASENAME" in
  models.module.ts|app.module.ts|.env|.env.local|.env.production|tsconfig.base.json) ;;
  *) exit 0 ;;
esac

# Edit tool: normal edits are allowed (they modify, not delete)
if [ "$(hook_field tool_name)" != "Write" ]; then
  exit 0
fi

# For Write tool: block if content is empty or whitespace-only
CONTENT=$(hook_field tool_input.content)
if [ -z "${CONTENT//[[:space:]]/}" ]; then
  echo "BLOCKED: Cannot overwrite ${BASENAME} with empty content. This is a critical project file." >&2
  exit 2
fi

exit 0
