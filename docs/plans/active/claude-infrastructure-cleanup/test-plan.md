# Claude Infrastructure Cleanup — 테스트 계획

**작성일**: 2026-03-12
**목적**: 커밋 전 수정/유지 대상 컴포넌트의 정상 작동 검증

---

## 테스트 영역 요약

| 영역 | 대상 | 변경 유형 | 위험도 |
|------|------|-----------|--------|
| Hooks | tsc-check.sh | 버그 수정 (session_id, cache, repo detection, MultiEdit) | **높음** |
| Hooks | post-tool-use-tracker.sh | 미변경 (계약 검증) | 중간 |
| Settings | settings.json | 훅 바인딩 축소 | **높음** |
| Agents | planner.md | Refactor Mode 섹션 추가 | 낮음 |
| Skills | vercel-react-best-practices | description 축소 | 낮음 |
| Skills | nextjs-frontend-guidelines | 1,073→328줄 분리 | 중간 |
| Skills | error-tracking | 서비스명 범용화 | 낮음 |
| Installer | install-claude-env.sh | 검증/인벤토리 수정 | 중간 |
| 삭제 검증 | 14파일 + 설정 | 잔존 참조 확인 | 중간 |

---

## 1. Hooks 테스트 (최우선)

### 1-1. tsc-check.sh — session_id 파싱

**목적**: stdin JSON에서 `session_id`를 올바르게 읽는지 확인

```bash
# 테스트 실행
cd /Users/bagjongman/dev/workspace/study/project/team-standards
export CLAUDE_PROJECT_DIR="$PWD"

# Edit fixture 주입
cat .claude/hooks/fixtures/stop-edit.json | bash .claude/hooks/tsc-check.sh 2>/dev/null; echo "exit: $?"

# 캐시 경로 확인 — session_id="smoke-test"이므로 default가 아니어야 함
ls -d "$PWD/.claude/tsc-cache/smoke-test" 2>/dev/null && echo "PASS: session_id correctly parsed" || echo "FAIL: session_id not parsed"
```

**수용 기준**: `$CLAUDE_PROJECT_DIR/.claude/tsc-cache/smoke-test/` 디렉터리 생성

### 1-2. tsc-check.sh — cache 경로 통일

**목적**: tsc-check가 post-tool-use-tracker와 같은 `$CLAUDE_PROJECT_DIR/.claude/tsc-cache/` 경로를 사용하는지 확인

```bash
# tsc-check 캐시 경로 확인
grep 'CACHE_DIR=' .claude/hooks/tsc-check.sh
# 기대값: CACHE_DIR="$CLAUDE_PROJECT_DIR/.claude/tsc-cache/$SESSION_ID"

# post-tool-use-tracker 캐시 경로 확인
grep 'cache_dir=' .claude/hooks/post-tool-use-tracker.sh
# 기대값: cache_dir="$CLAUDE_PROJECT_DIR/.claude/tsc-cache/${session_id:-default}"
```

**수용 기준**: 두 훅 모두 `$CLAUDE_PROJECT_DIR/.claude/tsc-cache/` 기반

### 1-3. tsc-check.sh — repo detection 패턴 일치

**목적**: tsc-check의 `get_repo_for_file()`이 post-tool-use-tracker의 `detect_repo()`와 동일한 패턴을 사용하는지 확인

```bash
# tsc-check의 인식 패턴 추출
grep -A 20 'get_repo_for_file()' .claude/hooks/tsc-check.sh | grep -E 'frontend|backend|client|server|database|packages'

# post-tool-use-tracker의 인식 패턴 추출
grep -A 20 'detect_repo()' .claude/hooks/post-tool-use-tracker.sh | grep -E 'frontend|backend|client|server|database|packages'
```

**수용 기준**: 두 훅이 인식하는 디렉터리 패턴 목록이 동일 (frontend, client, web, app, ui, backend, server, api, src, services, database, prisma, migrations, packages)

