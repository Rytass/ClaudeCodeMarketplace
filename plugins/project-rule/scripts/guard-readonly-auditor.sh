#!/usr/bin/env bash
set -euo pipefail

# Guard: pattern-auditor agent can only use read-only tools (Glob, Grep, Read)
# Event: PreToolUse | Matcher: Bash|Write|Edit | Action: BLOCK

INPUT=$(cat)

AGENT_NAME=$(echo "$INPUT" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    print(data.get('agentName', ''))
except:
    print('')
" 2>/dev/null || echo "")

# Only enforce for pattern-auditor agent
if [ "$AGENT_NAME" != "pattern-auditor" ]; then
  exit 0
fi

# If we get here, pattern-auditor is trying to use Bash/Write/Edit — block it
TOOL_NAME=$(echo "$INPUT" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    print(data.get('toolName', 'unknown'))
except:
    print('unknown')
" 2>/dev/null || echo "unknown")

echo "BLOCKED: pattern-auditor agent is read-only and cannot use $TOOL_NAME. Only Glob, Grep, and Read are permitted."
exit 2
