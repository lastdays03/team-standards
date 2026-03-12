# Claude Code Skills 전체 분석 및 평가 보고서

> **Date:** 2026-03-12
> **Scope:** `.claude/skills/` 전체 16개 스킬
> **Analyst:** Claude Code

---

## Executive Summary

16개 스킬을 7가지 차원(description 트리거링, 콘텐츠 구조, 깊이/완성도, 실용성, 리소스 구성, 프로젝트 정합성, 이식성)에서 분석했다. 전반적으로 높은 수준의 스킬셋이나, 일부 스킬은 프로젝트 특화/범용 사이의 정체성 혼란, description 과잉/과소, 또는 외부 의존성 미검증 문제가 있다.

---

## 평가 기준

| 차원 | 설명 | 배점 |
|------|------|------|
| **Description 트리거링** | 적절한 상황에서 정확히 활성화되는가 | A-D |
| **콘텐츠 구조** | Progressive disclosure, 가독성, 500줄 권장 준수 | A-D |
| **깊이/완성도** | 주제에 대한 충분한 커버리지 | A-D |
| **실용성** | 실제 작업 시 즉시 활용 가능한가 | A-D |
| **리소스 구성** | 번들 리소스(scripts, references) 품질 | A-D |
| **프로젝트 정합성** | YGS/QWarty 프로젝트와의 연결성 | A-D |
| **이식성** | 다른 프로젝트에 재사용 가능한가 | A-D |

---

## Summary Dashboard

| # | Skill | Lines | Resources | 종합 | 핵심 평가 |
|---|-------|-------|-----------|------|-----------|
| 1 | fastapi-backend-guidelines | 656 | 10 files | **A** | 모범적 구조, 프로젝트 최적화 |
| 2 | nextjs-frontend-guidelines | 328 | 13 files | **A** | 모듈형 설계 우수 |
| 3 | pytest-backend-testing | 520 | 7 files | **A-** | 체계적, 약간 길음 |
| 4 | area-deep-dive | 202 | - | **A-** | 깊이 있는 분석 워크플로우 |
| 5 | pptx | 489 | 다수 | **B+** | 기능 풍부하나 복잡도 높음 |
| 6 | docx | 481 | scripts/ | **B+** | 실전적이나 거의 500줄 한계 |
| 7 | pdf | 314 | scripts/, refs | **B+** | 균형 잡힌 도구 가이드 |
| 8 | vercel-react-best-practices | 136 | 57 rules | **B+** | 우수한 레퍼런스, 외부 출처 |
| 9 | project-health-check | 203 | - | **B** | 실용적 체크리스트 |
| 10 | project-report | 165 | - | **B** | 간결하고 목적 명확 |
| 11 | mermaid | 201 | 30 refs | **B** | 좋은 레퍼런스 허브 |
| 12 | error-tracking | 309 | - | **B-** | 테크 스택 불일치 |
| 13 | frontend-design | 42 | - | **B-** | 영감 제공용, 얕음 |
| 14 | ppt-brand-guidelines | 197 | assets/ | **C+** | 특정 브랜드 한정 |
| 15 | brand-guidelines | 73 | - | **C+** | 특정 브랜드 한정, 매우 짧음 |
| 16 | web-design-guidelines | 39 | - | **C** | 외부 URL 의존, 본체 부재 |

---

## 개별 스킬 상세 분석

---

### 1. fastapi-backend-guidelines

| 차원 | 등급 | 평가 |
|------|------|------|
| Description 트리거링 | **A** | 핵심 키워드(API, routes, services, repositories, backend) 포괄적 |
| 콘텐츠 구조 | **A** | Quick Start 체크리스트 → 토픽별 요약 → resources 참조의 3단계 구조 |
| 깊이/완성도 | **A** | Router/Service/Repository 3계층 + DDD + DTO + async + error 전부 커버 |
| 실용성 | **A** | "New Domain Template"으로 즉시 코드 생성 가능 |
| 리소스 구성 | **A** | 10개 리소스 파일로 모듈형 Progressive Disclosure 구현 |
| 프로젝트 정합성 | **A** | YGS 도메인(user, auth, admin, match, llm) 직접 반영 |
| 이식성 | **B** | 패턴은 범용이나 YGS 특화 구조/경로가 하드코딩 |

