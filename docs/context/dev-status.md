# Dev Status

> **크기 가이드**: 이 문서는 50줄 이내로 유지한다. Completed 섹션은 요약만 기록하고, 상세 내역은 handoff.md 또는 계획 문서에 남긴다.

## Last Updated
- Date: 2026-03-04
- Branch: `main`

## Sprint Focus
- 문서 관리 규칙 최적화 및 보완

## Current State
- 인프라 템플릿 중심 레포로 전환 작업 진행 중

## Completed (최근)
- docs/dev/ 통합 (dev/ → docs/dev/ 경로 마이그레이션)
- docs/ 하위 폴더 README 생성 (architecture, dev-guide, archive, operations, dev)
- 에이전트 MCP 참조 정리 (documentation-architect, auth-route-debugger, frontend-error-fixer, refactor-planner)
- QWarty 결정 아카이브 (decisions.md → docs/archive/decisions-qwarty.md)
- settings.json/settings.local.json MCP 설정 제거
- CLAUDE.md 최적화 (구조 반영, 문서관리 섹션 신설, MCP 제거)

## In Progress
- 없음

## Risks And Blockers
- 없음

## Next 3 Actions
1. 검증: 모든 경로 참조가 docs/dev/로 통일되었는지 확인
2. 필요 시 backend/frontend 앱 코드에서도 QWarty 전용 내용 정리
3. 인프라 템플릿 배포/설치 스크립트 검증

## Sync Notes
- 2026-03-04: 문서 관리 규칙 최적화 — 7개 Phase 일괄 적용
