#!/usr/bin/env bash
set -euo pipefail

# Verify deployment completed successfully
# Event: SubagentStop | Matcher: prototype-deployer | Action: VERIFY

# Simple verification — check if git remote exists (GitHub push) or out/ exists (CF Pages)
PROTO_DIR=""

for dir in */; do
  if [ -f "${dir}package.json" ]; then
    if grep -q 'mezzanine-ui' "${dir}package.json" 2>/dev/null; then
      PROTO_DIR="${dir%/}"
    fi
  fi
done

if [ -z "$PROTO_DIR" ]; then
  echo "⚠️ ProtoForge: 找不到 prototype 目錄，無法驗證部署狀態。"
  exit 0
fi

RESULTS=""

# Check GitHub push
if [ -d "$PROTO_DIR/.git" ]; then
  REMOTE=$(cd "$PROTO_DIR" && git remote get-url origin 2>/dev/null || echo "")
  if [ -n "$REMOTE" ]; then
    RESULTS="${RESULTS}\n  ✅ GitHub: $REMOTE"
  fi
fi

# Check build output (for CF Pages)
if [ -d "$PROTO_DIR/out" ]; then
  FILE_COUNT=$(find "$PROTO_DIR/out" -name '*.html' 2>/dev/null | wc -l | tr -d ' ')
  RESULTS="${RESULTS}\n  ✅ Build output: $PROTO_DIR/out/ ($FILE_COUNT HTML files)"
fi

if [ -n "$RESULTS" ]; then
  echo -e "📦 ProtoForge 部署驗證：${RESULTS}"
else
  echo "⚠️ ProtoForge: 未偵測到部署成果。請確認部署步驟是否完成。"
fi

exit 0