**강점:**
- **Progressive Disclosure의 교과서적 구현**. SKILL.md(656줄)가 허브 역할을 하고, 10개 resources 파일로 깊이를 분산. 각 토픽은 2-3줄 요약 + "Complete Guide" 링크 패턴으로 일관성 있음
- Quick Start의 체크리스트 패턴이 실전에서 바로 쓸 수 있는 "New API Route / New Domain Feature" 형태
- 코드 예제가 실제 프로젝트 구조(backend/domain/...)를 반영해 contextual

**개선 기회:**
- 656줄로 500줄 권장을 초과. Common Imports 섹션이나 Quick Reference 템플릿을 별도 resources로 분리 권장
- 이식성을 위해 프로젝트 특화 경로(`backend/domain/user/...`)를 placeholder화하는 방안 검토
- description에 한국어 트리거("백엔드 개발", "API 만들기") 추가 시 한국어 사용자 매칭 개선 가능

---

### 2. nextjs-frontend-guidelines

| 차원 | 등급 | 평가 |
|------|------|------|
| Description 트리거링 | **A** | 프레임워크 + 기능(components, pages, styling, auth) 모두 명시 |
| 콘텐츠 구조 | **A** | fastapi 스킬과 동일한 허브+리소스 패턴, 일관성 우수 |
| 깊이/완성도 | **A** | Server/Client 컴포넌트, Auth, 데이터 페칭, shadcn/ui 등 전방위 |
| 실용성 | **A** | Import Cheatsheet와 Project Structure가 즉시 참조 가능 |
| 리소스 구성 | **A** | 13개 리소스 파일, 토픽별 명확 분리 |
| 프로젝트 정합성 | **A** | YGS의 실제 컴포넌트/라우팅 구조 반영 |
| 이식성 | **B-** | YGS 브랜드(Coral/Orange), 한국어 UI 등 프로젝트 특화 |

**강점:**
- fastapi-backend-guidelines와 **동일한 설계 패턴**(허브+체크리스트+리소스 링크)을 사용해 스킬 간 일관성이 뛰어남
- "Server vs Client" 의사결정 가이드가 실전에서 가장 빈번한 질문을 정확히 답변
- Navigation Guide 테이블이 "Need to..." 형식으로 작업 지향적

**개선 기회:**
- YGS 특화 내용(Firebase/Kakao 인증, 관리자 대시보드 패턴)과 범용 Next.js 패턴의 경계가 모호. 이식 시 혼란 가능
- description이 매우 긴 편(328자). 핵심 트리거만 남기고 세부 사항은 "When to Use" 섹션에 위임 가능

---

### 3. pytest-backend-testing

| 차원 | 등급 | 평가 |
|------|------|------|
| Description 트리거링 | **A** | "test", "testing", "pytest", "coverage" 등 핵심 키워드 포함 |
| 콘텐츠 구조 | **A-** | 체크리스트+패턴+리소스 일관 구조, 다만 520줄로 약간 길음 |
| 깊이/완성도 | **A** | unit/integration/async/mocking/coverage/FastAPI 테스팅 전부 |
| 실용성 | **A** | Quick Reference 테스트 패턴과 full template이 copy-paste 가능 |
| 리소스 구성 | **A-** | 7개 리소스 (testing-architecture, unit, integration, async, mocking, coverage, fastapi) |
| 프로젝트 정합성 | **A** | pyproject.toml 설정까지 반영 |
| 이식성 | **B+** | FastAPI + pytest 조합이면 대부분 재활용 가능 |

**강점:**
- "Quick Reference: Test Template" 섹션이 전체 테스트 파일의 스캐폴딩을 제공해 신규 테스트 작성 시간 대폭 단축
- AAA(Arrange-Act-Assert) 패턴, 네이밍 컨벤션(`test_<what>_<when>_<expected>`) 등 **팀 표준으로 기능**
- Coverage 목표(80%)와 실행 명령어가 구체적

**개선 기회:**
- 520줄로 500줄 권장 초과. "Quick Reference: Test Template"(약 100줄)을 별도 리소스로 분리 권장
- "Current Project Configuration" 섹션이 프로젝트 특화. 이식 시 수정 필요
- E2E/Playwright 테스트 가이드가 프론트엔드에만 있고 백엔드 API E2E는 없음

