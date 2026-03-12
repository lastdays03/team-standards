---
name: project-health-check
description: "Run a comprehensive project health check and generate a Markdown report. Use this skill when the user asks to check project health, audit code quality, review project status, run a codebase checkup, or wants a periodic quality assessment. Also trigger when the user mentions 'health check', 'code quality report', 'project audit', 'technical debt check', 'codebase review', '프로젝트 상태', '코드 품질', '기술부채 점검', or '현재 상태 체크'. Proactively suggest this skill when the user starts a new session and wants to understand the current state of the project."
---

# Project Health Check

> **Example output**: See [references/example-report.md](references/example-report.md) for a sample report based on QWarty.

Generate a comprehensive project health report by analyzing the codebase across multiple dimensions — tests, builds, lint, dependencies, code patterns, and structural consistency. The report is saved as Markdown for tracking trends over time.

**Distinguish from other skills:**
- **Health check** (this) = broad + shallow, internal metrics, periodic checkup
- **Deep dive** = narrow + deep, one area in detail
- **Project report** = external audience, achievements-focused

## When to Use

- Periodic quality assessment (weekly/sprint-end)
- Before major releases or milestones
- When onboarding to understand project state
- After large refactoring to verify nothing regressed
- When the user asks "프로젝트 상태 어때?" or "how's the project looking?"

## Report Generation Process

### Step 0: Read CLAUDE.md

프로젝트의 CLAUDE.md를 먼저 읽어서 검사 명령어를 동적으로 결정:
- **경로**: 백엔드/프론트엔드 루트 디렉토리
- **명령어**: 테스트(pytest/jest), 린트(eslint/ruff), 빌드 명령
- **테크 스택**: ORM, 마이그레이션 도구, 패키지 매니저
- **컨벤션**: 디렉토리 구조, 네이밍 규칙

### Step 1: Gather Data (run checks in parallel)

Spawn parallel subagents or run commands concurrently for speed. The whole check should complete in under 2 minutes.

**1. Tests & Build** (CLAUDE.md의 Quick Commands 섹션 참조)
```bash
# 백엔드 테스트 — CLAUDE.md에 명시된 테스트 명령어 사용
cd {backend_path} && {test_command} -q --tb=no 2>&1 | tail -5

# 프론트엔드 린트 — CLAUDE.md에 명시된 린트 명령어 사용
cd {frontend_path} && {lint_command} 2>&1 | tail -10

# 프론트엔드 빌드 (타입 체크)
cd {frontend_path} && {build_command} 2>&1 | tail -10
```

**2. Code Pattern Analysis** (use Grep)
| Pattern | What it signals | Target |
|---------|----------------|--------|
| `except Exception:` with bare pass/continue | Swallowed errors | 0 |
| `# TODO` / `# FIXME` / `# HACK` | Technical debt markers | Track count |
| `type: ignore` / `noqa` / `@ts-ignore` | Suppressed warnings | Track count |
| `print(` / `console.log(` (not in tests) | Debug output left in code | 0 |
| `import pdb` / `breakpoint()` / `debugger` | Debug breakpoints left in | 0 |

**3. Git & Development Activity**
```bash
git status --short
git log --oneline -10
git log --oneline --since="7 days ago" | wc -l  # weekly velocity
```

**4. Database & Migrations** (프로젝트에 해당하는 경우만)
- CLAUDE.md에서 마이그레이션 도구 확인 (alembic/prisma/drizzle 등)
- 마이그레이션 동기화 상태 점검
- 모델-DB 드리프트 확인

**5. Structure Consistency** (use Glob)
- CLAUDE.md에 명시된 디렉토리 컨벤션 준수 여부
- API 라우트와 도메인 구조 일치 여부
- 고아 import (삭제된 모듈 참조) 존재 여부

**6. Documentation Currency**
- 프로젝트 문서 디렉토리(`docs/context/` 등)의 최근 수정일
- 활성 계획(active plans) 존재 여부 및 상태

### Step 2: Analyze & Score

Rate each category:

| Score | Meaning | Action |
|-------|---------|--------|
| GREEN | Healthy, no action needed | Maintain |
| YELLOW | Minor issues, address when convenient | Plan fix |
| RED | Needs immediate attention | Fix now |

