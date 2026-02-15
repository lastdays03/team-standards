#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <target-repo-path> <project-name>"
  exit 1
fi

TARGET_DIR="$1"
PROJECT_NAME="$2"
TEMPLATE_ROOT="$(cd "$(dirname "$0")/.." && pwd)/templates"
TODAY="$(date +%F)"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Target repo path does not exist: $TARGET_DIR"
  exit 1
fi

mkdir -p "$TARGET_DIR/docs/context"

copy_and_render() {
  local src="$1"
  local dst="$2"
  sed \
    -e "s/__PROJECT_NAME__/${PROJECT_NAME//\//-}/g" \
    -e "s/__DATE__/$TODAY/g" \
    "$src" > "$dst"
}

copy_and_render "$TEMPLATE_ROOT/AGENTS.template.md" "$TARGET_DIR/AGENTS.md"
copy_and_render "$TEMPLATE_ROOT/docs/context/README.md" "$TARGET_DIR/docs/context/README.md"
copy_and_render "$TEMPLATE_ROOT/docs/context/ops-rules.md" "$TARGET_DIR/docs/context/ops-rules.md"
copy_and_render "$TEMPLATE_ROOT/docs/context/dev-status.md" "$TARGET_DIR/docs/context/dev-status.md"
copy_and_render "$TEMPLATE_ROOT/docs/context/decisions.md" "$TARGET_DIR/docs/context/decisions.md"
copy_and_render "$TEMPLATE_ROOT/docs/context/handoff.md" "$TARGET_DIR/docs/context/handoff.md"

echo "Applied standards to: $TARGET_DIR"
echo "Generated files:"
echo "- AGENTS.md"
echo "- docs/context/README.md"
echo "- docs/context/ops-rules.md"
echo "- docs/context/dev-status.md"
echo "- docs/context/decisions.md"
echo "- docs/context/handoff.md"