### 1-4. tsc-check.sh — Write 입력 처리

**목적**: Write 도구 payload에서 file_path를 올바르게 추출하고 repo를 감지하는지 확인

```bash
export CLAUDE_PROJECT_DIR="/project"
cat .claude/hooks/fixtures/stop-write.json | bash .claude/hooks/tsc-check.sh 2>&1; echo "exit: $?"
```

**수용 기준**: exit 0 (frontend/ 디렉터리에 실제 tsconfig가 없으므로 체크 skip이 정상). stderr에 에러 메시지 없음

### 1-5. tsc-check.sh — Edit 입력 처리

```bash
export CLAUDE_PROJECT_DIR="/project"
cat .claude/hooks/fixtures/stop-edit.json | bash .claude/hooks/tsc-check.sh 2>&1; echo "exit: $?"
```

**수용 기준**: exit 0, 에러 없음

### 1-6. tsc-check.sh — MultiEdit 입력 처리

**목적**: MultiEdit의 `edits[].file_path`와 top-level `file_path` 모두에서 경로를 추출하는지 확인

```bash
export CLAUDE_PROJECT_DIR="/project"

# MultiEdit fixture로 file_path 추출 로직만 검증
cat .claude/hooks/fixtures/stop-multiedit.json | jq -r '(.tool_input.edits[].file_path // empty), (.tool_input.file_path // empty)' | sort -u
```

**기대 출력**:
```
/project/backend/src/index.ts
/project/frontend/src/app/page.tsx
```

**수용 기준**: edits[].file_path와 top-level file_path 모두 추출됨 (3개 경로, 중복 제거 후 2~3개)

### 1-7. post-tool-use-tracker.sh — 기본 동작

**목적**: 미변경 훅이 기존과 동일하게 작동하는지 확인

```bash
export CLAUDE_PROJECT_DIR="$PWD"
echo '{"tool_name":"Edit","session_id":"smoke-test","tool_input":{"file_path":"'$PWD'/frontend/src/test.tsx"}}' | bash .claude/hooks/post-tool-use-tracker.sh; echo "exit: $?"

# 로그 확인
cat "$PWD/.claude/tsc-cache/smoke-test/edited-files.log" 2>/dev/null
cat "$PWD/.claude/tsc-cache/smoke-test/affected-repos.txt" 2>/dev/null
```

**수용 기준**: exit 0, `edited-files.log`에 파일 경로 기록, `affected-repos.txt`에 `frontend` 기록

### 1-8. 두 훅 캐시 체인 검증

**목적**: post-tool-use-tracker가 쓴 캐시를 tsc-check가 동일 경로에서 읽을 수 있는지 확인

```bash
export CLAUDE_PROJECT_DIR="$PWD"

# 1단계: tracker가 캐시 생성
echo '{"tool_name":"Edit","session_id":"chain-test","tool_input":{"file_path":"'$PWD'/frontend/src/app.tsx"}}' | bash .claude/hooks/post-tool-use-tracker.sh

# 2단계: tsc-check가 같은 세션 캐시 경로를 사용하는지 확인
TRACKER_CACHE="$PWD/.claude/tsc-cache/chain-test"
ls -la "$TRACKER_CACHE/" 2>/dev/null && echo "PASS: cache chain aligned" || echo "FAIL: cache paths diverge"
```

**수용 기준**: `$CLAUDE_PROJECT_DIR/.claude/tsc-cache/chain-test/` 경로에 두 훅이 모두 접근

---

## 2. Settings 테스트

### 2-1. settings.json 구조 유효성

```bash
jq . .claude/settings.json > /dev/null && echo "PASS: valid JSON"
jq '.hooks | keys' .claude/settings.json
```

**수용 기준**: 유효한 JSON, 키는 `["PostToolUse", "Stop"]`만 존재 (UserPromptSubmit 없음)

### 2-2. 등록된 훅 파일 존재 확인

