# Skill Improvement - Context & Decisions

## Status
- Phase: Not started
- Progress: 0 / 15 tasks complete
- Last Updated: 2026-03-12

## Key Files

**Modified (Phase 1)**:
- `.claude/skills/vercel-react-best-practices/SKILL.md` -- 전면 재작성 (규칙 나열 -> 구조화된 가이드 + Before/After 예제)
- `.claude/skills/nextjs-frontend-guidelines/skill.md` -- Navigation Guide 테이블 갱신
- `.claude/skills/nextjs-frontend-guidelines/resources/ui-styling.md` -- styling-guide.md 내용 통합
- `.claude/skills/nextjs-frontend-guidelines/resources/app-router.md` -- routing-guide.md 내용 통합

**Modified (Phase 2)**:
- `.claude/skills/web-design-guidelines/references/guidelines.md` -- Design Quality 규칙 + Bad/Good 예제 추가
- `.claude/skills/web-design-guidelines/SKILL.md` -- frontend-design 연결 안내 추가
- `.claude/skills/frontend-design/SKILL.md` -- web-design-guidelines 검수 워크플로우 안내 추가

**Modified (Phase 3)**:
- `.claude/skills/docx/SKILL.md` -- Setup/Dependencies 섹션 추가
- `.claude/skills/pdf/SKILL.md` -- Setup/Dependencies 섹션 추가
- `.claude/skills/pptx/SKILL.md` -- Setup/Dependencies 섹션 추가
- `.claude/skills/mermaid/SKILL.md` -- Setup/Dependencies 섹션 추가

**New (Phase 1)**:
- `.claude/skills/vercel-react-best-practices/resources/eliminating-waterfalls.md` -- async-* 규칙 상세 가이드
- `.claude/skills/vercel-react-best-practices/resources/bundle-optimization.md` -- bundle-* 규칙 상세 가이드
- `.claude/skills/vercel-react-best-practices/resources/server-performance.md` -- server-* 규칙 상세 가이드
- `.claude/skills/vercel-react-best-practices/resources/client-data-fetching.md` -- client-* 규칙 상세 가이드
- `.claude/skills/vercel-react-best-practices/resources/rerender-optimization.md` -- rerender-* 규칙 상세 가이드
- `.claude/skills/vercel-react-best-practices/resources/rendering-performance.md` -- rendering-* 규칙 상세 가이드
- `.claude/skills/vercel-react-best-practices/resources/javascript-performance.md` -- js-* 규칙 상세 가이드
- `.claude/skills/vercel-react-best-practices/resources/advanced-patterns.md` -- advanced-* 규칙 상세 가이드

**New (Phase 3)**:
- `docs/plans/reports/EXAMPLE-area-deep-dive.md` -- area-deep-dive 예제 보고서
- `docs/plans/reports/EXAMPLE-project-health-check.md` -- project-health-check 예제 보고서
- `docs/plans/reports/EXAMPLE-project-report.md` -- project-report 예제 보고서

**Deleted (Phase 1)**:
- `.claude/skills/nextjs-frontend-guidelines/resources/styling-guide.md` -- ui-styling.md에 통합
- `.claude/skills/nextjs-frontend-guidelines/resources/routing-guide.md` -- app-router.md에 통합

## Key Decisions

1. **vercel-react-best-practices: rules/ 유지 + resources/ 신규 생성** (2026-03-12)
   - Rationale: 기존 rules/ 57개 파일은 개별 규칙 참조로 유지 가치 있음. resources/에 카테고리별 통합 가이드를 새로 만들어 SKILL.md에서 참조
   - Alternatives: (a) rules/만 보강 -- 57개 파일을 각각 수정하면 작업량 과다 (b) rules/ 삭제하고 resources/만 -- 개별 규칙 참조 불가
   - Trade-offs: 디렉토리가 rules/ + resources/ 두 개가 되지만, rules/는 원본 Vercel 규칙 유지, resources/는 프로젝트 맞춤 가이드로 역할 분리 명확

