# Skill Improvement - Task Checklist

## Status Legend
- [ ] Not started
- [x] Complete
- [B] Blocked
- [S] Skipped

## Progress Summary
0 / 15 tasks complete (0%)

---

## Phase 1: P0 -- 핵심 스킬 정상화 (3-4일)

### 1.1 vercel-react-best-practices SKILL.md 전면 재작성
- [ ] SKILL.md 전면 재작성
  - File: `.claude/skills/vercel-react-best-practices/SKILL.md`
  - Details:
    - Frontmatter description 유지 (현재 것 양호)
    - Purpose + When to Apply 섹션 재작성
    - 프로젝트 성능 기준 연결 섹션 추가 (LCP <2000ms, FCP <1000ms, CLS <0.1, TTI <2500ms, TBT <300ms)
    - 8개 카테고리별 섹션 재구성: 각 카테고리에 개요 1-2문장 + 대표 규칙 1-2개의 Before/After 코드 예제 + `resources/` 링크
    - Navigation Guide 테이블 추가 (카테고리 -> resources/ 파일 매핑)
    - 기존 Quick Reference의 규칙 이름 나열은 제거하고 resources/로 이동
    - rules/ 개별 규칙 참조 방법 안내 유지
  - Acceptance: SKILL.md에 카테고리당 최소 1개 Before/After 코드 예제 존재. SKILL.md 총 길이 200-350줄 범위
  - Size: XL
  - Dependencies: 1.2 (resources/ 파일 생성)와 병렬 진행 가능하나, 최종 링크 확인은 1.2 완료 후

### 1.2 vercel-react-best-practices resources/ 카테고리별 가이드 생성
- [ ] `resources/eliminating-waterfalls.md` 생성
  - File: `.claude/skills/vercel-react-best-practices/resources/eliminating-waterfalls.md`
  - Details: async-defer-await, async-parallel, async-dependencies, async-api-routes, async-suspense-boundaries 5개 규칙. 각 규칙에 설명 + Before/After 코드 + 추가 컨텍스트. rules/ 원본 내용 기반으로 보강
  - Acceptance: 5개 규칙 모두 Before/After 코드 예제 포함
  - Size: L
  - Dependencies: 없음

- [ ] `resources/bundle-optimization.md` 생성
  - File: `.claude/skills/vercel-react-best-practices/resources/bundle-optimization.md`
  - Details: bundle-barrel-imports, bundle-dynamic-imports, bundle-defer-third-party, bundle-conditional, bundle-preload 5개 규칙
  - Acceptance: 5개 규칙 모두 Before/After 코드 예제 포함
  - Size: L
  - Dependencies: 없음

- [ ] `resources/server-performance.md` 생성
  - File: `.claude/skills/vercel-react-best-practices/resources/server-performance.md`
  - Details: server-auth-actions, server-cache-react, server-cache-lru, server-dedup-props, server-serialization, server-parallel-fetching, server-after-nonblocking 7개 규칙
  - Acceptance: 7개 규칙 모두 Before/After 코드 예제 포함
  - Size: L
  - Dependencies: 없음

- [ ] `resources/client-data-fetching.md` 생성
  - File: `.claude/skills/vercel-react-best-practices/resources/client-data-fetching.md`
  - Details: client-swr-dedup, client-event-listeners, client-passive-event-listeners, client-localstorage-schema 4개 규칙
  - Acceptance: 4개 규칙 모두 Before/After 코드 예제 포함
  - Size: M
  - Dependencies: 없음

- [ ] `resources/rerender-optimization.md` 생성
  - File: `.claude/skills/vercel-react-best-practices/resources/rerender-optimization.md`
  - Details: rerender-defer-reads, rerender-memo, rerender-memo-with-default-value, rerender-dependencies, rerender-derived-state, rerender-derived-state-no-effect, rerender-functional-setstate, rerender-lazy-state-init, rerender-simple-expression-in-memo, rerender-move-effect-to-event, rerender-transitions, rerender-use-ref-transient-values 12개 규칙
  - Acceptance: 12개 규칙 모두 Before/After 코드 예제 포함
  - Size: XL
  - Dependencies: 없음

