# Global Rules

목적: 모든 프로젝트에 공통으로 적용되는 전역 규칙을 고정한다.

## Branch Strategy
- `main` 직접 푸시 금지
- 기본 통합 브랜치: `develop`
- 기능 개발: `feature/*` 브랜치에서 진행 후 `develop`으로 병합

## Commit And PR
- 커밋 메시지: Conventional Commits (`type: subject`)
- PR 제목/본문: 팀 표준 언어/포맷 준수
- PR 본문에는 원문 로그를 그대로 붙여넣지 않는다

## Sync Before Push
- 커밋/푸시 전 `git fetch`
- behind 상태면 `git pull --rebase`

## Security Baseline
- 시크릿 원문 출력 금지(API 키, 토큰, 비밀번호)
- 임시 진단 파일은 커밋 금지

## Quality Baseline
- 백엔드 변경: 백엔드 테스트 필수
- 프론트 변경: 프론트 lint/test 필수
- 스키마 변경: 마이그레이션 검증 필수

## 적용 정책
- 새 프로젝트 시작 시 이 문서를 먼저 확인하고 `AGENTS.md`와 함께 적용한다.
- 프로젝트별 예외는 `docs/context/decisions.md`에 확정 기록한다.
