#!/usr/bin/env bash
set -euo pipefail

# Ensure .entity.ts files with @Entity also have @ObjectType and Symbol export
# Event: PostToolUse | Matcher: Write|Edit | Action: WARN

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    print(data.get('toolInput', {}).get('file_path', ''))
except:
    print('')
" 2>/dev/null || echo "")

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
  echo "WARNING: Entity file $(basename "$FILE_PATH") is incomplete:"
  echo -e "$WARNINGS"
  echo "See architecting-nestjs skill for Entity-as-ObjectType pattern."
fi

exit 0
