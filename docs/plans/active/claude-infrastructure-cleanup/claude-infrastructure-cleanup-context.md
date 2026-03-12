# Claude Infrastructure Cleanup — Context

**Last Updated**: 2026-03-12

---

## Key Files

### 삭제 대상

| 파일/디렉터리 | Phase | 비고 |
|---------------|-------|------|
| `.claude/skills/skill-rules.json` | 1 | 1,058줄, 22개 엔트리. 8/10 기능 미작동 |
| `.claude/skills/skill-developer/` | 1 | 7파일, 2,215줄. 미작동 시스템 가이드 |
| `.claude/hooks/skill-activation-prompt.ts` | 1 | skill-rules.json 유일 소비자 |
| `.claude/hooks/skill-activation-prompt.sh` | 1 | 위 ts의 래퍼 |
| `.claude/hooks/error-handling-reminder.ts` | 1 | 고아 (settings 미등록) |
| `.claude/hooks/error-handling-reminder.sh` | 1 | 고아 |
| `.claude/hooks/stop-build-check-enhanced.sh` | 1 | 고아, tsc-check 중복 |
| `.claude/hooks/trigger-build-resolver.sh` | 1 | 미존재 에이전트 호출 |
| `.claude/agents/refactor-planner.md` | 2 | planner에 병합 후 삭제 |
| `.claude/agents/web-research-specialist.md` | 2 | 내장 웹 검색 중복 |
| `.claude/agents/auth-route-tester.md` | 2 | Express/PM2 전제 |
| `.claude/agents/auth-route-debugger.md` | 2 | Keycloak/app.ts 전제 |
| `.claude/commands/route-research-for-testing.md` | 2 | FastAPI 구조와 충돌 |

### 수정 대상

| 파일 | Phase | 작업 |
|------|-------|------|
| `.claude/settings.json` | 1 | UserPromptSubmit 제거, Stop에서 trigger-build-resolver 제거 |
| `.claude/hooks/package.json` | 1 | 삭제된 hook test 참조 제거, TS hook toolchain 유지 여부 결정 |
| `.claude/hooks/package-lock.json` | 1 | TS hook toolchain 제거 시 함께 삭제 |
| `.claude/hooks/tsconfig.json` | 1 | TS hook toolchain 제거 시 함께 삭제 |
| `scripts/install-claude-env.sh` | 1 | install banner, verify_installation, dry-run, next steps에서 삭제 대상 참조 제거 |
| `.claude/agents/planner.md` | 2 | refactor-planner 체크리스트 병합 |
| `.claude/skills/vercel-react-best-practices/SKILL.md` | 2 | generic frontend trigger 제거, 성능 병목 작업으로 범위 축소 |
| `.claude/hooks/tsc-check.sh` | 3 | session_id 버그, repo detection 계약 불일치, MultiEdit/Write 검증 보강 |
| `.claude/skills/nextjs-frontend-guidelines/SKILL.md` | 3 | 대형 파일을 주제별 리소스로 분리 |
| `.claude/skills/error-tracking/SKILL.md` | 3 | Form/Email Service 같은 stale 서비스명과 진행률 서술 제거 |

### 문서 재작성 대상 (Phase 4)

| 문서 | 영향 규모 |
|------|-----------|
| `CLAUDE.md` | ~10줄 수정 |
| `README.md` | ~25줄 수정 |
| `.claude/skills/README.md` | ~240줄 재작성 (65%) |
| `.claude/agents/README.md` | ~45줄 수정 |
| `.claude/hooks/README.md` | ~80줄 재작성 (49%) |
| `.claude/hooks/CONFIG.md` | ~120줄 수정 (27%) |
| `CLAUDE_INTEGRATION_GUIDE.md` | 대규모 정리 |

### 유지 (구조 유지)

