#!/usr/bin/env bash
set -euo pipefail

# Ensure @Mutation handlers have @Authenticated() decorator
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

# Only check mutation files
case "$FILE_PATH" in
  *.mutations.ts) ;;
  *) exit 0 ;;
esac

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

MUTATION_COUNT=$(grep -cE '@Mutation\b' "$FILE_PATH" 2>/dev/null) || true
AUTH_COUNT=$(grep -cE '@Authenticated\b|@AllowActions\b|@Public\b' "$FILE_PATH" 2>/dev/null) || true

if [ "$MUTATION_COUNT" -gt 0 ] && [ "$AUTH_COUNT" -lt "$MUTATION_COUNT" ]; then
  echo "WARNING: $(basename "$FILE_PATH") has $MUTATION_COUNT @Mutation(s) but only $AUTH_COUNT auth decorator(s)."
  echo "Every @Mutation should have @Authenticated(), @AllowActions(), or @Public() decorator."
  echo "See setting-up-auth-rbac skill for permission patterns."
fi

exit 0
