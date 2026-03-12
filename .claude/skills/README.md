# Skills

Claude Code 스킬 모음 -- 네이티브 description 매칭으로 자동 활성화.

---

## What Are Skills?

스킬은 Claude Code가 맥락에 따라 자동으로 로드하는 모듈형 지식 베이스다. 각 스킬 디렉토리의 `SKILL.md` 파일에 정의된 `description` 필드를 Claude Code가 사용자 프롬프트와 매칭하여, 관련 스킬을 자동으로 활성화한다.

**별도 설정 파일이나 훅 없이** Claude Code의 네이티브 매칭만으로 동작한다:
- 사용자가 "FastAPI 라우터 만들어줘"라고 하면 → `fastapi-backend-guidelines` 활성화
- 사용자가 "PDF 합치고 싶어"라고 하면 → `pdf` 활성화
- 사용자가 "프로젝트 상태 점검해줘"라고 하면 → `project-health-check` 활성화

매칭 정확도는 SKILL.md의 `description` 품질에 달려 있다. 구체적이고 다양한 트리거 표현을 포함할수록 활성화 정확도가 높아진다.

---

## Available Skills

| # | 스킬 | 설명 | 범용성 |
|---|------|------|--------|
| 1 | [fastapi-backend-guidelines](fastapi-backend-guidelines/) | FastAPI DDD, SQLModel, async/await 패턴 | 프로젝트 특화 |
| 2 | [nextjs-frontend-guidelines](nextjs-frontend-guidelines/) | Next.js 15 App Router, shadcn/ui, Tailwind CSS 4 | 프로젝트 특화 |
| 3 | [pytest-backend-testing](pytest-backend-testing/) | FastAPI pytest 패턴 (유닛/통합/비동기/목킹) | 프로젝트 특화 |
| 4 | [vercel-react-best-practices](vercel-react-best-practices/) | React/Next.js 성능 최적화 (Vercel 엔지니어링 57개 규칙) | 범용 |
| 5 | [error-tracking](error-tracking/) | Sentry v8 통합 패턴 | 범용 |
| 6 | [mermaid](mermaid/) | Mermaid 다이어그램 생성 (flowchart, sequence, ER 등 20종) | 범용 |
| 7 | [docx](docx/) | Word 문서 생성/편집/분석 | 범용 |
| 8 | [pdf](pdf/) | PDF 읽기/합치기/분할/워터마크/OCR | 범용 |
| 9 | [pptx](pptx/) | PowerPoint 프레젠테이션 생성/편집 | 범용 |
| 10 | [frontend-design](frontend-design/) | 프론트엔드 UI 디자인 (프로덕션급, 비AI 미학) | 범용 |
| 11 | [web-design-guidelines](web-design-guidelines/) | Web Interface Guidelines 기반 UI 리뷰 | 범용 |
| 12 | [brand-guidelines](brand-guidelines/) | Anthropic 브랜드 색상/타이포그래피 | 프로젝트 특화 |
| 13 | [ppt-brand-guidelines](ppt-brand-guidelines/) | VRL 프레젠테이션 브랜드 가이드라인 | 프로젝트 특화 |
| 14 | [area-deep-dive](area-deep-dive/) | 코드 영역 심층 분석 리포트 생성 | 범용 |
| 15 | [project-health-check](project-health-check/) | 프로젝트 건강 점검 (테스트/빌드/린트/의존성/구조) | 범용 |
| 16 | [project-report](project-report/) | 외부 공유용 프로젝트 상태 보고서 | 범용 |

---

## Creating Your Own Skills

### 디렉토리 구조

```
.claude/skills/
  my-skill/
    SKILL.md          # 필수 - description 포함
    resources/        # 선택 - 참조 자료
      topic-1.md
      topic-2.md
```

### SKILL.md 작성법

```markdown
---
name: my-skill
description: "이 스킬이 하는 일에 대한 명확한 설명.
Use when 사용자가 X를 요청할 때, Y 작업을 할 때.
Also trigger when 'keyword1', 'keyword2', '한국어 트리거'."
---

# My Skill Title

## Purpose
[이 스킬이 존재하는 이유]

## Guidelines
[핵심 패턴과 예제]
```

### description 작성 팁

`description`이 스킬 활성화의 유일한 매칭 기준이다. 잘 작성해야 한다:

1. **첫 문장**: 스킬이 하는 일을 한 줄로 명확히
2. **Use when**: 어떤 상황에서 사용하는지 구체적으로
3. **트리거 키워드**: 사용자가 실제로 쓸 표현을 나열 (영어 + 한국어)
4. **구분 표현**: 유사 스킬과 혼동되지 않도록 경계 명시

좋은 예:
```yaml
description: "Run a comprehensive project health check and generate a Markdown report.
Use this skill when the user asks to check project health, audit code quality,
review project status. Also trigger when the user mentions 'health check',
'code quality report', '프로젝트 상태', '코드 품질'."
```

나쁜 예:
```yaml
description: "Project health checking tool."
```

---

## Troubleshooting

### 스킬이 활성화되지 않는다

1. `.claude/skills/{skill-name}/SKILL.md` 파일이 존재하는지 확인
2. SKILL.md에 `---` frontmatter와 `description` 필드가 있는지 확인
3. description에 사용자가 실제로 사용할 키워드/표현이 포함되어 있는지 확인
4. 한국어로 요청한다면 description에 한국어 트리거도 포함했는지 확인

### 스킬이 너무 자주 활성화된다

- description을 더 구체적으로 작성
- "Do NOT use for..." 문구로 제외 조건 명시
- 유사 스킬과의 차이점을 description에 기술

### 엉뚱한 스킬이 활성화된다

- description 첫 문장이 스킬의 핵심 목적을 명확히 전달하는지 확인
- 다른 스킬과 겹치는 키워드가 있다면 구분 표현 추가
