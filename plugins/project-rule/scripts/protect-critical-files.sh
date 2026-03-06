#!/usr/bin/env bash
set -euo pipefail

# Protect critical files from being emptied or deleted
# Event: PreToolUse | Matcher: Write|Edit | Action: BLOCK

INPUT=$(cat)

# Parse all needed fields in a single python3 call
# Output format: EXIT_CODE (0=allow, 2=block)
# If block, also outputs a message on stderr-like second line
RESULT=$(echo "$INPUT" | python3 -c "
import json, sys

try:
    data = json.load(sys.stdin)
except:
    print('0')
    sys.exit(0)

tool_input = data.get('toolInput', {})
file_path = tool_input.get('file_path', '')
tool_name = data.get('toolName', '')

if not file_path:
    print('0')
    sys.exit(0)

import os
basename = os.path.basename(file_path)

protected = [
    'models.module.ts',
    'app.module.ts',
    '.env',
    '.env.local',
    '.env.production',
    'tsconfig.base.json',
]

if basename not in protected:
    print('0')
    sys.exit(0)

# For Write tool: block if content is empty or whitespace-only
if tool_name == 'Write':
    content = tool_input.get('content', '')
    if not content or not content.strip():
        print('2')
        print(f'BLOCKED: Cannot overwrite {basename} with empty content. This is a critical project file.')
        sys.exit(0)

# Edit tool: normal edits are allowed (they modify, not delete)
print('0')
" 2>/dev/null || echo "0")

EXIT_CODE=$(echo "$RESULT" | head -1)
MESSAGE=$(echo "$RESULT" | tail -n +2)

if [ "$EXIT_CODE" = "2" ]; then
  echo "$MESSAGE"
  exit 2
fi

exit 0
