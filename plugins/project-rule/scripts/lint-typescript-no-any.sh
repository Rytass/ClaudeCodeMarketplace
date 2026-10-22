#!/usr/bin/env bash
set -euo pipefail

# Detect `any` type usage in TypeScript files
# Event: PostToolUse | Matcher: Write|Edit | Action: WARN

source "$(dirname "$0")/_lib.sh"

FILE_PATH=$(hook_field tool_input.file_path)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only check .ts/.tsx files
case "$FILE_PATH" in
  *.ts|*.tsx) ;;
  *) exit 0 ;;
esac

# Skip generated/dist/node_modules/.d.ts
case "$FILE_PATH" in
  */generated/*|*/dist/*|*/node_modules/*|*.d.ts) exit 0 ;;
esac

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Search for `any` type patterns
VIOLATIONS=$(grep -nE ':\s*any\b|as\s+any\b|<any>' "$FILE_PATH" 2>/dev/null | head -5 || true)

if [ -n "$VIOLATIONS" ]; then
  emit_context "WARNING: TypeScript \`any\` type detected in $(basename "$FILE_PATH"):
$VIOLATIONS

Use specific types instead of \`any\`. See project eslint rules."
fi

exit 0
