# __PROJECT_NAME__ Project Rules

## Scope
- These rules apply only to this repository.
- If session-level instructions conflict, session-level instructions win.

## Collaboration Rules
- Use Git-Flow branch strategy:
- `main`: production-ready only, no direct push. Final merge must come from `develop` only.
- `develop`: default branch and integration branch for ongoing development.
- `feature/*`: feature development branches. Feature work must merge into `develop`.
- Before commit/push, sync with remote first (`git fetch` + `git pull --rebase` when behind) to minimize conflicts.
- Branch naming for features: `feature/<issue-number>-<short-slug>` (example: `feature/1-login-page`).
- Commit message format must follow Conventional Commits: `type: subject`.
- Allowed commit types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`, `ci`, `build`, `revert`.
- PR title and PR description must be written in Korean so team members can review consistently.
- PR description should be concise and human-readable; do not paste raw terminal logs into PR body.

## Frontend Rules
- Run frontend dev server with `npm run dev`.
- If optional env keys are empty, the app must still render (graceful fallback).
- For UI data loading, always provide loading, error, and empty states.

## Backend Rules
- Environment load priority is `.env.local` then `.env`.
- `.env` must contain non-secret template values only.
- Any DB schema change requires a migration.
- Migrations must be safe on pre-existing local DBs (idempotent where needed).

## API Rules
- Keep v1 compatibility for existing clients.
- Implement new endpoints/features in v2 first.
- When deprecating v1 behavior, add explicit deprecation signals in API responses/docs.

## Quality Gates
- Before concluding backend changes, run backend tests.
- Before concluding frontend changes, run frontend lint/tests.
- If migrations changed, run migration checks.

## Security Rules
- Never print secrets in full (API keys, tokens, passwords).
- Secret checks must only report presence/format, not raw values.
- Temporary diagnostics files must not be committed.

## Artifact Rules
- Store test/debug artifacts under `.temp/artifacts/` instead of repository root.
- Prefer removing one-off artifacts after verification; keep only files needed for follow-up debugging.
- If artifact retention is needed, keep them grouped by purpose in a single subfolder.

## Context Continuity Rules
- Use lightweight project memory files under `docs/context/`:
- `dev-status.md`: current development state and next actions (actively updated during work)
- `ops-rules.md`: operation/collaboration rules
- `decisions.md`: confirmed technical decisions only
- `handoff.md`: session-end handoff summary
- At session start, always restore context in this exact order before starting work:
1. Read `docs/context/dev-status.md`
2. Read `docs/context/decisions.md`
3. Read `docs/context/handoff.md`
4. Read `docs/context/ops-rules.md`
- If switching PCs without ending the session, run this mid-session sync sequence before continuing:
1. `git fetch origin`
2. `git pull --rebase`
3. Re-read `docs/context/dev-status.md` and `docs/context/handoff.md`
4. Append a 1-2 line "Sync Note" to `docs/context/dev-status.md` only when there is meaningful delta
- If the user explicitly says `핸드오프`, `마무리`, or `종료`, execute this sequence before final response:
1. Update `docs/context/handoff.md`
2. Report handoff summary and wait for explicit `커밋` / `푸시` commands
- If commit/push fails, report the failure reason and current git state.

## Tooling Baseline
- MCP servers (default): Notion, NotebookLM, Linear, GitHub, Playwright
- Skills (default): architecture-patterns, api-design-principles, python-testing-patterns, gh-address-comments, gh-fix-ci, linear
- Rule: tool/skill defaults can be reduced per project, and exceptions must be recorded in `docs/context/decisions.md`.
