# Component Patterns

실제 구현에 바로 사용할 수 있는 UI 컴포넌트 패턴. 각 패턴은 미학적 변형과 함께 제공된다.

## Table of Contents

1. [Hero Section](#hero-section)
2. [Card](#card)
3. [Navigation](#navigation)
4. [Form](#form)
5. [Modal / Dialog](#modal--dialog)
6. [Feature Grid](#feature-grid)
7. [Testimonial](#testimonial)
8. [Pricing Table](#pricing-table)
9. [Footer](#footer)
10. [Toast / Notification](#toast--notification)

---

## Hero Section

가장 먼저 눈에 들어오는 영역. 첫인상을 결정한다.

### 패턴 A: Split Hero (텍스트 + 비주얼 분리)

```html
<section class="hero">
  <div class="hero__content">
    <span class="hero__eyebrow">Introducing v3.0</span>
    <h1 class="hero__title">Design that<br><em>actually ships</em></h1>
    <p class="hero__subtitle">Tools for teams who care about craft</p>
    <div class="hero__actions">
      <button class="btn btn--primary">Get Started</button>
      <button class="btn btn--ghost">Watch Demo →</button>
    </div>
  </div>
  <div class="hero__visual">
    <!-- 3D 요소, 일러스트, 인터랙티브 캔버스 등 -->
  </div>
</section>
```

```css
.hero {
  display: grid;
  grid-template-columns: 1fr 1fr;
  min-height: 90vh;
  align-items: center;
  gap: 4rem;
  padding: 0 clamp(2rem, 5vw, 8rem);
}

.hero__eyebrow {
  font-family: var(--font-mono);
  font-size: 0.75rem;
  letter-spacing: 0.2em;
  text-transform: uppercase;
  color: var(--color-accent);
}

.hero__title {
  font-family: var(--font-display);
  font-size: clamp(3rem, 6vw, 7rem);
  line-height: 0.95;
  letter-spacing: -0.03em;
  margin: 1rem 0;
}

.hero__title em {
  font-style: italic;
  background: linear-gradient(135deg, var(--color-accent), var(--color-accent-alt));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.hero__subtitle {
  font-size: 1.25rem;
  color: var(--color-muted);
  max-width: 28ch;
}

/* 진입 애니메이션 — staggered reveal */
.hero__eyebrow { animation: fadeUp 0.6s ease both; animation-delay: 0.1s; }
.hero__title   { animation: fadeUp 0.6s ease both; animation-delay: 0.2s; }
.hero__subtitle{ animation: fadeUp 0.6s ease both; animation-delay: 0.35s; }
.hero__actions { animation: fadeUp 0.6s ease both; animation-delay: 0.5s; }
.hero__visual  { animation: fadeUp 0.8s ease both; animation-delay: 0.3s; }

@keyframes fadeUp {
  from { opacity: 0; transform: translateY(24px); }
  to   { opacity: 1; transform: translateY(0); }
}
```

### 패턴 B: Full-bleed Hero (텍스트 오버레이)

```css
.hero--fullbleed {
  position: relative;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  overflow: hidden;
}

.hero--fullbleed::before {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(ellipse at 30% 50%, rgba(0,0,0,0.2), rgba(0,0,0,0.7));
  z-index: 1;
}

.hero--fullbleed .hero__content {
  position: relative;
  z-index: 2;
  max-width: 60ch;
}

.hero--fullbleed video,
.hero--fullbleed img {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
}
```

### 패턴 C: Editorial Hero (비대칭 매거진 스타일)

```css
.hero--editorial {
  display: grid;
  grid-template-columns: 2fr 3fr;
  grid-template-rows: auto 1fr auto;
  min-height: 100vh;
  padding: 2rem;
  gap: 0;
}

.hero--editorial .hero__eyebrow {
  grid-column: 1;
  writing-mode: vertical-rl;
  align-self: center;
  font-size: 0.65rem;
  letter-spacing: 0.3em;
}

.hero--editorial .hero__title {
  grid-column: 1 / -1;
  font-size: clamp(4rem, 10vw, 12rem);
  line-height: 0.85;
  mix-blend-mode: difference;
}

.hero--editorial .hero__visual {
  grid-column: 2;
  grid-row: 1 / -1;
  clip-path: polygon(10% 0, 100% 0, 100% 100%, 0 100%);
}
```

### 미학별 변형 가이드

| 미학 | Hero 접근 | 핵심 기법 |
|------|----------|-----------|
| Brutalist | 거대 타이포만, 이미지 없음 | `font-size: 20vw`, 모노스페이스, 하드 엣지 |
| Luxury | 풀스크린 비디오/이미지 + 섬세한 오버레이 | 세리프 폰트, `letter-spacing: 0.15em`, 느린 fade |
| Playful | 인터랙티브 요소, 커서 반응 | 커스텀 커서, bouncy 애니메이션, 불규칙 레이아웃 |
| Editorial | 비대칭 그리드, 오버랩 | `mix-blend-mode`, `clip-path`, 대비 강한 타이포 |
| Retro-Futuristic | 스캔라인, CRT 효과 | 그리드라인, `text-shadow` 글로우, 모노스페이스 |

---

## Card

정보 단위를 담는 가장 보편적인 컴포넌트.

### 기본 카드 구조

```html
<article class="card">
  <div class="card__media">
    <img src="..." alt="..." loading="lazy" />
    <span class="card__badge">New</span>
  </div>
  <div class="card__body">
    <span class="card__meta">Design · 5 min read</span>
    <h3 class="card__title">The Art of Negative Space</h3>
    <p class="card__excerpt">How strategic emptiness creates visual tension...</p>
  </div>
  <div class="card__footer">
    <img class="card__avatar" src="..." alt="Author" />
    <span class="card__author">Sarah Kim</span>
    <time class="card__date">Mar 12</time>
  </div>
</article>
```

### 변형: Glass Card

```css
.card--glass {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(20px) saturate(1.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 1.5rem;
  overflow: hidden;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.card--glass:hover {
  transform: translateY(-4px);
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  border-color: rgba(255, 255, 255, 0.2);
}
```

### 변형: Editorial Card (이미지 오버랩)

```css
.card--editorial {
  display: grid;
  grid-template-rows: 1fr auto;
  position: relative;
}

.card--editorial .card__media {
  grid-row: 1 / -1;
  grid-column: 1;
}

.card--editorial .card__body {
  grid-row: 2;
  grid-column: 1;
  background: var(--color-surface);
  padding: 2rem;
  margin: 0 1.5rem;
  transform: translateY(2rem);
  position: relative;
  z-index: 1;
}
```

### 변형: Brutalist Card

```css
.card--brutalist {
  border: 3px solid var(--color-fg);
  background: var(--color-bg);
  padding: 0;
  transition: none;
}

.card--brutalist:hover {
  background: var(--color-fg);
  color: var(--color-bg);
  transform: translate(-4px, -4px);
  box-shadow: 4px 4px 0 var(--color-fg);
}

.card--brutalist .card__title {
  font-family: var(--font-mono);
  text-transform: uppercase;
  font-size: 1.1rem;
  letter-spacing: 0.05em;
  padding: 1rem;
  border-top: 3px solid currentColor;
}
```

### 카드 그리드 레이아웃

```css
/* 균일 그리드 */
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 2rem;
}

/* 매거진 스타일 — 첫 카드 강조 */
.card-grid--featured {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-template-rows: auto;
  gap: 1.5rem;
}

.card-grid--featured .card:first-child {
  grid-column: 1 / 3;
  grid-row: 1 / 3;
}

/* Masonry (CSS-only, 2024+) */
.card-grid--masonry {
  columns: 3 320px;
  column-gap: 1.5rem;
}

.card-grid--masonry .card {
  break-inside: avoid;
  margin-bottom: 1.5rem;
}
```

---

## Navigation

### 패턴 A: 미니멀 Navbar

```html
<nav class="nav">
  <a href="/" class="nav__logo">
    <svg><!-- 로고 --></svg>
  </a>
  <ul class="nav__links">
    <li><a href="/work" class="nav__link">Work</a></li>
    <li><a href="/about" class="nav__link">About</a></li>
    <li><a href="/journal" class="nav__link">Journal</a></li>
  </ul>
  <button class="nav__cta btn btn--primary btn--sm">Contact</button>
</nav>
```

```css
.nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.5rem clamp(2rem, 5vw, 6rem);
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  transition: background 0.3s ease, backdrop-filter 0.3s ease;
}

/* 스크롤 시 배경 */
.nav--scrolled {
  background: rgba(var(--color-bg-rgb), 0.8);
  backdrop-filter: blur(12px);
  border-bottom: 1px solid rgba(var(--color-fg-rgb), 0.06);
}

.nav__links {
  display: flex;
  gap: 2rem;
  list-style: none;
}

.nav__link {
  font-size: 0.875rem;
  letter-spacing: 0.02em;
  color: var(--color-muted);
  text-decoration: none;
  position: relative;
}

.nav__link::after {
  content: '';
  position: absolute;
  bottom: -4px;
  left: 0;
  width: 0;
  height: 1.5px;
  background: var(--color-accent);
  transition: width 0.3s ease;
}

.nav__link:hover::after,
.nav__link--active::after {
  width: 100%;
}
```

### 패턴 B: 풀스크린 모바일 메뉴

```css
.nav__overlay {
  position: fixed;
  inset: 0;
  background: var(--color-bg);
  z-index: 200;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 4rem;
  clip-path: circle(0% at calc(100% - 3rem) 2.5rem);
  transition: clip-path 0.6s cubic-bezier(0.77, 0, 0.175, 1);
}

.nav__overlay--open {
  clip-path: circle(150% at calc(100% - 3rem) 2.5rem);
}

.nav__overlay .nav__link {
  font-family: var(--font-display);
  font-size: clamp(2rem, 6vw, 4rem);
  line-height: 1.3;
  color: var(--color-fg);
  display: block;
  opacity: 0;
  transform: translateY(20px);
}

.nav__overlay--open .nav__link {
  animation: fadeUp 0.4s ease forwards;
}

.nav__overlay--open .nav__link:nth-child(1) { animation-delay: 0.2s; }
.nav__overlay--open .nav__link:nth-child(2) { animation-delay: 0.3s; }
.nav__overlay--open .nav__link:nth-child(3) { animation-delay: 0.4s; }
.nav__overlay--open .nav__link:nth-child(4) { animation-delay: 0.5s; }
```

### 햄버거 아이콘 애니메이션

```css
.hamburger {
  width: 32px;
  height: 24px;
  position: relative;
  cursor: pointer;
  background: none;
  border: none;
}

.hamburger span {
  display: block;
  width: 100%;
  height: 2px;
  background: var(--color-fg);
  position: absolute;
  left: 0;
  transition: all 0.3s ease;
}

.hamburger span:nth-child(1) { top: 0; }
.hamburger span:nth-child(2) { top: 50%; transform: translateY(-50%); }
.hamburger span:nth-child(3) { bottom: 0; }

.hamburger--open span:nth-child(1) { top: 50%; transform: translateY(-50%) rotate(45deg); }
.hamburger--open span:nth-child(2) { opacity: 0; }
.hamburger--open span:nth-child(3) { bottom: 50%; transform: translateY(50%) rotate(-45deg); }
```

---

## Form

### 인터랙티브 폼 필드

```html
<div class="field">
  <input type="email" id="email" class="field__input" placeholder=" " required />
  <label for="email" class="field__label">Email address</label>
  <span class="field__highlight"></span>
  <span class="field__error">Please enter a valid email</span>
</div>
```

```css
.field {
  position: relative;
  margin-bottom: 2rem;
}

.field__input {
  width: 100%;
  padding: 1.25rem 1rem 0.5rem;
  font-size: 1rem;
  font-family: var(--font-body);
  background: var(--color-surface);
  border: 1.5px solid var(--color-border);
  border-radius: 0.75rem;
  outline: none;
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.field__label {
  position: absolute;
  top: 50%;
  left: 1rem;
  transform: translateY(-50%);
  font-size: 1rem;
  color: var(--color-muted);
  pointer-events: none;
  transition: all 0.2s ease;
}

/* Float label on focus or when filled */
.field__input:focus + .field__label,
.field__input:not(:placeholder-shown) + .field__label {
  top: 0.5rem;
  transform: translateY(0);
  font-size: 0.7rem;
  font-weight: 600;
  color: var(--color-accent);
  letter-spacing: 0.05em;
}

.field__input:focus {
  border-color: var(--color-accent);
  box-shadow: 0 0 0 3px rgba(var(--color-accent-rgb), 0.15);
}

/* 에러 상태 */
.field__input:invalid:not(:placeholder-shown) {
  border-color: var(--color-error);
}

.field__error {
  display: none;
  font-size: 0.75rem;
  color: var(--color-error);
  margin-top: 0.5rem;
  padding-left: 1rem;
}

.field__input:invalid:not(:placeholder-shown) ~ .field__error {
  display: block;
}
```

### 버튼 시스템

```css
.btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.875rem 2rem;
  font-family: var(--font-body);
  font-size: 0.9rem;
  font-weight: 600;
  letter-spacing: 0.01em;
  border: none;
  border-radius: 0.75rem;
  cursor: pointer;
  transition: all 0.2s ease;
  position: relative;
  overflow: hidden;
}

.btn--primary {
  background: var(--color-accent);
  color: var(--color-on-accent);
}

.btn--primary:hover {
  transform: translateY(-1px);
  box-shadow: 0 8px 24px rgba(var(--color-accent-rgb), 0.35);
}

.btn--primary:active {
  transform: translateY(0);
}

.btn--ghost {
  background: transparent;
  color: var(--color-fg);
  border: 1.5px solid var(--color-border);
}

.btn--ghost:hover {
  border-color: var(--color-fg);
  background: rgba(var(--color-fg-rgb), 0.04);
}

.btn--sm { padding: 0.5rem 1.25rem; font-size: 0.8rem; }
.btn--lg { padding: 1.1rem 2.75rem; font-size: 1rem; }

/* Ripple effect */
.btn::after {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(circle, rgba(255,255,255,0.3) 10%, transparent 70%);
  transform: scale(0);
  opacity: 0;
  transition: transform 0.5s ease, opacity 0.3s ease;
}

.btn:active::after {
  transform: scale(3);
  opacity: 1;
  transition: transform 0s, opacity 0s;
}
```

---

## Modal / Dialog

```html
<dialog class="modal" id="modal">
  <div class="modal__content">
    <button class="modal__close" aria-label="Close">
      <svg width="20" height="20"><path d="M4 4l12 12M16 4L4 16" stroke="currentColor" stroke-width="2"/></svg>
    </button>
    <h2 class="modal__title">Confirm action</h2>
    <p class="modal__body">This cannot be undone.</p>
    <div class="modal__actions">
      <button class="btn btn--ghost" onclick="this.closest('dialog').close()">Cancel</button>
      <button class="btn btn--primary">Confirm</button>
    </div>
  </div>
</dialog>
```

```css
.modal {
  border: none;
  background: transparent;
  max-width: min(90vw, 480px);
  padding: 0;
}

.modal::backdrop {
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(4px);
  animation: fadeIn 0.2s ease;
}

.modal[open] {
  animation: modalIn 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.modal__content {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: 1.25rem;
  padding: 2rem;
  position: relative;
}

.modal__close {
  position: absolute;
  top: 1rem;
  right: 1rem;
  background: none;
  border: none;
  color: var(--color-muted);
  cursor: pointer;
  padding: 0.5rem;
  border-radius: 0.5rem;
  transition: background 0.15s ease;
}

.modal__close:hover {
  background: rgba(var(--color-fg-rgb), 0.06);
}

.modal__actions {
  display: flex;
  gap: 0.75rem;
  justify-content: flex-end;
  margin-top: 1.5rem;
}

@keyframes modalIn {
  from { opacity: 0; transform: scale(0.95) translateY(8px); }
  to   { opacity: 1; transform: scale(1) translateY(0); }
}

@keyframes fadeIn {
  from { opacity: 0; }
  to   { opacity: 1; }
}
```

---

## Feature Grid

제품/서비스 기능을 시각적으로 보여주는 섹션.

```html
<section class="features">
  <div class="features__header">
    <h2 class="section-title">Built for scale</h2>
    <p class="section-subtitle">Everything you need, nothing you don't.</p>
  </div>
  <div class="features__grid">
    <div class="feature">
      <div class="feature__icon">⚡</div>
      <h3 class="feature__title">Lightning fast</h3>
      <p class="feature__desc">Sub-50ms response times globally.</p>
    </div>
    <!-- 더 많은 feature 항목... -->
  </div>
</section>
```

```css
.features__grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1px;
  background: var(--color-border);
  border: 1px solid var(--color-border);
  border-radius: 1.5rem;
  overflow: hidden;
}

.feature {
  background: var(--color-surface);
  padding: 2.5rem;
  transition: background 0.3s ease;
}

.feature:hover {
  background: rgba(var(--color-accent-rgb), 0.04);
}

.feature__icon {
  width: 3rem;
  height: 3rem;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  background: rgba(var(--color-accent-rgb), 0.1);
  border-radius: 0.75rem;
  margin-bottom: 1.25rem;
}

.feature__title {
  font-size: 1.1rem;
  font-weight: 600;
  margin-bottom: 0.5rem;
}

.feature__desc {
  font-size: 0.9rem;
  color: var(--color-muted);
  line-height: 1.6;
}
```

---

## Testimonial

```css
.testimonial {
  position: relative;
  padding: 3rem;
  border-left: 3px solid var(--color-accent);
}

.testimonial__quote {
  font-family: var(--font-display);
  font-size: clamp(1.25rem, 2.5vw, 1.75rem);
  font-style: italic;
  line-height: 1.5;
  color: var(--color-fg);
  margin-bottom: 1.5rem;
}

.testimonial__quote::before {
  content: '"';
  font-size: 4rem;
  line-height: 0;
  vertical-align: -0.5rem;
  color: var(--color-accent);
  opacity: 0.3;
  margin-right: 0.25rem;
}

.testimonial__author {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.testimonial__avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  object-fit: cover;
}

.testimonial__name {
  font-weight: 600;
  font-size: 0.9rem;
}

.testimonial__role {
  font-size: 0.8rem;
  color: var(--color-muted);
}
```

---

## Pricing Table

```css
.pricing {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
  align-items: start;
}

.pricing__card {
  border: 1.5px solid var(--color-border);
  border-radius: 1.5rem;
  padding: 2.5rem;
  position: relative;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.pricing__card:hover {
  transform: translateY(-4px);
  box-shadow: 0 20px 40px rgba(0,0,0,0.08);
}

.pricing__card--featured {
  border-color: var(--color-accent);
  background: rgba(var(--color-accent-rgb), 0.02);
}

.pricing__card--featured::before {
  content: 'Most Popular';
  position: absolute;
  top: -0.75rem;
  left: 2rem;
  background: var(--color-accent);
  color: var(--color-on-accent);
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  padding: 0.25rem 1rem;
  border-radius: 2rem;
}

.pricing__price {
  font-family: var(--font-display);
  font-size: 3.5rem;
  font-weight: 700;
  line-height: 1;
  margin: 1rem 0;
}

.pricing__price span {
  font-size: 1rem;
  font-weight: 400;
  color: var(--color-muted);
}

.pricing__features {
  list-style: none;
  padding: 0;
  margin: 2rem 0;
}

.pricing__features li {
  padding: 0.5rem 0;
  padding-left: 1.5rem;
  position: relative;
  font-size: 0.9rem;
  color: var(--color-muted);
}

.pricing__features li::before {
  content: '✓';
  position: absolute;
  left: 0;
  color: var(--color-accent);
  font-weight: 700;
}
```

---

## Footer

```css
.footer {
  padding: 5rem clamp(2rem, 5vw, 6rem) 2rem;
  border-top: 1px solid var(--color-border);
}

.footer__grid {
  display: grid;
  grid-template-columns: 2fr repeat(3, 1fr);
  gap: 3rem;
  margin-bottom: 4rem;
}

.footer__brand {
  max-width: 20rem;
}

.footer__tagline {
  font-size: 0.9rem;
  color: var(--color-muted);
  line-height: 1.6;
  margin-top: 1rem;
}

.footer__heading {
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--color-muted);
  margin-bottom: 1.25rem;
}

.footer__links {
  list-style: none;
  padding: 0;
}

.footer__links li + li {
  margin-top: 0.75rem;
}

.footer__links a {
  font-size: 0.9rem;
  color: var(--color-fg);
  text-decoration: none;
  transition: color 0.15s ease;
}

.footer__links a:hover {
  color: var(--color-accent);
}

.footer__bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 2rem;
  border-top: 1px solid var(--color-border);
  font-size: 0.8rem;
  color: var(--color-muted);
}

@media (max-width: 768px) {
  .footer__grid {
    grid-template-columns: 1fr 1fr;
  }
  .footer__brand {
    grid-column: 1 / -1;
  }
}
```

---

## Toast / Notification

```css
.toast-container {
  position: fixed;
  bottom: 2rem;
  right: 2rem;
  display: flex;
  flex-direction: column-reverse;
  gap: 0.75rem;
  z-index: 9999;
}

.toast {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem 1.25rem;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: 0.75rem;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
  min-width: 300px;
  max-width: 420px;
  animation: toastIn 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.toast--success { border-left: 3px solid #22c55e; }
.toast--error   { border-left: 3px solid #ef4444; }
.toast--info    { border-left: 3px solid #3b82f6; }

.toast__message {
  flex: 1;
  font-size: 0.875rem;
}

.toast__dismiss {
  background: none;
  border: none;
  color: var(--color-muted);
  cursor: pointer;
  padding: 0.25rem;
}

.toast--exit {
  animation: toastOut 0.2s ease forwards;
}

@keyframes toastIn {
  from { opacity: 0; transform: translateX(100%) scale(0.95); }
  to   { opacity: 1; transform: translateX(0) scale(1); }
}

@keyframes toastOut {
  to { opacity: 0; transform: translateX(100%) scale(0.95); }
}
```
