#!/usr/bin/env bash
set -euo pipefail

# Check if a scaffolding workflow was started but may be incomplete
# Event: Stop | Action: WARN only if scaffolding activity detected

# Detect recently changed files via git
RECENT_FILES=""
if command -v git &>/dev/null && git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  RECENT_FILES=$(git diff --name-only HEAD 2>/dev/null || git diff --name-only 2>/dev/null || true)
fi

if [ -z "$RECENT_FILES" ]; then
  exit 0
fi

# --- NestJS scaffolding check ---
NESTJS_PATTERNS=(".entity.ts" "-data.service.ts" ".dataloader.ts" "-data.module.ts" ".queries.ts" ".mutations.ts" ".resolver.ts" ".module.ts")
NESTJS_MATCHED=0
NESTJS_MISSING=""

for pattern in "${NESTJS_PATTERNS[@]}"; do
  if echo "$RECENT_FILES" | grep -qF -- "$pattern"; then
    NESTJS_MATCHED=$((NESTJS_MATCHED + 1))
  else
    NESTJS_MISSING="${NESTJS_MISSING}  - ${pattern}\n"
  fi
done

# Only warn if at least 2 NestJS patterns matched (indicates scaffolding was started)
if [ "$NESTJS_MATCHED" -ge 2 ] && [ "$NESTJS_MATCHED" -lt "${#NESTJS_PATTERNS[@]}" ]; then
  echo "⚠️ NestJS module scaffolding appears incomplete. Missing:"
  echo -e "$NESTJS_MISSING"
  echo "Review the 11-step workflow in scaffolding-nestjs-module skill."
  echo ""
fi

# --- Next.js scaffolding check ---
NEXTJS_PATTERNS=(".fragment.graphql" ".query.graphql" ".mutation.graphql" "page.tsx" "page.module.scss" "Table.tsx" "FormModal.tsx")
NEXTJS_MATCHED=0
NEXTJS_MISSING=""

for pattern in "${NEXTJS_PATTERNS[@]}"; do
  if echo "$RECENT_FILES" | grep -qF -- "$pattern"; then
    NEXTJS_MATCHED=$((NEXTJS_MATCHED + 1))
  else
    NEXTJS_MISSING="${NEXTJS_MISSING}  - ${pattern}\n"
  fi
done

# Only warn if at least 2 Next.js patterns matched
if [ "$NEXTJS_MATCHED" -ge 2 ] && [ "$NEXTJS_MATCHED" -lt "${#NEXTJS_PATTERNS[@]}" ]; then
  echo "⚠️ Next.js page scaffolding appears incomplete. Missing:"
  echo -e "$NEXTJS_MISSING"
  echo "Review the 9-step workflow in scaffolding-nextjs-page skill."
fi

exit 0
