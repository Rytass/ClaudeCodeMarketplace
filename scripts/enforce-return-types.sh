#!/usr/bin/env bash
set -euo pipefail

# Detect TypeScript functions missing explicit return types
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

# Only check .ts/.tsx files
case "$FILE_PATH" in
  *.ts|*.tsx) ;;
  *) exit 0 ;;
esac

# Skip test and declaration files
case "$FILE_PATH" in
  *.spec.ts|*.test.ts|*.d.ts|*/node_modules/*|*/dist/*|*/generated/*) exit 0 ;;
esac

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Find functions with ) { but missing ): ReturnType {
# Exclude control flow statements (if, for, while, switch, catch)
VIOLATIONS=$(grep -nE '^\s*(export\s+)?(async\s+)?function\s+\w+|^\s*(public|private|protected|static|async)\s+.*\)\s*\{' "$FILE_PATH" 2>/dev/null \
  | grep -vE '^\s*(if|for|while|switch|catch|else)\s*\(' \
  | grep -vE '\)\s*:\s*\S+' \
  | head -5 || true)

if [ -n "$VIOLATIONS" ]; then
  echo "WARNING: Functions missing explicit return types in $(basename "$FILE_PATH"):"
  echo "$VIOLATIONS"
  echo ""
  echo "Every function must declare a return type per project rules."
fi

exit 0