2. **SKILL.md에 카테고리당 대표 규칙 1-2개만 Before/After 포함** (2026-03-12)
   - Rationale: 57개 전부 넣으면 SKILL.md가 1000줄 이상으로 비대해져 Claude의 컨텍스트 효율 저하
   - Alternatives: 모든 규칙 포함 -- 파일 크기 초과, 스킬 매칭 시 불필요한 토큰 소비
   - Trade-offs: SKILL.md만으로는 일부 규칙 상세를 볼 수 없으나, resources/ 링크로 필요 시 접근 가능

3. **nextjs-frontend-guidelines 중복 통합 방향: 기존 파일(ui-styling, app-router)에 통합** (2026-03-12)
   - Rationale: ui-styling.md(272줄)과 app-router.md(178줄)가 이미 skill.md의 주요 참조 대상. styling-guide.md(473줄)와 routing-guide.md(140줄)의 고유 내용을 기존 파일에 머지
   - Alternatives: 새 파일 생성 -- 추가 참조 포인트 증가, 복잡도 상승
   - Trade-offs: ui-styling.md가 700줄 이상이 될 수 있음 -- 필요 시 섹션 분리 검토

4. **예제 보고서는 docs/plans/reports/에 EXAMPLE-* 형태로 배치** (2026-03-12)
   - Rationale: 스킬 디렉토리 안에 넣으면 스킬 매칭 시 불필요하게 로드될 수 있음. reports/에 두면 독립 참조 가능
   - Alternatives: 각 스킬 폴더 내 examples/ -- 스킬 크기 증가
   - Trade-offs: 스킬에서 예제까지 경로가 길어지나, SKILL.md에 경로 명시로 해결

## nextjs-frontend-guidelines 중복 분석

### ui-styling.md vs styling-guide.md
- **공통**: shadcn/ui 개요, cn() 유틸리티, Tailwind CSS 기본, 반응형 패턴
- **ui-styling.md 고유**: YGS 프로젝트 특화 컴포넌트 목록, 폼 패턴
- **styling-guide.md 고유**: shadcn/ui 설치 방법, CSS 변수 커스터마이징, 다크모드 패턴, 고급 Tailwind 유틸리티
- **통합 전략**: styling-guide.md의 고유 섹션(설치, CSS 변수, 다크모드, 고급 유틸리티)을 ui-styling.md 하단에 "Advanced Styling" 섹션으로 추가

### app-router.md vs routing-guide.md
- **공통**: 파일 기반 라우팅, 동적 라우트 기본
- **app-router.md 고유**: YGS 앱 구조, 레이아웃 패턴, 에러/로딩 바운더리, 상수/enum 패턴
- **routing-guide.md 고유**: 기본 라우팅 문법 설명 (제네릭)
- **통합 전략**: routing-guide.md의 제네릭 라우팅 문법을 app-router.md의 "Basic Routes" 섹션으로 통합 (이미 대부분 중복)

## vercel-react-best-practices 재작성 구조

### SKILL.md 목표 구조
```
- Frontmatter (description)
- Purpose + When to Apply
- Quick Start (성능 기준 연결: LCP <2000ms 등)
- 카테고리별 섹션 (8개)
  - 각 섹션: 개요 + 대표 규칙 Before/After + resources/ 링크
- Navigation Guide 테이블
- rules/ 개별 규칙 참조 방법 안내
```

### resources/ 파일별 내용 구성
```
각 파일:
- 카테고리 개요
- 해당 카테고리 전체 규칙 상세 (rules/ 내용 통합 + 보강)
- 모든 규칙에 Before/After 코드 예제
- 프로젝트 성능 기준과의 연결점
- 관련 nextjs-frontend-guidelines resources/ 크로스 참조
```

## Testing Notes

- 각 SKILL.md 수정 후 frontmatter `description` 필드가 유효한지 확인
- 모든 내부 링크(resources/, references/, rules/)가 유효한 파일을 가리키는지 검증
- 중복 파일 삭제 후 skill.md의 참조가 깨지지 않았는지 확인

## Known Issues

- vercel-react-best-practices의 기존 rules/ 파일 내용 품질이 들쭉날쭉 (일부는 async-parallel.md처럼 간결하고 좋지만, 다른 파일은 확인 필요)
- web-design-guidelines의 references/guidelines.md가 Vercel의 web-interface-guidelines 원본을 기반으로 하므로, Design Quality 규칙 추가 시 원본과의 구분 명확히 할 것
