# Layout Templates

페이지 유형별 구조 템플릿. 각 템플릿은 완전한 페이지 골격을 제공하며, 미학 방향에 따라 커스터마이즈한다.

## Table of Contents

1. [Landing Page](#landing-page)
2. [Dashboard](#dashboard)
3. [Portfolio / Showcase](#portfolio--showcase)
4. [Blog / Editorial](#blog--editorial)
5. [SaaS Application Shell](#saas-application-shell)
6. [E-commerce Product Page](#e-commerce-product-page)
7. [Documentation Layout](#documentation-layout)
8. [반응형 전략](#반응형-전략)

---

## Landing Page

단일 목적: 방문자를 전환(CTA)으로 유도.

### 섹션 구성

```
┌─────────────────────────────────────────┐
│  Nav (fixed, transparent → blur on scroll)   │
├─────────────────────────────────────────┤
│  Hero (90-100vh)                              │
│  - Headline + Subline + CTA                   │
│  - 배경: 비디오 / 3D / 그라디언트 메시         │
├─────────────────────────────────────────┤
│  Social Proof Bar (로고 스트립)               │
├─────────────────────────────────────────┤
│  Features (Bento Grid 또는 3-col)            │
├─────────────────────────────────────────┤
│  How It Works (3-step)                        │
├─────────────────────────────────────────┤
│  Testimonials (캐러셀 또는 그리드)            │
├─────────────────────────────────────────┤
│  Pricing                                      │
├─────────────────────────────────────────┤
│  Final CTA (Hero 반복 축약)                   │
├─────────────────────────────────────────┤
│  Footer                                       │
└─────────────────────────────────────────┘
```

### HTML 골격

```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Product — Tagline</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link href="https://fonts.googleapis.com/css2?family=...&display=swap" rel="stylesheet" />
  <style>
    /* CSS 변수 시스템 — aesthetic-palettes.md 참조 */
    :root {
      --color-bg: #0a0a0b;
      --color-fg: #fafaf9;
      --color-surface: #141416;
      --color-border: rgba(255,255,255,0.08);
      --color-muted: #71717a;
      --color-accent: #6366f1;
      --color-accent-rgb: 99, 102, 241;
      --color-on-accent: #fff;
      --font-display: 'Your Display Font', serif;
      --font-body: 'Your Body Font', sans-serif;
      --font-mono: 'Your Mono Font', monospace;
      --container: min(90rem, 90vw);
      --section-gap: clamp(6rem, 12vh, 10rem);
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; }

    body {
      font-family: var(--font-body);
      background: var(--color-bg);
      color: var(--color-fg);
      -webkit-font-smoothing: antialiased;
    }

    .container {
      max-width: var(--container);
      margin: 0 auto;
      padding: 0 clamp(1.5rem, 4vw, 4rem);
    }

    section {
      padding: var(--section-gap) 0;
    }

    .section-header {
      text-align: center;
      max-width: 48ch;
      margin: 0 auto 4rem;
    }

    .section-title {
      font-family: var(--font-display);
      font-size: clamp(2rem, 4vw, 3.5rem);
      line-height: 1.1;
      letter-spacing: -0.02em;
    }

    .section-subtitle {
      font-size: 1.125rem;
      color: var(--color-muted);
      margin-top: 1rem;
      line-height: 1.6;
    }
  </style>
</head>
<body>
  <nav class="nav">...</nav>

  <section class="hero">
    <div class="container">...</div>
  </section>

  <section class="logos">
    <div class="container">
      <p class="logos__label">Trusted by teams at</p>
      <div class="logos__strip">
        <!-- 로고 이미지들, grayscale + opacity 처리 -->
      </div>
    </div>
  </section>

  <section class="features">
    <div class="container">
      <div class="section-header">
        <h2 class="section-title">Features title</h2>
        <p class="section-subtitle">Features description</p>
      </div>
      <div class="features__grid">...</div>
    </div>
  </section>

  <section class="steps">...</section>
  <section class="testimonials">...</section>
  <section class="pricing">...</section>

  <section class="cta-final">
    <div class="container" style="text-align: center;">
      <h2 class="section-title">Ready to start?</h2>
      <p class="section-subtitle">Join thousands of teams</p>
      <button class="btn btn--primary btn--lg" style="margin-top: 2rem;">Get Started Free</button>
    </div>
  </section>

  <footer class="footer">...</footer>
</body>
</html>
```

### 로고 스트립 (Social Proof)

```css
.logos__label {
  text-align: center;
  font-size: 0.8rem;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--color-muted);
  margin-bottom: 2rem;
}

.logos__strip {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: clamp(2rem, 4vw, 4rem);
  flex-wrap: wrap;
}

.logos__strip img {
  height: 24px;
  opacity: 0.4;
  filter: grayscale(1);
  transition: opacity 0.3s ease, filter 0.3s ease;
}

.logos__strip img:hover {
  opacity: 1;
  filter: grayscale(0);
}
```

---

## Dashboard

데이터 밀도가 높은 정보 인터페이스.

### 레이아웃 구조

```
┌──────┬────────────────────────────────┐
│      │  Header (breadcrumb, search)   │
│ Side │├───────┬───────┬───────┬───────┤
│ bar  ││ KPI   │ KPI   │ KPI   │ KPI   │
│      │├───────┴───────┼───────┴───────┤
│      ││ Main Chart    │ Activity Feed │
│      │├───────────────┼───────────────┤
│      ││ Data Table    │ Side Panel    │
│      │├───────────────┴───────────────┤
└──────┴────────────────────────────────┘
```

```css
.dashboard {
  display: grid;
  grid-template-columns: 260px 1fr;
  grid-template-rows: auto 1fr;
  min-height: 100vh;
  background: var(--color-bg);
}

/* Sidebar */
.sidebar {
  grid-row: 1 / -1;
  background: var(--color-surface);
  border-right: 1px solid var(--color-border);
  padding: 1.5rem 0;
  display: flex;
  flex-direction: column;
}

.sidebar__logo {
  padding: 0 1.5rem;
  margin-bottom: 2rem;
}

.sidebar__nav {
  flex: 1;
  overflow-y: auto;
}

.sidebar__link {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.625rem 1.5rem;
  font-size: 0.875rem;
  color: var(--color-muted);
  text-decoration: none;
  transition: all 0.15s ease;
  border-left: 2px solid transparent;
}

.sidebar__link:hover {
  color: var(--color-fg);
  background: rgba(var(--color-accent-rgb), 0.04);
}

.sidebar__link--active {
  color: var(--color-accent);
  background: rgba(var(--color-accent-rgb), 0.08);
  border-left-color: var(--color-accent);
}

/* Header */
.dashboard__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1rem 2rem;
  border-bottom: 1px solid var(--color-border);
}

/* Content */
.dashboard__content {
  padding: 2rem;
  overflow-y: auto;
}

/* KPI 카드 그리드 */
.kpi-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 1rem;
  margin-bottom: 2rem;
}

.kpi-card {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: 1rem;
  padding: 1.5rem;
}

.kpi-card__label {
  font-size: 0.75rem;
  color: var(--color-muted);
  letter-spacing: 0.05em;
  text-transform: uppercase;
}

.kpi-card__value {
  font-family: var(--font-display);
  font-size: 2rem;
  font-weight: 700;
  margin-top: 0.5rem;
}

.kpi-card__delta {
  font-size: 0.8rem;
  margin-top: 0.25rem;
}

.kpi-card__delta--up { color: #22c55e; }
.kpi-card__delta--down { color: #ef4444; }

/* 메인 컨텐츠 2열 레이아웃 */
.dashboard__main {
  display: grid;
  grid-template-columns: 1fr 360px;
  gap: 1.5rem;
}

@media (max-width: 1200px) {
  .dashboard { grid-template-columns: 1fr; }
  .sidebar { display: none; }
  .dashboard__main { grid-template-columns: 1fr; }
}
```

### 데이터 테이블

```css
.data-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.875rem;
}

.data-table th {
  text-align: left;
  padding: 0.75rem 1rem;
  font-size: 0.7rem;
  font-weight: 600;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--color-muted);
  border-bottom: 1px solid var(--color-border);
}

.data-table td {
  padding: 0.875rem 1rem;
  border-bottom: 1px solid var(--color-border);
}

.data-table tr {
  transition: background 0.1s ease;
}

.data-table tr:hover {
  background: rgba(var(--color-accent-rgb), 0.03);
}
```

---

## Portfolio / Showcase

작품이나 프로젝트를 보여주는 레이아웃.

### 패턴 A: 풀스크린 케이스 스터디

```css
.portfolio {
  /* 각 프로젝트가 풀스크린 섹션 */
}

.case {
  min-height: 100vh;
  display: grid;
  grid-template-columns: 1fr 1fr;
  cursor: pointer;
  overflow: hidden;
}

.case__info {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: clamp(3rem, 6vw, 8rem);
}

.case__number {
  font-family: var(--font-mono);
  font-size: 0.75rem;
  color: var(--color-muted);
  letter-spacing: 0.1em;
}

.case__title {
  font-family: var(--font-display);
  font-size: clamp(2.5rem, 5vw, 5rem);
  line-height: 1;
  margin: 1rem 0;
}

.case__tags {
  display: flex;
  gap: 0.75rem;
  margin-top: 1rem;
}

.case__tag {
  font-size: 0.7rem;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  padding: 0.35rem 0.75rem;
  border: 1px solid var(--color-border);
  border-radius: 2rem;
  color: var(--color-muted);
}

.case__media {
  position: relative;
  overflow: hidden;
}

.case__media img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.6s cubic-bezier(0.16, 1, 0.3, 1);
}

.case:hover .case__media img {
  transform: scale(1.05);
}

/* 교차 색상 — 홀수/짝수 다른 배경 */
.case:nth-child(even) {
  background: var(--color-surface);
}

.case:nth-child(even) {
  direction: rtl; /* 이미지와 텍스트 위치 교대 */
}

.case:nth-child(even) > * {
  direction: ltr;
}
```

### 패턴 B: 인터랙티브 그리드

```css
.portfolio-grid {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: 1rem;
  padding: 2rem;
}

/* 다양한 크기의 아이템 */
.portfolio-grid__item--wide {
  grid-column: span 8;
  aspect-ratio: 16/9;
}

.portfolio-grid__item--tall {
  grid-column: span 4;
  grid-row: span 2;
}

.portfolio-grid__item--square {
  grid-column: span 4;
  aspect-ratio: 1;
}

.portfolio-grid__item {
  position: relative;
  overflow: hidden;
  border-radius: 0.75rem;
  cursor: pointer;
}

.portfolio-grid__item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}

.portfolio-grid__item:hover img {
  transform: scale(1.08);
}

/* 호버 시 오버레이 */
.portfolio-grid__overlay {
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  padding: 2rem;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.portfolio-grid__item:hover .portfolio-grid__overlay {
  opacity: 1;
}
```

---

## Blog / Editorial

### 아티클 레이아웃

```css
.article {
  max-width: 72ch;
  margin: 0 auto;
  padding: 4rem clamp(1.5rem, 4vw, 2rem);
}

.article__header {
  margin-bottom: 3rem;
  text-align: center;
}

.article__category {
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: var(--color-accent);
}

.article__title {
  font-family: var(--font-display);
  font-size: clamp(2rem, 5vw, 3.5rem);
  line-height: 1.15;
  margin: 1rem 0;
}

.article__meta {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  font-size: 0.85rem;
  color: var(--color-muted);
}

.article__meta__divider {
  width: 3px;
  height: 3px;
  border-radius: 50%;
  background: var(--color-muted);
}

/* 프로즈 타이포그래피 */
.article__body {
  font-size: 1.1rem;
  line-height: 1.8;
  color: var(--color-fg);
}

.article__body h2 {
  font-family: var(--font-display);
  font-size: 1.75rem;
  margin-top: 3rem;
  margin-bottom: 1rem;
}

.article__body p + p {
  margin-top: 1.5rem;
}

.article__body blockquote {
  border-left: 3px solid var(--color-accent);
  padding-left: 1.5rem;
  margin: 2rem 0;
  font-style: italic;
  color: var(--color-muted);
}

.article__body img {
  width: calc(100% + 4rem);
  margin-left: -2rem;
  border-radius: 0.75rem;
  margin: 2rem -2rem;
}

.article__body code {
  font-family: var(--font-mono);
  font-size: 0.9em;
  background: var(--color-surface);
  padding: 0.15em 0.4em;
  border-radius: 0.25rem;
}

.article__body pre {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: 0.75rem;
  padding: 1.5rem;
  overflow-x: auto;
  margin: 2rem 0;
}

.article__body pre code {
  background: none;
  padding: 0;
}
```

### 블로그 리스트 페이지

```css
.blog-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 2.5rem;
  padding: var(--section-gap) 0;
}

/* 첫 아티클 강조 */
.blog-list .card:first-child {
  grid-column: 1 / -1;
  display: grid;
  grid-template-columns: 1.2fr 1fr;
  gap: 2.5rem;
}
```

---

## SaaS Application Shell

앱 전체의 레이아웃 셸.

```css
.app-shell {
  display: grid;
  grid-template-columns: var(--sidebar-width, 260px) 1fr;
  grid-template-rows: var(--header-height, 56px) 1fr;
  height: 100vh;
  overflow: hidden;
}

.app-shell__sidebar {
  grid-row: 1 / -1;
  border-right: 1px solid var(--color-border);
  overflow-y: auto;
}

.app-shell__header {
  grid-column: 2;
  border-bottom: 1px solid var(--color-border);
  display: flex;
  align-items: center;
  padding: 0 1.5rem;
  gap: 1rem;
}

.app-shell__main {
  grid-column: 2;
  overflow-y: auto;
  padding: 1.5rem;
}

/* 접히는 사이드바 */
.app-shell--collapsed {
  --sidebar-width: 64px;
}

.app-shell--collapsed .sidebar__label {
  display: none;
}

.app-shell--collapsed .sidebar__link {
  justify-content: center;
  padding: 0.75rem;
}

/* Command palette overlay */
.command-palette {
  position: fixed;
  inset: 0;
  z-index: 999;
  display: flex;
  align-items: flex-start;
  justify-content: center;
  padding-top: 20vh;
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(4px);
}

.command-palette__input-wrapper {
  width: min(90vw, 560px);
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: 1rem;
  overflow: hidden;
  box-shadow: 0 24px 48px rgba(0, 0, 0, 0.2);
}

.command-palette__input {
  width: 100%;
  padding: 1rem 1.25rem;
  font-size: 1rem;
  background: transparent;
  border: none;
  color: var(--color-fg);
  outline: none;
}

.command-palette__results {
  border-top: 1px solid var(--color-border);
  max-height: 320px;
  overflow-y: auto;
}

.command-palette__item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem 1.25rem;
  font-size: 0.875rem;
  cursor: pointer;
  transition: background 0.1s ease;
}

.command-palette__item:hover,
.command-palette__item--active {
  background: rgba(var(--color-accent-rgb), 0.08);
}

.command-palette__shortcut {
  margin-left: auto;
  font-family: var(--font-mono);
  font-size: 0.7rem;
  color: var(--color-muted);
  padding: 0.2rem 0.4rem;
  border: 1px solid var(--color-border);
  border-radius: 0.25rem;
}
```

---

## E-commerce Product Page

```css
.product {
  display: grid;
  grid-template-columns: 1.2fr 1fr;
  gap: clamp(2rem, 4vw, 5rem);
  padding: 2rem clamp(2rem, 5vw, 6rem);
  max-width: 1400px;
  margin: 0 auto;
}

/* 이미지 갤러리 */
.product__gallery {
  display: grid;
  grid-template-columns: 80px 1fr;
  gap: 1rem;
  position: sticky;
  top: 100px;
  height: fit-content;
}

.product__thumbnails {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.product__thumb {
  aspect-ratio: 1;
  border-radius: 0.5rem;
  overflow: hidden;
  cursor: pointer;
  border: 2px solid transparent;
  transition: border-color 0.15s ease;
}

.product__thumb--active {
  border-color: var(--color-accent);
}

.product__main-image {
  aspect-ratio: 3/4;
  border-radius: 1rem;
  overflow: hidden;
}

.product__main-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* 제품 정보 */
.product__info {
  padding: 2rem 0;
}

.product__brand {
  font-size: 0.75rem;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: var(--color-muted);
}

.product__name {
  font-family: var(--font-display);
  font-size: clamp(1.5rem, 3vw, 2.5rem);
  margin: 0.5rem 0;
}

.product__price {
  font-size: 1.5rem;
  font-weight: 700;
  margin: 1rem 0;
}

.product__price--sale {
  color: var(--color-accent);
}

.product__price--original {
  font-size: 1rem;
  color: var(--color-muted);
  text-decoration: line-through;
  margin-left: 0.5rem;
  font-weight: 400;
}

/* 사이즈 셀렉터 */
.size-selector {
  display: flex;
  gap: 0.5rem;
  margin: 1.5rem 0;
}

.size-selector__option {
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1.5px solid var(--color-border);
  border-radius: 0.5rem;
  font-size: 0.85rem;
  cursor: pointer;
  transition: all 0.15s ease;
  background: transparent;
}

.size-selector__option:hover {
  border-color: var(--color-fg);
}

.size-selector__option--active {
  border-color: var(--color-accent);
  background: rgba(var(--color-accent-rgb), 0.08);
  color: var(--color-accent);
  font-weight: 600;
}

.size-selector__option--disabled {
  opacity: 0.3;
  cursor: not-allowed;
  text-decoration: line-through;
}

@media (max-width: 768px) {
  .product {
    grid-template-columns: 1fr;
  }
  .product__gallery {
    position: static;
    grid-template-columns: 1fr;
  }
  .product__thumbnails {
    flex-direction: row;
    order: 1;
  }
}
```

---

## Documentation Layout

```css
.docs {
  display: grid;
  grid-template-columns: 260px 1fr 200px;
  min-height: 100vh;
}

.docs__sidebar {
  position: sticky;
  top: 0;
  height: 100vh;
  overflow-y: auto;
  padding: 2rem 0;
  border-right: 1px solid var(--color-border);
}

.docs__content {
  max-width: 72ch;
  padding: 3rem clamp(2rem, 4vw, 4rem);
}

.docs__toc {
  position: sticky;
  top: 2rem;
  height: fit-content;
  padding: 0 1rem;
}

.docs__toc-title {
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--color-muted);
  margin-bottom: 1rem;
}

.docs__toc-link {
  display: block;
  font-size: 0.8rem;
  color: var(--color-muted);
  text-decoration: none;
  padding: 0.3rem 0;
  padding-left: 0.75rem;
  border-left: 1.5px solid var(--color-border);
  transition: all 0.15s ease;
}

.docs__toc-link:hover {
  color: var(--color-fg);
}

.docs__toc-link--active {
  color: var(--color-accent);
  border-left-color: var(--color-accent);
}

/* 사이드바 네비게이션 그룹 */
.docs-nav__group {
  margin-bottom: 1.5rem;
}

.docs-nav__group-title {
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--color-muted);
  padding: 0 1.5rem;
  margin-bottom: 0.5rem;
}

.docs-nav__link {
  display: block;
  padding: 0.375rem 1.5rem;
  font-size: 0.85rem;
  color: var(--color-muted);
  text-decoration: none;
  transition: all 0.1s ease;
}

.docs-nav__link:hover {
  color: var(--color-fg);
}

.docs-nav__link--active {
  color: var(--color-accent);
  background: rgba(var(--color-accent-rgb), 0.06);
}

@media (max-width: 1024px) {
  .docs { grid-template-columns: 1fr; }
  .docs__sidebar, .docs__toc { display: none; }
}
```

---

## 반응형 전략

모든 레이아웃에 적용할 공통 반응형 원칙.

### 브레이크포인트

```css
/* 모바일 퍼스트 브레이크포인트 */
/* sm: 640px, md: 768px, lg: 1024px, xl: 1280px, 2xl: 1536px */

/* 선호: clamp()로 브레이크포인트 없이 유동적 처리 */
.section-title {
  font-size: clamp(2rem, 4vw + 1rem, 4rem);
}

.container {
  padding: 0 clamp(1rem, 4vw, 6rem);
}

section {
  padding: clamp(4rem, 8vh, 10rem) 0;
}
```

### 그리드 축소 패턴

```css
/* 4열 → 2열 → 1열 자동 축소 */
.grid-responsive {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(100%, 300px), 1fr));
  gap: clamp(1rem, 2vw, 2rem);
}

/* 사이드바 레이아웃 → 스택 */
@media (max-width: 768px) {
  .layout-with-sidebar {
    grid-template-columns: 1fr;
  }
}
```

### 터치 타겟

```css
/* 모바일에서 최소 44x44px 터치 영역 확보 */
@media (pointer: coarse) {
  .btn { min-height: 44px; min-width: 44px; }
  .nav__link { padding: 0.75rem 1rem; }
  .form__input { font-size: 16px; /* iOS 줌 방지 */ }
}
```

### 컨테이너 쿼리 (모던 레이아웃)

```css
.card-wrapper {
  container-type: inline-size;
}

@container (min-width: 500px) {
  .card {
    display: grid;
    grid-template-columns: 200px 1fr;
  }
}

@container (max-width: 499px) {
  .card {
    display: block;
  }
  .card__media {
    aspect-ratio: 16/9;
  }
}
```