- [ ] `resources/rendering-performance.md` 생성
  - File: `.claude/skills/vercel-react-best-practices/resources/rendering-performance.md`
  - Details: rendering-animate-svg-wrapper, rendering-content-visibility, rendering-hoist-jsx, rendering-svg-precision, rendering-hydration-no-flicker, rendering-hydration-suppress-warning, rendering-activity, rendering-conditional-render, rendering-usetransition-loading 9개 규칙
  - Acceptance: 9개 규칙 모두 Before/After 코드 예제 포함
  - Size: L
  - Dependencies: 없음

- [ ] `resources/javascript-performance.md` 생성
  - File: `.claude/skills/vercel-react-best-practices/resources/javascript-performance.md`
  - Details: js-batch-dom-css, js-index-maps, js-cache-property-access, js-cache-function-results, js-cache-storage, js-combine-iterations, js-length-check-first, js-early-exit, js-hoist-regexp, js-min-max-loop, js-set-map-lookups, js-tosorted-immutable 12개 규칙
  - Acceptance: 12개 규칙 모두 Before/After 코드 예제 포함
  - Size: XL
  - Dependencies: 없음

- [ ] `resources/advanced-patterns.md` 생성
  - File: `.claude/skills/vercel-react-best-practices/resources/advanced-patterns.md`
  - Details: advanced-event-handler-refs, advanced-init-once, advanced-use-latest 3개 규칙
  - Acceptance: 3개 규칙 모두 Before/After 코드 예제 포함
  - Size: M
  - Dependencies: 없음

### 1.3 nextjs-frontend-guidelines 중복 파일 통합
- [ ] ui-styling.md + styling-guide.md 통합
  - File: `.claude/skills/nextjs-frontend-guidelines/resources/ui-styling.md`
  - Details:
    - styling-guide.md의 고유 콘텐츠 식별: shadcn/ui 설치 상세, CSS 변수 커스터마이징, 다크모드 패턴, 고급 Tailwind 유틸리티
    - 해당 내용을 ui-styling.md 하단에 "Advanced Styling" 섹션으로 추가
    - 중복 내용(shadcn/ui 개요, cn() 기본, 반응형 패턴)은 ui-styling.md 버전 유지
    - styling-guide.md 삭제
  - Acceptance: ui-styling.md에 styling-guide.md의 고유 콘텐츠 포함. styling-guide.md 삭제됨
  - Size: M
  - Dependencies: 1.4 (skill.md 갱신)

- [ ] app-router.md + routing-guide.md 통합
  - File: `.claude/skills/nextjs-frontend-guidelines/resources/app-router.md`
  - Details:
    - routing-guide.md(140줄)의 고유 콘텐츠 식별 (대부분 app-router.md와 중복 예상)
    - 고유 내용만 app-router.md에 병합
    - routing-guide.md 삭제
  - Acceptance: app-router.md에 routing-guide.md의 고유 콘텐츠 포함. routing-guide.md 삭제됨
  - Size: S
  - Dependencies: 1.4 (skill.md 갱신)

### 1.4 nextjs-frontend-guidelines skill.md Navigation Guide 갱신
- [ ] skill.md Navigation Guide 테이블 및 참조 링크 업데이트
  - File: `.claude/skills/nextjs-frontend-guidelines/skill.md`
  - Details:
    - Navigation Guide 테이블에서 styling-guide.md, routing-guide.md 행 제거
    - "Style components / forms" 행의 참조를 ui-styling.md로 단일화
    - "Set up routing" 행의 참조를 app-router.md로 단일화
    - 본문 내 `resources/styling-guide.md`, `resources/routing-guide.md` 참조 링크 모두 제거 또는 갱신
    - "Essential vs Advanced" 구분 추가: Navigation Guide 테이블을 "Essential Guides"와 "Advanced Guides" 두 섹션으로 분리
  - Acceptance: skill.md에 삭제된 파일 참조 0개. Navigation Guide에 Essential/Advanced 구분 존재
  - Size: S
  - Dependencies: 1.3 완료 후

