#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: bash install.sh <target-repo-path> <project-name> [repo] [ref]"
  echo "Example: bash install.sh ~/dev/my-new-project my-new-project lastdays03/team-standards main"
  exit 1
fi

TARGET_DIR="$1"
PROJECT_NAME="$2"
REPO="${3:-lastdays03/team-standards}"
REF="${4:-main}"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Target repo path does not exist: $TARGET_DIR"
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required"
  exit 1
fi

if ! command -v tar >/dev/null 2>&1; then
  echo "tar is required"
  exit 1
fi

TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

ARCHIVE_URL="https://codeload.github.com/${REPO}/tar.gz/${REF}"

curl -fsSL "$ARCHIVE_URL" -o "$TMP_DIR/team-standards.tar.gz"
tar -xzf "$TMP_DIR/team-standards.tar.gz" -C "$TMP_DIR"

EXTRACTED_DIR="$(find "$TMP_DIR" -maxdepth 1 -type d -name 'team-standards-*' | head -n 1)"
if [[ -z "$EXTRACTED_DIR" ]]; then
  echo "Failed to extract team-standards archive"
  exit 1
fi

bash "$EXTRACTED_DIR/scripts/apply-standards.sh" "$TARGET_DIR" "$PROJECT_NAME"

echo ""
echo "Installed standards from ${REPO}@${REF}"
