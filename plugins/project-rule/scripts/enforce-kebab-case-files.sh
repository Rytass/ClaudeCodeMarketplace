#!/usr/bin/env bash
set -euo pipefail

# Enforce kebab-case file naming for new TypeScript files
# Event: PostToolUse | Matcher: Write | Action: WARN

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
# Whole-stem match, so an empty segment (foo., .foo, foo..bar) is invalid too
KEBAB_STEM='^[a-z][a-z0-9]*(-[a-z0-9]+)*(\.[a-z][a-z0-9]*(-[a-z0-9]+)*)*$'
VALID="valid"
if ! [[ "$STEM" =~ $KEBAB_STEM ]]; then
  VALID="invalid"
fi

if [ "$VALID" = "invalid" ]; then
  emit_context "WARNING: File name '${BASENAME}' does not follow kebab-case convention.
Expected pattern: kebab-case segments separated by dots (e.g., my-feature.module.ts)"
fi

exit 0