---

## Phase 2: P1 -- 스킬 품질 보강 (2일)

### 2.1 web-design-guidelines Design Quality 규칙 추가
- [ ] references/guidelines.md에 Design Quality 섹션 추가
  - File: `.claude/skills/web-design-guidelines/references/guidelines.md`
  - Details:
    - 기존 규칙 카테고리 (Accessibility, Focus States, Forms, Animation, Typography, Content Handling, Images, Performance) 뒤에 "Design Quality" 섹션 추가
    - 포함할 규칙: 색상 대비 (WCAG AA 4.5:1), 타이포그래피 스케일 (일관된 font-size 계단), 컴포넌트 시각 일관성 (border-radius, shadow, spacing 통일), 간격 시스템 (4px/8px 기반 그리드), 색상 팔레트 제한 (주 3-5색)
    - 각 규칙에 Bad/Good 코드 예제 추가
  - Acceptance: Design Quality 섹션에 규칙 5개 이상, 각각 Bad/Good 예제 포함
  - Size: L
  - Dependencies: 없음

- [ ] 기존 규칙에 Bad/Good 예제 추가
  - File: `.claude/skills/web-design-guidelines/references/guidelines.md`
  - Details:
    - 기존 8개 카테고리 중 예제가 없는 규칙에 주요 Bad/Good 코드 예제 추가
    - 모든 카테고리에 최소 1개 Bad/Good 예제 보장
    - 현재 규칙은 한 줄 설명만 있는 상태 -> 가장 영향력 큰 규칙 위주로 코드 예제 보강
  - Acceptance: 모든 카테고리에 최소 1개 Bad/Good 예제 존재
  - Size: L
  - Dependencies: 없음

### 2.2 frontend-design <-> web-design-guidelines 워크플로우 연결
- [ ] frontend-design SKILL.md에 검수 안내 추가
  - File: `.claude/skills/frontend-design/SKILL.md`
  - Details:
    - "## Related Skills" 또는 "## Post-Creation Checklist" 섹션 추가
    - "UI 생성 후 web-design-guidelines 스킬로 접근성/UX 검수 권장" 명시
    - 검수 시 사용할 트리거 문구 예시 포함
  - Acceptance: SKILL.md에 web-design-guidelines 검수 권장 문구 존재
  - Size: S
  - Dependencies: 없음

- [ ] web-design-guidelines SKILL.md에 생성 워크플로우 연결 추가
  - File: `.claude/skills/web-design-guidelines/SKILL.md`
  - Details:
    - "## Related Skills" 섹션 추가
    - "frontend-design 스킬과 함께 사용: 생성(frontend-design) -> 검수(web-design-guidelines) 워크플로우" 명시
  - Acceptance: SKILL.md에 frontend-design 연결 문구 존재
  - Size: S
  - Dependencies: 없음

---

## Phase 3: P2 -- 보강 및 예제 (2-3일)

### 3.1 프로젝트 관리 스킬 예제 보고서
- [ ] area-deep-dive 예제 보고서 작성
  - File: `docs/plans/reports/EXAMPLE-area-deep-dive.md`
  - Details:
    - QWarty 프로젝트의 실제 도메인(예: auth 또는 curai)을 대상으로 한 예제 보고서
    - area-deep-dive SKILL.md의 출력 형식을 따라 작성
    - SKILL.md에 "예제 보고서: `docs/plans/reports/EXAMPLE-area-deep-dive.md`" 참조 추가
  - Acceptance: 보고서가 SKILL.md 출력 형식과 일치. SKILL.md에 참조 링크 존재
  - Size: L
  - Dependencies: 없음

