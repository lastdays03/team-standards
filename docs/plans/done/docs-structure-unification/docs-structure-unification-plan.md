# docs/planning + docs/dev 통합 — Strategic Plan

> Last Updated: 2026-03-06

## Executive Summary

`docs/planning/`(기획, What/Why)과 `docs/dev/`(구현, How)로 분리된 문서 구조를 `docs/plans/`로 단일화한다. 현재 `docs/dev/`가 완전히 비어있어 마이그레이션 비용이 거의 0이며, 양방향 참조 오버헤드와 이중 아카이브 관리를 제거하여 문서 운영을 단순화한다.

## Current State Analysis

### 현재 구조
```
docs/
├── planning/              # 기획 (What/Why)
│   ├── README.md
│   ├── REPORT-infrastructure-template-value-assessment.md  (활성)
│   └── completed/
│       └── REPORT-container-persistence.md                 (완료)
├── dev/                   # 구현 (How) — 완전히 비어있음
│   ├── README.md
│   ├── active/.gitkeep
│   └── done/.gitkeep
```

### 문제점
1. **이중 관리**: 2개 폴더, 2개 README, 2개 아카이브 경로 (completed vs done)
2. **양방향 링크 의무**: PLAN → dev 링크, dev → PLAN 링크 — 실제 미준수 가능성 높음
3. **아카이브 이중 로직**: `/dev-docs-update`가 양쪽 폴더 모두 아카이브 처리
4. **네이밍 불일치**: planning은 `completed/`, dev는 `done/`

## Proposed Future State

```
docs/
├── plans/                 # 기획 + 구현 통합
│   ├── README.md          # 통합 운영 규칙
│   ├── active/            # 진행 중 (PLAN + tasks + context 동거)
│   │   └── {topic}/
│   │       ├── PLAN-{topic}.md        # What/Why (기존 planning)
│   │       ├── {topic}-tasks.md       # How (기존 dev)
│   │       └── {topic}-context.md     # How (기존 dev)
│   ├── reports/           # 독립 리서치 (PLAN과 무관)
│   │   └── REPORT-*.md
│   └── done/              # 완료 아카이브 (통째 이동)
```

### 핵심 변경
- 양방향 링크 불필요 (같은 폴더 내 공존)
- 아카이브 경로 단일화 (`done/`)
- REPORT는 `reports/` 서브폴더로 독립 관리
- 완료 REPORT도 `done/`으로 이동 (단일 아카이브 규칙)

## Implementation Phases

### Phase 1: 디렉토리 구조 생성 + 파일 이동 (Foundation)

**Goal**: 새 `docs/plans/` 구조 생성, 기존 파일 이동, 구 폴더 삭제

1. `docs/plans/active/`, `docs/plans/reports/`, `docs/plans/done/` 생성
2. `docs/dev/active/docs-structure-unification/` → `docs/plans/active/` 이동 (이 계획 문서)
3. `docs/planning/REPORT-infrastructure-template-value-assessment.md` → `docs/plans/reports/`
4. `docs/planning/completed/REPORT-container-persistence.md` → `docs/plans/done/`
5. 통합 README.md 작성 → `docs/plans/README.md`
6. `docs/planning/`, `docs/dev/` 폴더 삭제

### Phase 2: 커맨드 + 에이전트 경로 수정 (Core Logic)

**Goal**: `/dev-docs`, `/dev-docs-update`, 에이전트 4개의 경로와 로직 수정

1. `.claude/commands/dev-docs.md` — 경로 변경 + `## Related Planning Doc` 생성 지시 제거
2. `.claude/commands/dev-docs-update.md` — 경로 변경 + "연관 기획 문서 자동 이동" 로직 삭제 + `## Related Planning Doc` 참조 삭제
3. `.claude/agents/planner.md` — 경로 + 양방향 링크 규칙 삭제
4. `.claude/agents/code-architecture-reviewer.md` — 경로 치환 (3곳: 탐색/저장/반환 메시지)
5. `.claude/agents/documentation-architect.md` — 경로 치환
6. `.claude/agents/refactor-planner.md` — 경로 치환

### Phase 3: 프로젝트 설정 + 운영 문서 수정 (Integration)

**Goal**: CLAUDE.md, ops-rules, 설치 스크립트 등 인프라 레벨 문서 동기화

1. `CLAUDE.md` — Monorepo Structure (2줄→1줄), Slash Commands 경로, Document Management 재작성 (규칙 문구 포함)
2. `docs/README.md` — 폴더 역할 테이블 재구성 + 역할 구분 섹션 삭제/대체 + 참조 링크 수정
3. `docs/context/ops-rules.md` — Archive Rules 통합 + Shared Rules Sync 경로 수정
4. `scripts/templates/context/ops-rules.md` — Archive Rules 템플릿 수정
5. `scripts/install-claude-env.sh` — 디렉토리 생성, .gitkeep, README 경로 수정
6. `README.md` (루트) — planner, /dev-docs 설명 경로 수정
7. `CLAUDE_INTEGRATION_GUIDE.md` — 경로 참조 수정
8. `backend/TESTING.md` — 데드 링크 정리
9. `.claude/skills/error-tracking/SKILL.md` — 예시 경로 수정
10. `REPORT-infrastructure-template-value-assessment.md` — 경로 현행화 (2곳, 이동 후)

### Phase 4: Context Memory 업데이트 + 검증 (Verification)

**Goal**: 결정 기록, 상태 갱신, 전체 경로 검증

1. `docs/context/decisions.md` — 통합 결정 기록 추가
2. `docs/context/dev-status.md` — 상태 갱신
3. `grep` 기반 전체 경로 검증 (docs/dev, docs/planning 잔여 참조 0건 확인)
4. `docs/context/handoff.md` — 세션 요약 갱신

## Risk Assessment

| 리스크 | 심각도 | 발생 확률 | 완화 전략 |
|--------|--------|-----------|-----------|
| 잔여 경로 참조 누락 | 중간 | 낮음 | Phase 4에서 grep 검증으로 0건 확인 |
| 설치 스크립트 미수정으로 신규 프로젝트에 구 구조 생성 | 높음 | 낮음 | Phase 3에서 install-claude-env.sh + 템플릿 동시 수정 |
| REPORT 아카이브 규칙 모호 | 낮음 | 중간 | README에 명확한 규칙 정의 |
| 기존 git 이력의 경로 참조 | 없음 | 확정 | 이력은 수정 불가하나 운영에 영향 없음 |

## Success Metrics

1. `grep -r "docs/dev[^-]" .` 결과 0건 (docs/dev-guide는 별개이므로 제외)
2. `grep -r "docs/planning" .` 결과 0건
3. `docs/plans/` 구조가 README에 정의된 대로 존재
4. `/dev-docs` 커맨드가 `docs/plans/active/`에 문서 생성하도록 수정 완료
5. `install-claude-env.sh`가 새 구조로 설치 가능

## Dependencies

- Phase 1 완료 후 Phase 2, 3 병렬 진행 가능
- Phase 4는 Phase 1-3 모두 완료 후 실행

## Timeline

- Phase 1: S (10분)
- Phase 2: M (20분)
- Phase 3: M (25분)
- Phase 4: S (10분)
- **Total: ~65분**
