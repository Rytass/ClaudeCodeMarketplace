#!/usr/bin/env bash
# PreToolUse hook: Remind Claude to prefer gws CLI over Chrome browser
# for Google Workspace URLs. Soft reminder (exit 0) — does not block.

set -euo pipefail

INPUT="$(cat)"

# Extract all string values from toolInput and check for Google Workspace URLs
MATCHED_URL=$(echo "$INPUT" | python3 -c "
import sys, json, re

def extract_strings(obj):
    if isinstance(obj, str):
        yield obj
    elif isinstance(obj, dict):
        for v in obj.values():
            yield from extract_strings(v)
    elif isinstance(obj, list):
        for v in obj:
            yield from extract_strings(v)

GWS_PATTERN = re.compile(
    r'https?://(?:'
    r'docs\.google\.com/(?:spreadsheets|document|presentation|forms)/d/'
    r'|drive\.google\.com/(?:file/d/|drive/folders/)'
    r'|sheets\.google\.com'
    r'|slides\.google\.com'
    r'|mail\.google\.com'
    r'|calendar\.google\.com'
    r'|meet\.google\.com'
    r'|chat\.google\.com'
    r'|script\.google\.com'
    r'|admin\.google\.com'
    r')'
)

try:
    data = json.load(sys.stdin)
    tool_input = data.get('toolInput', {})
    for s in extract_strings(tool_input):
        m = GWS_PATTERN.search(s)
        if m:
            print(s)
            sys.exit(0)
except Exception:
    pass
" 2>/dev/null <<< "$INPUT") || true

if [ -n "$MATCHED_URL" ]; then
  cat <<'MSG'
⚠️ Google Workspace URL detected. The `gws` CLI can handle this operation directly without browser automation.

Prefer using the `gws` CLI (via the "operating-google-workspace-cli" skill) unless the user explicitly requested visual browser interaction.

Extract the file ID from the URL and use the appropriate gws command:
- spreadsheets/d/{ID} → gws sheets spreadsheets ...
- document/d/{ID} → gws docs documents ...
- presentation/d/{ID} → gws slides presentations ...
- forms/d/{ID} → gws forms forms ...
- file/d/{ID} → gws drive files ...
- drive/folders/{ID} → gws drive files list (with parent filter)
MSG
fi

exit 0