---

### 4. area-deep-dive

| 차원 | 등급 | 평가 |
|------|------|------|
| Description 트리거링 | **A** | 한국어/영어 트리거 모두 포함, 유사 스킬(health-check, project-report) 구분 명확 |
| 콘텐츠 구조 | **A** | Step 0-3의 명확한 워크플로우, 6 Dimensions 분석 프레임워크 |
| 깊이/완성도 | **A-** | 분석 차원이 체계적이나, 자동화 스크립트/도구 지원은 없음 |
| 실용성 | **A** | 리포트 템플릿이 즉시 사용 가능, Mermaid 다이어그램 포함 |
| 리소스 구성 | **B** | 번들 리소스 없음 (단일 SKILL.md만) |
| 프로젝트 정합성 | **A** | CLAUDE.md 참조, docs/plans/reports/ 저장 경로 |
| 이식성 | **A** | 프레임워크 무관, 범용적 분석 워크플로우 |

**강점:**
- **스킬 간 역할 구분이 모범적**: health-check(broad+shallow), deep-dive(narrow+deep), project-report(external) 3종의 관계를 description과 본문 모두에서 명시
- "Supported Areas" 테이블이 area별 탐색 방법(Glob/Grep 패턴)을 구체적으로 안내
- 6 Dimensions(Architecture, Data Flow, Code Quality, Test Coverage, Dependencies, Risks) 프레임워크가 체계적

**개선 기회:**
- 리포트 템플릿의 rating(GREEN/YELLOW/RED)이 주관적. 정량 기준 제시 권장
- 대규모 코드베이스에서의 실행 시간 관리 가이드 부재
- Step 1에서 "spawn multiple Explore agents"라고 했지만 구체적 병렬화 패턴 미제시

---

### 5. pptx

| 차원 | 등급 | 평가 |
|------|------|------|
| Description 트리거링 | **B+** | ".pptx" 키워드 중심, 다만 "프레젠테이션 만들어줘" 같은 자연어 트리거 부족 |
| 콘텐츠 구조 | **B** | 3가지 워크플로우(새 생성/편집/템플릿)가 명확하나, 489줄로 밀도 높음 |
| 깊이/완성도 | **A** | HTML→PPTX 변환, OOXML 편집, 템플릿 기반 생성까지 전부 커버 |
| 실용성 | **A** | scripts/(html2pptx, thumbnail, inventory, replace, rearrange) 풍부 |
| 리소스 구성 | **A** | html2pptx.md, ooxml.md, designs/, ooxml/scripts/ 체계적 |
| 프로젝트 정합성 | **C** | YGS 프로젝트와 직접 관련 없는 범용 도구 |
| 이식성 | **A** | 프로젝트 무관, 독립 동작 |

**강점:**
- **가장 풍부한 번들 리소스**: scripts 5개, 참조 문서 2개(html2pptx.md 20K, ooxml.md 10K), 디자인 템플릿까지
- 색상 팔레트 19종 제공으로 디자인 다양성 보장
- 워크플로우가 명확하고 순서대로 따라가면 결과물 생성 가능
- Visual validation(thumbnail 검증) 단계가 품질 보증에 기여

**개선 기회:**
- 489줄의 SKILL.md에 "MANDATORY - READ ENTIRE FILE"로 html2pptx.md와 ooxml.md 추가 읽기를 요구. 실질적 context 부담 높음
- 외부 의존성(LibreOffice, Poppler, pptxgenjs, playwright) 많음. 설치 확인/자동화 필요
- description에 한국어 트리거와 자연어("슬라이드 만들어줘", "발표자료 작성") 추가 권장

---

### 6. docx

| 차원 | 등급 | 평가 |
|------|------|------|
| Description 트리거링 | **A** | 매우 상세. "Word doc", ".docx", 문서 유형(report, memo, letter), 작업 유형(tracked changes, comments) 모두 포함 |
| 콘텐츠 구조 | **B+** | Quick Reference 테이블 → 생성 → 편집 → XML Reference 순서 논리적 |
| 깊이/완성도 | **A** | docx-js API, OOXML XML 편집, tracked changes, comments까지 심층 |
| 실용성 | **A** | 코드 예제가 즉시 실행 가능, "Critical Rules" 섹션이 pitfall 방지 |
| 리소스 구성 | **A-** | scripts/(unpack, pack, validate, comment, soffice, accept_changes) |
| 프로젝트 정합성 | **C** | YGS와 직접 관련 없음 |
| 이식성 | **A** | 범용 도구, 프로젝트 무관 |

