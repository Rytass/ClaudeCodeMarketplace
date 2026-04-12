#!/usr/bin/env bash
set -euo pipefail

# Enforce TypeScript strict patterns — no `any` type usage
# Event: PostToolUse | Matcher: Write|Edit | Action: SOFT REMIND

source "$(dirname "$0")/_lib.sh"

FILE_PATH=$(get_file_path)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only check .ts and .tsx files
case "$FILE_PATH" in
  *.ts|*.tsx) ;;
  *) exit 0 ;;
esac

if is_skip_path "$FILE_PATH"; then
  exit 0
fi

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

VIOLATIONS=""

# Check for `any` type usage (common patterns)
# Match: `: any`, `as any`, `<any>`, but not words containing "any" like "company", "many"
if grep -qE ':\s*any\b|as\s+any\b|<any>' "$FILE_PATH" 2>/dev/null; then
  VIOLATIONS="${VIOLATIONS}\n  - \`any\` 型別 → 請使用明確的型別或 \`unknown\`"
fi

if [ -n "$VIOLATIONS" ]; then
  echo -e "⚠️ ProtoForge: 偵測到 TypeScript strict 違規：${VIOLATIONS}\n\nPrototype 應遵循 TypeScript strict mode，不使用 \`any\` 型別。"
fi

exit 0