```bash
# settings.json에서 참조하는 모든 훅 파일이 실제 존재하는지
jq -r '.. | .command? // empty' .claude/settings.json | sed 's|\$CLAUDE_PROJECT_DIR|.|g' | while read cmd; do
  if [ -f "$cmd" ]; then
    echo "PASS: $cmd exists"
  else
    echo "FAIL: $cmd MISSING"
  fi
done
```

**수용 기준**: 모든 훅 파일 PASS

### 2-3. 삭제된 훅 미참조 확인

```bash
grep -c 'skill-activation-prompt\|trigger-build-resolver\|error-handling-reminder\|stop-build-check' .claude/settings.json
```

**수용 기준**: 0

---

## 3. Agent 테스트

### 3-1. planner — Refactor Mode 존재 확인

```bash
grep -c 'Refactor Mode' .claude/agents/planner.md
grep -c 'Refactoring Analysis Checklist' .claude/agents/planner.md
grep -c 'Refactoring Risk Categories' .claude/agents/planner.md
```

**수용 기준**: 각각 1 이상

### 3-2. planner — 기존 기능 보존 확인

```bash
# 핵심 프로세스 5단계가 유지되는지
grep -c 'Step 1\|Step 2\|Step 3\|Step 4\|Step 5' .claude/agents/planner.md
```

**수용 기준**: 5

### 3-3. 에이전트 frontmatter 유효성

```bash
# 모든 에이전트 .md에 name, description frontmatter가 있는지
for f in .claude/agents/*.md; do
  [[ "$(basename $f)" == "README.md" ]] && continue
  name=$(head -5 "$f" | grep '^name:')
  desc=$(head -5 "$f" | grep '^description:')
  if [ -n "$name" ] && [ -n "$desc" ]; then
    echo "PASS: $(basename $f)"
  else
    echo "FAIL: $(basename $f) — missing frontmatter"
  fi
done
```

**수용 기준**: 7개 모두 PASS

### 3-4. 삭제된 에이전트 부재 확인

```bash
for agent in refactor-planner web-research-specialist auth-route-tester auth-route-debugger; do
  [ -f ".claude/agents/$agent.md" ] && echo "FAIL: $agent.md still exists" || echo "PASS: $agent.md deleted"
done
```

**수용 기준**: 4개 모두 PASS

---

## 4. Skill 테스트

### 4-1. vercel-react-best-practices — description 범위 축소 확인

```bash
# 광범위 표현이 제거되었는지
desc=$(head -3 .claude/skills/vercel-react-best-practices/SKILL.md | grep 'description:')
echo "$desc" | grep -c 'React components' && echo "FAIL: broad trigger remains" || echo "PASS: broad trigger removed"
echo "$desc" | grep -c 'Next.js pages' && echo "FAIL: broad trigger remains" || echo "PASS: broad trigger removed"

# 성능 관련 키워드가 있는지
echo "$desc" | grep -c 'performance' && echo "PASS: performance keyword present" || echo "FAIL: missing"
echo "$desc" | grep -c 'bottleneck\|waterfall\|bundle\|re-render' && echo "PASS: specific triggers present" || echo "FAIL: missing"
```

**수용 기준**: 광범위 표현 0건, 성능 키워드 존재

### 4-2. nextjs-frontend-guidelines — 분리 검증

```bash
# 메인 파일 500줄 이하
lines=$(wc -l < .claude/skills/nextjs-frontend-guidelines/skill.md)
[ "$lines" -le 500 ] && echo "PASS: $lines lines (≤500)" || echo "FAIL: $lines lines (>500)"

# 리소스 파일 존재
for res in auth app-router ui-styling; do
  [ -f ".claude/skills/nextjs-frontend-guidelines/resources/$res.md" ] && echo "PASS: resources/$res.md" || echo "FAIL: resources/$res.md missing"
done

# 기존 리소스 파일 보존
for res in common-patterns component-patterns data-fetching performance routing-guide styling-guide; do
  [ -f ".claude/skills/nextjs-frontend-guidelines/resources/$res.md" ] && echo "PASS: resources/$res.md" || echo "FAIL: resources/$res.md missing"
done

# frontmatter 유지
head -3 .claude/skills/nextjs-frontend-guidelines/skill.md | grep 'name: nextjs-frontend-guidelines' && echo "PASS: frontmatter intact" || echo "FAIL: frontmatter broken"
```