**강점:**
- "Critical Rules for docx-js" 섹션이 **실수 방지에 특화**. "NEVER use `\n`", "NEVER use unicode bullets" 등 경험 기반 가드레일
- "Editing Existing Documents" 3단계(Unpack → Edit XML → Pack)가 명쾌
- Tracked Changes와 Comments의 XML 패턴이 매우 상세

**개선 기회:**
- 481줄로 500줄 한계 근접. Page Size 테이블이나 XML Reference를 별도 리소스로 분리 가능
- pandoc, LibreOffice 등 외부 의존성 설치 확인 로직 부재
- description이 과도하게 길음(345자). "DO NOT use" 네거티브 조건이 많아 트리거링 복잡도 증가

---

### 7. pdf

| 차원 | 등급 | 평가 |
|------|------|------|
| Description 트리거링 | **A** | PDF 관련 모든 작업(읽기, 합치기, 분리, 회전, 워터마크, OCR 등) 열거 |
| 콘텐츠 구조 | **A-** | Quick Start → 라이브러리별 가이드 → CLI → Quick Reference 테이블 |
| 깊이/완성도 | **B+** | pypdf, pdfplumber, reportlab, CLI 도구 커버. 고급 기능은 REFERENCE.md로 위임 |
| 실용성 | **A** | 코드 예제가 copy-paste 즉시 실행 가능 |
| 리소스 구성 | **A** | REFERENCE.md(16K), FORMS.md(12K), scripts/(8개) 풍부 |
| 프로젝트 정합성 | **C** | YGS와 직접 관련 없음 |
| 이식성 | **A** | 범용 PDF 처리, 프로젝트 무관 |

**강점:**
- "Quick Reference" 테이블이 작업→도구→코드 3열로 빠른 판단 가능
- subscript/superscript 주의사항 같은 **실전 pitfall**을 명시
- Progressive Disclosure 잘 구현: SKILL.md(기본) → REFERENCE.md(고급) → FORMS.md(양식)

**개선 기회:**
- Python 라이브러리(pypdf, pdfplumber, reportlab)의 버전 명시 부재
- OCR 기능(pytesseract)의 정확도 한계나 대안(EasyOCR 등) 미언급
- CLI 도구(qpdf, pdftk)의 설치 확인 로직 없음

---

### 8. vercel-react-best-practices

| 차원 | 등급 | 평가 |
|------|------|------|
| Description 트리거링 | **A-** | "performance", "render", "bundle size", "waterfall" 등 최적화 키워드 |
| 콘텐츠 구조 | **A** | 136줄의 간결한 허브. 우선순위별 8개 카테고리로 구조화 |
| 깊이/완성도 | **A** | 57개 규칙, 각각 별도 .md 파일에 예제 포함 |
| 실용성 | **A-** | 규칙 이름(async-parallel, bundle-barrel-imports)이 검색 가능하고 구체적 |
| 리소스 구성 | **A** | rules/ 디렉토리에 57개 개별 규칙 파일 + AGENTS.md(82K) 풀 문서 |
| 프로젝트 정합성 | **B+** | Next.js 프론트엔드에 직접 적용 가능 |
| 이식성 | **A** | React/Next.js 프로젝트 범용 |

**강점:**
- **57개 규칙의 우선순위 분류**가 탁월. CRITICAL → HIGH → MEDIUM → LOW 순서로 ROI 기반 적용 가능
- 규칙 네이밍 규칙(`{category}-{name}`)이 일관적이고 검색 친화적
- Vercel 공식 출처로 **권위성** 확보

**개선 기회:**
- AGENTS.md가 82K(약 2000줄)로 한번에 로드하면 context 부담 큼. 그러나 개별 rules/ 파일 참조 패턴이 이를 보완
- description에 한국어 트리거 없음
- YGS 프로젝트의 실제 성능 이슈와 연결하는 매핑 부재

---

### 9. project-health-check