- [ ] project-health-check 예제 보고서 작성
  - File: `docs/plans/reports/EXAMPLE-project-health-check.md`
  - Details:
    - QWarty 프로젝트 전체를 대상으로 한 예제 건강 점검 보고서
    - project-health-check SKILL.md의 출력 형식을 따라 작성
    - SKILL.md에 예제 참조 추가
  - Acceptance: 보고서가 SKILL.md 출력 형식과 일치. SKILL.md에 참조 링크 존재
  - Size: L
  - Dependencies: 없음

- [ ] project-report 예제 보고서 작성
  - File: `docs/plans/reports/EXAMPLE-project-report.md`
  - Details:
    - QWarty 프로젝트의 스테이크홀더 대상 예제 보고서
    - project-report SKILL.md의 출력 형식을 따라 작성
    - SKILL.md에 예제 참조 추가
  - Acceptance: 보고서가 SKILL.md 출력 형식과 일치. SKILL.md에 참조 링크 존재
  - Size: L
  - Dependencies: 없음

### 3.2 문서 스킬 의존성 설치 가이드
- [ ] docx SKILL.md에 Setup/Dependencies 섹션 추가
  - File: `.claude/skills/docx/SKILL.md`
  - Details:
    - "## Setup & Dependencies" 섹션을 Quick Reference 앞에 삽입
    - macOS: `brew install pandoc` + `npm install -g docx-js` (또는 해당 스킬이 사용하는 실제 도구)
    - Ubuntu: `apt-get install pandoc` + npm 설치
    - Python: `pip install python-docx` (해당 시)
    - 실제 SKILL.md 본문에서 사용하는 도구를 기반으로 정확한 의존성 나열
  - Acceptance: Setup 섹션에 macOS/Ubuntu 설치 명령어 포함
  - Size: S
  - Dependencies: 없음

- [ ] pdf SKILL.md에 Setup/Dependencies 섹션 추가
  - File: `.claude/skills/pdf/SKILL.md`
  - Details: docx와 동일 패턴. pypdf, reportlab, poppler-utils 등 실제 사용 도구 기반
  - Acceptance: Setup 섹션에 macOS/Ubuntu 설치 명령어 포함
  - Size: S
  - Dependencies: 없음

- [ ] pptx SKILL.md에 Setup/Dependencies 섹션 추가
  - File: `.claude/skills/pptx/SKILL.md`
  - Details: python-pptx, markitdown, pandoc 등 실제 사용 도구 기반
  - Acceptance: Setup 섹션에 macOS/Ubuntu 설치 명령어 포함
  - Size: S
  - Dependencies: 없음

- [ ] mermaid SKILL.md에 Setup/Dependencies 섹션 추가
  - File: `.claude/skills/mermaid/SKILL.md`
  - Details: mermaid-cli(mmdc), puppeteer/playwright 등 렌더링 의존성
  - Acceptance: Setup 섹션에 macOS/Ubuntu 설치 명령어 포함
  - Size: S
  - Dependencies: 없음

---

## Deployment Checklist
- [ ] 모든 SKILL.md frontmatter description 필드 유효성 확인
- [ ] 모든 내부 링크(resources/, references/, rules/) 유효 파일 지향 확인
- [ ] 삭제 파일(styling-guide.md, routing-guide.md) 참조가 코드베이스 어디에도 남지 않음 확인
- [ ] 기존 rules/ 57개 파일이 손상 없이 유지됨 확인

## Notes
- vercel-react-best-practices의 resources/ 파일 작성 시 기존 rules/ 원본 내용을 기반으로 하되, 설명 보강 + 프로젝트 맥락 추가
- nextjs-frontend-guidelines 통합 시 styling-guide.md(473줄)의 내용이 많으므로 ui-styling.md가 비대해질 수 있음 -- 필요 시 "Basic" / "Advanced" 서브 헤딩으로 구조화
- 문서 스킬 의존성은 각 SKILL.md 본문에서 실제 사용하는 도구를 읽고 정확히 반영할 것 (추측 금지)
