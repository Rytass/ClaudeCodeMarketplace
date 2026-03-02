#!/usr/bin/env bash
set -euo pipefail

# Detect string-based @Inject() — should use Symbol injection instead
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
  echo "WARNING: String-based @Inject() detected in $(basename "$FILE_PATH"):"
  echo "$VIOLATIONS"
  echo ""
  echo "Use Symbol injection instead: @Inject(MY_SYMBOL) with export const MY_SYMBOL = Symbol('...')"
fi

exit 0
