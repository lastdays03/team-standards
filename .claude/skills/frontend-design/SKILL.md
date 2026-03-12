---
name: frontend-design
description: "Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, artifacts, posters, or applications (examples include websites, landing pages, dashboards, React components, HTML/CSS layouts, or when styling/beautifying any web UI). Generates creative, polished code and UI design that avoids generic AI aesthetics. Also trigger when '웹 디자인', '랜딩 페이지', '대시보드 만들기', 'UI 디자인', '컴포넌트 디자인', '웹 페이지 제작', or any frontend design/styling work."
license: Complete terms in LICENSE.txt
---

This skill guides creation of distinctive, production-grade frontend interfaces that avoid generic "AI slop" aesthetics. Implement real working code with exceptional attention to aesthetic details and creative choices.

The user provides frontend requirements: a component, page, application, or interface to build. They may include context about the purpose, audience, or technical constraints.

## Reference Files

구체적인 패턴과 코드가 필요할 때 아래 참조 파일을 읽어라:

- `references/component-patterns.md` — Hero, Card, Nav, Form, Modal, Feature Grid, Testimonial, Pricing, Footer, Toast 등 10개 컴포넌트의 구현 패턴과 미학별 변형 코드
- `references/layout-templates.md` — Landing Page, Dashboard, Portfolio, Blog, SaaS Shell, E-commerce, Docs 등 7개 페이지 유형의 완전한 골격 코드와 반응형 전략
- `references/css-techniques.md` — Gradient Mesh, Glassmorphism, Noise/Grain, Scroll Animation, Text Effect, Shadow, Border, Cursor, Background Pattern, Page Transition, Skeleton Loading 등 12개 CSS 테크닉 레시피
- `references/aesthetic-palettes.md` — Brutalist, Luxury, Editorial, Retro-Futuristic, Organic, Playful, Art Deco, Soft/Pastel, Industrial, Maximalist, Monochrome, Neon Cyber 등 12개 미학별 폰트 페어링, 컬러 시스템, CSS 변수 세트

**언제 참조하는가:**
- 컴포넌트를 만들 때 → `component-patterns.md`에서 해당 컴포넌트 패턴을 기반으로 시작
- 전체 페이지를 만들 때 → `layout-templates.md`에서 가장 가까운 레이아웃 골격을 가져와 커스터마이즈
- 시각 효과를 구현할 때 → `css-techniques.md`에서 해당 기법의 실제 코드를 참조
- 미학 방향을 결정했을 때 → `aesthetic-palettes.md`에서 해당 미학의 디자인 토큰(폰트, 컬러, CSS 변수)을 적용

참조 파일의 코드는 출발점이다. 그대로 복사하지 말고, 프로젝트의 맥락과 미학 방향에 맞게 변형하고 발전시켜라.

## Design Thinking

Before coding, understand the context and commit to a BOLD aesthetic direction:
- **Purpose**: What problem does this interface solve? Who uses it?
- **Tone**: Pick an extreme: brutally minimal, maximalist chaos, retro-futuristic, organic/natural, luxury/refined, playful/toy-like, editorial/magazine, brutalist/raw, art deco/geometric, soft/pastel, industrial/utilitarian, etc. There are so many flavors to choose from. Use these for inspiration but design one that is true to the aesthetic direction. → `aesthetic-palettes.md`에서 선택한 미학의 구체적 토큰을 가져와라.
- **Constraints**: Technical requirements (framework, performance, accessibility).
- **Differentiation**: What makes this UNFORGETTABLE? What's the one thing someone will remember?

**CRITICAL**: Choose a clear conceptual direction and execute it with precision. Bold maximalism and refined minimalism both work - the key is intentionality, not intensity.

Then implement working code (HTML/CSS/JS, React, Vue, etc.) that is:
- Production-grade and functional
- Visually striking and memorable
- Cohesive with a clear aesthetic point-of-view
- Meticulously refined in every detail

## Frontend Aesthetics Guidelines

Focus on:
- **Typography**: Choose fonts that are beautiful, unique, and interesting. Avoid generic fonts like Arial and Inter; opt instead for distinctive choices that elevate the frontend's aesthetics; unexpected, characterful font choices. Pair a distinctive display font with a refined body font. → 구체적 폰트 조합은 `aesthetic-palettes.md`의 각 미학별 페어링 테이블 참조.
- **Color & Theme**: Commit to a cohesive aesthetic. Use CSS variables for consistency. Dominant colors with sharp accents outperform timid, evenly-distributed palettes. → `aesthetic-palettes.md`의 CSS 변수 세트를 기반으로 프로젝트 팔레트 구성.
- **Motion**: Use animations for effects and micro-interactions. Prioritize CSS-only solutions for HTML. Use Motion library for React when available. Focus on high-impact moments: one well-orchestrated page load with staggered reveals (animation-delay) creates more delight than scattered micro-interactions. Use scroll-triggering and hover states that surprise. → 구체적 구현은 `css-techniques.md`의 Scroll Animation, Page Transition, Text Effect 섹션 참조.
- **Spatial Composition**: Unexpected layouts. Asymmetry. Overlap. Diagonal flow. Grid-breaking elements. Generous negative space OR controlled density. → `layout-templates.md`에서 레이아웃 골격을 선택한 뒤 비대칭/오버랩 등의 변형 적용.
- **Backgrounds & Visual Details**: Create atmosphere and depth rather than defaulting to solid colors. Add contextual effects and textures that match the overall aesthetic. Apply creative forms like gradient meshes, noise textures, geometric patterns, layered transparencies, dramatic shadows, decorative borders, custom cursors, and grain overlays. → 모든 기법의 실제 코드는 `css-techniques.md`에 있다.

NEVER use generic AI-generated aesthetics like overused font families (Inter, Roboto, Arial, system fonts), cliched color schemes (particularly purple gradients on white backgrounds), predictable layouts and component patterns, and cookie-cutter design that lacks context-specific character.

Interpret creatively and make unexpected choices that feel genuinely designed for the context. No design should be the same. Vary between light and dark themes, different fonts, different aesthetics. NEVER converge on common choices (Space Grotesk, for example) across generations.

**IMPORTANT**: Match implementation complexity to the aesthetic vision. Maximalist designs need elaborate code with extensive animations and effects. Minimalist or refined designs need restraint, precision, and careful attention to spacing, typography, and subtle details. Elegance comes from executing the vision well.

Remember: Claude is capable of extraordinary creative work. Don't hold back, show what can truly be created when thinking outside the box and committing fully to a distinctive vision.

## Quality Review Workflow

After generating UI code, use the **web-design-guidelines** skill to audit the output for:
- Accessibility compliance (aria-labels, focus states, semantic HTML)
- Interactive state completeness (hover, active, focus, loading, empty, error)
- Design quality (visual hierarchy, spacing consistency, color contrast)
- Performance patterns (image dimensions, lazy loading, virtualization)

**Recommended flow**: Design with `frontend-design` → Review with `web-design-guidelines` → Fix findings → Ship.
