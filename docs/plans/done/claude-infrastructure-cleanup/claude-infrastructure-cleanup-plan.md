# Claude Infrastructure Cleanup Plan

**Last Updated**: 2026-03-12
**근거 문서**: `docs/plans/reports/REPORT-claude-infrastructure-audit.md`
**범위**: `.claude/` 전체 인프라 정리 + installer 정합성 보정 + 문서 동기화

---

## Executive Summary

감사 보고서에서 확인된 핵심 문제:
1. **skill-rules.json 커스텀 트리거**: 10개 기능 중 8개 미작동, 네이티브 description 매칭과 중복
2. **고아 훅/에이전트**: settings.json 미등록 훅 3개, 레거시 Express 전제 에이전트 3개
3. **설치/검증 경로 드리프트**: installer와 hook test가 삭제 예정 파일을 계속 참조
4. **문서-구현 드리프트**: 7개 핵심 문서가 삭제 대상을 계속 권장

목표: 미작동 코드 제거 + 삭제 직후 깨지는 경로 보정 → 구조 통합 → 훅/스킬 런타임 개선 → 문서 동기화

---

## Current State

| 영역 | 파일 수 | 문제 |
|------|---------|------|
| skills/ | 277 (22개 skill-rules 엔트리) | 14개 스킬 rules에만 존재 (SKILL.md 없음), skill-developer 삭제 대상 |
| hooks/ | 13 | 활성 4개, 고아 3개, trigger-build-resolver 미작동, test 스크립트가 삭제 예정 hook 참조 |
| agents/ | 11 | 4개 삭제/병합 대상 (refactor-planner, web-research-specialist, auth-route 2개) |
| commands/ | 3 | 1개 삭제 대상 (route-research-for-testing) |
| scripts/ | 1 | install script가 삭제 예정 파일을 검증/안내/인벤토리 출력에 사용 |
| 문서 | 7개 핵심 | 전부 stale 상태 |

## Proposed Future State

| 영역 | 변경 후 |
|------|---------|
| skills/ | skill-rules.json 삭제, skill-developer 삭제. 네이티브 description 매칭만 사용 (16개 스킬) |
| hooks/ | 활성 2개 (post-tool-use-tracker, tsc-check). 고아·미작동 5개 삭제, 필요 없어진 TS hook toolchain도 함께 정리 |
| agents/ | 7개 (planner가 refactor planning 흡수) |
| commands/ | 2개 (/dev-docs, /dev-docs-update) |
| scripts/ | installer 검증/안내가 정리 후 인벤토리와 일치 |
| 문서 | 현재 구현과 일치하는 상태 |

---

## Implementation Phases

### Phase 1: 즉시 삭제 + 안전장치

미작동 코드와 고아 파일을 제거하고, 삭제 직후 installer/test 경로가 깨지지 않게 보정한다.

**작업 목록:**

1. **skill-rules.json 삭제** [S]
   - 대상: `.claude/skills/skill-rules.json` (1,058줄)
   - 근거: 10개 기능 중 8개 미작동, 작동 2개도 네이티브 중복
   - Effort: S

2. **skill-developer 디렉터리 삭제** [S]
   - 대상: `.claude/skills/skill-developer/` (7파일, 2,215줄)
   - 근거: 미작동 시스템의 가이드. 네이티브 스킬 생성은 SKILL.md description만 작성
   - Effort: S

3. **skill-activation-prompt 훅 삭제** [S]
   - 대상: `.claude/hooks/skill-activation-prompt.ts`, `.claude/hooks/skill-activation-prompt.sh`
   - 근거: skill-rules.json의 유일한 소비자
   - Effort: S

4. **고아 훅 삭제** [S]
   - 대상:
     - `.claude/hooks/error-handling-reminder.ts` (222줄)
     - `.claude/hooks/error-handling-reminder.sh` (10줄)
     - `.claude/hooks/stop-build-check-enhanced.sh` (124줄)
   - 근거: settings.json 미등록
   - Effort: S

5. **trigger-build-resolver.sh 삭제** [S]
   - 대상: `.claude/hooks/trigger-build-resolver.sh` (78줄)
   - 근거: 미존재 에이전트(`build-error-resolver`) 호출, 서비스 목록 불일치
   - Effort: S

6. **settings.json 훅 바인딩 정리**
   - UserPromptSubmit 섹션 전체 제거 (skill-activation-prompt)
   - Stop 섹션에서 trigger-build-resolver 제거
   - 수용 기준: settings.json에 삭제된 훅 참조 없음
   - Effort: S

