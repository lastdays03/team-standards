# Advanced Harness

Claude Code 스킬/에이전트/훅/커맨드 모음 — 다른 프로젝트에 이식 가능한 인프라 템플릿.

한 줄 설치로 16개 스킬, 7개 에이전트, 2개 훅, 2개 커맨드 + 문서 체계를 기존 프로젝트에 적용할 수 있다.

## 핵심 기능

### 스킬 자동 활성화

각 스킬의 `description` 필드를 기반으로 Claude Code가 네이티브 매칭하여 관련 스킬을 자동 활성화한다. 별도 훅이나 규칙 파일 불필요.

### 훅

| 이벤트 | 훅 | 역할 |
|--------|-----|------|
| PostToolUse | `post-tool-use-tracker.sh` | Edit/Write/MultiEdit 파일 변경 추적 |
| Stop | `tsc-check.sh` | TypeScript 컴파일 에러 검출 |

### Context Memory 시스템

세션 간 작업 맥락을 4개 파일로 유지한다:

```
docs/context/
├── dev-status.md    # 현재 상태, 다음 액션 (50줄 이내)
├── decisions.md     # 확정된 기술 결정 + 근거
├── handoff.md       # 세션 종료 시 다음 시작점 (40줄 이내)
└── ops-rules.md     # 협업 절차, 문서 운영 규칙
```

---

## Skills (16개)

| 스킬 | 설명 | 범용성 |
|------|------|--------|
| `frontend-design` | 프로덕션급 프론트엔드 UI 생성 디자인 가이드 | 범용 |
| `mermaid` | Mermaid 다이어그램 생성 — 플로우차트, ER, 간트 등 23종 | 범용 |
| `web-design-guidelines` | Web Interface Guidelines 기반 UI 접근성/UX 리뷰 | 범용 |
| `docx` | Word 문서(.docx) 생성/편집/분석 | 범용 |
| `pdf` | PDF 읽기/병합/분할/회전/워터마크/OCR | 범용 |
| `pptx` | PowerPoint 생성/편집/분석 | 범용 |
| `brand-guidelines` | Anthropic 브랜드 컬러/타이포그래피 적용 | 커스텀 |
| `ppt-brand-guidelines` | VRL 프레젠테이션 브랜드 가이드라인 | 커스텀 |
| `fastapi-backend-guidelines` | FastAPI DDD 개발 — SQLModel, 레포지토리 패턴, async/await | FastAPI |
| `nextjs-frontend-guidelines` | Next.js 15 App Router, shadcn/ui, Tailwind CSS 4, 한국어 i18n | Next.js |
| `pytest-backend-testing` | FastAPI pytest 패턴 — 유닛/통합/비동기/목킹 | pytest |
| `vercel-react-best-practices` | Vercel 엔지니어링 기준 React/Next.js 성능 최적화 (58개 규칙) | React |
| `error-tracking` | Sentry v8 에러 트래킹 및 성능 모니터링 통합 | Sentry |

## Agents (7개)

| 에이전트 | 설명 | 범용성 |
|---------|------|--------|
| `planner` | `docs/plans/active/`에 구조화된 개발 계획(plan/context/tasks) 생성, 리팩토링 계획 포함 | 범용 |
| `plan-reviewer` | 구현 전 개발 계획 리뷰 — 리스크 평가, 갭 분석 | 범용 |
| `code-architecture-reviewer` | 코드 품질, 아키텍처 일관성, 시스템 통합 리뷰 | 범용 |
| `code-refactor-master` | 파일 재구성, 의존성 추적, 컴포넌트 추출 등 종합 리팩토링 | 범용 |
| `documentation-architect` | 개발 문서, API 문서, 데이터 플로우 다이어그램 생성 | 범용 |
| `frontend-error-fixer` | 빌드타임/런타임 프론트엔드 에러 진단 및 수정 | 프론트엔드 |
| `auto-error-resolver` | TypeScript 컴파일 에러 자동 감지 및 수정 | TypeScript |

## Commands (2개)

| 커맨드 | 설명 |
|--------|------|
| `/dev-docs` | `docs/plans/active/{task-name}/`에 plan/context/tasks 3파일 구조 생성 |
| `/dev-docs-update` | 컨텍스트 컴팩션 전 진행 상태 업데이트, 완료 작업 아카이브 |

---

## 설치

### 원격 설치 (curl)

현재 폴더에 설치:

```bash
curl -fsSL https://raw.githubusercontent.com/lastdays03/team-standards/main/scripts/install-claude-env.sh | bash
```

특정 폴더에 설치:

```bash
curl -fsSL https://raw.githubusercontent.com/lastdays03/team-standards/main/scripts/install-claude-env.sh | bash -s -- ~/my-project
```

### 로컬 설치 (레포 클론 후)

```bash
git clone https://github.com/lastdays03/team-standards.git
./team-standards/scripts/install-claude-env.sh ~/my-project
```

### 설치 옵션

```bash
install-claude-env.sh [options] [target-path]

옵션:
  --dry-run          실제 복사 없이 설치 내역 미리보기
  --reset-context    docs/context/ 파일을 클린 템플릿으로 강제 초기화
```

### 설치 동작

| 대상 | 신규 프로젝트 | 기존 프로젝트 (재설치) |
|------|:----------:|:----------------:|
| `.claude/` | 생성 | 강제 덮어쓰기 |
| `CLAUDE.md` | 생성 | 유지 (템플릿은 `.example.md`로 저장) |
| `docs/` 폴더 | 생성 | 부족한 폴더만 추가 |
| `docs/` README | 생성 | 덮어쓰기 |
| `docs/context/` 내용 | 클린 템플릿 생성 | 기존 유지 (`--reset-context`로 초기화) |

---

## 프로젝트 구조

```
.claude/
  agents/           # 7 autonomous agents
  commands/         # 2 slash commands
  hooks/            # 2 hooks
  skills/           # 16 skills
  settings.json     # Hook bindings & permissions
docs/
  context/          # 세션 운영 (상태/결정/핸드오프/규칙)
  plans/            # 기획 + 구현 통합 (active/, reports/, done/)
  architecture/     # 시스템 아키텍처
  operations/       # 팀 협업 프로세스
  dev-guide/        # 개발자 가이드
  archive/          # 역할 완료 문서
scripts/
  install-claude-env.sh   # 설치 스크립트
  templates/context/      # 클린 context 템플릿 (4개)
backend/            # FastAPI 레퍼런스 구현 (Python 3.12, SQLModel)
frontend/           # Next.js 15 레퍼런스 구현 (React 19, Tailwind CSS 4)
CLAUDE.md           # 프로젝트 지침
CLAUDE_INTEGRATION_GUIDE.md  # 타 프로젝트 통합 가이드 (881줄)
```

---

## 설치 후 설정

1. **CLAUDE.md 수정** — Backend/Frontend Architecture, Quick Commands를 프로젝트에 맞게 교체
2. **docs/context/ 초기화** — dev-status, decisions를 프로젝트 현재 상태로 갱신
3. **CLAUDE_INTEGRATION_GUIDE.md 참조** — 스킬/에이전트별 상세 커스터마이징 가이드
