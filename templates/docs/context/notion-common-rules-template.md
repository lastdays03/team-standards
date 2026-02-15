# Notion Common Rules Template

목적: 공통 규칙을 Notion에서 일관되게 관리하고, 각 프로젝트에 빠르게 적용한다.

## 운영 원칙
- 공통 규칙 공유/검색/온보딩은 Notion에서 수행한다.
- 프로젝트 실행 기준(Source of Truth)은 항상 레포 문서(`AGENTS.md`, `docs/context/*`)다.
- 규칙 변경은 `Notion 초안 -> 레포 반영(PR) -> Notion 확정` 순서로 처리한다.

## Notion 권장 구조
1. 상위 페이지: `공통 운영 규칙`
2. 데이터베이스: `규칙 레지스트리`
3. 필수 속성:
- `Rule ID` (텍스트, 예: OPS-001)
- `제목` (타이틀)
- `상태` (Draft/Active/Deprecated)
- `카테고리` (협업, 브랜치, 품질게이트, 보안, API, 컨텍스트)
- `적용 범위` (All Projects/Selected Projects)
- `레포 반영 경로` (예: `AGENTS.md`, `docs/context/ops-rules.md`)
- `최종 확정일` (날짜)
- `담당자` (People)
- `비고` (리치텍스트)

## 새 프로젝트 5분 적용 체크리스트
1. Notion `규칙 레지스트리`에서 `상태=Active`, `적용 범위=All Projects` 필터 적용
2. `AGENTS.md` 기본 규칙 블록 반영
3. `docs/context/ops-rules.md` 운영 규칙 반영
4. `docs/context/README.md` 체크리스트/역할 링크 반영
5. 프로젝트별 예외가 있으면 `docs/context/decisions.md`에 확정 기록
