#!/usr/bin/env bash
set -euo pipefail

# Ensure prototype uses mock data only — no real API calls
# Event: PostToolUse | Matcher: Write|Edit | Action: SOFT REMIND

source "$(dirname "$0")/_lib.sh"

FILE_PATH=$(get_file_path)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only check .ts and .tsx files
case "$FILE_PATH" in
  *.ts|*.tsx) ;;
  *) exit 0 ;;
esac

if is_skip_path "$FILE_PATH"; then
  exit 0
fi

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

VIOLATIONS=""

# Check for fetch API
if grep -qE '\bfetch\s*\(' "$FILE_PATH" 2>/dev/null; then
  VIOLATIONS="${VIOLATIONS}\n  - fetch() → 使用 useMock{Entity} hooks 替代"
fi

# Check for axios
if grep -q 'axios' "$FILE_PATH" 2>/dev/null; then
  VIOLATIONS="${VIOLATIONS}\n  - axios → 使用 useMock{Entity} hooks 替代"
fi

# Check for Apollo/GraphQL client
if grep -qE 'useQuery|useMutation|useLazyQuery|gql\`|@apollo' "$FILE_PATH" 2>/dev/null; then
  VIOLATIONS="${VIOLATIONS}\n  - Apollo/GraphQL → 使用 useMock{Entity} hooks 替代"
fi

# Check for SWR
if grep -q 'useSWR' "$FILE_PATH" 2>/dev/null; then
  VIOLATIONS="${VIOLATIONS}\n  - useSWR → 使用 useMock{Entity} hooks 替代"
fi

# Check for react-query / tanstack
if grep -qE '@tanstack/react-query|from.*react-query' "$FILE_PATH" 2>/dev/null; then
  VIOLATIONS="${VIOLATIONS}\n  - react-query → 使用 useMock{Entity} hooks 替代"
fi

if [ -n "$VIOLATIONS" ]; then
  echo -e "⚠️ ProtoForge: Prototype 不應使用真實 API 呼叫。請改用 mock data hooks：${VIOLATIONS}\n\n參考 MOCK_DATA.md 了解 mock data hook 的寫法。"
fi

exit 0