**수용 기준**: 메인 ≤500줄, 새 리소스 3개 + 기존 리소스 유지, frontmatter 정상

### 4-3. error-tracking — stale 참조 제거 확인

```bash
grep -c 'Form Service\|Email Service\|6/22 tasks\|189 ErrorLogger\|blog-api\|DHS_CLOSEOUT\|SystemActionQueueProcessor' .claude/skills/error-tracking/SKILL.md
```

**수용 기준**: 0

### 4-4. 전체 스킬 인벤토리

```bash
count=$(find .claude/skills -maxdepth 2 \( -name 'SKILL.md' -o -name 'skill.md' \) | wc -l | tr -d ' ')
[ "$count" -eq 16 ] && echo "PASS: $count skills" || echo "FAIL: expected 16, got $count"
```

**수용 기준**: 16

### 4-5. 모든 스킬 frontmatter 유효성

```bash
find .claude/skills -maxdepth 2 \( -name 'SKILL.md' -o -name 'skill.md' \) | while read f; do
  name=$(head -5 "$f" | grep '^name:')
  desc=$(head -5 "$f" | grep '^description:')
  skill_dir=$(basename $(dirname "$f"))
  if [ -n "$name" ] && [ -n "$desc" ]; then
    echo "PASS: $skill_dir"
  else
    echo "FAIL: $skill_dir — missing name or description"
  fi
done
```

**수용 기준**: 16개 모두 PASS

---

## 5. Command 테스트

### 5-1. 커맨드 인벤토리

```bash
ls .claude/commands/*.md
count=$(ls .claude/commands/*.md | wc -l | tr -d ' ')
[ "$count" -eq 2 ] && echo "PASS: $count commands" || echo "FAIL: expected 2, got $count"
```

**수용 기준**: dev-docs.md, dev-docs-update.md만 존재 (2개)

### 5-2. 삭제된 커맨드 부재

```bash
[ -f ".claude/commands/route-research-for-testing.md" ] && echo "FAIL: still exists" || echo "PASS: deleted"
```

**수용 기준**: PASS

---

## 6. Installer 테스트

### 6-1. dry-run 인벤토리 수치 확인

```bash
bash scripts/install-claude-env.sh --dry-run 2>&1 | grep -E 'agents|commands|hooks|skills'
```

**기대 출력**:
```
    agents/        (7 agents)
    commands/      (2 commands)
    hooks/         (2 hooks)
    skills/        (16 skills)
```

**수용 기준**: 수치가 실제 파일 수와 일치

### 6-2. verify_installation 체크 목록 확인

```bash
# 검증 대상 파일 목록에 삭제된 파일이 없는지
grep -E 'skill-rules|skill-activation-prompt' scripts/install-claude-env.sh
```

**수용 기준**: 0건

### 6-3. print_next_steps 확인

```bash
# skill-rules.json 정리 안내가 제거되었는지
grep -c 'skill-rules' scripts/install-claude-env.sh
# skill-developer 안내가 제거되었는지
grep -c 'skill-developer' scripts/install-claude-env.sh
```

**수용 기준**: 모두 0

### 6-4. node/npm 의존성 불필요 확인

```bash
# hooks npm install 관련 코드가 제거되었는지
grep -c 'npm install' scripts/install-claude-env.sh
```

**수용 기준**: 0

---

## 7. 삭제 검증 (네거티브 테스트)

### 7-1. 삭제 파일 부재 확인

