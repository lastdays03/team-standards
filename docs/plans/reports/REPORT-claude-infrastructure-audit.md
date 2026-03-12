# .claude/ 인프라 종합 감사 보고서

**작성일**: 2026-03-12
**범위**: `.claude/` 전체 (agents, commands, hooks, skills, settings)
**검증 방법**: 아래 3단계를 구분하여 표기

| 검증 수준 | 기호 | 의미 |
|-----------|------|------|
| 정적 확인 | `[S]` | 파일 존재·내용·참조 관계를 코드 레벨에서 대조 |
| 실행 관찰 | `[O]` | 이 감사 세션 중 실제 훅 출력 또는 통제된 샘플 실행으로 동작을 확인 |
| 런타임 미검증 | `[?]` | 훅을 독립 실행하여 확인하지는 않음 (향후 검증 필요) |

---

## 인벤토리

`find .claude -type f | wc -l` 결과:

| 영역 | 파일 수 | 크기 |
|------|---------|------|
| agents/ | 12 | 92K |
| commands/ | 3 | 12K |
| hooks/ | 13 | 96K |
| skills/ | 277 | 4.0M |
| settings (루트) | 2 | 4K |
| **합계** | **307** | **4.2M** |

---

## 1. 커스텀 스킬 트리거 시스템

이 레포의 가장 큰 커스텀 인프라이며, 가장 문제가 큰 영역.

### 1-1. 시스템 구성

```
skill-rules.json (1,058줄, 22개 스킬 엔트리)
  ├─ promptTriggers (keywords, intentPatterns)  ← skill-activation-prompt.ts가 읽음
  ├─ fileTriggers (pathPatterns, contentPatterns) ← 읽는 코드 없음
  ├─ enforcement/blockMessage/skipConditions     ← 읽는 코드 없음
  │
skill-activation-prompt.ts (132줄)
  └─ UserPromptSubmit 훅으로 등록
  └─ promptTriggers만 사용 (L58-77)
  │
skill-developer/ (7파일, 2,215줄)
  └─ 위 시스템의 사용 가이드
```

### 1-2. 기능별 작동 상태 `[S]`

skill-activation-prompt.ts 소스를 정적 분석한 결과:

| skill-rules.json 기능 | 소비하는 코드 | 작동 |
|----------------------|-------------|------|
| `promptTriggers.keywords` | skill-activation-prompt.ts L58-66 | O |
| `promptTriggers.intentPatterns` | skill-activation-prompt.ts L69-77 | O |
| `fileTriggers.pathPatterns` | 없음 | **X** |
| `fileTriggers.pathExclusions` | 없음 | **X** |
| `fileTriggers.contentPatterns` | 없음 | **X** |
| `enforcement: "block"` | 없음 (PreToolUse 훅 미존재) | **X** |
| `blockMessage` | 없음 | **X** |
| `skipConditions.sessionSkillUsed` | 없음 | **X** |
| `skipConditions.fileMarkers` | 없음 | **X** |
| `skipConditions.envOverride` | 없음 | **X** |

skill-rules.json의 10개 기능 중 8개는 소비하는 코드가 존재하지 않아 미작동.
또한 skill-developer 관련 문서는 PreToolUse 흐름과 `skill-verification-guard.ts` 실행 예시를 설명하지만, `.claude/settings.json`에는 PreToolUse 훅 등록이 없고 해당 파일도 존재하지 않음. 반면 "Two-Hook Architecture"의 두 번째 훅으로 설명한 `error-handling-reminder.ts` 역시 settings.json에 미등록 상태. `[S]`

### 1-3. skill-rules.json ↔ SKILL.md 정합성 `[S]`

| 분류 | 수 | 목록 |
|------|-----|------|
| **skill-rules.json에만 존재** (skill 문서 없음) | 14 | cliwant-brand-guidelines, copyright-safe-style-transfer, detailed-page-writer, evan-insight-blog-writer, handwriting-beautifier, product-display-video, reel-creator, reels-fire-effect, route-tester, threads-writer, viral-reel-creator, visual-hook-creator, youtube-editor, youtube-editor-highlight |
| **skill 문서에만 존재** (skill-rules.json 없음) | 9 | brand-guidelines, docx, frontend-design, mermaid, pdf, ppt-brand-guidelines, pptx, vercel-react-best-practices, web-design-guidelines |
| **양쪽 모두 존재** | 8 | area-deep-dive, error-tracking, fastapi-backend-guidelines, nextjs-frontend-guidelines, project-health-check, project-report, pytest-backend-testing, skill-developer |

skill 문서가 없는 14개 스킬은 훅이 추천해도 Claude Code가 Skill 도구로 실행할 수 없음.
반면 skill-rules.json에 없는 9개 스킬은 네이티브 description 매칭으로 정상 작동 중.