| 차원 | 등급 | 평가 |
|------|------|------|
| Description 트리거링 | **A** | 한국어/영어 트리거 풍부, 유사 스킬 구분 명확 |
| 콘텐츠 구조 | **A-** | Step 0-3 워크플로우, 데이터 수집 → 분석 → 리포트 |
| 깊이/완성도 | **B+** | 6가지 점검 영역 커버, 다만 깊이는 shallow 의도 |
| 실용성 | **A** | 리포트 템플릿이 즉시 사용 가능, Trend 비교 기능 |
| 리소스 구성 | **B** | 번들 리소스 없음, 단일 SKILL.md |
| 프로젝트 정합성 | **A** | docs/plans/reports/ 저장 경로, CLAUDE.md 동적 참조 |
| 이식성 | **A** | CLAUDE.md 기반 동적 탐지로 프로젝트 무관 적용 가능 |

**강점:**
- **CLAUDE.md 기반 동적 명령어 결정**이 핵심 차별점. 프로젝트 구조를 먼저 읽고 적절한 test/lint/build 명령을 결정
- Scoring 기준(GREEN/YELLOW/RED)이 구체적 수치 기반
- "Trend (vs Previous)" 섹션으로 시계열 비교 가능
- "2분 이내 완료" 실행 시간 목표 명시

**개선 기회:**
- "Code Pattern Analysis" 테이블의 패턴이 Python/TypeScript 혼합. 프로젝트 자동 감지로 필터링 권장
- Security advisory 체크(`npm audit`, `pip-audit`)의 구체적 명령어 미제시
- health-check 자동화(hook이나 cron 연동) 가이드 추가 가능

---

### 10. project-report

| 차원 | 등급 | 평가 |
|------|------|------|
| Description 트리거링 | **A** | "stakeholder", "progress", "milestone", 한국어 트리거 포함 |
| 콘텐츠 구조 | **A** | 165줄로 간결, 워크플로우와 템플릿이 명확 |
| 깊이/완성도 | **B+** | 외부 보고서 목적에 충실, 기술 세부사항은 의도적 배제 |
| 실용성 | **A-** | 리포트 템플릿이 스캔 가능하고 비개발자 친화적 |
| 리소스 구성 | **B** | 번들 리소스 없음, 단일 SKILL.md |
| 프로젝트 정합성 | **A** | docs/plans/done/ 활용, git 히스토리 기반 메트릭 |
| 이식성 | **A** | 프로젝트 무관 적용 가능 |

**강점:**
- **Key Principles의 "Audience-aware"**가 핵심. "RAG pipeline with semantic routing" → "AI-powered legal guidance chatbot"으로 번역하라는 지침이 실전적
- "Derive features from done/ folder" 지침으로 완료 기능 자동 수집
- health-check과 역할 구분이 명확 (internal vs external)

**개선 기회:**
- 시각적 요소(차트, 그래프) 생성 가이드 부재. mermaid 스킬과 연동 지침 추가 권장
- 자동 메트릭 수집 스크립트 번들링 검토
- "Risks & Dependencies" 섹션의 예제가 한 줄뿐. 더 구체적인 프레이밍 가이드 필요

---

### 11. mermaid

| 차원 | 등급 | 평가 |
|------|------|------|
| Description 트리거링 | **B+** | "Mermaid diagrams"와 다이어그램 유형 언급, 다만 "다이어그램 그려줘" 같은 자연어 부족 |
| 콘텐츠 구조 | **A** | 201줄의 허브, 23개 다이어그램 유형별 레퍼런스 링크 |
| 깊이/완성도 | **A** | 23개 다이어그램 유형 + 테마/설정 5개 레퍼런스 |
| 실용성 | **B+** | 다이어그램 유형 선택 테이블이 유용, 스타일 가이드라인 포함 |
| 리소스 구성 | **A** | references/ 30개 파일로 Progressive Disclosure 우수 |
| 프로젝트 정합성 | **B** | 문서화에 간접 활용 가능 |
| 이식성 | **A** | 범용 다이어그램 도구 |

**강점:**
- **23개 다이어그램 유형의 완전한 레퍼런스 허브**. references/ 디렉토리에 각 유형별 문법 가이드
- "NO COLOR STYLING" 기본 규칙이 일관된 시각적 스타일 보장
- mmdc PNG 생성을 위한 config.json 템플릿 2종(Business/Print) 제공

