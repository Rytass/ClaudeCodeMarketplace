#!/usr/bin/env bash
set -euo pipefail

# Remind Claude to prefer Mezzanine-UI components in frontend .tsx files
# Event: PostToolUse | Matcher: Write|Edit | Action: SOFT REMIND

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

# Only check .tsx files (React component files)
case "$FILE_PATH" in
  *.tsx) ;;
  *) exit 0 ;;
esac

# Skip non-app directories
case "$FILE_PATH" in
  */node_modules/*|*/dist/*|*/generated/*|*/.next/*) exit 0 ;;
esac

# Skip Next.js special files (typically wrappers, not UI-heavy)
BASENAME=$(basename "$FILE_PATH")
STEM="${BASENAME%.tsx}"
case "$STEM" in
  page|layout|loading|error|not-found|template|default|middleware|route|global-error) exit 0 ;;
esac

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Check if file already imports from @mezzanine-ui
HAS_MZN=$(grep -c '@mezzanine-ui/' "$FILE_PATH" 2>/dev/null) || true
if [ "${HAS_MZN:-0}" != "0" ]; then
  exit 0
fi

# Check if file has UI-related patterns (JSX elements that suggest a UI component)
HAS_JSX=$(grep -cE '<[A-Z][a-zA-Z]*' "$FILE_PATH" 2>/dev/null) || true
if [ "${HAS_JSX:-0}" = "0" ]; then
  exit 0
fi

cat <<'MSG'
💡 This .tsx file renders UI but does not import from @mezzanine-ui/*. The project uses the Mezzanine-UI design system — check the "using-mezzanine-ui" skill for available components (Button, TextField, Select, Table, Modal, Form, DatePicker, Typography, Icon, etc.) before using raw HTML elements or third-party UI libraries.
MSG

exit 0
