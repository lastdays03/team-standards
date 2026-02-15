# Ops Rules

목적: 세션 운영/협업 절차를 간결하게 유지한다.

## Core Rules
- 브랜치 전략: `main` 직접 푸시 금지, `develop` 기본, 기능은 `feature/*`.
- 커밋/푸시 전 원격 동기화: `git fetch` 후 `git pull --rebase`.
- PR 규칙은 팀 공통 정책을 따른다.

## Update Triggers
- 작업 상태 변경: `dev-status.md`
- 확정 결정 발생: `decisions.md`
- 규칙 변경: `ops-rules.md`
- 세션 종료 직전: `handoff.md`

## Handoff Trigger
- `핸드오프`, `마무리`, `종료` 요청 시:
1. `handoff.md` 갱신
2. 커밋/푸시는 명시 요청 전 대기