### 1-4. 네이티브 시스템과의 중복 `[S][O]`

**네이티브 시스템** (Claude Code 내장):
- 각 SKILL.md의 `description` frontmatter 필드를 읽음
- 시스템 리마인더의 `The following skills are available...` 섹션에 전체 스킬 목록 주입
- Claude가 프롬프트의 의도를 의미론적으로 이해하여 Skill 도구 호출 여부 판단

**커스텀 시스템** (이 레포):
- skill-rules.json의 keywords를 부분문자열 매칭 (`prompt.includes(kw.toLowerCase())`, L59)
- intentPatterns를 정규식 매칭 (`new RegExp(pattern, 'i').test(prompt)`, L71)
- 매칭 결과를 stdout으로 출력하여 Claude 컨텍스트에 주입

이 감사 세션에서 관찰된 커스텀 훅 출력 `[O]`:

| 프롬프트 (요약) | 훅 추천 | 판정 |
|----------------|---------|------|
| "skill-developer 삭제 논의" | skill-developer, reels-fire-effect | 오탐: 삭제 대상을 추천 |
| "추천은?" | skill-developer, viral-reel-creator | 오탐: 완전 무관 |
| ".claude 전체 평가해봐" | skill-developer | 오탐 |
| "skill-rules.json 유지 해야 되는지" | skill-developer | 오탐 |
| "빡세게 분석해서 보고서" | area-deep-dive, project-report | 부분: 코드 분석은 맞지만 인프라 감사와는 다름 |
| (이 프롬프트) | skill-developer, nextjs-frontend-guidelines, viral-reel-creator, project-report | 오탐: 4개 중 0개 관련 |

6회 관찰 중 정확한 추천 0회, 부분 관련 1회. 원인: `"skill"` 한 단어만 포함되면 skill-developer가 매칭, `"분석"` 하나로 area-deep-dive가 매칭되는 구조적 한계.

### 1-5. 이식성 고려사항

이 레포는 "Claude Code 인프라 템플릿"을 목표로 함 (CLAUDE.md L7). 따라서:

