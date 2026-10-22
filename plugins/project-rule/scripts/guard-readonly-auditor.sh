#!/usr/bin/env bash
set -euo pipefail

# Guard: pattern-auditor agent can only use read-only tools (Glob, Grep, Read)
# Event: PreToolUse | Matcher: Bash|Write|Edit | Action: BLOCK

INPUT=$(cat)

AGENT_NAME=$(echo "$INPUT" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    print(data.get('agent_type', ''))
except:
    print('')
" 2>/dev/null || echo "")

# Only enforce for pattern-auditor agent
# Plugin agents are reported namespaced (project-rule:pattern-auditor)
case "$AGENT_NAME" in
  pattern-auditor|*:pattern-auditor) ;;
  *) exit 0 ;;
esac

# If we get here, pattern-auditor is trying to use Bash/Write/Edit — block it
TOOL_NAME=$(echo "$INPUT" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    print(data.get('tool_name', 'unknown'))
except:
    print('unknown')
" 2>/dev/null || echo "unknown")

echo "BLOCKED: pattern-auditor agent is read-only and cannot use $TOOL_NAME. Only Glob, Grep, and Read are permitted." >&2
exit 2
