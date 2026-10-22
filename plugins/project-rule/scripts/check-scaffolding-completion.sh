#!/usr/bin/env bash
set -euo pipefail

# Check if a scaffolding workflow was started but may be incomplete
# Event: Stop | Action: WARN only if scaffolding activity detected
#
# Any model-visible output from a Stop hook makes Claude take another turn, and
# the working tree stays incomplete until the user commits. So this reports each distinct
# missing set once per repository (not per session: a half-done scaffold left in the
# tree would otherwise cost every new session an extra turn), and never while already
# continuing from a Stop hook.

source "$(dirname "$0")/_lib.sh"

if [ "$(hook_field stop_hook_active)" = "true" ]; then
  exit 0
fi

MESSAGE=""

# Changed tracked files plus new untracked ones: a fresh scaffold is all new files
CHANGED_FILES=""
if command -v git &>/dev/null && git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  CHANGED_FILES=$( { git diff --name-only HEAD 2>/dev/null || git diff --name-only 2>/dev/null || true; \
    git ls-files --others --exclude-standard 2>/dev/null || true; } | sort -u)
fi

if [ -z "$CHANGED_FILES" ]; then
  exit 0
fi

# Group files by the entity they belong to, so unrelated edits (app.module.ts next to
# some foo.entity.ts) are not mistaken for one half-finished scaffold. Prints one
# "<entity>\t<missing patterns>" line per entity that has 2+ but not all patterns.
# Usage: report_incomplete nestjs|nextjs
report_incomplete() {
  printf '%s\n' "$CHANGED_FILES" | awk -v kind="$1" '
    function norm(k) {
      k = tolower(k); gsub(/[-_]/, "", k)
      if (k ~ /ies$/) sub(/ies$/, "y", k); else sub(/s$/, "", k)
      return k
    }
    function add(k, p) { if (k != "") { seen[norm(k), p] = 1; keys[norm(k)] = 1 } }
    {
      n = split($0, parts, "/"); b = parts[n]; dir = (n > 1) ? parts[n - 1] : ""
      if (kind == "nestjs") {
        if (b ~ /-data\.service\.ts$/)      { sub(/-data\.service\.ts$/, "", b); add(b, "-data.service.ts") }
        else if (b ~ /-data\.module\.ts$/)  { sub(/-data\.module\.ts$/, "", b);  add(b, "-data.module.ts") }
        else if (b ~ /\.entity\.ts$/)       { sub(/\.entity\.ts$/, "", b);       add(b, ".entity.ts") }
        else if (b ~ /\.dataloader\.ts$/)   { sub(/\.dataloader\.ts$/, "", b);   add(b, ".dataloader.ts") }
        else if (b ~ /\.queries\.ts$/)      { sub(/\.queries\.ts$/, "", b);      add(b, ".queries.ts") }
        else if (b ~ /\.mutations\.ts$/)    { sub(/\.mutations\.ts$/, "", b);    add(b, ".mutations.ts") }
        else if (b ~ /\.resolver\.ts$/)     { sub(/\.resolver\.ts$/, "", b);     add(b, ".resolver.ts") }
        else if (b ~ /\.module\.ts$/)       { sub(/\.module\.ts$/, "", b);       add(b, ".module.ts") }
      } else {
        if (b ~ /\.fragment\.graphql$/)      { sub(/\.fragment\.graphql$/, "", b); sub(/-fields$/, "", b); add(b, ".fragment.graphql") }
        else if (b ~ /\.query\.graphql$/)    { sub(/\.query\.graphql$/, "", b); sub(/^get-/, "", b); add(b, ".query.graphql") }
        else if (b ~ /\.mutation\.graphql$/) { sub(/\.mutation\.graphql$/, "", b); sub(/^(create|update|delete)-/, "", b); add(b, ".mutation.graphql") }
        else if (b == "page.tsx")            { add(dir, "page.tsx") }
        else if (b == "page.module.scss")    { add(dir, "page.module.scss") }
        else if (b ~ /FormModal\.tsx$/)      { sub(/FormModal\.tsx$/, "", b); add(b, "FormModal.tsx") }
        else if (b ~ /Table\.tsx$/)          { sub(/Table\.tsx$/, "", b); add(b, "Table.tsx") }
      }
    }
    END {
      if (kind == "nestjs") np = split(".entity.ts -data.service.ts .dataloader.ts -data.module.ts .queries.ts .mutations.ts .resolver.ts .module.ts", pats, " ")
      else np = split(".fragment.graphql .query.graphql .mutation.graphql page.tsx page.module.scss Table.tsx FormModal.tsx", pats, " ")
      for (k in keys) {
        matched = 0; missing = ""
        for (i = 1; i <= np; i++) {
          if ((k, pats[i]) in seen) matched++
          else missing = missing (missing == "" ? "" : ", ") pats[i]
        }
        if (matched >= 2 && matched < np) printf "%s\t%s\n", k, missing
      }
    }' | sort
}

NESTJS_INCOMPLETE=$(report_incomplete nestjs)
if [ -n "$NESTJS_INCOMPLETE" ]; then
  MESSAGE="${MESSAGE}⚠️ NestJS module scaffolding appears incomplete. Missing per entity:\n$(printf '%s\n' "$NESTJS_INCOMPLETE" | sed 's/^\([^	]*\)	/  - \1: /')\nReview the 11-step workflow in scaffolding-nestjs-module skill.\n\n"
fi

NEXTJS_INCOMPLETE=$(report_incomplete nextjs)
if [ -n "$NEXTJS_INCOMPLETE" ]; then
  MESSAGE="${MESSAGE}⚠️ Next.js page scaffolding appears incomplete. Missing per entity:\n$(printf '%s\n' "$NEXTJS_INCOMPLETE" | sed 's/^\([^	]*\)	/  - \1: /')\nReview the 9-step workflow in scaffolding-nextjs-page skill.\n"
fi

if [ -z "$MESSAGE" ]; then
  exit 0
fi

# Skip if this exact report was already sent for this repository
REPO_KEY=$(git rev-parse --show-toplevel 2>/dev/null | cksum | cut -d' ' -f1)
STATE_FILE="${TMPDIR:-/tmp}/project-rule-scaffold-check-${REPO_KEY}"
REPORT_HASH=$(printf '%s' "$MESSAGE" | cksum | cut -d' ' -f1)
if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE" 2>/dev/null)" = "$REPORT_HASH" ]; then
  exit 0
fi
printf '%s' "$REPORT_HASH" > "$STATE_FILE" 2>/dev/null || true

emit_context "$(echo -e "$MESSAGE")"

exit 0