- **skill-creator 플러그인은 글로벌 설치 의존**: 이 레포를 다른 환경에 이식할 때 skill-creator가 있다고 가정할 수 없음.
- **skill-developer 삭제 시**: 스킬 생성 가이드를 제공하는 로컬 자원이 사라짐. 다만 Claude Code 공식 문서(https://docs.anthropic.com/en/docs/claude-code)가 SKILL.md 작성법을 다루므로, 로컬 가이드 없이도 스킬 생성은 가능.
- **skill-rules.json 삭제 시**: 커스텀 트리거 시스템 전체가 제거됨. 다만 네이티브 description 매칭이 이미 작동하고 있어 핵심 스킬 가용성은 유지되고, 사라지는 것은 저품질의 커스텀 자동 추천 동작임.

결론적으로 이식성 관점에서도 네이티브 시스템 의존이 더 안정적임. skill-creator 같은 특정 플러그인 의존보다, Claude Code 자체 기능(description 매칭)에 의존하는 것이 환경 간 호환성이 높음.

### 1-6. 판정

| 대상 | 판정 | 근거 요약 |
|------|------|-----------|
| skill-rules.json | 삭제 | 10개 기능 중 8개 미작동 `[S]`, 작동 2개는 네이티브 중복 `[S][O]` |
| skill-activation-prompt.ts/.sh | 삭제 | 위 파일의 유일한 소비자. skill-rules.json 삭제 시 존재 이유 없음 `[S]` |
| skill-developer/ (7파일) | 삭제 | 미작동 시스템의 가이드. 네이티브 스킬 생성은 SKILL.md description만 작성하면 됨 `[S]` |
| settings.json UserPromptSubmit | 등록 해제 | 위 삭제에 따른 후속 |

---

## 2. 삭제·통합 시 영향 범위 (문서 마이그레이션 필요) `[S]`

Track 1~3에서 삭제·병합이 확정된 항목(skill-rules, skill-activation, refactor-planner, auth-route 계열, route-research-for-testing)을 참조하는 핵심 문서 목록:

| 문서 | 영향받는 줄 | 영향 범위 | 필요 작업 |
|------|-----------|-----------|-----------|
| **CLAUDE.md** (201줄) | L73-76, L94, L107, L111, L121-123 | ~10줄 | 인벤토리 수치, skill-rules/skill-activation 설명, auth-route 계열, web-research-specialist, route-research-for-testing 소개를 현재 권장 세트에 맞게 수정 |
| **README.md** (161줄) | L11-21, L67-80, L136, L159 | ~25줄 | skill-rules 기반 자동 주입 모델, 삭제 대상 에이전트/커맨드, 구형 인벤토리 설명 제거 |
| **skills/README.md** (368줄) | L15-17, L23-36, L40-140, L168-266, L302-358 | ~240줄 (65%) | skill-rules.json 설정법뿐 아니라 존재하지 않는 `backend-dev-guidelines`, `frontend-dev-guidelines`, `route-tester`를 계속 소개. **전면 재작성 필요** |
| **agents/README.md** (300줄) | L19, L86-124, L179-182, L215-218 | ~45줄 | `Available Agents (10)` 수치 수정, refactor-planner/web-research-specialist/auth-route 계열 제거, planner 중심 구조로 재편 |
| **hooks/README.md** (163줄) | L19-65, L115-147 | ~80줄 (49%) | "Essential Hooks" 섹션에서 skill-activation-prompt를 핵심으로 소개하고, `tsc-check`의 실제 한계는 반영하지 않음. 섹션 재구성 필요 |
| **hooks/CONFIG.md** (448줄) | L14-19, L35-49, L143-169, L225-295, L304-324 | ~120줄 (27%) | UserPromptSubmit 설정 예시, 존재하지 않는 `stop-prettier-formatter.sh`, 고아 훅, 잘못된 tsc 캐시 경로 문서를 그대로 복사하게 만듦. **최우선 수정 대상** |
| **CLAUDE_INTEGRATION_GUIDE.md** (881줄) | L26-69, L92-201, L349-384, L512-543, L562-615, L722-870 | 대규모 | 존재하지 않는 skills, skill-rules 커스터마이징, skill-activation 훅, auth-route 계열, route-research-for-testing를 계속 권장. 외부 공유용 가이드 재정렬 필요 |
| **hooks/package.json** (16줄) | L9 | 1줄 | `test` 스크립트가 삭제 대상 `skill-activation-prompt.ts` 참조 |
| **skill-developer/ 전체** | 7파일 2,215줄 | 100% | 삭제 대상이므로 문서 마이그레이션 아닌 삭제 |

**결론: "CLAUDE.md 1개 수정"이 아니라, 7개 핵심 문서 + 1개 package metadata + settings 수정이 묶인 체계적 마이그레이션이 필요.**

---

## 3. 훅 시스템

### 3-1. settings.json 등록 상태 `[S]`

| 이벤트 | 훅 파일 | settings 등록 | 런타임 근거 | 판정 |
|--------|---------|---------------|-------------|------|
| UserPromptSubmit | skill-activation-prompt.sh | O `[S]` | 세션에서 훅 출력 관찰 `[O]` | 삭제 (§1 참조) |
| PostToolUse | post-tool-use-tracker.sh | O `[S]` | Edit/MultiEdit 샘플 입력으로 로그·명령 캐시 생성 확인 `[O]` | **유지** — 편집 추적은 실제 작동 |
| Stop | tsc-check.sh (172줄) | O `[S]` | Edit 성공/실패 경로는 확인했으나 세션·MultiEdit 처리 결함 확인 `[O]` | **수정 필요** — 부분 작동 |
| Stop | trigger-build-resolver.sh (78줄) | O `[S]` | 미검증 `[?]` | **삭제 권장** (아래 상세) |

### 3-2. trigger-build-resolver.sh 상세 `[S]`

- L13: 하드코딩된 서비스 목록 `email exports form frontend projects uploads users utilities events database` — 현재 레포 구조(backend/, frontend/)와 불일치
- L57: `claude --agent build-error-resolver` 호출 — `build-error-resolver.md` 에이전트가 agents/에 존재하지 않음 (`auto-error-resolver.md`는 존재)
- 에이전트명 불일치와 서비스 목록 불일치로 **현재 환경에서 정상 작동 불가능**

### 3-3. 미등록 파일 (고아) `[S]`

| 파일 | 줄 수 | settings.json 등록 | 판정 |
|------|-------|-------------------|------|
| error-handling-reminder.ts | 222 | X | 삭제 |
| error-handling-reminder.sh | 10 | X | 삭제 |
| stop-build-check-enhanced.sh | 124 | X | 삭제 (tsc-check.sh와 역할 중복) |

참고: hooks/CONFIG.md L35-49는 이 고아 파일들을 포함한 설정 예시를 보여줌 (stop-prettier-formatter.sh, stop-build-check-enhanced.sh, error-handling-reminder.sh). 이들 중 stop-prettier-formatter.sh는 파일 자체도 존재하지 않음.

### 3-4. Track 2 런타임 검증 `[O]`

통제된 임시 프로젝트에서 hook stdin을 직접 주입해 확인한 결과:

| 대상 | 결과 | 판정 |
|------|------|------|
| post-tool-use-tracker.sh | `Edit`와 `MultiEdit` 입력에서 `edited-files.log`, `affected-repos.txt`, `commands.txt` 생성 확인 | **정상 작동** |
| tsc-check.sh | `Edit` 입력에서는 성공/실패 경로 모두 동작. 실패 시 `last-errors.txt`, `affected-repos.txt`, `tsc-commands.txt` 생성 확인 | **부분 작동** |
| tsc-check.sh `session_id` 처리 | stdin의 `session_id`를 읽지 않고 항상 `$HOME/.claude/tsc-cache/default/` 사용 | **버그** |
| tsc-check.sh `MultiEdit` 처리 | 표준적인 `tool_input.file_path + edits[]` 샘플에서는 체크를 건너뜀 | **버그** |
| post-tool-use-tracker ↔ tsc-check 캐시 체인 | 전자는 `$CLAUDE_PROJECT_DIR/.claude/tsc-cache/[session_id]/`, 후자는 `$HOME/.claude/tsc-cache/[session_id]/` 사용 | **구현 불일치** |

결론적으로 `post-tool-use-tracker → tsc-check`는 문서상 의도와 달리 현재 구현에서 하나의 일관된 세션 캐시 파이프라인을 이루지 못함.

### 3-5. 보조 파일

| 파일 | 판정 | 비고 |
|------|------|------|
| hooks/package.json | 수정 | test 스크립트의 skill-activation-prompt 참조 제거 |
| hooks/tsconfig.json | 유지 | error-handling-reminder.ts 삭제 후에도 다른 ts 훅이 추가될 수 있음 |
| hooks/README.md | 재작성 | §2 참조 |
| hooks/CONFIG.md | 재작성 | §2 참조 |

---

## 4. 스킬 평가

### 4-1. 대형 스킬 (프로젝트 핵심)

| 스킬 | 메인 스킬 파일 줄 수 | 파일 수 | 500줄 가이드 | 판정 |
|------|----------------------|---------|-------------|------|
| fastapi-backend-guidelines | 656 | 12 | 초과 (리소스 10개로 분리) | **유지** |
| nextjs-frontend-guidelines | **1,073** | 12 | 크게 초과 | 유지, 분리 권장 |
| pytest-backend-testing | 520 | 8 | 경미 초과 | **유지** |
| vercel-react-best-practices | 136 | 59 | 준수 | **유지** — 성능 특화 레퍼런스. 트리거 범위 축소 권장 |
| pptx | 489 | 59 | 준수 | **유지** (설치형) |
| docx | 481 | 61 | 준수 | **유지** (설치형) |
| mermaid | 201 | 31 | 준수 | **유지** |
| pdf | 314 | 12 | 준수 | **유지** (설치형) |

여기서는 500줄 원칙을 절대 금지 규칙이 아니라 설계 가이드로 보았다. 초과 여부와 별개로 리소스 분리 수준과 실제 효용을 함께 판단했다.

### 4-2. 소형 스킬

| 스킬 | 메인 스킬 파일 줄 수 | 판정 | 비고 |
|------|----------------------|------|------|
| area-deep-dive | 202 | **유지** | 코드 영역 분석 프레임워크 |
| project-health-check | 203 | **유지** | 품질 메트릭 체계 |
| project-report | 165 | **유지** | 외부 공유용 보고서 |
| error-tracking | 375 | **수정** | Sentry 패턴 자체는 유용. 참조 서비스명(Form Service, Email Service 등)이 다른 프로젝트 것 |
| ppt-brand-guidelines | 197 | **유지** | VRL 브랜딩 |
| frontend-design | 42 | **유지** | 디자인 원칙 |
| brand-guidelines | 73 | **유지** | Anthropic 브랜딩 (VRL과 대상 다름) |
| web-design-guidelines | 39 | **유지** | Vercel 외부 가이드라인 래퍼 |
| skill-developer | 426 | **삭제** | §1 참조 |

### 4-3. 중복 분석

| 스킬 A | 스킬 B | 관계 | 판단 |
|--------|--------|------|------|
| nextjs-frontend-guidelines | vercel-react-best-practices | 영역 일부 중복 | nextjs는 YGS 맞춤형(컴포넌트, 인증, i18n)이고 vercel은 `startTransition`, `React.cache`, SWR dedup, passive listeners 같은 성능 미세 규칙 57개를 제공. **삭제보다 역할 분리 유지가 타당** |
| brand-guidelines | ppt-brand-guidelines | 없음 | Anthropic vs VRL. 대상이 다름 |
| area-deep-dive | project-health-check | 없음 | 깊이 vs 넓이. 상호보완 설계 |
| fastapi-backend-guidelines | pytest-backend-testing | 의도적 분리 | 코드 패턴 vs 테스트 패턴. 같은 도메인이지만 역할 다름 |

### 4-4. vercel-react-best-practices 상세 `[S]`

- nextjs-frontend-guidelines의 성능 섹션은 Server Components, dynamic imports, `next/image`, `useMemo/useCallback/React.memo` 수준의 상위 가이드에 머뭄
- vercel-react-best-practices는 별도 규칙 파일 57개를 통해 `React.cache()`, `startTransition`, SWR dedup, passive listeners, `useEffectEvent`, `toSorted()` 등 미세 최적화 패턴을 제공
- 따라서 두 스킬은 "프로젝트 패턴" vs "성능 룰셋"으로 역할을 분리하는 편이 낫다
- 다만 현재 description이 너무 넓어 일반 React/Next.js 작업 전체에 걸쳐 경쟁하므로, **성능 최적화·렌더링 병목·데이터 페칭 병렬화 작업으로 트리거 범위를 축소**하는 것이 적절

---

## 5. 에이전트 평가

### 5-1. 범용 에이전트

| 에이전트 | 모델 | 줄 수 | 판정 | 비고 |
|----------|------|-------|------|------|
| planner | - | 225 | **유지** | 3파일 계획 구조 생성. /dev-docs 커맨드와 연계 |
| plan-reviewer | opus | 52 | **유지** | 구현 전 계획 검증 |
| refactor-planner | - | 62 | **삭제** | planner가 이미 refactor scope와 phase/risk 계획을 다룸. refactor 체크리스트만 병합 후 제거 |
| code-architecture-reviewer | sonnet | 83 | **유지** | 구현 후 코드 리뷰 |
| code-refactor-master | opus | 94 | **유지** | 리팩토링 실행. planner가 계획, 이것이 실행 |
| documentation-architect | inherit | 85 | **유지** | docs/ 구조 맞춤 문서 생성 |
| web-research-specialist | sonnet | 78 | **삭제** | 내장 웹 검색과 실질적으로 중복. 프로젝트 특화 흐름이나 독립 인프라 연계 없음 |

### 5-2. 프로젝트 특화 에이전트

| 에이전트 | 모델 | 줄 수 | 판정 | 비고 |
|----------|------|-------|------|------|
| frontend-error-fixer | - | 68 | **유지** | Playwright MCP 활용 |
| auth-route-tester | sonnet | 93 | **삭제** | Express/PM2/Docker MySQL/test-auth-route.js 전제. 현재 FastAPI 레포 구조와 불일치 |
| auth-route-debugger | - | 115 | **삭제** | `app.ts`, Keycloak, get-auth-token.js, PM2 전제. 현재 레포와 불일치 |
| auto-error-resolver | - | 96 | **유지** | tsc-check 훅과 연계. 도구 제한으로 집중적 |

### 5-3. Track 1 상세 판정 `[S]`

- **refactor-planner**: planner는 애초에 Refactor를 공식 scope로 다루고 phase/risk/success metric 구조까지 정의한다. 반면 refactor-planner는 planning-only 세부화 버전에 가깝다. 독립 에이전트보다 planner 내부 "refactor mode" 체크리스트로 흡수하는 편이 단순하다.
- **web-research-specialist**: GitHub/Reddit/Stack Overflow를 뒤지는 일반론적 리서치 절차를 설명하지만, 현재 Claude Code 내장 웹 검색과 차별되는 프로젝트 특화 규칙이나 연계 포인트가 없다. 별도 에이전트로 둘 이유가 약하다.
- **auth-route-tester / auth-route-debugger**: 두 파일 모두 `scripts/test-auth-route.js`, `scripts/get-auth-token.js`, PM2, Docker MySQL, `app.ts`, Keycloak/쿠키 기반 Express 라우트 구조를 전제로 한다. 현재 레포는 FastAPI의 `backend/backend/api/v1/routers/*.py`와 `backend/backend/main.py` 구조이므로 활성 자산으로 보기 어렵다.
- 위 3개 영역은 "삭제"가 맞지만, 템플릿 히스토리 보존이 필요하면 `archive/legacy-express-auth/` 같은 별도 보관 영역으로 옮기는 방안은 가능하다

---

## 6. 커맨드 평가

| 커맨드 | 줄 수 | 판정 | 비고 |
|--------|-------|------|------|
| `/dev-docs` | 67 | **유지** | docs/plans/active/ 구조 생성. 워크플로우 진입점 |
| `/dev-docs-update` | 65 | **유지** | 컨텍스트 컴팩션 전 상태 보존 |
| `/route-research-for-testing` | 37 | **삭제** | `/routes/`, `src/app.ts`, auth-route-tester 전제. FastAPI 라우터 편집 로그 재현 시에도 결과가 비어 현재 구조와 불일치 |

### 6-1. route-research-for-testing 상세 `[S][O]`

- `edited-files.log`에서 `/routes/` 경로만 grep함
- `src/app.ts`를 기준으로 prefix를 해석하도록 지시함
- 최종적으로 auth-route-tester sub-agent 호출을 강제함
- 하지만 현재 레포의 실제 라우트는 `backend/backend/api/v1/routers/*.py`이며 엔트리포인트는 `backend/backend/main.py`
- 실제로 FastAPI router 편집 로그를 생성한 뒤 커맨드의 grep 파이프라인을 그대로 재현해도 결과가 비었음

즉 이 커맨드는 단순히 "검증이 안 됨" 수준이 아니라, **현재 저장소의 라우트 구조와 직접 충돌하는 레거시 워크플로우**다.

---

## 7. CLAUDE.md 정확성 `[S]`

| 항목 | CLAUDE.md 기술 | 실제 | 상태 |
|------|---------------|------|------|
| 스킬 수 | L76: "14 skills" | 17개 스킬 디렉터리 (SKILL.md/skill.md 보유) | 부정확 |
| 에이전트 수 | "11개" | 11개 (.md 파일, README 제외) | 정확 |
| 훅 수 | L75: "7 hooks" | 활성 등록 4개, 고아 3개, 보조 6개 = 파일 13개 | 모호 |
| 커맨드 수 | "3개" | 3개 | 정확 |
| L94 skill-rules.json 설명 | "트리거 규칙에 따라 자동 활성화...파일 컨텍스트를 매칭" | 파일 컨텍스트 매칭(fileTriggers)은 미구현 | 부정확 |

### 7-1. Track 3 문서 마이그레이션 상세 `[S]`

- **skills/README.md는 부분 수정 수준이 아님**: skill-rules.json을 중심으로 자동 활성화와 통합 절차를 설명하고, 현재 존재하지 않는 `backend-dev-guidelines`, `frontend-dev-guidelines`, `route-tester`까지 소개한다. 삭제 대상 skill-developer 설명도 남아 있어 전면 재작성에 가깝다.
- **hooks/CONFIG.md는 잘못된 구성을 복사하게 만든다**: Quick Start와 selective setup 모두 `skill-activation-prompt`, `stop-build-check-enhanced.sh`, `error-handling-reminder.sh`, 심지어 존재하지 않는 `stop-prettier-formatter.sh`까지 등록 예시로 제시한다. Track 2에서 확인한 `tsc-check` 캐시 경로 불일치도 문서와 맞지 않는다.
- **권위 문서들이 stale 상태다**: `CLAUDE.md`, 루트 `README.md`, `agents/README.md`, `hooks/README.md`, `CLAUDE_INTEGRATION_GUIDE.md`가 삭제 대상 에이전트·커맨드·훅을 여전히 핵심 워크플로우로 소개한다. 특히 외부 공유 가능성이 높은 `README.md`와 `CLAUDE_INTEGRATION_GUIDE.md`는 우선 정리해야 한다.
- **보조 메타데이터도 같이 정리해야 한다**: `hooks/package.json`의 test 스크립트는 삭제 대상 `skill-activation-prompt.ts`를 직접 참조한다. 문서 수정만 하고 package metadata를 그대로 두면 삭제 직후 테스트 명령이 깨진다.

따라서 Phase 3는 문장 몇 줄 교정이 아니라, "현재 구현에 맞는 사용 설명서 집합"으로 재정렬하는 작업으로 봐야 한다.

---

## 8. 권장 조치 목록

### Phase 1: 즉시 삭제 (죽은 코드·고아 파일)

| # | 대상 | 유형 | 파일 수 | 근거 | 검증 |
|---|------|------|---------|------|------|
| 1 | `.claude/skills/skill-rules.json` | 파일 | 1 | 10개 기능 중 8개 미작동, 2개 네이티브 중복 | `[S]` |
| 2 | `.claude/skills/skill-developer/` | 디렉터리 | 7 | 미작동 시스템의 가이드 문서 | `[S]` |
| 3 | `.claude/hooks/skill-activation-prompt.ts` | 파일 | 1 | skill-rules.json의 유일한 소비자 | `[S]` |
| 4 | `.claude/hooks/skill-activation-prompt.sh` | 파일 | 1 | 위 ts의 래퍼 | `[S]` |
| 5 | `.claude/hooks/error-handling-reminder.ts` | 파일 | 1 | settings.json 미등록 | `[S]` |
| 6 | `.claude/hooks/error-handling-reminder.sh` | 파일 | 1 | settings.json 미등록 | `[S]` |
| 7 | `.claude/hooks/stop-build-check-enhanced.sh` | 파일 | 1 | settings.json 미등록, tsc-check.sh 중복 | `[S]` |
| 8 | `.claude/hooks/trigger-build-resolver.sh` | 파일 | 1 | 미존재 에이전트 호출, 서비스 목록 불일치 | `[S]` |
| 9 | `settings.json` UserPromptSubmit 바인딩 | 설정 수정 | - | 훅 삭제에 따른 해제 | - |
| 10 | `settings.json` Stop의 trigger-build-resolver 바인딩 | 설정 수정 | - | 훅 삭제에 따른 해제 | - |
| | **소계** | | **14파일 + 설정 2건** | | |

### Phase 2: 구조 통합 (Track 1 반영)

| # | 대상 | 작업 |
|---|------|------|
| 11 | `planner.md` | refactor-planner의 refactor-specific 체크리스트, 위험 분석 포인트를 planner에 병합 |
| 12 | `.claude/agents/refactor-planner.md` | 병합 후 삭제 |
| 13 | `.claude/agents/web-research-specialist.md` | 삭제 또는 legacy archive로 이동 |
| 14 | `.claude/agents/auth-route-tester.md` | 삭제 또는 legacy archive로 이동 |
| 15 | `.claude/agents/auth-route-debugger.md` | 삭제 또는 legacy archive로 이동 |
| 16 | `.claude/commands/route-research-for-testing.md` | 삭제 |
| 17 | `vercel-react-best-practices/SKILL.md` | description을 "일반 React/Next.js 작업"이 아니라 "성능 최적화/병목 분석" 중심으로 축소 |

### Phase 3: 문서 마이그레이션 (Phase 1~2 후속)

| # | 대상 | 작업 | 영향 규모 |
|---|------|------|-----------|
| 18 | **CLAUDE.md** | 인벤토리 수치 업데이트. skill-rules/skill-activation 설명 제거. web-research-specialist, auth-route 계열, route-research-for-testing 소개를 현재 권장 세트에 맞게 정리 | 다수 줄 수정 |
| 19 | **README.md** | skill-rules 기반 자동 주입 설명 제거. 에이전트/커맨드 목록에서 refactor-planner, web-research-specialist, auth-route 계열, route-research-for-testing 정리 | 중간 |
| 20 | **skills/README.md** | skill-developer 섹션 삭제, skill-rules.json 설정법/트러블슈팅 재작성, 존재하지 않는 `backend-dev-guidelines`/`frontend-dev-guidelines`/`route-tester` 소개 제거. **네이티브 description 기반 가이드로 전면 전환** | ~240줄 재작성 (65%) |
| 21 | **agents/README.md** | `Available Agents (10)` 수치 수정, 삭제 대상 에이전트와 quick reference 제거, planner가 refactor planning을 흡수한 구조로 재구성 | 중간 |
| 22 | **hooks/README.md** | "Essential Hooks" 섹션에서 skill-activation-prompt 제거. post-tool-use-tracker 중심으로 재구성하고, `tsc-check`의 session/MultiEdit 제약을 문서화 | ~80줄 재작성 (49%) |
| 23 | **hooks/CONFIG.md** | UserPromptSubmit 설정 예시 제거, 존재하지 않는 `stop-prettier-formatter.sh` 및 고아 훅 참조 정리, `tsc-check` 캐시 경로 설명을 실제 구현과 일치시킴 | ~120줄 수정 |
| 24 | **hooks/package.json** | L9 test 스크립트의 skill-activation-prompt 참조 제거. 삭제 후에도 테스트 명령이 깨지지 않도록 정리 | 1줄 |
| 25 | **CLAUDE_INTEGRATION_GUIDE.md** | 존재하지 않는 skills, skill-rules 커스터마이징, skill-activation 훅, auth-route 계열, route-research-for-testing, refactor-planner 안내를 현재 권장 세트에 맞게 대규모 정리 | 중간~대규모 |

### Phase 4: 개선 (독립 작업)

| # | 대상 | 작업 |
|---|------|------|
| 26 | `tsc-check.sh` | stdin에서 `session_id`를 읽도록 수정하고, 캐시 경로를 post-tool-use-tracker와 통일 |
| 27 | `tsc-check.sh` | `MultiEdit`에서 `tool_input.file_path` fallback을 지원하고, 실제 Stop 이벤트 payload 계약을 재검증 |
| 28 | `nextjs-frontend-guidelines/skill.md` | 1,073줄 → 500줄 이하로 분리 |
| 29 | `error-tracking/SKILL.md` | 참조 서비스명을 현재 프로젝트 컨텍스트에 맞게 수정 |

### 유지 (변경 불필요)

| 영역 | 컴포넌트 | 수 |
|------|---------|-----|
| 에이전트 | planner, plan-reviewer, code-architecture-reviewer, code-refactor-master, documentation-architect, frontend-error-fixer, auto-error-resolver | 7 |
| 커맨드 | /dev-docs, /dev-docs-update | 2 |
| 훅 | post-tool-use-tracker.sh | 1 |
| 스킬 | fastapi-backend-guidelines, nextjs-frontend-guidelines, pytest-backend-testing, vercel-react-best-practices, pptx, docx, mermaid, pdf, area-deep-dive, project-health-check, project-report, brand-guidelines, ppt-brand-guidelines, frontend-design, web-design-guidelines, error-tracking | 16 |

---

## 9. 아키텍처 교훈

### 과잉 설계

1. **네이티브 기능 위에 커스텀 레이어**: skill-rules.json + 훅 시스템은 Claude Code의 description 매칭을 자체 키워드 매칭으로 대체하려 했으나, 네이티브가 의미론적 이해를 제공하므로 부분문자열 매칭보다 우수.

2. **설계만 존재하는 기능**: PreToolUse guardrail은 skill-rules.json에 blockMessage, skipConditions, fileTriggers 스키마가 상세하게 정의되어 있지만, 실행할 훅이 구현되지 않음. 1,058줄 설정의 상당 부분이 미사용.

3. **엔트리만 있는 스킬**: 14개 스킬이 skill-rules.json에 트리거 규칙만 있고 실행할 SKILL.md가 없음.

4. **문서-구현 드리프트**: hooks/CONFIG.md뿐 아니라 README, skills/README, CLAUDE_INTEGRATION_GUIDE가 삭제 대상 훅·에이전트·커맨드를 계속 권장한다. 특히 `post-tool-use-tracker`와 `tsc-check`는 캐시 경로·세션 처리 방식이 실제 구현과 문서 설명에서 어긋난다.

### 잘 된 설계

1. **편집 추적 자체**: `post-tool-use-tracker`는 Edit/MultiEdit 입력에서 편집 파일, 영향 repo, 빌드/tsc 명령 캐시를 실제로 남긴다. 기본 추적기 역할은 실용적이다.

2. **Progressive disclosure**: fastapi-backend-guidelines (SKILL.md 656줄 + 리소스 10개)처럼 메인은 개요, 세부는 리소스로 분리.

3. **SDLC 에이전트 커버리지**: 현재도 planner → plan-reviewer → 구현 → code-architecture-reviewer → refactor-planner → code-refactor-master 흐름을 제공한다. 다만 권장 end-state는 refactor-planner를 planner에 흡수해 동일 흐름을 더 단순하게 유지하는 것이다.

4. **커맨드-에이전트 연계**: `/dev-docs` 구조 생성 → planner 내용 채움 → `/dev-docs-update` 세션 연속성 유지.

---

## 부록 A: 이전 보고서 대비 수정 사항

| 항목 | 이전 값 | 수정 값 | 원인 |
|------|---------|---------|------|
| 총 파일 수 (대시보드) | 309 | 307 | 영역별 합산 오류 (hooks 11→13, skills 281→277) |
| error-tracking 줄 수 | 480 | 375 | 서브에이전트 추정치 사용. `wc -l`로 재측정 |
| skill-developer 줄 수 | 490 | 426 | 동일 |
| area-deep-dive 줄 수 | 390 | 202 | 동일 |
| project-health-check 줄 수 | 400 | 203 | 동일 |
| project-report 줄 수 | 380 | 165 | 동일 |
| "유지 스킬 12개" 나열 | 15개 나열 | 15개로 통일 | 제목과 내용 불일치 |
| 삭제 대상 "13파일" | 파일·디렉터리·설정 혼합 | "14파일 + 설정 2건"으로 분리 표기 | 단위 혼합 |
| 영향 범위 | "CLAUDE.md 수정" | 7개 핵심 문서 + package metadata + settings 수정 | 과소평가 |
| skill-developer 삭제 근거 | "skill-creator 플러그인이 상위 호환" | 이식성 고려사항 추가, 네이티브 description 의존으로 재정리 | 글로벌 플러그인 가정 문제 |
| "허위" 등 단정 표현 | 검증 수준 미표기 | `[S]` `[O]` `[?]` 3단계 검증 표기 | 증거 프로토콜 부재 |
| trigger-build-resolver 판정 | "검토" | "삭제 권장" + 구체적 근거(에이전트명·서비스 목록 불일치) | 과소평가 |
