# Skill Improvement - Strategic Plan

## Executive Summary

14개 Claude Code 스킬 재평가 결과를 바탕으로, 6개 개선 항목을 3단계 우선순위(P0/P1/P2)로 나누어 실행한다. P0은 사실상 사용 불가 상태인 vercel-react-best-practices 스킬의 전면 재작성과 nextjs-frontend-guidelines 중복 리소스 통합이며, P1은 web-design-guidelines 보완 및 스킬 간 워크플로우 연결, P2는 프로젝트 관리 스킬 예제 보고서와 문서 스킬 의존성 가이드 추가이다.

## Current State

### 문제 요약

| # | 스킬 | 문제 | 심각도 |
|---|------|------|--------|
| 1 | vercel-react-best-practices | SKILL.md가 57개 규칙 이름만 나열. rules/ 파일이 존재하나 SKILL.md에서 구조화된 참조 없음. Before/After 코드 예제가 SKILL.md 본문에 전무 | P0 |
| 2 | nextjs-frontend-guidelines | resources/ 내 ui-styling.md vs styling-guide.md, app-router.md vs routing-guide.md 중복 | P0 |
| 3 | web-design-guidelines | Design Quality 규칙 부재, Bad/Good 예제 없음 | P1 |
| 4 | frontend-design + web-design-guidelines | 생성/검수 워크플로우 연결 없음 | P1 |
| 5 | area-deep-dive, project-health-check, project-report | 예제 보고서 없어 출력 형태 불명확 | P2 |
| 6 | docx, pdf, pptx, mermaid | 의존성 설치 가이드 없음 | P2 |

### 잘 된 스킬 패턴 (벤치마크)

**fastapi-backend-guidelines** 구조:
- `skill.md` -- 핵심 패턴 요약 + Quick Start 체크리스트 + 토픽별 섹션 + Navigation Guide
- `references/ygs-project.md` -- 프로젝트 특화 참조
- `resources/` (10개) -- 카테고리별 상세 가이드 (domain-driven-design.md, service-layer.md 등)

**pytest-backend-testing** 구조:
- `SKILL.md` -- 테스트 전략 개요 + 핵심 패턴 코드 예제 포함
- `references/ygs-examples.md` -- 실제 프로젝트 예제
- `resources/` (7개) -- 유형별 상세 가이드

## Proposed Solution

### 설계 원칙

1. **SKILL.md는 실행 가능해야 한다** -- 규칙 이름 나열이 아닌 핵심 패턴의 Before/After 코드 + 카테고리별 상세 가이드 링크
2. **중복 제거, 역할 명확화** -- 같은 주제의 파일이 두 개 있으면 통합하고 Navigation Guide 갱신
3. **스킬 간 연결** -- 생성(frontend-design) -> 검수(web-design-guidelines) 워크플로우를 양쪽에 명시
4. **예제 제공** -- 프로젝트 관리 스킬에 실제 출력 형태 예제 추가로 기대치 설정
5. **자급자족** -- 문서 스킬이 의존성 설치를 안내하여 바로 사용 가능

## Implementation Phases

### Phase 1: P0 -- 핵심 스킬 정상화 (3-4일)

**Goal**: 사용 불가/비효율 상태의 핵심 프론트엔드 스킬 2개를 정상화

**Tasks**:
- [x] vercel-react-best-practices SKILL.md 전면 재작성 - Size: XL
- [x] vercel-react-best-practices resources/ 카테고리별 상세 가이드 8개 생성 - Size: XL
- [x] nextjs-frontend-guidelines 중복 파일 분석 및 통합 - Size: M
- [x] nextjs-frontend-guidelines skill.md Navigation Guide 갱신 - Size: S

### Phase 2: P1 -- 스킬 품질 보강 (2일)

**Goal**: web-design-guidelines 검수 품질 향상, 스킬 간 워크플로우 연결

**Tasks**:
- [x] web-design-guidelines Design Quality 규칙 섹션 추가 - Size: L
- [x] web-design-guidelines Bad/Good 예제 추가 - Size: L
- [x] frontend-design SKILL.md에 검수 워크플로우 안내 추가 - Size: S
- [x] web-design-guidelines SKILL.md에 생성 워크플로우 연결 추가 - Size: S

### Phase 3: P2 -- 보강 및 예제 (2-3일)

**Goal**: 프로젝트 관리 스킬에 예제 제공, 문서 스킬 설치 가이드 추가

**Tasks**:
- [x] area-deep-dive 예제 보고서 작성 - Size: L
- [x] project-health-check 예제 보고서 작성 - Size: L
- [x] project-report 예제 보고서 작성 - Size: L
- [x] docx SKILL.md Setup/Dependencies 섹션 추가 - Size: S
- [x] pdf SKILL.md Setup/Dependencies 섹션 추가 - Size: S
- [x] pptx SKILL.md Setup/Dependencies 섹션 추가 - Size: S
- [x] mermaid SKILL.md Setup/Dependencies 섹션 추가 - Size: S

## Risk Assessment

- **High Risk**: vercel-react-best-practices 재작성 범위가 크다 (57개 규칙) -- Mitigation: 8개 카테고리별 resources/ 파일로 분산. SKILL.md에는 카테고리당 대표 규칙 1-2개만 Before/After로 포함하고 나머지는 resources/ 참조
- **Medium Risk**: nextjs-frontend-guidelines 중복 통합 시 기존 링크 깨짐 -- Mitigation: skill.md 내 모든 참조 링크를 함께 갱신. 통합 대상 파일 내용을 꼼꼼히 diff하여 유실 방지
- **Low Risk**: 예제 보고서 품질이 실제 사용과 괴리 -- Mitigation: 실제 프로젝트(QWarty) 기반으로 작성

## Success Metrics

- vercel-react-best-practices SKILL.md에 카테고리당 최소 1개 Before/After 코드 예제 포함
- nextjs-frontend-guidelines resources/ 중복 파일 0개 (13 -> 11개 이하)
- web-design-guidelines에 Design Quality 규칙 5개 이상 + Bad/Good 예제
- 프로젝트 관리 스킬 3종에 각각 예제 보고서 1개 이상
- 문서 스킬 4종에 Setup/Dependencies 섹션 포함

## Dependencies

- Phase 1, 2, 3는 독립 실행 가능 (순차 권장이나 병렬도 가능)
- vercel-react-best-practices의 기존 rules/ 57개 파일은 유지 -- resources/에 카테고리별 통합 가이드를 별도 생성
- 예제 보고서는 QWarty 프로젝트 코드베이스 참조 필요

## Timeline

- Phase 1: 3-4일 (vercel-react-best-practices XL 작업이 주요 병목)
- Phase 2: 2일
- Phase 3: 2-3일
- **Total: 7-9일**
