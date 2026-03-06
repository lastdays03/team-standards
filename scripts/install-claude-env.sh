#!/usr/bin/env bash
set -euo pipefail

# install-claude-env.sh
#
# 기존 프로젝트에 Claude Code 개발환경 설정만 설치한다.
# 소스코드(backend/frontend)는 복사하지 않는다.
#
# 설치 동작:
#   .claude/     → 항상 강제 덮어쓰기 (최신 에이전트/스킬/훅 보장)
#   CLAUDE.md    → 기존 있으면 유지, 템플릿은 CLAUDE.example.md로 저장
#   docs/ README → 항상 최신 템플릿으로 덮어쓰기
#   docs/context → 클린 템플릿으로 초기화
#
# Usage:
#   install-claude-env.sh                    # 현재 폴더에 설치
#   install-claude-env.sh <target-path>      # 지정 폴더에 설치
#   install-claude-env.sh --dry-run          # 실제 복사 없이 미리보기
#   install-claude-env.sh --dry-run ~/proj   # 특정 경로 dry-run
#   install-claude-env.sh --reset-context    # context 파일도 클린 템플릿으로 초기화
#
# 원격 설치:
#   curl -fsSL https://raw.githubusercontent.com/lastdays03/team-standards/main/scripts/install-claude-env.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/lastdays03/team-standards/main/scripts/install-claude-env.sh | bash -s -- ~/my-project

# --- 색상 ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${CYAN}[INFO]${NC} $*"; }
ok()    { echo -e "${GREEN}  OK${NC}   $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
fail()  { echo -e "${RED}[FAIL]${NC} $*"; }

# --- 인자 파싱 ---
DRY_RUN=false
RESET_CONTEXT=false
TARGET_DIR="$PWD"

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --reset-context) RESET_CONTEXT=true ;;
    -*) fail "Unknown option: $arg"; exit 1 ;;
    *) TARGET_DIR="$arg" ;;
  esac
done

if [[ ! -d "$TARGET_DIR" ]]; then
  fail "Target path does not exist: $TARGET_DIR"
  exit 1
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