- **에이전트 (7)**: planner, plan-reviewer, code-architecture-reviewer, code-refactor-master, documentation-architect, frontend-error-fixer, auto-error-resolver
- **커맨드 (2)**: /dev-docs, /dev-docs-update
- **훅 (2)**: post-tool-use-tracker.sh, tsc-check.sh
- **스킬 수 (16)**: 인벤토리는 유지. 단, `vercel-react-best-practices`, `nextjs-frontend-guidelines`, `error-tracking`은 내용 정리 대상

---

## Key Decisions

1. **skill-rules.json 전체 삭제** (부분 수정 아님)
   - 네이티브 description 매칭이 의미론적으로 우수
   - 6회 관찰 중 정확한 추천 0회로 커스텀 시스템 실효성 없음

2. **refactor-planner는 병합 후 삭제** (단순 삭제 아님)
   - planner가 이미 refactor scope를 다루지만, refactor-specific 체크리스트는 가치 있음
   - planner.md에 refactor mode 섹션으로 흡수

3. **레거시 에이전트는 삭제** (archive 아님)
   - auth-route-tester/debugger는 Express 전제로 현재 FastAPI 구조와 직접 충돌
   - 템플릿 히스토리는 git history에 보존됨

4. **삭제와 동시에 설치/검증 경로 보정**
   - `scripts/install-claude-env.sh`와 `.claude/hooks/package.json`은 Phase 1에서 함께 수정
   - dead code 제거 직후 installer/test 경로가 깨지지 않게 한다

5. **Phase 순서 엄수**: 삭제+안전장치 → 통합 → 런타임 개선 → 문서
   - 문서 수정은 반드시 코드/스크립트 변경 이후에 수행하여 이중 작업 방지
   - `tsc-check` 제약 문서화는 해당 제약 수정 이후에만 수행

6. **커밋 전략**: Phase별 별도 커밋
   - Phase 1: `refactor: remove dead claude infrastructure and repair installer refs`
   - Phase 2: `refactor: consolidate agents and commands`
   - Phase 3: `fix: harden claude hook runtime handling`
   - Phase 4: `docs: sync documentation with current infrastructure`

7. **vercel-react-best-practices description은 키워드 추가가 아니라 트리거 축소가 목적**
   - `"React components"`, `"Next.js pages"` 같은 광범위 표현은 제거
   - 성능 병목, waterfall 제거, bundle 최적화, re-render 진단처럼 Vercel 룰셋이 필요한 상황만 남긴다

8. **Phase 1 종료 시 TS hook toolchain의 생사도 확정**
   - `skill-activation-prompt.ts`, `error-handling-reminder.ts` 삭제 후 TS hook이 0개면 `package*.json`, `tsconfig.json` 유지 이유가 약함
   - 유지할 근거가 없으면 hooks 디렉터리를 shell-only runtime으로 단순화한다

9. **Stop hook 계약은 Write/Edit/MultiEdit 전체 기준으로 맞춘다**
   - `post-tool-use-tracker`와 `tsc-check`가 같은 session cache와 repo detection 규칙을 써야 한다
   - smoke 검증도 `Write`를 포함한 세 입력 유형을 모두 다룬다

---

## Dependencies

```
Phase 1 (삭제+안전장치) ──→ Phase 2 (통합) ──→ Phase 3 (런타임 개선) ──→ Phase 4 (문서)
```

- Phase 1은 삭제 전에 installer/test 경로 영향을 함께 반영해야 함
- Phase 2의 planner 병합은 refactor-planner.md 내용 읽기 필요
- Phase 3의 hook 수정은 Phase 4의 hooks 문서보다 먼저 완료되어야 함
- Phase 4는 Phase 1~3 완료 후 최종 파일 상태 기준으로 작성

---

## Reference

- 감사 보고서: `docs/plans/reports/REPORT-claude-infrastructure-audit.md`
- settings.json: `.claude/settings.json`
- 검증 기호: `[S]` 정적 확인, `[O]` 실행 관찰, `[?]` 런타임 미검증
