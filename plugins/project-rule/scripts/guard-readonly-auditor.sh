#!/usr/bin/env bash
set -euo pipefail

# Guard: pattern-auditor agent can only use read-only tools (Glob, Grep, Read)
# Event: PreToolUse | Matcher: Bash|Write|Edit | Action: BLOCK

source "$(dirname "$0")/_lib.sh"

AGENT_TYPE=$(hook_field agent_type)

# Only enforce for this plugin's pattern-auditor agent.
# Plugin agents are reported namespaced (project-rule:pattern-auditor); the bare
# name covers a copy installed as a standalone agent. Other plugins' agents that
# happen to share the name are not ours to restrict.
case "$AGENT_TYPE" in
  project-rule:pattern-auditor|pattern-auditor) ;;
  *) exit 0 ;;
esac

# If we get here, pattern-auditor is trying to use Bash/Write/Edit — block it
TOOL_NAME=$(hook_field tool_name)

echo "BLOCKED: pattern-auditor agent is read-only and cannot use ${TOOL_NAME:-unknown}. Only Glob, Grep, and Read are permitted." >&2
exit 2