**개선 기회:**
- description에 한국어 트리거("다이어그램", "플로우차트", "시퀀스 다이어그램") 추가 권장
- "NO custom colors" 규칙이 때때로 과도한 제약. 사용자가 색상을 원할 때의 대안 경로 미제시
- `$ARGUMENTS` placeholder가 SKILL.md 마지막에 있으나, 실제 인자 처리 로직 불명확

---

### 12. error-tracking

| 차원 | 등급 | 평가 |
|------|------|------|
| Description 트리거링 | **B** | "error handling", "Sentry" 키워드 포함 |
| 콘텐츠 구조 | **B** | 패턴별 코드 예제, 체크리스트 포함 |
| 깊이/완성도 | **B+** | Controller/Route/Cron/DB 모니터링 패턴 커버 |
| 실용성 | **B-** | 코드가 Express 패턴이라 Next.js/FastAPI 모두 직접 적용 불가 |
| 리소스 구성 | **C** | 번들 리소스 없음, 단일 SKILL.md |
| 프로젝트 정합성 | **C** | **Express 패턴 기반이나, 프론트는 Next.js, 백엔드는 FastAPI** |
| 이식성 | **B** | Express 프로젝트에는 적용 가능, 다른 스택은 수정 필요 |

**강점:**
- "Common Mistakes to Avoid" 섹션의 네거티브 패턴 목록이 실수 방지에 유용
- Implementation Checklist가 코드 리뷰 시 체크리스트로 활용 가능
- Error Levels(fatal/error/warning/info/debug) 분류가 명확

**개선 기회:**
- **Express/Node.js 패턴과 프로젝트 스택 불일치**: `Sentry.Handlers.requestHandler()`, `BaseController` 등은 Express 전용 API. 프로젝트의 두 스택에 맞게 분리 필요:
  - **프론트엔드(Next.js)**: `@sentry/nextjs` 기반으로 재작성 — `sentry.client.config.ts`/`sentry.server.config.ts` 초기화, `instrumentation.ts`(Next.js 15), Server/Client Component별 에러 처리
  - **백엔드(FastAPI)**: Python `sentry-sdk[fastapi]` 기반으로 재작성 — `sentry_sdk.init()`, FastAPI integration, async 에러 캡처
- Express-specific 코드(`router.get`, `app.use(Sentry.Handlers...)`)가 Next.js App Router 패턴과 다름
- description의 "ALL ERRORS MUST BE CAPTURED TO SENTRY"가 과도하게 강제적

---

### 13. frontend-design

| 차원 | 등급 | 평가 |
|------|------|------|
| Description 트리거링 | **A-** | "web components", "landing pages", "dashboards", "styling" 등 포괄적 |
| 콘텐츠 구조 | **B-** | 42줄로 매우 짧음. 원칙 중심, 구체적 구현 패턴 부족 |
| 깊이/완성도 | **C+** | 디자인 철학은 전달하나, 코드 예제나 패턴 없음 |
| 실용성 | **B** | 영감과 방향성 제공, 실행은 모델 역량에 의존 |
| 리소스 구성 | **D** | 번들 리소스 전혀 없음 |
| 프로젝트 정합성 | **B** | 프론트엔드 UI 작업에 간접 적용 |
| 이식성 | **A** | 프로젝트 무관, 범용 디자인 가이드 |

**강점:**
- "Choose a clear conceptual direction and execute it with precision"이라는 핵심 원칙이 AI 생성 UI의 가장 큰 문제(bland sameness)를 정확히 겨냥
- "NEVER use generic AI-generated aesthetics" 지침이 Inter/Roboto/purple gradient 같은 cliché 방지

**개선 기회:**
- **42줄은 스킬로서 너무 짧음**. 구체적 코드 패턴, 색상 팔레트 예제, 레이아웃 템플릿 추가 필요
- pptx 스킬의 색상 팔레트 19종과 같은 구체적 참조 자료 부재
- "Don't hold back" 같은 추상적 지침보다 체크리스트나 디자인 시스템 템플릿이 더 유용
- nextjs-frontend-guidelines의 shadcn/ui, Tailwind CSS 4와의 연결 가이드 없음