# --- 의존성 검사 ---
check_deps() {
  local missing=()
  command -v curl &>/dev/null || missing+=("curl")
  command -v tar &>/dev/null  || missing+=("tar")

  if [[ ${#missing[@]} -gt 0 ]]; then
    fail "Required tools not found: ${missing[*]}"
    exit 1
  fi

  if ! command -v node &>/dev/null; then
    warn "node not found — hooks 의존성 설치가 건너뛰어집니다"
    warn "훅을 사용하려면 Node.js 18+ 설치 후 cd .claude/hooks && npm install"
  fi
}

# --- 원본 소스 확보 ---
resolve_source() {
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "")"

  if [[ -n "$SCRIPT_DIR" ]] && [[ -d "$SCRIPT_DIR/../.claude" ]]; then
    SRC_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
    info "Using local source: $SRC_DIR"
    return
  fi

  TMP_DIR="$(mktemp -d)"
  cleanup() { rm -rf "$TMP_DIR"; }
  trap cleanup EXIT

  REPO="lastdays03/team-standards"
  REF="main"
  ARCHIVE_URL="https://codeload.github.com/${REPO}/tar.gz/${REF}"

  info "Downloading from ${REPO}@${REF}..."
  curl -fsSL "$ARCHIVE_URL" -o "$TMP_DIR/archive.tar.gz"
  tar -xzf "$TMP_DIR/archive.tar.gz" -C "$TMP_DIR"
  SRC_DIR="$(find "$TMP_DIR" -maxdepth 1 -type d -name 'team-standards-*' | head -n 1)"

  if [[ -z "$SRC_DIR" ]]; then
    fail "Failed to extract archive"
    exit 1
  fi
}

# --- 설치 ---
install_claude_env() {
  echo ""
  echo -e "${BOLD}Installing Claude Code environment to: $TARGET_DIR${NC}"
  echo ""

  # ━━━ 1. .claude/ — 항상 강제 덮어쓰기 ━━━
  info ".claude/ (강제 덮어쓰기)"
  rm -rf "$TARGET_DIR/.claude"
  cp -R "$SRC_DIR/.claude" "$TARGET_DIR/.claude"
  # settings.local.json은 개인 설정이므로 배포하지 않음
  rm -f "$TARGET_DIR/.claude/settings.local.json"
  ok ".claude/ — agents(11), commands(3), hooks(6), skills(14+), settings"

  # hooks 의존성
  if [[ -f "$TARGET_DIR/.claude/hooks/package.json" ]] && command -v npm &>/dev/null; then
    info "Installing hooks dependencies..."
    if (cd "$TARGET_DIR/.claude/hooks" && npm install --silent 2>/dev/null); then
      ok "hooks dependencies"
    else
      warn "hooks npm install failed — 수동 설치 필요: cd .claude/hooks && npm install"
    fi
  fi

  # ━━━ 2. CLAUDE.md — 기존 유지, 템플릿은 .example로 ━━━
  if [[ -f "$TARGET_DIR/CLAUDE.md" ]]; then
    cp "$SRC_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.example.md"
    ok "CLAUDE.example.md (템플릿 저장, 기존 CLAUDE.md 유지)"
  else
    cp "$SRC_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
    ok "CLAUDE.md"
  fi

  # CLAUDE_INTEGRATION_GUIDE.md — 항상 최신으로
  cp "$SRC_DIR/CLAUDE_INTEGRATION_GUIDE.md" "$TARGET_DIR/CLAUDE_INTEGRATION_GUIDE.md"
  ok "CLAUDE_INTEGRATION_GUIDE.md"

  # ━━━ 3. docs/ — 폴더 구조 생성 + README 덮어쓰기 ━━━
  info "docs/ structure"
  local docs_dirs=(
    "docs/context"
    "docs/plans/active"
    "docs/plans/reports"
    "docs/plans/done"
    "docs/architecture"
    "docs/operations"
    "docs/dev-guide"
    "docs/archive"
  )

  for dir in "${docs_dirs[@]}"; do
    mkdir -p "$TARGET_DIR/$dir"
  done

  # .gitkeep (빈 디렉토리 git 추적용)
  for dir in "docs/plans/active" "docs/plans/reports" "docs/plans/done"; do
    touch "$TARGET_DIR/$dir/.gitkeep"
  done

  # README.md — 항상 최신 템플릿으로 덮어쓰기
  local readme_sources=(
    "docs/README.md"
    "docs/context/README.md"
    "docs/plans/README.md"
    "docs/architecture/README.md"
    "docs/operations/README.md"
    "docs/dev-guide/README.md"
    "docs/archive/README.md"
  )

  for readme in "${readme_sources[@]}"; do
    if [[ -f "$SRC_DIR/$readme" ]]; then
      cp "$SRC_DIR/$readme" "$TARGET_DIR/$readme"
    fi
  done
  ok "docs/ — 8 folders + READMEs (덮어쓰기, plans/README.md 포함)"

  # ━━━ 4. docs/context/ — 없으면 생성, 있으면 보존 ━━━
  local template_dir="$SRC_DIR/scripts/templates/context"
  local context_files=("dev-status.md" "decisions.md" "handoff.md" "ops-rules.md")

  if [[ "$RESET_CONTEXT" == true ]]; then
    info "docs/context/ (--reset-context: 클린 템플릿으로 초기화)"
    for cf in "${context_files[@]}"; do
      if [[ -f "$template_dir/$cf" ]]; then
        cp "$template_dir/$cf" "$TARGET_DIR/docs/context/$cf"
      fi
    done
    ok "docs/context/ — 4개 파일 클린 템플릿으로 초기화됨"
  else
    local created=0
    local preserved=0
    for cf in "${context_files[@]}"; do
      if [[ -f "$TARGET_DIR/docs/context/$cf" ]]; then
        preserved=$((preserved + 1))
      elif [[ -f "$template_dir/$cf" ]]; then
        cp "$template_dir/$cf" "$TARGET_DIR/docs/context/$cf"
        created=$((created + 1))
      fi
    done
    if [[ $preserved -gt 0 ]]; then
      ok "docs/context/ — ${created}개 생성, ${preserved}개 기존 유지"
    else
      ok "docs/context/ — ${created}개 클린 템플릿으로 생성"
    fi
  fi
}

# --- 설치 후 검증 ---
verify_installation() {
  echo ""
  info "Verifying installation..."

  local errors=0
  local checks=(
    ".claude/settings.json"
    ".claude/agents/planner.md"
    ".claude/skills/skill-rules.json"
    ".claude/hooks/skill-activation-prompt.sh"
    ".claude/commands/dev-docs.md"
    "CLAUDE_INTEGRATION_GUIDE.md"
    "docs/README.md"
    "docs/context/dev-status.md"
  )

  for check in "${checks[@]}"; do
    if [[ -f "$TARGET_DIR/$check" ]]; then
      ok "$check"
    else
      fail "$check — MISSING"
      errors=$((errors + 1))
    fi
  done

  # CLAUDE.md 또는 CLAUDE.example.md 중 하나 존재 확인
  if [[ -f "$TARGET_DIR/CLAUDE.md" ]]; then
    ok "CLAUDE.md"
  elif [[ -f "$TARGET_DIR/CLAUDE.example.md" ]]; then
    ok "CLAUDE.example.md (기존 CLAUDE.md 유지됨)"
  else
    fail "CLAUDE.md — MISSING"
    errors=$((errors + 1))
  fi

  echo ""
  if [[ $errors -eq 0 ]]; then
    echo -e "${GREEN}Installation verified successfully!${NC}"
  else
    echo -e "${RED}$errors file(s) missing — check the errors above${NC}"
  fi

  return $errors
}

# --- Dry Run ---
dry_run() {
  echo ""
  echo -e "${BOLD}[DRY RUN] Would install to: $TARGET_DIR${NC}"
  echo ""
  echo -e "  ${CYAN}.claude/${NC}  ${YELLOW}← 강제 덮어쓰기${NC}"
  echo "    agents/        (11 agents)"
  echo "    commands/      (3 commands)"
  echo "    hooks/         (6 hooks + dependencies)"
  echo "    skills/        (14+ skills)"
  echo "    settings.json  (hook bindings, permissions)"
  echo ""

  if [[ -f "$TARGET_DIR/CLAUDE.md" ]]; then
    echo -e "  ${CYAN}CLAUDE.md${NC}  ${GREEN}← 기존 유지${NC}"
    echo -e "  ${CYAN}CLAUDE.example.md${NC}  ${YELLOW}← 템플릿 저장${NC}"
  else
    echo -e "  ${CYAN}CLAUDE.md${NC}  ${YELLOW}← 새로 생성${NC}"
  fi
  echo -e "  ${CYAN}CLAUDE_INTEGRATION_GUIDE.md${NC}  ${YELLOW}← 덮어쓰기${NC}"
  echo ""
  echo -e "  ${CYAN}docs/${NC}"
  echo -e "    README.md (8개)  ${YELLOW}← 덮어쓰기${NC}"
  if [[ "$RESET_CONTEXT" == true ]]; then
    echo -e "    context/ (4개)   ${YELLOW}← 클린 템플릿으로 초기화 (--reset-context)${NC}"
  else
    echo -e "    context/ (4개)   ${GREEN}← 기존 유지, 없는 것만 생성${NC}"
  fi
  echo "    folders (8개)    ← 생성 (기존 콘텐츠 유지)"
  echo ""
}

# --- Next Steps ---
print_next_steps() {
  echo ""
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${CYAN}  Next Steps${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""

  if [[ -f "$TARGET_DIR/CLAUDE.example.md" ]]; then
    echo "  1. CLAUDE.example.md를 참고하여 CLAUDE.md 보강"
    echo "     - Document Management, Monorepo Structure 섹션 참고"
    echo "     - 프로젝트 기술 스택에 맞게 Quick Commands 수정"
  else
    echo "  1. CLAUDE.md를 프로젝트 기술 스택에 맞게 수정"
    echo "     - Backend/Frontend Architecture 섹션 교체"
    echo "     - Quick Commands 섹션을 프로젝트 실행 명령어로 변경"
  fi
  echo ""
  echo "  2. .claude/skills/skill-rules.json 정리"
  echo "     - 사용하지 않는 스킬의 enabled를 false로 변경"
  echo "     - filePathTriggers 경로를 프로젝트 구조에 맞게 수정"
  echo ""
  echo "  3. docs/context/ 파일을 프로젝트 현재 상태로 갱신"
  echo "     - dev-status.md: Sprint Focus, Current State 작성"
  echo "     - decisions.md: 기존 확정 결정 기록"
  echo ""
  echo "  4. CLAUDE_INTEGRATION_GUIDE.md 참고하여 세부 커스터마이징"
  echo ""
  echo -e "  ${YELLOW}범용 스킬 (즉시 사용 가능):${NC}"
  echo "    skill-developer, mermaid, docx, pdf, pptx,"
  echo "    frontend-design, web-design-guidelines"
  echo ""
  echo -e "  ${YELLOW}프레임워크 스킬 (스택 확인 후 사용):${NC}"
  echo "    fastapi-backend-guidelines, nextjs-frontend-guidelines,"
  echo "    pytest-backend-testing, vercel-react-best-practices,"
  echo "    error-tracking (Sentry)"
  echo ""
}

# --- 메인 ---
main() {
  check_deps
  resolve_source

  if [[ "$DRY_RUN" == true ]]; then
    dry_run
    exit 0
  fi

  install_claude_env
  verify_installation || true
  print_next_steps
}

main
