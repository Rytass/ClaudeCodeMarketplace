#!/usr/bin/env bash
set -euo pipefail

# Enforce 'use client' directive on all .tsx files under app/ directory
# Event: PostToolUse | Matcher: Write|Edit | Action: SOFT REMIND

source "$(dirname "$0")/_lib.sh"

FILE_PATH=$(get_file_path)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only check .tsx files under app/ directory
case "$FILE_PATH" in
  *.tsx) ;;
  *) exit 0 ;;
esac

case "$FILE_PATH" in
  */app/*) ;;
  *) exit 0 ;;
esac

# Skip non-source directories
if is_skip_path "$FILE_PATH"; then
  exit 0
fi

# Skip server component files (layouts at any nesting level, not-found)
BASENAME=$(basename "$FILE_PATH")
case "$BASENAME" in
  layout.tsx|not-found.tsx) exit 0 ;;
esac

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Check if the file starts with 'use client' (allowing leading whitespace/newlines)
FIRST_CODE_LINE=$(grep -m1 -v '^\s*$' "$FILE_PATH" 2>/dev/null || echo "")

case "$FIRST_CODE_LINE" in
  *"'use client'"*|*'"use client"'*) exit 0 ;;
esac

echo "⚠️ ProtoForge: 此檔案缺少 'use client' 指令。Prototype 中 app/ 下的 .tsx 頁面/元件必須以 'use client' 開頭，否則 Next.js App Router 會將其視為 server component，使用 useState/useCallback 時會 runtime crash。"

exit 0
