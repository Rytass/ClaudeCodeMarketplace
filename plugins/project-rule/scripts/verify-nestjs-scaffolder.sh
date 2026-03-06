#!/usr/bin/env bash
set -euo pipefail

# Verify NestJS module scaffolder produced complete file set
# Event: SubagentStop | Matcher: nestjs-module-scaffolder | Action: WARN

INPUT=$(cat)

# For SubagentStop, we check recently created files
# Try git diff first, fall back to find
RECENT_FILES=""
if command -v git &>/dev/null && git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  RECENT_FILES=$(git diff --name-only HEAD 2>/dev/null || git diff --name-only 2>/dev/null || true)
fi

if [ -z "$RECENT_FILES" ]; then
  RECENT_FILES=$(find . -name '*.ts' -mmin -10 -not -path '*/node_modules/*' -not -path '*/dist/*' 2>/dev/null || true)
fi

if [ -z "$RECENT_FILES" ]; then
  echo "WARNING: No recently created files detected. NestJS scaffolding may not have run."
  exit 0
fi

MISSING=""
REQUIRED_PATTERNS=(
  ".entity.ts:Step 1 - Entity file"
  "-data.service.ts:Step 5 - Data service"
  ".dataloader.ts:Step 6 - DataLoader"
  "-data.module.ts:Step 7 - Data module"
  ".queries.ts:Step 8 - Queries resolver"
  ".mutations.ts:Step 9 - Mutations resolver"
  ".resolver.ts:Step 10 - Resolver"
  ".module.ts:Step 11 - Feature module"
)

for entry in "${REQUIRED_PATTERNS[@]}"; do
  pattern="${entry%%:*}"
  step="${entry#*:}"
  if ! echo "$RECENT_FILES" | grep -q "$pattern"; then
    MISSING="${MISSING}  - ${step} (${pattern})\n"
  fi
done

if [ -n "$MISSING" ]; then
  echo "WARNING: NestJS module scaffolding appears incomplete. Missing files:"
  echo -e "$MISSING"
  echo "Review the 11-step scaffolding workflow in scaffolding-nestjs-module skill."
fi

exit 0
