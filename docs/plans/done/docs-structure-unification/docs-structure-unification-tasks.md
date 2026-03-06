# docs-structure-unification - Task Checklist

> Last Updated: 2026-03-06

## Status Legend
- [ ] Not started
- [x] Complete
- [!] Blocked

## Progress Summary
23 / 23 tasks complete (100%)

---

## Phase 1: 디렉토리 구조 생성 + 파일 이동 (S)

- [x] 1-1. `docs/plans/active/`, `docs/plans/reports/`, `docs/plans/done/` 디렉토리 생성 + .gitkeep
- [x] 1-2. `docs/dev/active/docs-structure-unification/` → `docs/plans/active/docs-structure-unification/` 이동
- [x] 1-3. `docs/planning/REPORT-infrastructure-template-value-assessment.md` → `docs/plans/reports/` 이동
- [x] 1-4. `docs/planning/completed/REPORT-container-persistence.md` → `docs/plans/done/` 이동
- [x] 1-5. `docs/plans/README.md` 작성 (통합 운영 규칙)
- [x] 1-6. `docs/planning/`, `docs/dev/` 폴더 삭제

---

## Phase 2: 커맨드 + 에이전트 경로 수정 (M)

- [x] 2-1. `.claude/commands/dev-docs.md` 수정
- [x] 2-2. `.claude/commands/dev-docs-update.md` 수정
- [x] 2-3. `.claude/agents/planner.md` 수정
- [x] 2-4. `.claude/agents/code-architecture-reviewer.md` 수정
- [x] 2-5. `.claude/agents/documentation-architect.md` 수정
- [x] 2-6. `.claude/agents/refactor-planner.md` 수정

---

## Phase 3: 프로젝트 설정 + 운영 문서 수정 (M)

- [x] 3-1. `CLAUDE.md` 수정
- [x] 3-2. `docs/README.md` 수정
- [x] 3-3. `docs/context/ops-rules.md` 수정
- [x] 3-4. `scripts/templates/context/ops-rules.md` 수정
- [x] 3-5. `scripts/install-claude-env.sh` 수정
- [x] 3-6. `README.md` (루트) 수정
- [x] 3-7. `CLAUDE_INTEGRATION_GUIDE.md` 수정
- [x] 3-8. `backend/TESTING.md` 수정
- [x] 3-9. `.claude/skills/error-tracking/SKILL.md` 수정
- [x] 3-10. `docs/plans/reports/REPORT-infrastructure-template-value-assessment.md` 내부 참조 수정

---

## Phase 4: Context Memory + 검증 (S)

- [x] 4-1. `docs/context/decisions.md`에 통합 결정 추가
- [x] 4-2. `docs/context/dev-status.md` 상태 갱신
- [x] 4-3. 전체 경로 검증 (grep) — 운영 파일 잔여 참조 0건 확인
- [x] 4-4. `docs/context/handoff.md` 세션 요약 갱신

---

## Notes
- Phase 1 → Phase 2, 3 (병렬 가능) → Phase 4 (순서 의존)
- 이 계획 문서 자체는 태스크 1-2에서 `docs/plans/active/`로 이동됨
- 계획 문서 내부의 구 경로 참조(`docs/dev/`, `docs/planning/`)는 히스토리 성격이므로 수정하지 않음
