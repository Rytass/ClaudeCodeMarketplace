#!/usr/bin/env bash
set -euo pipefail

# Enforce mezzanine-ui component usage in .tsx files — block raw HTML form/table elements
# Event: PostToolUse | Matcher: Write|Edit | Action: SOFT REMIND

source "$(dirname "$0")/_lib.sh"

FILE_PATH=$(get_file_path)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only check .tsx files
case "$FILE_PATH" in
  *.tsx) ;;
  *) exit 0 ;;
esac

# Skip non-source directories
if is_skip_path "$FILE_PATH"; then
  exit 0
fi

# Skip layout files (they may not have UI elements)
BASENAME=$(basename "$FILE_PATH")
case "$BASENAME" in
  layout.tsx) exit 0 ;;
esac

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Check for raw HTML elements that should be mezzanine-ui components
VIOLATIONS=""

# Raw <input> (should be Input wrapped in FormField)
if grep -qE '<input[^A-Z]' "$FILE_PATH" 2>/dev/null; then
  VIOLATIONS="${VIOLATIONS}\n  - <input> → 使用 FormField + Input (@mezzanine-ui/react)，以手動 register() 綁定 react-hook-form"
fi

# Raw <button> (should be Button from @mezzanine-ui/react)
if grep -qE '<button[^A-Z]' "$FILE_PATH" 2>/dev/null; then
  VIOLATIONS="${VIOLATIONS}\n  - <button> → 使用 Button (@mezzanine-ui/react)"
fi

# Raw <table> (should be Table from @mezzanine-ui/react)
if grep -qE '<table[^A-Z]' "$FILE_PATH" 2>/dev/null; then
  VIOLATIONS="${VIOLATIONS}\n  - <table> → 使用 Table (@mezzanine-ui/react)，內建 actions / pagination / draggable"
fi

# Raw <select> (should be Select from @mezzanine-ui/react)
if grep -qE '<select[^A-Z]' "$FILE_PATH" 2>/dev/null; then
  VIOLATIONS="${VIOLATIONS}\n  - <select> → 使用 FormField + Select (@mezzanine-ui/react)，搭配 useController"
fi

# Raw <textarea> (should be Textarea from @mezzanine-ui/react)
if grep -qE '<textarea[^A-Z]' "$FILE_PATH" 2>/dev/null; then
  VIOLATIONS="${VIOLATIONS}\n  - <textarea> → 使用 FormField + Textarea (@mezzanine-ui/react)，以手動 register() 綁定"
fi

if [ -n "$VIOLATIONS" ]; then
  echo -e "⚠️ ProtoForge: 偵測到原生 HTML 元素。Prototype 應全面使用 mezzanine-ui 元件：${VIOLATIONS}"
fi

exit 0
