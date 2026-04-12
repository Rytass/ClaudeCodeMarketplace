#!/usr/bin/env bash
set -euo pipefail

# Suggest using admin-components wrappers over raw mezzanine-ui components
# Event: PostToolUse | Matcher: Write|Edit | Action: SOFT REMIND

source "$(dirname "$0")/_lib.sh"

FILE_PATH=$(get_file_path)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only check .tsx page files (not _components)
case "$FILE_PATH" in
  *.tsx) ;;
  *) exit 0 ;;
esac

if is_skip_path "$FILE_PATH"; then
  exit 0
fi

case "$FILE_PATH" in
  */_components/*) exit 0 ;;
esac

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

SUGGESTIONS=""

# Using raw Table instead of AdminTable (in page files)
if grep -q "from '@mezzanine-ui/react'" "$FILE_PATH" 2>/dev/null; then
  if grep -qE "import.*\bTable\b.*from '@mezzanine-ui/react'" "$FILE_PATH" 2>/dev/null; then
    if ! grep -q "from 'mezzanine-ui-admin-components'" "$FILE_PATH" 2>/dev/null; then
      SUGGESTIONS="${SUGGESTIONS}\n  - Table → 建議使用 AdminTable (mezzanine-ui-admin-components)，內建 filters、tabs、分頁、行動下拉"
    fi
  fi
fi

# Check if page has Typography h1 but not PageWrapper (custom header instead of PageWrapper)
if grep -qE "variant=['\"]h1['\"]" "$FILE_PATH" 2>/dev/null; then
  if ! grep -q "PageWrapper" "$FILE_PATH" 2>/dev/null; then
    SUGGESTIONS="${SUGGESTIONS}\n  - 頁面標題 → 建議使用 PageWrapper (mezzanine-ui-admin-components)，內建標題 + 新增按鈕"
  fi
fi

if [ -n "$SUGGESTIONS" ]; then
  echo -e "💡 ProtoForge: 建議使用 admin-components 封裝元件以簡化開發：${SUGGESTIONS}"
fi

exit 0
