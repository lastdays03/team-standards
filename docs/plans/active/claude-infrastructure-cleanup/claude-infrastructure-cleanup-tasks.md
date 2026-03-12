# Claude Infrastructure Cleanup — Tasks

**Last Updated**: 2026-03-12

---

## Phase 1: 즉시 삭제 + 안전장치 [Effort: S~M]

- [ ] **1.1** `skill-rules.json` 삭제
  - `.claude/skills/skill-rules.json` (1,058줄)
  - 수용 기준: 파일 부재, 다른 코드에서 참조 없음

- [ ] **1.2** `skill-developer/` 디렉터리 삭제
  - `.claude/skills/skill-developer/` (7파일)
  - 수용 기준: 디렉터리 부재

- [ ] **1.3** `skill-activation-prompt` 훅 삭제
  - `.claude/hooks/skill-activation-prompt.ts`
  - `.claude/hooks/skill-activation-prompt.sh`
  - 수용 기준: 두 파일 부재

- [ ] **1.4** 고아 훅 삭제
  - `.claude/hooks/error-handling-reminder.ts`
  - `.claude/hooks/error-handling-reminder.sh`
  - `.claude/hooks/stop-build-check-enhanced.sh`
  - 수용 기준: 세 파일 부재

- [ ] **1.5** `trigger-build-resolver.sh` 삭제
  - `.claude/hooks/trigger-build-resolver.sh`
  - 수용 기준: 파일 부재

- [ ] **1.6** `settings.json` 훅 바인딩 정리
  - UserPromptSubmit 섹션 전체 제거
  - Stop 섹션에서 trigger-build-resolver 엔트리 제거
  - 수용 기준: `jq .` 유효한 JSON, 삭제된 파일 참조 0건

- [ ] **1.7** `.claude/hooks` TypeScript metadata 정리
  - `skill-activation-prompt.ts` 참조 제거
  - 필요 시 `test` 스크립트 삭제 또는 유지 대상 훅 기준 smoke command로 교체
  - `skill-activation-prompt.ts`, `error-handling-reminder.ts` 삭제 후 TS hook이 0개면 `.claude/hooks/package.json`, `.claude/hooks/package-lock.json`, `.claude/hooks/tsconfig.json` 제거 여부까지 함께 결정
  - 수용 기준: hooks metadata에 삭제된 hook 참조 0건, 남는 파일은 유지 이유가 설명 가능

- [ ] **1.8** `scripts/install-claude-env.sh` 설치 검증/안내 정리
  - `install_claude_env()` 성공 메시지/인벤토리 출력 현행화
  - `verify_installation()` 체크 목록에서 삭제 대상 제거
  - `dry_run()` 인벤토리 수치 현행화
  - `print_next_steps()`에서 skill-rules 기반 후속 조치와 삭제 대상 skill 안내 제거
  - 수용 기준: installer가 삭제 대상 파일 부재를 실패로 보지 않고, 출력 메시지도 실제 인벤토리와 일치

- [ ] **1.9** Phase 1 검증
  - `jq . .claude/settings.json`
  - `rg`로 `settings.json`, `package*.json`, `tsconfig.json`, `install-claude-env.sh`의 stale 참조 확인
  - 가능하면 installer dry-run으로 출력 검증

- [ ] **1.10** Phase 1 커밋
  - 메시지: `refactor: remove dead claude infrastructure and repair installer refs`

---

## Phase 2: 구조 통합 [Effort: M]

- [ ] **2.1** `refactor-planner.md` 내용 읽기 및 병합 포인트 파악
  - refactor-specific 체크리스트, 위험 분석 포인트 추출

- [ ] **2.2** `planner.md`에 refactor 관련 내용 병합
  - 수용 기준: planner가 refactor scope 명시적 지원

- [ ] **2.3** `refactor-planner.md` 삭제
  - 수용 기준: 파일 부재, planner에 핵심 내용 포함

- [ ] **2.4** 레거시 에이전트 삭제
  - `.claude/agents/web-research-specialist.md`
  - `.claude/agents/auth-route-tester.md`
  - `.claude/agents/auth-route-debugger.md`
  - 수용 기준: 세 파일 부재

- [ ] **2.5** `route-research-for-testing` 커맨드 삭제
  - `.claude/commands/route-research-for-testing.md`
  - 수용 기준: 파일 부재

- [ ] **2.6** `vercel-react-best-practices` description 축소
  - SKILL.md description을 성능 최적화/렌더링 병목/데이터 페칭 병렬화 중심으로 변경
  - `"React components"`, `"Next.js pages"`처럼 일반 프론트엔드 작업 전체에 매칭되는 표현 제거
  - 수용 기준: description이 일반 컴포넌트 작성/페이지 구현에는 직접 매칭되지 않고, 성능 병목 시나리오로 한정됨

- [ ] **2.7** Phase 2 커밋
  - 메시지: `refactor: consolidate agents and remove legacy commands`

---

## Phase 3: 런타임/품질 개선 [Effort: M~L]

