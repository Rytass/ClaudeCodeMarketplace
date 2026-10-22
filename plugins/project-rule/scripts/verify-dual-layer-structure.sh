#!/usr/bin/env bash
set -euo pipefail

# Verify dual-layer module structure: .module.ts should have a corresponding -data.module.ts
# Event: PostToolUse | Matcher: Write | Action: WARN

source "$(dirname "$0")/_lib.sh"

FILE_PATH=$(hook_field tool_input.file_path)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only check .module.ts files (but not -data.module.ts themselves)
case "$FILE_PATH" in
  *-data.module.ts) exit 0 ;;  # Skip data modules themselves
  *.module.ts) ;;
  *) exit 0 ;;
esac

# Skip known standalone modules that don't need dual-layer
BASENAME=$(basename "$FILE_PATH")
case "$BASENAME" in
  app.module.ts|models.module.ts) exit 0 ;;
esac

# Check if corresponding -data.module.ts exists in same directory
DIR=$(dirname "$FILE_PATH")
MODULE_NAME="${BASENAME%.module.ts}"
DATA_MODULE="${DIR}/${MODULE_NAME}-data.module.ts"

if [ ! -f "$DATA_MODULE" ]; then
  emit_context "WARNING: Module $(basename "$FILE_PATH") created without corresponding data module.
Expected: ${MODULE_NAME}-data.module.ts in the same directory.
NestJS dual-layer architecture requires both a feature module and a data module.
See architecting-nestjs DUAL_LAYER skill."
fi

exit 0
