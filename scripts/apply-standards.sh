#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   apply-standards.sh
#   apply-standards.sh <project-name>
#   apply-standards.sh <target-repo-path> <project-name>
#
# Defaults:
# - target-repo-path: current directory
# - project-name: basename of target-repo-path

TARGET_DIR="$PWD"
PROJECT_NAME="$(basename "$TARGET_DIR")"

if [[ $# -eq 1 ]]; then
  if [[ -d "$1" ]]; then
    TARGET_DIR="$1"
    PROJECT_NAME="$(basename "$TARGET_DIR")"
  else
    PROJECT_NAME="$1"
  fi
elif [[ $# -ge 2 ]]; then
  TARGET_DIR="$1"
  PROJECT_NAME="$2"
fi

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
copy_and_render "$TEMPLATE_ROOT/docs/context/global-rules.md" "$TARGET_DIR/docs/context/global-rules.md"
copy_and_render "$TEMPLATE_ROOT/docs/context/notebooklm-query-templates.md" "$TARGET_DIR/docs/context/notebooklm-query-templates.md"
copy_and_render "$TEMPLATE_ROOT/docs/context/notebooklm-analysis-action-log.md" "$TARGET_DIR/docs/context/notebooklm-analysis-action-log.md"
copy_and_render "$TEMPLATE_ROOT/docs/context/notebooklm-mcp-runbook.md" "$TARGET_DIR/docs/context/notebooklm-mcp-runbook.md"
copy_and_render "$TEMPLATE_ROOT/docs/context/context-memory-validation-log.md" "$TARGET_DIR/docs/context/context-memory-validation-log.md"
copy_and_render "$TEMPLATE_ROOT/docs/context/tooling-defaults.md" "$TARGET_DIR/docs/context/tooling-defaults.md"

echo "Applied standards to: $TARGET_DIR"
echo "Project name: $PROJECT_NAME"
echo "Generated files:"
echo "- AGENTS.md"
echo "- docs/context/global-rules.md"
echo "- docs/context/README.md"
echo "- docs/context/ops-rules.md"
echo "- docs/context/dev-status.md"
echo "- docs/context/decisions.md"
echo "- docs/context/handoff.md"
echo "- docs/context/notebooklm-query-templates.md"
echo "- docs/context/notebooklm-analysis-action-log.md"
echo "- docs/context/notebooklm-mcp-runbook.md"
echo "- docs/context/context-memory-validation-log.md"
echo "- docs/context/tooling-defaults.md"