- [ ] **3.1** `tsc-check.sh` — session_id 읽기 수정
  - stdin에서 `session_id` 파싱
  - 캐시 경로를 post-tool-use-tracker와 동일 기준으로 통일
  - repo detection/affected-repos 기준도 post-tool-use-tracker와 통일
  - 수용 기준: 두 훅이 같은 캐시 디렉터리와 같은 repo 판별 규칙 사용

- [ ] **3.2** `tsc-check.sh` — MultiEdit 지원
  - `tool_input.file_path` fallback 구현
  - 실제 Stop 이벤트 payload 계약을 Write/Edit/MultiEdit 기준으로 재검증
  - 수용 기준: MultiEdit 입력에서 TypeScript 체크 실행되고, Write/Edit와 동일한 repo 판별 흐름을 따름

- [ ] **3.3** Stop hook smoke 검증 경로 확보
  - Write/Edit/MultiEdit 예시 payload 또는 fixture 준비
  - 수용 기준: 세 입력 유형 모두 재현 가능한 검증 절차 확보

- [ ] **3.4** `nextjs-frontend-guidelines` 분리
  - SKILL.md 1,073줄 → 500줄 이하 + 리소스 파일
  - App Router, auth, data fetching, UI/styling, performance 같은 주제별 리소스로 분리
  - 수용 기준: 메인 스킬 파일 500줄 이하, 세부 규칙은 탐색 가능한 리소스 경로로 이동

- [ ] **3.5** `error-tracking/SKILL.md` 서비스명 수정
  - Form Service, Email Service, 진행률 숫자 등 stale 프로젝트 특화 문맥 제거
  - 현재 레포 기준으로 재작성하거나 템플릿/범용 표현으로 일반화
  - 수용 기준: stale 서비스명/진행률 서술 0건, 현재 레포 또는 범용 템플릿 문맥과 일치

- [ ] **3.6** Phase 3 검증
  - Stop hook Write/Edit/MultiEdit smoke 확인
  - 캐시 경로, session_id, repo detection 계약 확인

- [ ] **3.7** Phase 3 커밋
  - 메시지: `fix: harden claude hook runtime handling`

---

## Phase 4: 문서 마이그레이션 [Effort: L~XL]

- [ ] **4.1** `CLAUDE.md` 업데이트
  - 인벤토리 수치 정정 (스킬, 에이전트, 훅, 커맨드)
  - skill-rules/skill-activation 설명 제거
  - 삭제된 에이전트/커맨드 소개 제거
  - 수용 기준: 삭제 대상 언급 0건, 수치 정확

- [ ] **4.2** `README.md` 업데이트
  - skill-rules 자동 주입 설명 제거
  - 에이전트/커맨드 목록 현행화
  - 설치 후 설정에서 skill-rules 기반 지침 제거
  - 수용 기준: 삭제 대상 언급 0건

- [ ] **4.3** `.claude/skills/README.md` 전면 재작성
  - skill-rules.json 설정법 전체 제거
  - 존재하지 않는 스킬 소개 제거
  - 네이티브 description 기반 가이드로 전환
  - 수용 기준: skill-rules 참조 0건, 현존 스킬만 나열

- [ ] **4.4** `.claude/agents/README.md` 업데이트
  - Available Agents 수치 수정 (→ 7)
  - 삭제 대상 에이전트 제거
  - planner의 refactor planning 흡수 반영
  - 수용 기준: 에이전트 수 정확, 삭제 대상 언급 0건

- [ ] **4.5** `.claude/hooks/README.md` 재구성
  - Essential Hooks에서 skill-activation-prompt 제거
  - post-tool-use-tracker 중심으로 재편
  - tsc-check의 수정된 session/MultiEdit 동작 반영
  - 수용 기준: 삭제된 훅 언급 0건, 구현과 설명 일치

- [ ] **4.6** `.claude/hooks/CONFIG.md` 수정
  - UserPromptSubmit 설정 예시 제거
  - 존재하지 않는 훅 파일 참조 정리
  - tsc-check 캐시 경로 설명을 실제 구현과 일치
  - 수용 기준: 고아 파일 참조 0건, 캐시 경로 정확

- [ ] **4.7** `CLAUDE_INTEGRATION_GUIDE.md` 정리
  - 미존재 skills/skill-rules 커스터마이징 안내 제거
  - 삭제 대상 에이전트/커맨드/훅 안내 제거
  - installer 검증/후속 조치 흐름 재정렬
  - 수용 기준: 삭제 대상 언급 0건

- [ ] **4.8** Phase 4 검증
  - 7개 핵심 문서 기준 stale 참조 0건 확인
  - 인벤토리 수치와 실제 파일 수 수동 대조

- [ ] **4.9** Phase 4 커밋
  - 메시지: `docs: sync documentation with current infrastructure state`

---

## Summary

| Phase | 태스크 수 | Effort | 의존성 |
|-------|-----------|--------|--------|
| 1 — 삭제+안전장치 | 10 | S~M | 없음 |
| 2 — 통합 | 7 | M | Phase 1 |
| 3 — 런타임 개선 | 7 | M~L | Phase 1+2 |
| 4 — 문서 | 9 | L~XL | Phase 1+2+3 |
| **합계** | **33** | | |
