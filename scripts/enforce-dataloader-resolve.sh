#!/usr/bin/env bash
set -euo pipefail

# Detect @ResolveField using repository.find instead of DataLoader
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

# Only check resolver files
case "$FILE_PATH" in
  *.resolver.ts|*.queries.ts|*.mutations.ts) ;;
  *) exit 0 ;;
esac

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

HAS_RESOLVE_FIELD=$(grep -c '@ResolveField' "$FILE_PATH" 2>/dev/null) || true
if [ "${HAS_RESOLVE_FIELD:-0}" = "0" ]; then
  exit 0
fi

# Check for repository.find* usage within the file (potential N+1)
VIOLATIONS=$(grep -nE 'repository\.(find|findOne|findBy|findOneBy)\b' "$FILE_PATH" 2>/dev/null | head -5 || true)

if [ -n "$VIOLATIONS" ]; then
  echo "WARNING: Potential N+1 query in $(basename "$FILE_PATH"):"
  echo "$VIOLATIONS"
  echo ""
  echo "@ResolveField should use DataLoader instead of direct repository queries."
  echo "See architecting-nestjs DATALOADER skill for the pattern."
fi

exit 0
