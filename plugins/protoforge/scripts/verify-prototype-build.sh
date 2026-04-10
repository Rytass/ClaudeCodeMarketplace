#!/usr/bin/env bash
set -euo pipefail

# Verify that the generated prototype can build successfully
# Event: SubagentStop | Matcher: prototype-generator | Action: VERIFY

# Find the most recently created prototype directory
# Search all subdirectories for package.json containing mezzanine-ui
PROTO_DIR=""

for dir in */; do
  if [ -f "${dir}package.json" ]; then
    if grep -q 'mezzanine-ui' "${dir}package.json" 2>/dev/null; then
      PROTO_DIR="${dir%/}"
    fi
  fi
done

if [ -z "$PROTO_DIR" ]; then
  echo "⚠️ ProtoForge: 找不到生成的 prototype 目錄。請確認 prototype-generator agent 已完成生成。"
  exit 0
fi

# Check if node_modules exists (npm install was run)
if [ ! -d "$PROTO_DIR/node_modules" ]; then
  echo "⚠️ ProtoForge: $PROTO_DIR/node_modules 不存在。請執行 npm install。"
  exit 0
fi

# Check if build output exists
if [ -d "$PROTO_DIR/out" ] || [ -d "$PROTO_DIR/.next" ]; then
  echo "✅ ProtoForge: Prototype build output 已存在於 $PROTO_DIR/"
  exit 0
fi

echo "⚠️ ProtoForge: Prototype 尚未建置。請在 $PROTO_DIR/ 執行 npm run build 驗證。"
exit 0
