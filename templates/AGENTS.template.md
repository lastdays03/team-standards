# __PROJECT_NAME__ Project Rules

## Scope
- These rules apply only to this repository.

## Collaboration Rules
- Use Git-Flow branch strategy:
  - `main`: production-ready only, no direct push.
  - `develop`: default integration branch.
  - `feature/*`: feature branches merged into `develop`.
- Before commit/push: `git fetch` then `git pull --rebase` if behind.
- Commit format: Conventional Commits (`type: subject`).

## Quality Gates
- Backend changes: run project backend tests.
- Frontend changes: run project frontend lint/tests.
- DB schema changes: run migration checks.

## Context Rules
- Start-of-session restore order:
1. `docs/context/dev-status.md`
2. `docs/context/decisions.md`
3. `docs/context/handoff.md`
4. `docs/context/ops-rules.md`

- Handoff trigger (`핸드오프`, `마무리`, `종료`):
1. Update `docs/context/handoff.md`
2. Share summary
3. Wait for explicit `커밋` / `푸시`
