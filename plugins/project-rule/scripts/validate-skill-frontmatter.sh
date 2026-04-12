#!/usr/bin/env bash
set -euo pipefail

# Validate SKILL.md frontmatter against official Claude Code specification
# Event: PostToolUse | Matcher: Write|Edit | If: **/SKILL.md | Action: WARN
#
# Checks:
#   1. Frontmatter starts on line 1 with ---
#   2. Frontmatter has closing ---
#   3. description is single-line (no YAML multiline indicators)
#   4. No unrecognized frontmatter fields
#   5. description ≤ 250 characters
#   6. name ≤ 64 characters, lowercase + hyphens only

# --- Extract file path from hook JSON input ---
INPUT=$(cat 2>/dev/null || echo "")
FILE_PATH=$(echo "$INPUT" | jq -r '.toolInput.file_path // ""' 2>/dev/null || echo "")

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# --- Official allowed frontmatter fields (13 total) ---
ALLOWED_FIELDS="name description argument-hint disable-model-invocation user-invocable allowed-tools model effort context agent hooks paths shell"

# --- Parse frontmatter ---
FIRST_LINE=$(head -1 "$FILE_PATH")
if [ "$FIRST_LINE" != "---" ]; then
  echo "🚫 SKILL.md: frontmatter 必須從第 1 行的 \`---\` 開始。目前第 1 行為: '$FIRST_LINE'"
  exit 0
fi

# Find closing --- (skip line 1, find next ---)
CLOSE_LINE=$(tail -n +2 "$FILE_PATH" | grep -n '^---$' | head -1 | cut -d: -f1)
if [ -z "$CLOSE_LINE" ]; then
  echo "🚫 SKILL.md: 缺少結束的 \`---\`。frontmatter 必須以 \`---\` 開始和結束。"
  exit 0
fi

# Extract frontmatter content (between the two ---)
FRONTMATTER=$(sed -n "2,$((CLOSE_LINE))p" "$FILE_PATH")

ERRORS=""
WARNINGS=""

# --- Check 3: description multiline indicator ---
if echo "$FRONTMATTER" | grep -qE '^description:\s*[>|]'; then
  ERRORS="${ERRORS}\n  🚫 description 使用了 YAML multiline indicator（>- 或 |）。description 必須是單行字串，否則 skill indexer 無法正確載入。"
fi

# --- Check 4: unrecognized fields ---
# Extract top-level field names (lines starting with a word followed by colon, not indented)
FIELD_NAMES=$(echo "$FRONTMATTER" | grep -oE '^[a-zA-Z][a-zA-Z0-9_-]*:' | sed 's/:$//')

for field in $FIELD_NAMES; do
  FOUND=false
  for allowed in $ALLOWED_FIELDS; do
    if [ "$field" = "$allowed" ]; then
      FOUND=true
      break
    fi
  done
  if [ "$FOUND" = false ]; then
    WARNINGS="${WARNINGS}\n  ⚠️ 不認識的欄位 \`$field\`。官方允許的欄位: name, description, argument-hint, disable-model-invocation, user-invocable, allowed-tools, model, effort, context, agent, hooks, paths, shell"
  fi
done

# --- Check 5: description length ---
DESC_LINE=$(echo "$FRONTMATTER" | grep -E '^description:' | head -1)
if [ -n "$DESC_LINE" ]; then
  # Remove "description: " prefix and surrounding quotes
  DESC_VALUE=$(echo "$DESC_LINE" | sed 's/^description:[[:space:]]*//' | sed 's/^["'"'"']//' | sed 's/["'"'"']$//')
  DESC_LEN=${#DESC_VALUE}
  if [ "$DESC_LEN" -gt 250 ]; then
    WARNINGS="${WARNINGS}\n  ⚠️ description 長度為 ${DESC_LEN} 字元，超過 250 字元上限。超出部分在 skill listing 中會被截斷。"
  fi
fi

# --- Check 6: name format ---
NAME_LINE=$(echo "$FRONTMATTER" | grep -E '^name:' | head -1)
if [ -n "$NAME_LINE" ]; then
  NAME_VALUE=$(echo "$NAME_LINE" | sed 's/^name:[[:space:]]*//' | sed 's/^["'"'"']//' | sed 's/["'"'"']$//')
  NAME_LEN=${#NAME_VALUE}
  if [ "$NAME_LEN" -gt 64 ]; then
    WARNINGS="${WARNINGS}\n  ⚠️ name 長度為 ${NAME_LEN} 字元，超過 64 字元上限。"
  fi
  if echo "$NAME_VALUE" | grep -qE '[^a-z0-9-]'; then
    WARNINGS="${WARNINGS}\n  ⚠️ name \`$NAME_VALUE\` 包含不合法字元。只能使用小寫字母、數字和連字號 (a-z, 0-9, -)。"
  fi
fi

# --- Output results ---
if [ -n "$ERRORS" ] || [ -n "$WARNINGS" ]; then
  echo -e "📋 SKILL.md frontmatter 檢查結果：${ERRORS}${WARNINGS}"
fi

exit 0
