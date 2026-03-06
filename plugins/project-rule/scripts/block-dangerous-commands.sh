#!/usr/bin/env bash
set -euo pipefail

# Block dangerous shell commands
# Event: PreToolUse | Matcher: Bash | Action: BLOCK

INPUT=$(cat)

COMMAND=$(echo "$INPUT" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    print(data.get('toolInput', {}).get('command', ''))
except:
    print('')
" 2>/dev/null || echo "")

# Fail-open if no command found
if [ -z "$COMMAND" ]; then
  exit 0
fi

# Check for dangerous patterns
DANGEROUS_PATTERNS=(
  'rm\s+-r[fe]*\s+/'
  'rm\s+-[fe]*r[fe]*\s+/'
  'DROP\s+DATABASE'
  'DROP\s+SCHEMA'
  'git\s+push\s+.*--force\s+.*\b(main|master)\b'
  'git\s+push\s+.*-f\s+.*\b(main|master)\b'
  'git\s+push\s+--force\s+origin\s+(main|master)'
  'chmod\s+-R\s+777\s+/'
  ':\(\)\s*\{\s*:\|:\s*&\s*\}\s*;'
  'mkfs\.'
  '>\s*/dev/sda'
  'dd\s+if=.*of=/dev/'
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qiE "$pattern"; then
    echo "BLOCKED: Dangerous command detected matching pattern: $pattern"
    echo "Command: $COMMAND"
    exit 2
  fi
done

exit 0
