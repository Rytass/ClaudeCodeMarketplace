#!/usr/bin/env bash
set -euo pipefail

# Enforce kebab-case file naming for new TypeScript files
# Event: PostToolUse | Matcher: Write | Action: WARN

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

# Skip node_modules/dist/generated
case "$FILE_PATH" in
  */node_modules/*|*/dist/*|*/generated/*) exit 0 ;;
esac

BASENAME=$(basename "$FILE_PATH")
# Remove all extensions to get the stem (e.g., supplier-data.module from supplier-data.module.ts)
STEM="${BASENAME%.*}"
# For .tsx, remove .tsx
case "$BASENAME" in
  *.tsx) STEM="${BASENAME%.tsx}" ;;
  *.ts) STEM="${BASENAME%.ts}" ;;
esac

# Allow Next.js conventions
case "$STEM" in
  page|layout|loading|error|not-found|template|default|middleware|route|global-error) exit 0 ;;
esac

# Allow underscore-prefixed files (Next.js private)
case "$STEM" in
  _*) exit 0 ;;
esac

# Allow bracket-wrapped dynamic routes: [slug], [id], [...catchAll], [[...optional]]
case "$STEM" in
  \[*\]) exit 0 ;;
esac

# Validate kebab-case: each dot-separated segment must be kebab-case
# e.g., supplier-data.module, order.entity, app.module
VALID=$(echo "$STEM" | python3 -c "
import re, sys
stem = sys.stdin.read().strip()
# Split by dots to get segments
segments = stem.split('.')
pattern = re.compile(r'^[a-z][a-z0-9]*(-[a-z0-9]+)*$')
all_valid = all(pattern.match(seg) for seg in segments)
print('valid' if all_valid else 'invalid')
" 2>/dev/null || echo "valid")

if [ "$VALID" = "invalid" ]; then
  echo "WARNING: File name '${BASENAME}' does not follow kebab-case convention."
  echo "Expected pattern: kebab-case segments separated by dots (e.g., my-feature.module.ts)"
fi

exit 0