7. **hooks TypeScript metadata 정리**
   - 삭제 예정인 `skill-activation-prompt.ts` 참조 제거
   - `test` 스크립트는 삭제하거나 유지 대상 훅 기준 smoke command로 교체
   - `skill-activation-prompt.ts`, `error-handling-reminder.ts` 삭제 후 TS hook이 0개면 `.claude/hooks/package.json`, `.claude/hooks/package-lock.json`, `.claude/hooks/tsconfig.json` 제거 여부까지 함께 결정
   - 수용 기준: hooks metadata에 삭제된 hook 참조 없음, 남기는 파일마다 유지 근거가 명확함
   - Effort: S

8. **install-claude-env.sh 설치 검증/안내 정리**
   - `verify_installation()` 체크 목록에서 삭제 대상 제거
   - `install_claude_env()`의 인벤토리/성공 메시지를 현행 구조로 수정
   - `dry_run()` 인벤토리 수치(agents/commands/hooks/skills) 현행화
   - `print_next_steps()`에서 skill-rules 기반 후속 조치와 삭제 대상 skill 안내 제거
   - 수용 기준: installer가 삭제 대상 파일 부재를 실패로 보지 않고, 출력 메시지도 실제 인벤토리와 일치
   - Effort: S

### Phase 2: 구조 통합

레거시 에이전트/커맨드 제거 및 planner 강화.

9. **refactor-planner → planner 병합**
   - `.claude/agents/refactor-planner.md`의 refactor-specific 체크리스트와 위험 분석 포인트를 `planner.md`에 병합
   - 병합 후 `refactor-planner.md` 삭제
   - Effort: M

10. **레거시 에이전트 삭제**
   - `.claude/agents/web-research-specialist.md` — 내장 웹 검색과 중복
   - `.claude/agents/auth-route-tester.md` — Express/PM2/Docker MySQL 전제
   - `.claude/agents/auth-route-debugger.md` — Keycloak/app.ts 전제
   - Effort: S

11. **route-research-for-testing 커맨드 삭제**
   - `.claude/commands/route-research-for-testing.md`
   - 근거: `/routes/` 경로 grep, `src/app.ts` 전제. FastAPI 구조와 직접 충돌
   - Effort: S

12. **vercel-react-best-practices description 축소**
    - 현재: 일반 React/Next.js 작업 전체에 매칭
    - 목표: 성능 최적화·렌더링 병목·데이터 페칭 병렬화·bundle/load-time 개선 작업으로 트리거 범위 한정
    - `"React components"`, `"Next.js pages"`처럼 모든 프론트엔드 작업에 걸리는 표현 제거
    - 수용 기준: description이 일반 컴포넌트 작성/페이지 구현을 직접 트리거하지 않고, 성능 병목 시나리오로만 읽힘
    - Effort: S

### Phase 3: 런타임/품질 개선

Phase 1~2 이후 남는 런타임 문제와 대형 스킬 정리를 먼저 마무리한다.

13. **tsc-check.sh session_id 버그 수정**
    - stdin에서 `session_id`를 읽도록 수정
    - 캐시 경로를 post-tool-use-tracker와 통일
    - repo detection/affected-repos 계약도 post-tool-use-tracker와 같은 기준으로 맞춤
    - Effort: M

14. **tsc-check.sh MultiEdit 지원**
    - `tool_input.file_path` fallback 지원
    - Write/Edit/MultiEdit별 Stop 이벤트 payload 계약 재검증
    - Effort: M

15. **Stop hook smoke 검증 경로 확보**
    - Write/Edit/MultiEdit 예시 payload 기준 검증 절차 또는 fixture 마련
    - 수용 기준: 세 입력 유형 모두 tsc-check 실행 여부를 재현 가능
    - Effort: S

16. **nextjs-frontend-guidelines 분리**
    - 1,073줄 → 500줄 이하 + 주제별 리소스 파일로 분리
    - App Router, auth, data fetching, UI/styling, performance처럼 탐색 가능한 단위로 나눔
    - Effort: L

17. **error-tracking 서비스명 수정**
    - 참조 서비스명(Form Service, Email Service)과 진행률 서술(예: `6/22 tasks`, `189 ErrorLogger.log()`) 제거 또는 현재 레포 기준으로 재작성
    - 템플릿/범용 인프라로서 재사용 가능한 표현으로 정리
    - Effort: S

### Phase 4: 문서 마이그레이션

Phase 1~3에서 삭제/변경된 내용을 7개 핵심 문서에 반영.