---

### 14. ppt-brand-guidelines

| 차원 | 등급 | 평가 |
|------|------|------|
| Description 트리거링 | **B** | "PPT", "slides", "presentation" 키워드, 다만 VRL 특화 |
| 콘텐츠 구조 | **B+** | 색상 → 타이포그래피 → 레이아웃 → CSS 순서 논리적 |
| 깊이/완성도 | **B** | VRL 브랜드에 한정적이나, 해당 범위 내에서는 충분 |
| 실용성 | **B+** | 구체적 hex 값, font 크기, CSS 코드 즉시 사용 가능 |
| 리소스 구성 | **B+** | assets/logo.png, references/ 디렉토리 있음 |
| 프로젝트 정합성 | **D** | YGS/QWarty와 무관한 VRL 브랜드 |
| 이식성 | **D** | VRL 전용, 다른 프로젝트 재활용 불가 |

**강점:**
- "NEVER apply CSS filters to logo" 같은 **실수 방지 규칙**이 구체적이고 경험 기반
- DO/DON'T 리스트가 빠른 참조에 유용
- 슬라이드 레이아웃 5종(Title, Content, Stats, Table, Closing)이 ASCII 다이어그램으로 시각화

**개선 기회:**
- **VRL 전용 스킬이 이 프로젝트에 있는 이유 불명확**. 이식 템플릿으로의 전환 또는 제거 검토
- brand-guidelines(Anthropic)와 역할 중복 가능성
- pptx 스킬과의 통합 연동 가이드 부재. pptx 생성 시 이 브랜드를 자동 적용하는 워크플로우 없음

---

### 15. brand-guidelines

| 차원 | 등급 | 평가 |
|------|------|------|
| Description 트리거링 | **B** | "brand colors", "style guidelines", "Anthropic brand" 키워드 |
| 콘텐츠 구조 | **B-** | 73줄로 매우 짧고 간단 |
| 깊이/완성도 | **C** | 색상 7개 + 폰트 2개 + 적용 규칙 정도 |
| 실용성 | **B** | hex 값과 폰트 즉시 참조 가능 |
| 리소스 구성 | **C** | LICENSE.txt만 있음 |
| 프로젝트 정합성 | **D** | Anthropic 브랜드이며 YGS와 무관 |
| 이식성 | **D** | Anthropic 전용 |

**강점:**
- 심플하고 명확. 색상 7개, 폰트 2개로 빠르게 참조 가능
- RGBColor 클래스와 python-pptx 연동 언급

**개선 기회:**
- **73줄은 독립 스킬로서의 가치가 의문**. pptx나 ppt-brand-guidelines의 하위 리소스로 통합 가능
- Anthropic 브랜드 가이드라인이 이 프로젝트에 필요한 이유 불명확
- "Smart Font Application" 같은 기능 설명이 있으나 실제 구현 코드 없음
- ppt-brand-guidelines(VRL)와 함께 "브랜드 가이드라인" 카테고리의 정체성 혼란

---

### 16. web-design-guidelines

| 차원 | 등급 | 평가 |
|------|------|------|
| Description 트리거링 | **B** | "review UI", "check accessibility", "audit design" 명시 |
| 콘텐츠 구조 | **D** | 39줄, 실질적으로 빈 스킬. 외부 URL에 전적으로 의존 |
| 깊이/완성도 | **D** | 자체 콘텐츠 없음, WebFetch로 외부 가이드라인 다운로드 |
| 실용성 | **C** | 외부 URL이 유효할 때만 작동 |
| 리소스 구성 | **D** | 없음 |
| 프로젝트 정합성 | **B** | 프론트엔드 UI 리뷰에 활용 가능 |
| 이식성 | **B** | 범용이나, 외부 의존성 리스크 |

**강점:**
- Vercel Labs의 Web Interface Guidelines는 높은 품질의 외부 자원
- 항상 최신 버전을 fetch하는 설계 의도

**개선 기회:**
- **39줄 + 외부 URL 의존은 스킬로서 매우 취약**. URL이 변경되거나 다운되면 전체 기능 상실
- 가이드라인의 핵심 규칙을 로컬에 캐싱하는 references/ 파일 추가 필수
- vercel-react-best-practices와 역할이 겹칠 수 있음 (둘 다 Vercel 출처의 프론트엔드 베스트 프랙티스)
- 출력 포맷이 "file:line" 형식이라고 했지만, 실제 파서/포매터 없음

