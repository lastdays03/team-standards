# Claude Infrastructure Cleanup — Tasks

**Last Updated**: 2026-03-12

---

## Phase 1: 즉시 삭제 + 안전장치 [Effort: S~M]

- [x] **1.1** `skill-rules.json` 삭제
- [x] **1.2** `skill-developer/` 디렉터리 삭제
- [x] **1.3** `skill-activation-prompt` 훅 삭제
- [x] **1.4** 고아 훅 삭제 (error-handling-reminder, stop-build-check-enhanced)
- [x] **1.5** `trigger-build-resolver.sh` 삭제
- [x] **1.6** `settings.json` 훅 바인딩 정리 (UserPromptSubmit 제거)
- [x] **1.7** `.claude/hooks` TS toolchain 정리 (package.json, package-lock.json, tsconfig.json 삭제)
- [x] **1.8** `scripts/install-claude-env.sh` 설치 검증/안내 정리
- [x] **1.9** Phase 1 검증
- [x] **1.10** Phase 1 커밋

## Phase 2: 구조 통합 [Effort: M]

- [x] **2.1** `refactor-planner.md` 내용 읽기 및 병합 포인트 파악
- [x] **2.2** `planner.md`에 Refactor Mode 섹션 병합
- [x] **2.3** `refactor-planner.md` 삭제
- [x] **2.4** 레거시 에이전트 삭제 (web-research-specialist, auth-route-tester, auth-route-debugger)
- [x] **2.5** `route-research-for-testing` 커맨드 삭제
- [x] **2.6** `vercel-react-best-practices` description 축소
- [x] **2.7** Phase 2 커밋

## Phase 3: 런타임/품질 개선 [Effort: M~L]

- [x] **3.1** `tsc-check.sh` — session_id 읽기 수정 + 캐시 경로 통일
- [x] **3.2** `tsc-check.sh` — MultiEdit 지원
- [x] **3.3** Stop hook smoke fixture 준비 (Write/Edit/MultiEdit)
- [x] **3.4** `nextjs-frontend-guidelines` 분리 (1,073→328줄 + resources 3개)
- [x] **3.5** `error-tracking/SKILL.md` 서비스명 범용화
- [x] **3.6** Phase 3 검증 — 26/26 PASS (test-plan.md 기준)
- [x] **3.7** Phase 3 커밋

## Phase 4: 문서 마이그레이션 [Effort: L~XL]

- [x] **4.1** `CLAUDE.md` 업데이트
- [x] **4.2** `README.md` 업데이트
- [x] **4.3** `.claude/skills/README.md` 재작성
- [x] **4.4** `.claude/agents/README.md` 업데이트
- [x] **4.5** `.claude/hooks/README.md` 재구성
- [x] **4.6** `.claude/hooks/CONFIG.md` 수정
- [x] **4.7** `CLAUDE_INTEGRATION_GUIDE.md` 정리
- [x] **4.8** Phase 4 검증 — stale 참조 0건 확인
- [x] **4.9** Phase 4 커밋

---

## Summary

모든 Phase 1~4 (33개 태스크) 완료. 단일 커밋으로 통합 (`6e7c67d`).

| Phase | 태스크 수 | 상태 |
|-------|-----------|------|
| 1 — 삭제+안전장치 | 10 | ✅ 완료 |
| 2 — 통합 | 7 | ✅ 완료 |
| 3 — 런타임 개선 | 7 | ✅ 완료 |
| 4 — 문서 | 9 | ✅ 완료 |
| **합계** | **33** | **✅ 전체 완료** |
