#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   bash install.sh
#   bash install.sh <project-name>
#   bash install.sh <target-repo-path> <project-name>
#   bash install.sh <target-repo-path> <project-name> [repo] [ref]
#
# Defaults:
# - target-repo-path: current directory
# - project-name: basename of target-repo-path
# - repo: lastdays03/team-standards
# - ref: main

TARGET_DIR="$PWD"
PROJECT_NAME="$(basename "$TARGET_DIR")"
REPO="lastdays03/team-standards"
REF="main"

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

if [[ $# -ge 3 ]]; then
  REPO="$3"
fi
if [[ $# -ge 4 ]]; then
  REF="$4"
fi

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
