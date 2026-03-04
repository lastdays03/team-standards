#!/usr/bin/env bash
set -euo pipefail

# install-claude-env.sh
#
# 기존 프로젝트에 Claude Code 개발환경 설정만 설치한다.
# 소스코드(backend/frontend)는 복사하지 않는다.
#
# Usage:
#   install-claude-env.sh                    # 현재 폴더에 설치
#   install-claude-env.sh <target-path>      # 지정 폴더에 설치
#
# 원격 설치:
#   curl -fsSL https://raw.githubusercontent.com/lastdays03/team-standards/main/scripts/install-claude-env.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/lastdays03/team-standards/main/scripts/install-claude-env.sh | bash -s -- ~/my-project

TARGET_DIR="${1:-$PWD}"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Error: target path does not exist: $TARGET_DIR"
  exit 1
fi

# --- 원본 소스 확보 ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# 스크립트가 repo 안에서 실행된 경우
if [[ -d "$REPO_ROOT/.claude" ]]; then
  SRC_DIR="$REPO_ROOT"
else
  # curl 파이프 등 원격 실행 — 임시로 clone
  TMP_DIR="$(mktemp -d)"
  cleanup() { rm -rf "$TMP_DIR"; }
  trap cleanup EXIT

  REPO="lastdays03/team-standards"
  REF="main"
  ARCHIVE_URL="https://codeload.github.com/${REPO}/tar.gz/${REF}"

  echo "Downloading from ${REPO}@${REF}..."
  curl -fsSL "$ARCHIVE_URL" -o "$TMP_DIR/archive.tar.gz"
  tar -xzf "$TMP_DIR/archive.tar.gz" -C "$TMP_DIR"
  SRC_DIR="$(find "$TMP_DIR" -maxdepth 1 -type d -name 'team-standards-*' | head -n 1)"

  if [[ -z "$SRC_DIR" ]]; then
    echo "Error: failed to extract archive"
    exit 1
  fi
fi

# --- 복사 대상 ---
# .claude/ (agents, commands, hooks, skills, settings)
echo "Installing .claude/..."
rm -rf "$TARGET_DIR/.claude"
cp -R "$SRC_DIR/.claude" "$TARGET_DIR/.claude"

# hooks 의존성 설치
if [[ -f "$TARGET_DIR/.claude/hooks/package.json" ]]; then
  echo "Installing hooks dependencies..."
  (cd "$TARGET_DIR/.claude/hooks" && npm install --silent 2>/dev/null) || true
fi

# CLAUDE.md (있으면 백업)
if [[ -f "$TARGET_DIR/CLAUDE.md" ]]; then
  echo "Backing up existing CLAUDE.md → CLAUDE.md.bak"
  cp "$TARGET_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md.bak"
fi
cp "$SRC_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"

# CLAUDE_INTEGRATION_GUIDE.md
cp "$SRC_DIR/CLAUDE_INTEGRATION_GUIDE.md" "$TARGET_DIR/CLAUDE_INTEGRATION_GUIDE.md"

# --- 결과 ---
echo ""
echo "Done! Claude Code environment installed to: $TARGET_DIR"
echo ""
echo "Installed:"
echo "  .claude/agents/      (12 agents)"
echo "  .claude/commands/    (3 commands)"
echo "  .claude/hooks/       (7 hooks)"
echo "  .claude/skills/      (20+ skills)"
echo "  .claude/settings.json"
echo "  CLAUDE.md"
echo "  CLAUDE_INTEGRATION_GUIDE.md"
echo ""
echo "Next steps:"
echo "  1. CLAUDE.md를 프로젝트 기술 스택에 맞게 수정"
echo "  2. .claude/skills/skill-rules.json에서 불필요한 스킬 비활성화"