**Scoring guidelines:**
- Tests: GREEN = all pass, YELLOW = <5 failures or skips, RED = >5 failures
- Lint: GREEN = 0 errors, YELLOW = warnings only, RED = errors present
- Build: GREEN = succeeds, RED = fails
- Legacy patterns: GREEN = 0 `raise HTTPException`, YELLOW = 1-5, RED = >5
- Debt markers: GREEN = <10 total, YELLOW = 10-30, RED = >30
- Structure: GREEN = all conventions followed, YELLOW = minor deviations, RED = structural problems

### Step 3: Generate Report

Save to `docs/plans/reports/REPORT-health-check-{YYYY-MM-DD}.md`:

```markdown
# Project Health Check Report

> **Date:** {date}
> **Branch:** {branch}
> **Analyst:** Claude Code

## Summary Dashboard

| Category | Status | Score | Detail |
|----------|--------|-------|--------|
| Backend Tests | {passed}/{total} passed | {GREEN/YELLOW/RED} | {brief} |
| Frontend Lint | {errors} errors | {GREEN/YELLOW/RED} | {brief} |
| Frontend Build | {pass/fail} | {GREEN/YELLOW/RED} | {brief} |
| DB Migrations | {synced/drift} | {GREEN/YELLOW/RED} | {brief} |
| Legacy Patterns | {count} remaining | {GREEN/YELLOW/RED} | {brief} |
| Technical Debt | {count} markers | {GREEN/YELLOW/RED} | {brief} |
| Code Structure | {assessment} | {GREEN/YELLOW/RED} | {brief} |
| Documentation | {current/stale} | {GREEN/YELLOW/RED} | {brief} |

## Overall Health: {HEALTHY / NEEDS_ATTENTION / CRITICAL}

{1-2 sentence overall assessment}

---

## Detailed Findings

### Tests & Quality Gates
- Backend: {X} passed, {Y} skipped, {Z} failed
- Frontend lint: {errors} errors, {warnings} warnings
- Frontend build: {pass/fail with key error if failed}
- {Notable observations}

### Code Patterns
| Pattern | Count | Location(s) | Status |
|---------|-------|-------------|--------|
| `raise HTTPException` | {n} | {files} | {GREEN/YELLOW/RED} |
| Bare `except Exception` | {n} | {files} | {GREEN/YELLOW/RED} |
| Debug prints | {n} | {files} | {GREEN/YELLOW/RED} |

### Technical Debt
- TODO: {count} ({top files})
- FIXME: {count}
- HACK: {count}
- Type suppressions: {count}

### Database Health
- Migration status: {synced/pending}
- Total migrations: {count}
- {Any model-DB drift detected}

### Dependencies
- Outdated packages: {list top 5 if any}
- Security advisories: {if any}

### Code Structure
- Feature directory compliance: {assessment}
- Naming consistency: {assessment}
- {Any structural anomalies}

### Documentation
- dev-status.md: {last modified}
- handoff.md: {last modified}
- Active plans: {count and names}

---

## Recommendations

| Priority | Action | Category | Effort |
|----------|--------|----------|--------|
| 1 | {specific action} | {category} | {S/M/L} |
| 2 | {specific action} | {category} | {S/M/L} |
| 3 | {specific action} | {category} | {S/M/L} |

---

## Trend (vs Previous)

{If a previous health check report exists in docs/plans/reports/, compare key metrics}

| Metric | Previous | Current | Trend |
|--------|----------|---------|-------|
| Test count | {prev} | {curr} | {arrow} |
| Test pass rate | {prev} | {curr} | {arrow} |
| HTTPException count | {prev} | {curr} | {arrow} |
| TODO count | {prev} | {curr} | {arrow} |
| Debt markers total | {prev} | {curr} | {arrow} |

---

*Generated by Claude Code on {date}*
```

## Key Principles

- **Be objective**: Report facts and numbers, not opinions. Let the scores speak.
- **Compare to previous**: If a prior health check exists, show the trend. Progress is motivating; regression needs attention.
- **Actionable recommendations**: Each recommendation should be specific enough to act on. "Improve test coverage" is vague; "Add tests for `app/features/rag/application/chat_service.py` (0 test coverage, 3 public methods)" is actionable.
- **Don't alarm unnecessarily**: YELLOW doesn't mean broken. Reserve RED for things that actually block development or risk production issues.
- **Fast execution**: The whole check should complete in under 2 minutes. Use parallel execution and avoid expensive operations.
- **Consistent format**: Keep the same structure across runs so trends are comparable. Don't restructure the report format between runs.
