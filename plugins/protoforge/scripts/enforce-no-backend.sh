#!/usr/bin/env bash
set -euo pipefail

# Block creation of backend/API files in prototype projects
# Event: PreToolUse | Matcher: Write|Edit | Action: BLOCK or PASS

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

# Only check files that look like they're in a prototype project
# (contain proto- or are under a path with mezzanine-ui in package.json)
case "$FILE_PATH" in
  */node_modules/*|*/dist/*|*/.next/*|*/out/*) exit 0 ;;
esac

# Block API route files
case "$FILE_PATH" in
  */app/api/*.ts|*/app/api/*.tsx|*/pages/api/*.ts|*/pages/api/*.tsx)
    echo "🚫 ProtoForge: Prototype 不應包含 API routes。請使用 mock data hooks 替代。"
    exit 2
    ;;
esac

# Block server action patterns (files with 'use server')
if [ -f "$FILE_PATH" ] 2>/dev/null; then
  exit 0
fi

# Check content being written for 'use server' directive
CONTENT=$(echo "$INPUT" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    ti = data.get('toolInput', {})
    print(ti.get('content', '') or ti.get('new_string', ''))
except:
    print('')
" 2>/dev/null || echo "")

if echo "$CONTENT" | grep -q "'use server'" 2>/dev/null; then
  echo "🚫 ProtoForge: Prototype 不應使用 server actions ('use server')。請使用 mock data hooks 替代。"
  exit 2
fi

exit 0
