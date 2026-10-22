#!/usr/bin/env bash
set -euo pipefail

# Ensure .entity.ts files with @Entity also have @ObjectType and Symbol export
# Event: PostToolUse | Matcher: Write|Edit | Action: WARN

source "$(dirname "$0")/_lib.sh"

FILE_PATH=$(hook_field tool_input.file_path)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only check .entity.ts files
case "$FILE_PATH" in
  *.entity.ts) ;;
  *) exit 0 ;;
esac

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

HAS_ENTITY=$(grep -c '@Entity' "$FILE_PATH" 2>/dev/null) || true
if [ "${HAS_ENTITY:-0}" = "0" ]; then
  exit 0
fi

WARNINGS=""

HAS_OBJECTTYPE=$(grep -c '@ObjectType' "$FILE_PATH" 2>/dev/null) || true
if [ "${HAS_OBJECTTYPE:-0}" = "0" ]; then
  WARNINGS="${WARNINGS}  - Missing @ObjectType() decorator (Entity-as-ObjectType pattern)\n"
fi

HAS_SYMBOL=$(grep -cE 'export\s+const\s+\w+\s*=\s*Symbol\(' "$FILE_PATH" 2>/dev/null) || true
if [ "${HAS_SYMBOL:-0}" = "0" ]; then
  WARNINGS="${WARNINGS}  - Missing Symbol export for ModelsModule injection\n"
fi

if [ -n "$WARNINGS" ]; then
  emit_context "$(echo -e "WARNING: Entity file $(basename "$FILE_PATH") is incomplete:\n${WARNINGS}")
See architecting-nestjs skill for Entity-as-ObjectType pattern."
fi

exit 0