```bash
deleted_files=(
  ".claude/skills/skill-rules.json"
  ".claude/skills/skill-developer/SKILL.md"
  ".claude/hooks/skill-activation-prompt.ts"
  ".claude/hooks/skill-activation-prompt.sh"
  ".claude/hooks/error-handling-reminder.ts"
  ".claude/hooks/error-handling-reminder.sh"
  ".claude/hooks/stop-build-check-enhanced.sh"
  ".claude/hooks/trigger-build-resolver.sh"
  ".claude/hooks/package.json"
  ".claude/hooks/package-lock.json"
  ".claude/hooks/tsconfig.json"
  ".claude/agents/refactor-planner.md"
  ".claude/agents/web-research-specialist.md"
  ".claude/agents/auth-route-tester.md"
  ".claude/agents/auth-route-debugger.md"
  ".claude/commands/route-research-for-testing.md"
)

for f in "${deleted_files[@]}"; do
  [ -e "$f" ] && echo "FAIL: $f still exists" || echo "PASS: $f deleted"
done
```

**수용 기준**: 16개 모두 PASS

### 7-2. 7개 핵심 문서 stale 참조 검사

```bash
docs=(
  "CLAUDE.md"
  "README.md"
  ".claude/skills/README.md"
  ".claude/agents/README.md"
  ".claude/hooks/README.md"
  ".claude/hooks/CONFIG.md"
  "CLAUDE_INTEGRATION_GUIDE.md"
)

stale_patterns='skill-rules\.json|skill-activation-prompt|skill-developer[^:]|refactor-planner|web-research-specialist|auth-route-tester|auth-route-debugger|route-research-for-testing|trigger-build-resolver|error-handling-reminder|stop-build-check-enhanced|stop-prettier-formatter'

total=0
for doc in "${docs[@]}"; do
  count=$(grep -cE "$stale_patterns" "$doc" 2>/dev/null || echo 0)
  total=$((total + count))
  [ "$count" -eq 0 ] && echo "PASS: $doc" || echo "FAIL: $doc ($count stale refs)"
done
echo "Total stale references: $total"
```

**수용 기준**: total = 0

---

## 8. 통합 테스트 (수동)

> 아래 항목은 Claude Code 세션 내에서 수동으로 관찰해야 합니다.

### 8-1. 네이티브 스킬 활성화

**절차**: Claude Code에서 "FastAPI로 새 엔드포인트 만들어줘" 입력
**기대**: system-reminder에 `fastapi-backend-guidelines` 스킬이 나타남
**확인**: skill-activation-prompt 훅 없이도 네이티브 매칭 작동

### 8-2. vercel-react-best-practices 트리거 범위

**절차 A**: "React 컴포넌트 하나 만들어줘" 입력
**기대**: vercel-react-best-practices가 활성화되지 **않음** (일반 컴포넌트 작성)

**절차 B**: "이 페이지 렌더링 성능을 최적화해줘" 입력
**기대**: vercel-react-best-practices가 활성화**됨**

### 8-3. Post-tool-use 훅 동작

**절차**: Claude Code에서 `.tsx` 파일을 Edit으로 수정
**기대**: `.claude/tsc-cache/[session-id]/edited-files.log`에 기록 생성

### 8-4. Stop 훅 (tsc-check) 동작

**절차**: Claude Code에서 TypeScript 파일을 수정하고 Stop
**기대**: stderr에 "⚡ TypeScript check on:" 메시지 출력 (또는 frontend 미존재 시 조용히 종료)

---

## 실행 순서

1. **7. 삭제 검증** — 선행 조건 확인 (1분)
2. **2. Settings** — 설정 유효성 (1분)
3. **1. Hooks** — 가장 높은 위험, 가장 먼저 (5분)
4. **3. Agents** + **4. Skills** + **5. Commands** — 병렬 실행 가능 (3분)
5. **6. Installer** — dry-run 검증 (2분)
6. **8. 통합 테스트** — 수동 관찰 (선택, 5분)

**예상 소요**: 자동화 테스트 ~12분, 수동 관찰 ~5분
