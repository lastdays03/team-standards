# docs-structure-unification - Context & Decisions

> Last Updated: 2026-03-06

## Status
- Phase: Complete (전체 완료)
- Progress: 23 / 23 tasks complete
- Last Updated: 2026-03-06

## Key Files

### 삭제 완료
- `docs/planning/` — 전체 폴더 삭제됨
- `docs/dev/` — 전체 폴더 삭제됨

### 이동 완료
- `docs/dev/active/docs-structure-unification/` → `docs/plans/active/docs-structure-unification/`
- `docs/planning/REPORT-infrastructure-template-value-assessment.md` → `docs/plans/reports/`
- `docs/planning/completed/REPORT-container-persistence.md` → `docs/plans/done/`

### 신규 생성
- `docs/plans/README.md` — 통합 운영 규칙

### 수정 완료 (18개 파일)

**커맨드 (2)**: dev-docs.md, dev-docs-update.md
**에이전트 (4)**: planner.md, code-architecture-reviewer.md, documentation-architect.md, refactor-planner.md
**프로젝트 설정 (2)**: CLAUDE.md, CLAUDE_INTEGRATION_GUIDE.md
**docs 문서 (4)**: docs/README.md, ops-rules.md, decisions.md, dev-status.md
**스크립트 + 템플릿 (2)**: install-claude-env.sh, templates/context/ops-rules.md
**공개 문서 (1)**: README.md (루트)
**기타 (3)**: backend/TESTING.md, error-tracking/SKILL.md, REPORT 내부 참조

## Key Decisions

1. **폴더명 `plans`** (2026-03-06)
   - `planning`이 아닌 `plans` — 짧고 기획+구현 통합 의미 반영
   - `dev`가 아닌 이유 — `docs/dev-guide/`와 혼동 방지

2. **REPORT는 `reports/` 서브폴더** (2026-03-06)
   - PLAN과 달리 REPORT는 독립 리서치이므로 별도 서브폴더
   - 완료 시 `done/`으로 이동 (단일 아카이브 규칙)

3. **양방향 링크 규칙 폐지** (2026-03-06)
   - 같은 폴더에 PLAN + tasks + context가 공존하므로 불필요

4. **"기획 문서에 구현 상세 금지" 규칙 재표현** (2026-03-06)
   - "PLAN 파일에 구현 상세를 작성하지 않는다 (별도 tasks/context 파일 사용)"

## Known Issues
- 없음 — 모든 태스크 완료, grep 검증 통과
