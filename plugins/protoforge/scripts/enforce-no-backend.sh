#!/usr/bin/env bash
set -euo pipefail

# Block creation of backend/API files in prototype projects
# Event: PreToolUse | Matcher: Write|Edit | Action: BLOCK or PASS

source "$(dirname "$0")/_lib.sh"

FILE_PATH=$(get_file_path)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Skip build artifacts
if is_skip_path "$FILE_PATH"; then
  exit 0
fi

# Block API route files
case "$FILE_PATH" in
  */app/api/*.ts|*/app/api/*.tsx|*/pages/api/*.ts|*/pages/api/*.tsx)
    echo "🚫 ProtoForge: Prototype 不應包含 API routes。請使用 mock data hooks 替代。"
    exit 2
    ;;
esac

# Check content being written for 'use server' directive
CONTENT=$(get_content)
NEW_STRING=$(get_new_string)
WRITE_CONTENT="${CONTENT}${NEW_STRING}"

# Match only directive-position 'use server' (start of line, ignoring whitespace)
# Avoids false positives on comments like "// don't use 'use server'"
if echo "$WRITE_CONTENT" | grep -qE "^[[:space:]]*['\"]use server['\"]" 2>/dev/null; then
  echo "🚫 ProtoForge: Prototype 不應使用 server actions ('use server')。請使用 mock data hooks 替代。"
  exit 2
fi

exit 0