18. **CLAUDE.md 업데이트**
    - 인벤토리 수치 (스킬 수, 훅 수, 에이전트 수) 정정
    - skill-rules/skill-activation 설명 제거
    - 삭제된 에이전트/커맨드 소개 제거
    - installer 후속 조치 문구를 현재 흐름에 맞게 정리
    - Effort: M

19. **README.md 업데이트**
    - skill-rules 기반 자동 주입 설명 제거
    - 에이전트/커맨드 목록 현행화
    - 설치 후 설정 단계에서 skill-rules 중심 지침 제거
    - Effort: M

20. **skills/README.md 전면 재작성**
    - skill-rules.json 설정법 전체 제거
    - 존재하지 않는 스킬(backend-dev-guidelines 등) 소개 제거
    - 네이티브 description 기반 가이드로 전환
    - Effort: L (~240줄, 전체의 65%)

21. **agents/README.md 업데이트**
    - `Available Agents` 수치 수정 (11 → 7)
    - 삭제 대상 에이전트 quick reference 제거
    - planner의 refactor planning 흡수 구조 반영
    - Effort: M

22. **hooks/README.md 재구성**
    - "Essential Hooks" 섹션에서 skill-activation-prompt 제거
    - post-tool-use-tracker 중심 재구성
    - tsc-check의 수정된 session/MultiEdit 동작을 문서화
    - Effort: M (~80줄, 전체의 49%)

23. **hooks/CONFIG.md 수정**
    - UserPromptSubmit 설정 예시 제거
    - 존재하지 않는 `stop-prettier-formatter.sh` 참조 정리
    - tsc-check 캐시 경로 설명을 실제 구현과 일치
    - Effort: L (~120줄)

24. **CLAUDE_INTEGRATION_GUIDE.md 정리**
    - 존재하지 않는 skills, skill-rules 커스터마이징 안내 제거
    - 삭제 대상 에이전트/커맨드 안내 제거
    - installer 검증/후속 조치 흐름을 현재 구조 기준으로 재정렬
    - 현재 권장 세트 기반으로 재정렬
    - Effort: L

---

## Risk Assessment

| 리스크 | 영향 | 확률 | 완화 |
|--------|------|------|------|
| skill-activation-prompt 삭제 후 스킬 비활성화 | 중 | 낮 | 네이티브 description 매칭이 이미 작동 확인됨 |
| settings.json 수정 오류로 전체 훅 비활성화 | 고 | 낮 | 수정 후 `jq . .claude/settings.json` 검증 |
| 삭제 직후 installer/test 경로 파손 | 고 | 중 | Phase 1에서 `scripts/install-claude-env.sh`, `.claude/hooks/package.json` 동시 수정 |
| TS hook 파일 삭제 후 package metadata만 잔존 | 중 | 중 | Phase 1에서 hooks toolchain 유지/삭제를 명시적으로 결정 |
| 문서 재작성 시 유효 정보 손실 | 중 | 중 | Phase 1~3을 분리 커밋하고 Phase 4를 문서 전용 커밋으로 유지 |
| planner 병합 시 기존 동작 변경 | 낮 | 낮 | refactor 체크리스트만 추가, 기존 로직 미변경 |
| Hook 문서가 실제 구현보다 먼저 갱신되어 재작업 발생 | 중 | 중 | `tsc-check` 개선을 문서 단계보다 앞에 배치 |
| `tsc-check`와 `post-tool-use-tracker`가 같은 repo를 보지 않아 smoke가 허위 통과 | 중 | 중 | session cache뿐 아니라 repo detection 규칙까지 함께 맞춤 |

## Success Metrics

- [ ] `.claude/settings.json`, `.claude/hooks/package*.json`, `.claude/hooks/tsconfig.json`, `scripts/install-claude-env.sh`에 삭제된 파일 참조 0건
- [ ] installer dry-run/verification이 삭제 대상 파일 부재 때문에 실패하지 않음
- [ ] installer install banner, dry-run, next steps의 인벤토리/안내가 실제 구조와 일치
- [ ] 7개 핵심 문서에서 삭제 대상 언급 0건
- [ ] tsc-check ↔ post-tool-use-tracker 캐시 경로 통일
- [ ] tsc-check ↔ post-tool-use-tracker repo detection/affected-repos 계약 통일
- [ ] Write/Edit/MultiEdit 기준 Stop hook smoke 검증 완료
- [ ] 네이티브 스킬 활성화 정상 작동 또는 수동 관찰 근거 기록

## Dependencies

- Phase 2 → Phase 1 (삭제 + 안전장치 먼저)
- Phase 3 → Phase 1 + 2 (hook/runtime 기준을 먼저 확정)
- Phase 4 → Phase 1 + 2 + 3 (문서는 마지막)
