#!/usr/bin/env bash
set -euo pipefail

# Block imports of deprecated Mezzanine-UI companion packages.
# The admin prototype must compose @mezzanine-ui/react primitives directly.
# Event: PostToolUse | Matcher: Write|Edit | Action: HARD BLOCK

source "$(dirname "$0")/_lib.sh"

FILE_PATH=$(get_file_path)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

case "$FILE_PATH" in
  *.tsx|*.ts) ;;
  *) exit 0 ;;
esac

if is_skip_path "$FILE_PATH"; then
  exit 0
fi

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

VIOLATIONS=""

# Deprecated admin-components wrapper — removed, use @mezzanine-ui/react primitives
if grep -qE "from ['\"]mezzanine-ui-admin-components['\"]" "$FILE_PATH" 2>/dev/null; then
  VIOLATIONS="${VIOLATIONS}\n  - 偵測到已棄用的 admin-components 封裝套件 → 改用 @mezzanine-ui/react 的 Navigation / Layout / PageHeader / Table"
fi

# Deprecated react-hook-form field-wrapper pack — removed, use FormField + primitives + manual register
if grep -qE "from ['\"]@mezzanine-ui/react-hook-form-v2['\"]" "$FILE_PATH" 2>/dev/null; then
  VIOLATIONS="${VIOLATIONS}\n  - 偵測到已棄用的 react-hook-form 欄位封裝套件 → 改用 FormField + Input/Select/Textarea/... + 手動 register() (見 plugin:project-rule:scaffolding-nextjs-page → FORM_MODAL_TEMPLATE.md)"
fi

if [ -n "$VIOLATIONS" ]; then
  echo -e "⛔ ProtoForge: 偵測到已棄用的 Mezzanine-UI 配套套件，不相容於當前 @mezzanine-ui/react：${VIOLATIONS}\n\n請參考 plugin:project-rule:using-mezzanine-ui 與 plugins/protoforge/skills/protoforge/references/ 下的最新模板。" >&2
  exit 2
fi

exit 0
