# Ops Rules

목적: 세션 운영/협업 절차만 짧게 유지한다.

## Core Rules
- 브랜치 전략: `main` 직접 푸시 금지, 개발 기본은 `develop`, 기능은 `feature/*`.
- 커밋/푸시 전 원격 동기화 우선: `git fetch` 후 behind면 `git pull --rebase`.
- PR 제목/본문은 한국어로 작성하고, 로그 원문 붙여넣기는 금지.

## Context Rules
- 세션 시작 복구 순서:
1. `docs/context/dev-status.md`
2. `docs/context/decisions.md`
3. `docs/context/handoff.md`
4. `docs/context/ops-rules.md`
- 세션 종료 전:
1. `dev-status.md`의 상태/다음 액션 갱신 (50줄 이내 유지)
2. 이번 세션 신규 확정사항을 `decisions.md`에 반영
3. `handoff.md` 갱신 (40줄 이내 유지, 다음 액션 중심)

## Update Triggers
- 작업 단위 완료/우선순위 변경 시: `dev-status.md` 갱신
- 확정 결정 발생 시: `decisions.md` 갱신 (날짜 | 결정 | 근거)
- 운영 규칙 변경 시: `ops-rules.md` 갱신
- 세션 종료 직전: `handoff.md` 갱신

## Document Size Management
- `dev-status.md`: 50줄 이내
- `handoff.md`: 40줄 이내
- 문서가 가이드 초과 시: 세션 종료 전 이전 내용 정리/축소

## Archive Rules
- 기획/구현 완료 시: `docs/plans/active/{topic}/` → `docs/plans/done/`으로 이동
- 역할 완료 문서: `docs/archive/`로 이동

## Handoff Trigger
- 사용자가 `핸드오프`, `마무리`, `종료`를 요청하면:
1. `docs/context/handoff.md` 갱신
2. 갱신 내용을 공유하고 `커밋`/`푸시` 명시 요청 전까지 대기
