# CSS Techniques Cookbook

SKILL.md에서 언급하는 시각 효과의 실제 구현 코드. 복사해서 바로 쓸 수 있는 레시피 형태.

## Table of Contents

1. [Gradient Mesh](#gradient-mesh)
2. [Glassmorphism](#glassmorphism)
3. [Noise / Grain Texture](#noise--grain-texture)
4. [Scroll Animations](#scroll-animations)
5. [Text Effects](#text-effects)
6. [Shadows & Depth](#shadows--depth)
7. [Borders & Dividers](#borders--dividers)
8. [Cursor Effects](#cursor-effects)
9. [Background Patterns](#background-patterns)
10. [Page Transitions](#page-transitions)
11. [Skeleton Loading](#skeleton-loading)
12. [Scroll-Driven Animations (CSS-only)](#scroll-driven-animations-css-only)

---

## Gradient Mesh

여러 그라디언트 레이어를 겹쳐 유기적 배경을 만든다.

### 정적 메시

```css
.gradient-mesh {
  background:
    radial-gradient(ellipse at 20% 50%, rgba(120, 80, 255, 0.4) 0%, transparent 50%),
    radial-gradient(ellipse at 80% 20%, rgba(255, 100, 80, 0.3) 0%, transparent 50%),
    radial-gradient(ellipse at 50% 80%, rgba(80, 200, 255, 0.3) 0%, transparent 50%),
    radial-gradient(ellipse at 70% 60%, rgba(255, 200, 50, 0.2) 0%, transparent 40%);
  background-color: #0a0a0b;
}
```

### 애니메이션 메시 (CSS-only)

```css
.gradient-mesh--animated {
  position: relative;
  overflow: hidden;
}

.gradient-mesh--animated::before,
.gradient-mesh--animated::after {
  content: '';
  position: absolute;
  width: 60vmax;
  height: 60vmax;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.5;
  animation: meshFloat 20s ease-in-out infinite alternate;
}

.gradient-mesh--animated::before {
  background: var(--color-accent);
  top: -20%;
  left: -10%;
}

.gradient-mesh--animated::after {
  background: #ff6b6b;
  bottom: -20%;
  right: -10%;
  animation-delay: -10s;
  animation-direction: alternate-reverse;
}

@keyframes meshFloat {
  0%   { transform: translate(0, 0) scale(1); }
  33%  { transform: translate(10%, -15%) scale(1.1); }
  66%  { transform: translate(-5%, 10%) scale(0.9); }
  100% { transform: translate(15%, 5%) scale(1.05); }
}
```

### Conic Gradient 변형

```css
.gradient-conic {
  background: conic-gradient(
    from 45deg at 50% 50%,
    #6366f1, #ec4899, #f59e0b, #22c55e, #6366f1
  );
  filter: blur(80px);
  opacity: 0.3;
}
```

---

## Glassmorphism

반투명 배경 + blur로 깊이감 표현.

### 기본 글래스

```css
.glass {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(20px) saturate(1.8);
  -webkit-backdrop-filter: blur(20px) saturate(1.8);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 1.5rem;
}

/* 라이트 모드용 */
.glass--light {
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(20px) saturate(1.5);
  border: 1px solid rgba(255, 255, 255, 0.4);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.06);
}
```

### 글래스 + 내부 광택 (Inner Glow)

```css
.glass--glow {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(24px);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 1.5rem;
  position: relative;
  overflow: hidden;
}

/* 상단 하이라이트 */
.glass--glow::before {
  content: '';
  position: absolute;
  top: 0;
  left: 10%;
  right: 10%;
  height: 1px;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(255, 255, 255, 0.3),
    transparent
  );
}
```

### Frosted Glass Navigation

```css
.nav--frosted {
  position: fixed;
  top: 1rem;
  left: 50%;
  transform: translateX(-50%);
  background: rgba(var(--color-bg-rgb), 0.6);
  backdrop-filter: blur(16px) saturate(1.5);
  border: 1px solid rgba(255, 255, 255, 0.06);
  border-radius: 999px;
  padding: 0.5rem 0.75rem;
  z-index: 100;
}
```

---

## Noise / Grain Texture

### SVG Noise (가장 가볍고 추천)

```html
<!-- HTML에 한 번만 추가, 시각적으로 보이지 않음 -->
<svg class="sr-only" aria-hidden="true">
  <filter id="noise">
    <feTurbulence type="fractalNoise" baseFrequency="0.65" numOctaves="3" stitchTiles="stitch" />
    <feColorMatrix type="saturate" values="0" />
  </filter>
</svg>
```

```css
/* 전체 페이지에 노이즈 오버레이 */
body::after {
  content: '';
  position: fixed;
  inset: 0;
  pointer-events: none;
  z-index: 9999;
  opacity: 0.03;
  filter: url(#noise);
  /* 또는 CSS로만: */
  /* background-image: url("data:image/svg+xml,..."); */
}
```

### CSS-only Grain (base64 인라인)

```css
.grain::after {
  content: '';
  position: absolute;
  inset: 0;
  pointer-events: none;
  opacity: 0.04;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.7' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
  background-repeat: repeat;
  background-size: 256px 256px;
  mix-blend-mode: overlay;
}
```

### 움직이는 Grain (필름 느낌)

```css
.grain--animated::after {
  content: '';
  position: fixed;
  inset: -50%;
  width: 200%;
  height: 200%;
  pointer-events: none;
  z-index: 9999;
  opacity: 0.035;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 512 512' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.65' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
  animation: grainShift 0.5s steps(4) infinite;
}

@keyframes grainShift {
  0%   { transform: translate(0, 0); }
  25%  { transform: translate(-5%, -5%); }
  50%  { transform: translate(5%, 3%); }
  75%  { transform: translate(-3%, 7%); }
  100% { transform: translate(2%, -3%); }
}
```

---

## Scroll Animations

### Intersection Observer 패턴 (JS)

```javascript
// 한 번만 설정하면 [data-animate] 속성이 있는 모든 요소에 적용
const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('is-visible');
        observer.unobserve(entry.target); // 한 번만 실행
      }
    });
  },
  { threshold: 0.15, rootMargin: '0px 0px -50px 0px' }
);

document.querySelectorAll('[data-animate]').forEach(el => observer.observe(el));
```

```css
/* 기본 상태 — 보이지 않음 */
[data-animate] {
  opacity: 0;
  transform: translateY(32px);
  transition: opacity 0.6s ease, transform 0.6s ease;
}

/* Visible 상태 */
[data-animate].is-visible {
  opacity: 1;
  transform: translateY(0);
}

/* 변형: 좌측에서 등장 */
[data-animate="slide-left"] {
  transform: translateX(-40px);
}
[data-animate="slide-left"].is-visible {
  transform: translateX(0);
}

/* 변형: 스케일 */
[data-animate="scale"] {
  transform: scale(0.95);
}
[data-animate="scale"].is-visible {
  transform: scale(1);
}

/* Stagger 딜레이 — 그리드 아이템에 적용 */
[data-animate-delay="1"] { transition-delay: 0.1s; }
[data-animate-delay="2"] { transition-delay: 0.2s; }
[data-animate-delay="3"] { transition-delay: 0.3s; }
[data-animate-delay="4"] { transition-delay: 0.4s; }
[data-animate-delay="5"] { transition-delay: 0.5s; }
```

### Parallax (CSS-only)

```css
.parallax-container {
  height: 100vh;
  overflow-y: auto;
  perspective: 1px;
  perspective-origin: center center;
}

.parallax-bg {
  position: absolute;
  inset: -20%;
  transform: translateZ(-1px) scale(2);
  z-index: -1;
}

.parallax-content {
  position: relative;
  transform: translateZ(0);
  background: var(--color-bg);
}
```

### 스크롤 진행 표시기

```css
.scroll-progress {
  position: fixed;
  top: 0;
  left: 0;
  height: 3px;
  background: var(--color-accent);
  z-index: 9999;
  transform-origin: left;
  animation: scrollProgress linear;
  animation-timeline: scroll();
}

@keyframes scrollProgress {
  from { transform: scaleX(0); }
  to   { transform: scaleX(1); }
}
```

---

## Text Effects

### Gradient Text

```css
.text-gradient {
  background: linear-gradient(135deg, var(--color-accent), #ec4899);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* 애니메이션 그라디언트 텍스트 */
.text-gradient--animated {
  background: linear-gradient(
    90deg,
    var(--color-accent),
    #ec4899,
    #f59e0b,
    var(--color-accent)
  );
  background-size: 300% 100%;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  animation: gradientShift 4s ease infinite;
}

@keyframes gradientShift {
  0%, 100% { background-position: 0% 50%; }
  50%      { background-position: 100% 50%; }
}
```

### Outlined / Stroke Text

```css
.text-outline {
  -webkit-text-stroke: 1.5px var(--color-fg);
  -webkit-text-fill-color: transparent;
  font-size: clamp(4rem, 10vw, 10rem);
  font-weight: 900;
  transition: -webkit-text-fill-color 0.3s ease;
}

.text-outline:hover {
  -webkit-text-fill-color: var(--color-fg);
}
```

### Typing Animation

```css
.typing {
  width: 0;
  overflow: hidden;
  white-space: nowrap;
  border-right: 2px solid var(--color-accent);
  animation:
    typeIn 2s steps(30) 0.5s forwards,
    blink 0.7s step-end infinite;
}

@keyframes typeIn {
  to { width: 100%; }
}

@keyframes blink {
  50% { border-color: transparent; }
}
```

### Split / Reveal Text

```css
.text-reveal {
  position: relative;
  overflow: hidden;
  display: inline-block;
}

.text-reveal span {
  display: inline-block;
  transform: translateY(110%);
  animation: revealUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

@keyframes revealUp {
  to { transform: translateY(0); }
}

/* 각 단어에 딜레이 */
.text-reveal span:nth-child(1) { animation-delay: 0.05s; }
.text-reveal span:nth-child(2) { animation-delay: 0.1s; }
.text-reveal span:nth-child(3) { animation-delay: 0.15s; }
/* ... JS로 동적 생성 가능 */
```

### Glitch Effect

```css
.text-glitch {
  position: relative;
  font-weight: 900;
}

.text-glitch::before,
.text-glitch::after {
  content: attr(data-text);
  position: absolute;
  inset: 0;
}

.text-glitch::before {
  color: #ff0040;
  animation: glitch1 2s infinite linear alternate-reverse;
  clip-path: inset(0 0 80% 0);
}

.text-glitch::after {
  color: #00ffff;
  animation: glitch2 2s infinite linear alternate-reverse;
  clip-path: inset(80% 0 0 0);
}

@keyframes glitch1 {
  0%, 90% { transform: translate(0); }
  92%     { transform: translate(-3px, 1px); }
  94%     { transform: translate(3px, -1px); }
  96%     { transform: translate(-2px, -1px); }
  98%     { transform: translate(2px, 1px); }
}

@keyframes glitch2 {
  0%, 90% { transform: translate(0); }
  91%     { transform: translate(2px, -1px); }
  93%     { transform: translate(-3px, 1px); }
  95%     { transform: translate(1px, 2px); }
  97%     { transform: translate(-1px, -2px); }
}
```

---

## Shadows & Depth

### 레이어드 섀도우 (자연스러운 깊이)

```css
/* 1단계 — 미세한 접촉 그림자 */
.shadow-subtle {
  box-shadow:
    0 1px 2px rgba(0, 0, 0, 0.05),
    0 1px 3px rgba(0, 0, 0, 0.04);
}

/* 2단계 — 카드 수준 */
.shadow-card {
  box-shadow:
    0 1px 2px rgba(0, 0, 0, 0.06),
    0 4px 8px rgba(0, 0, 0, 0.04),
    0 12px 24px rgba(0, 0, 0, 0.04);
}

/* 3단계 — 모달/팝오버 */
.shadow-elevated {
  box-shadow:
    0 2px 4px rgba(0, 0, 0, 0.04),
    0 8px 16px rgba(0, 0, 0, 0.06),
    0 24px 48px rgba(0, 0, 0, 0.08);
}

/* 4단계 — 플로팅 (드래그, 드롭다운) */
.shadow-floating {
  box-shadow:
    0 4px 8px rgba(0, 0, 0, 0.04),
    0 16px 32px rgba(0, 0, 0, 0.08),
    0 48px 96px rgba(0, 0, 0, 0.12);
}
```

### 컬러 섀도우 (브랜드 강조)

```css
.shadow-color {
  box-shadow: 0 8px 32px rgba(var(--color-accent-rgb), 0.3);
}

/* 호버 시 글로우 */
.shadow-glow {
  transition: box-shadow 0.3s ease;
}

.shadow-glow:hover {
  box-shadow:
    0 0 20px rgba(var(--color-accent-rgb), 0.2),
    0 0 60px rgba(var(--color-accent-rgb), 0.1);
}
```

### Inset Shadow (inner depth)

```css
.shadow-inset {
  box-shadow:
    inset 0 1px 4px rgba(0, 0, 0, 0.1),
    inset 0 0 1px rgba(0, 0, 0, 0.05);
}
```

---

## Borders & Dividers

### Gradient Border

```css
.border-gradient {
  position: relative;
  border-radius: 1rem;
  padding: 2rem;
  background: var(--color-surface);
}

.border-gradient::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  padding: 1.5px;
  background: linear-gradient(135deg, var(--color-accent), #ec4899);
  -webkit-mask:
    linear-gradient(#fff 0 0) content-box,
    linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;
  mask-composite: exclude;
}
```

### 빛나는 보더 (Glowing Border)

```css
.border-glow {
  border: 1px solid rgba(var(--color-accent-rgb), 0.3);
  box-shadow:
    0 0 8px rgba(var(--color-accent-rgb), 0.1),
    inset 0 0 8px rgba(var(--color-accent-rgb), 0.05);
}
```

### 장식적 구분선

```css
/* 그라디언트 Fade */
.divider {
  height: 1px;
  background: linear-gradient(
    90deg,
    transparent,
    var(--color-border),
    transparent
  );
  margin: 4rem 0;
}

/* 다이아몬드 중앙 장식 */
.divider--diamond {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  color: var(--color-muted);
}

.divider--diamond::before,
.divider--diamond::after {
  content: '';
  flex: 1;
  height: 1px;
  background: var(--color-border);
}
```

---

## Cursor Effects

### 커스텀 커서 (CSS)

```css
/* 전체 페이지 커서 숨기기 + 커스텀 */
* { cursor: none; }

.cursor {
  position: fixed;
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: var(--color-accent);
  pointer-events: none;
  z-index: 99999;
  transition: transform 0.15s ease, opacity 0.15s ease;
  mix-blend-mode: difference;
}

.cursor--outer {
  width: 40px;
  height: 40px;
  background: transparent;
  border: 1.5px solid var(--color-accent);
  transition: transform 0.3s ease, width 0.3s ease, height 0.3s ease;
}

/* 호버 시 확대 */
a:hover ~ .cursor,
button:hover ~ .cursor {
  transform: scale(2.5);
}
```

### 커스텀 커서 (JS — 부드러운 추적)

```javascript
const cursor = document.querySelector('.cursor');
const cursorOuter = document.querySelector('.cursor--outer');
let mouseX = 0, mouseY = 0;
let outerX = 0, outerY = 0;

document.addEventListener('mousemove', (e) => {
  mouseX = e.clientX;
  mouseY = e.clientY;
  cursor.style.left = mouseX + 'px';
  cursor.style.top = mouseY + 'px';
});

function animateOuter() {
  outerX += (mouseX - outerX) * 0.12;
  outerY += (mouseY - outerY) * 0.12;
  cursorOuter.style.left = outerX + 'px';
  cursorOuter.style.top = outerY + 'px';
  requestAnimationFrame(animateOuter);
}
animateOuter();
```

---

## Background Patterns

### Dot Grid

```css
.bg-dots {
  background-image: radial-gradient(
    circle,
    rgba(var(--color-fg-rgb), 0.08) 1px,
    transparent 1px
  );
  background-size: 24px 24px;
}
```

### Grid Lines

```css
.bg-grid {
  background-image:
    linear-gradient(rgba(var(--color-fg-rgb), 0.04) 1px, transparent 1px),
    linear-gradient(90deg, rgba(var(--color-fg-rgb), 0.04) 1px, transparent 1px);
  background-size: 48px 48px;
}

/* 중심에서 페이드 */
.bg-grid--fade {
  -webkit-mask-image: radial-gradient(ellipse at center, black 30%, transparent 70%);
  mask-image: radial-gradient(ellipse at center, black 30%, transparent 70%);
}
```

### Diagonal Stripes

```css
.bg-stripes {
  background: repeating-linear-gradient(
    -45deg,
    transparent,
    transparent 10px,
    rgba(var(--color-fg-rgb), 0.02) 10px,
    rgba(var(--color-fg-rgb), 0.02) 20px
  );
}
```

### Concentric Circles

```css
.bg-circles {
  background: repeating-radial-gradient(
    circle at 50% 50%,
    transparent 0,
    transparent 40px,
    rgba(var(--color-fg-rgb), 0.03) 40px,
    rgba(var(--color-fg-rgb), 0.03) 41px
  );
}
```

---

## Page Transitions

### 뷰 트랜지션 API (모던 브라우저)

```css
@view-transition {
  navigation: auto;
}

::view-transition-old(root) {
  animation: fadeOut 0.2s ease;
}

::view-transition-new(root) {
  animation: fadeIn 0.3s ease;
}

/* 특정 요소에 커스텀 트랜지션 */
.hero__title {
  view-transition-name: page-title;
}

::view-transition-old(page-title) {
  animation: slideOutLeft 0.3s ease;
}

::view-transition-new(page-title) {
  animation: slideInRight 0.3s ease;
}

@keyframes slideOutLeft {
  to { transform: translateX(-20px); opacity: 0; }
}

@keyframes slideInRight {
  from { transform: translateX(20px); opacity: 0; }
}
```

### 페이지 로드 트랜지션

```css
.page-loader {
  position: fixed;
  inset: 0;
  background: var(--color-bg);
  z-index: 99999;
  display: flex;
  align-items: center;
  justify-content: center;
  animation: loaderExit 0.5s ease 0.3s forwards;
}

@keyframes loaderExit {
  to {
    clip-path: inset(0 0 100% 0);
    /* 또는: opacity: 0; pointer-events: none; */
  }
}
```

---

## Skeleton Loading

```css
.skeleton {
  background: var(--color-surface);
  border-radius: 0.5rem;
  position: relative;
  overflow: hidden;
}

.skeleton::after {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(255, 255, 255, 0.04),
    transparent
  );
  animation: shimmer 1.5s infinite;
}

@keyframes shimmer {
  from { transform: translateX(-100%); }
  to   { transform: translateX(100%); }
}

/* 프리셋 */
.skeleton--text {
  height: 1rem;
  width: 80%;
  margin-bottom: 0.75rem;
}

.skeleton--title {
  height: 1.5rem;
  width: 60%;
  margin-bottom: 1rem;
}

.skeleton--avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
}

.skeleton--image {
  width: 100%;
  aspect-ratio: 16/9;
}
```

---

## Scroll-Driven Animations (CSS-only)

JavaScript 없이 스크롤에 연동되는 모던 CSS.

### 진입 애니메이션

```css
/* 요소가 뷰포트에 진입하면 애니메이션 */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(40px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.scroll-reveal {
  animation: fadeInUp linear both;
  animation-timeline: view();
  animation-range: entry 0% entry 30%;
}
```

### 스크롤 연동 크기 변환

```css
.scroll-scale {
  animation: scaleUp linear both;
  animation-timeline: view();
  animation-range: entry 0% cover 40%;
}

@keyframes scaleUp {
  from { transform: scale(0.85); opacity: 0.5; }
  to   { transform: scale(1); opacity: 1; }
}
```

### 가로 스크롤 섹션

```css
.horizontal-scroll {
  overflow-x: auto;
  scroll-snap-type: x mandatory;
  display: flex;
  gap: 1.5rem;
  padding: 2rem;
  -webkit-overflow-scrolling: touch;
}

.horizontal-scroll > * {
  flex: 0 0 min(90vw, 400px);
  scroll-snap-align: start;
}

/* 스크롤바 숨기기 */
.horizontal-scroll::-webkit-scrollbar { display: none; }
.horizontal-scroll { scrollbar-width: none; }
```

### Sticky Header Transform

```css
.sticky-header {
  position: sticky;
  top: 0;
  animation: headerShrink linear both;
  animation-timeline: scroll();
  animation-range: 0px 200px;
}

@keyframes headerShrink {
  from {
    padding: 2rem 0;
    font-size: clamp(3rem, 6vw, 5rem);
  }
  to {
    padding: 0.75rem 0;
    font-size: 1.25rem;
    backdrop-filter: blur(12px);
    background: rgba(var(--color-bg-rgb), 0.8);
  }
}
```