---

## 종합 분석

### 카테고리별 분류

| 카테고리 | 스킬 | 상태 |
|----------|------|------|
| **프로젝트 핵심** | fastapi-backend, nextjs-frontend, pytest-backend | 우수 |
| **프로젝트 분석** | area-deep-dive, project-health-check, project-report | 우수 |
| **문서 생성** | pptx, docx, pdf | 양호 |
| **성능/품질** | vercel-react, error-tracking, web-design | 혼재 |
| **디자인** | frontend-design, mermaid | 양호 |
| **브랜드** | brand-guidelines, ppt-brand-guidelines | 정리 필요 |

### 구조적 패턴 분석

**가장 잘 설계된 패턴 (모범 사례):**
1. **허브+리소스 패턴**: fastapi-backend, nextjs-frontend, pytest-backend, vercel-react
   - SKILL.md는 300줄 이내의 허브, 깊이는 resources/로 위임
   - 각 토픽이 2-3줄 요약 + "Complete Guide" 링크
2. **체크리스트 시작 패턴**: fastapi-backend, nextjs-frontend, pytest-backend
   - "New API Route Checklist", "New Component Checklist" 등 즉시 행동 가능
3. **역할 구분 패턴**: area-deep-dive, project-health-check, project-report
   - 3개 스킬이 서로의 경계를 description에서 명확히 선언

**개선이 필요한 패턴:**
1. **단일 파일 과부하**: error-tracking(309줄), area-deep-dive(202줄)는 리소스 분리 없이 SKILL.md 하나에 모든 것을 담음
2. **외부 의존 과다**: web-design-guidelines는 외부 URL에 100% 의존
3. **테크 스택 불일치**: error-tracking이 TypeScript/Express 코드인데 프로젝트는 FastAPI/Python

### 주요 권고사항

| 우선순위 | 조치 | 대상 스킬 | 효과 |
|----------|------|-----------|------|
| **P0** | error-tracking을 2개 섹션으로 분리 재작성: Next.js(`@sentry/nextjs`) + FastAPI(`sentry-sdk[fastapi]`) | error-tracking | 테크 스택 정합성 복원 |
| **P0** | web-design-guidelines에 로컬 레퍼런스 추가 | web-design-guidelines | 외부 의존성 제거 |
| **P1** | brand-guidelines를 pptx의 하위 리소스로 통합 | brand-guidelines | 스킬 수 최적화 |
| **P1** | ppt-brand-guidelines의 프로젝트 내 역할 재정의 | ppt-brand-guidelines | 정체성 명확화 |
| **P1** | frontend-design에 구체적 패턴/템플릿 추가 | frontend-design | 실용성 강화 |
| **P2** | fastapi-backend, pytest-backend의 프로젝트 특화 부분을 범용/특화 분리 | 2개 스킬 | 이식성 향상 |
| **P2** | 모든 스킬 description에 한국어 트리거 추가 | 전체 | 한국어 사용자 매칭률 향상 |
| **P2** | 500줄 초과 스킬(fastapi 656줄, pytest 520줄)의 리소스 분리 | 2개 스킬 | 권장 구조 준수 |

---

## 이식성 평가

"다른 프로젝트에 그대로 가져다 쓸 수 있는가?" 기준:

| 등급 | 스킬 | 비고 |
|------|------|------|
| **즉시 이식 가능** | pptx, docx, pdf, mermaid, frontend-design, vercel-react | 프로젝트 무관 범용 도구 |
| **약간의 수정 필요** | area-deep-dive, project-health-check, project-report, pytest-backend | CLAUDE.md 기반 동적 탐지로 대부분 자동 적응 |
| **상당한 수정 필요** | fastapi-backend, nextjs-frontend, error-tracking | YGS 특화 경로/구조 하드코딩 |
| **이식 부적합** | brand-guidelines, ppt-brand-guidelines | 특정 브랜드 전용 |
| **이식 위험** | web-design-guidelines | 외부 URL 의존 |

---

*Generated by Claude Code on 2026-03-12*
