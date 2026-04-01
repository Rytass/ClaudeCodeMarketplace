#!/usr/bin/env bash
set -euo pipefail

# Verify Next.js page scaffolder produced complete file set
# Event: SubagentStop | Matcher: nextjs-page-scaffolder | Action: WARN

INPUT=$(cat)

# Check recently created files
RECENT_FILES=""
if command -v git &>/dev/null && git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  RECENT_FILES=$(git diff --name-only HEAD 2>/dev/null || git diff --name-only 2>/dev/null || true)
fi

if [ -z "$RECENT_FILES" ]; then
  RECENT_FILES=$(find . -name '*.ts' -o -name '*.tsx' -o -name '*.graphql' -o -name '*.scss' -mmin -10 -not -path '*/node_modules/*' -not -path '*/dist/*' 2>/dev/null || true)
fi

if [ -z "$RECENT_FILES" ]; then
  echo "WARNING: No recently created files detected. Next.js scaffolding may not have run."
  exit 0
fi

MISSING=""
REQUIRED_PATTERNS=(
  ".fragment.graphql:Step 1 - Fragment file"
  ".query.graphql:Step 2 - Query file"
  ".mutation.graphql:Step 3 - Mutation files"
  "page.tsx:Step 5 - Page component"
  "page.module.scss:Step 6 - Page styles"
  "Table.tsx:Step 7 - Table component"
  "FormModal.tsx:Step 8 - Form modal component"
)

for entry in "${REQUIRED_PATTERNS[@]}"; do
  pattern="${entry%%:*}"
  step="${entry#*:}"
  if ! echo "$RECENT_FILES" | grep -qF -- "$pattern"; then
    MISSING="${MISSING}  - ${step} (${pattern})\n"
  fi
done

if [ -n "$MISSING" ]; then
  echo "WARNING: Next.js page scaffolding appears incomplete. Missing files:"
  echo -e "$MISSING"
  echo "Review the 9-step scaffolding workflow in scaffolding-nextjs-page skill."
fi

exit 0
