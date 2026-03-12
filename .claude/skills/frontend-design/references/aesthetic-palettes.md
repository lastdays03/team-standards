# Aesthetic Palettes

미학 방향별 구체적 폰트 페어링, 컬러 시스템, CSS 변수 세트. 미학을 선택하면 바로 적용할 수 있는 완전한 디자인 토큰.

## Table of Contents

1. [Brutalist](#brutalist)
2. [Luxury / Refined](#luxury--refined)
3. [Editorial / Magazine](#editorial--magazine)
4. [Retro-Futuristic](#retro-futuristic)
5. [Organic / Natural](#organic--natural)
6. [Playful / Toy-like](#playful--toy-like)
7. [Art Deco / Geometric](#art-deco--geometric)
8. [Soft / Pastel](#soft--pastel)
9. [Industrial / Utilitarian](#industrial--utilitarian)
10. [Maximalist Chaos](#maximalist-chaos)
11. [Monochrome Minimal](#monochrome-minimal)
12. [Neon Cyber](#neon-cyber)
13. [폰트 로딩 전략](#폰트-로딩-전략)

---

## Brutalist

날것 그대로의 거친 미학. 장식 제거, 구조 노출.

### 폰트 페어링

| 역할 | 선택지 | Google Fonts |
|------|--------|-------------|
| Display | **Archivo Black**, Monument Extended, Bebas Neue | `Archivo+Black` |
| Body | **Space Mono**, IBM Plex Mono, JetBrains Mono | `Space+Mono:wght@400;700` |
| Alt Display | **Anton**, Impact (시스템) | `Anton` |

### CSS 변수

```css
:root {
  /* 폰트 */
  --font-display: 'Archivo Black', 'Impact', sans-serif;
  --font-body: 'Space Mono', 'Courier New', monospace;
  --font-mono: 'Space Mono', monospace;

  /* 컬러 — 하드 흑백 + 경고 레드 */
  --color-bg: #ffffff;
  --color-bg-rgb: 255, 255, 255;
  --color-fg: #000000;
  --color-fg-rgb: 0, 0, 0;
  --color-surface: #f0f0f0;
  --color-border: #000000;
  --color-muted: #666666;
  --color-accent: #ff0000;
  --color-accent-rgb: 255, 0, 0;
  --color-on-accent: #ffffff;

  /* 비주얼 특성 */
  --radius: 0;
  --border-width: 3px;
  --shadow: 4px 4px 0 var(--color-fg);
}
```

### 다크 변형

```css
[data-theme="dark"] {
  --color-bg: #000000;
  --color-bg-rgb: 0, 0, 0;
  --color-fg: #ffffff;
  --color-fg-rgb: 255, 255, 255;
  --color-surface: #111111;
  --color-border: #ffffff;
  --color-muted: #999999;
  --color-accent: #00ff00;
  --color-accent-rgb: 0, 255, 0;
}
```

### 핵심 기법
- `border: var(--border-width) solid var(--color-border)` 모든 요소에
- `text-transform: uppercase` 자주 사용
- 애니메이션 없음 또는 의도적으로 갑작스러운 `transition: none`
- `box-shadow: var(--shadow)` — 3D 오프셋 그림자

---

## Luxury / Refined

고급스러운 절제. 세리프 타이포와 깊은 컬러.

### 폰트 페어링

| 역할 | 선택지 | Google Fonts |
|------|--------|-------------|
| Display | **Playfair Display**, Cormorant Garamond, DM Serif Display | `Playfair+Display:ital,wght@0,400;0,700;1,400` |
| Body | **Outfit**, Jost, Sora | `Outfit:wght@300;400;500` |
| Accent | **Cormorant**, Lora (이탤릭 강조) | `Cormorant:ital,wght@1,400` |

### CSS 변수

```css
:root {
  --font-display: 'Playfair Display', 'Georgia', serif;
  --font-body: 'Outfit', 'Helvetica Neue', sans-serif;
  --font-mono: 'DM Mono', monospace;

  /* 딥 네이비 + 골드 */
  --color-bg: #0c0f1a;
  --color-bg-rgb: 12, 15, 26;
  --color-fg: #f5f0e8;
  --color-fg-rgb: 245, 240, 232;
  --color-surface: #151929;
  --color-border: rgba(245, 240, 232, 0.1);
  --color-muted: #8a8575;
  --color-accent: #c9a96e;
  --color-accent-rgb: 201, 169, 110;
  --color-on-accent: #0c0f1a;

  --radius: 0.25rem;
  --border-width: 1px;
  --letter-spacing-wide: 0.15em;
}
```

### 라이트 변형

```css
[data-theme="light"] {
  --color-bg: #faf8f5;
  --color-bg-rgb: 250, 248, 245;
  --color-fg: #1a1a1a;
  --color-fg-rgb: 26, 26, 26;
  --color-surface: #ffffff;
  --color-border: rgba(26, 26, 26, 0.08);
  --color-muted: #7a7a7a;
  --color-accent: #8b6914;
  --color-accent-rgb: 139, 105, 20;
}
```

### 핵심 기법
- `letter-spacing: var(--letter-spacing-wide)` 아이브로우/레이블에
- 느린 트랜지션: `transition: all 0.4s ease`
- 최소한의 보더, 대신 미묘한 그라디언트 배경 분리
- 이탤릭 세리프로 강조 (`font-style: italic`)

---

## Editorial / Magazine

타이포그래피가 주인공. 대담한 크기 대비와 비대칭.

### 폰트 페어링

| 역할 | 선택지 | Google Fonts |
|------|--------|-------------|
| Display | **Instrument Serif**, Newsreader, Fraunces | `Instrument+Serif:ital@0;1` |
| Body | **Inter Tight**, Manrope, Plus Jakarta Sans | `Inter+Tight:wght@300;400;500;600` |
| Accent | **Syne**, Clash Display (자체 호스팅 권장) | `Syne:wght@400;700;800` |

### CSS 변수

```css
:root {
  --font-display: 'Instrument Serif', 'Georgia', serif;
  --font-body: 'Inter Tight', 'Helvetica', sans-serif;
  --font-mono: 'JetBrains Mono', monospace;

  /* 고대비 흑백 + 레드 악센트 */
  --color-bg: #fafafa;
  --color-bg-rgb: 250, 250, 250;
  --color-fg: #0a0a0a;
  --color-fg-rgb: 10, 10, 10;
  --color-surface: #ffffff;
  --color-border: rgba(10, 10, 10, 0.1);
  --color-muted: #6b6b6b;
  --color-accent: #dc2626;
  --color-accent-rgb: 220, 38, 38;
  --color-on-accent: #ffffff;

  --radius: 0;
  --border-width: 1px;
}
```

### 핵심 기법
- 거대한 디스플레이 사이즈: `font-size: clamp(4rem, 12vw, 12rem)`
- `mix-blend-mode: difference` 텍스트 오버랩
- `clip-path` 이미지 마스킹
- 세리프 이탤릭을 강조 기법으로: `<em>italic accent</em>`
- 2:1 이상의 컬럼 비율 비대칭

---

## Retro-Futuristic

80s-90s SF 미학. 스캔라인, 글로우, 모노스페이스.

### 폰트 페어링

| 역할 | 선택지 | Google Fonts |
|------|--------|-------------|
| Display | **Orbitron**, Audiowide, Rajdhani | `Orbitron:wght@400;700;900` |
| Body | **Share Tech Mono**, Fira Code, Source Code Pro | `Share+Tech+Mono` |
| Alt | **Exo 2**, Titillium Web | `Exo+2:wght@300;400;700` |

### CSS 변수

```css
:root {
  --font-display: 'Orbitron', 'Courier', monospace;
  --font-body: 'Share Tech Mono', 'Courier New', monospace;
  --font-mono: 'Share Tech Mono', monospace;

  /* 다크 + 시안/마젠타 글로우 */
  --color-bg: #0a0e17;
  --color-bg-rgb: 10, 14, 23;
  --color-fg: #e0f0ff;
  --color-fg-rgb: 224, 240, 255;
  --color-surface: #111827;
  --color-border: rgba(0, 255, 255, 0.15);
  --color-muted: #4a7a8a;
  --color-accent: #00ffff;
  --color-accent-rgb: 0, 255, 255;
  --color-on-accent: #0a0e17;
  --color-accent-alt: #ff00ff;

  --radius: 0;
  --border-width: 1px;
  --glow: 0 0 10px rgba(0, 255, 255, 0.3), 0 0 40px rgba(0, 255, 255, 0.1);
}
```

### 핵심 기법
- `text-shadow: var(--glow)` 네온 글로우 텍스트
- `border: 1px solid rgba(0, 255, 255, 0.2)` 그리드라인
- 스캔라인: 반복 그라디언트 오버레이 (`repeating-linear-gradient`)
- CRT 효과: 미세한 `text-shadow` + 약간의 `blur`
- `animation` 깜빡임 — `steps()` 타이밍으로 디지털 느낌

```css
/* 스캔라인 오버레이 */
.scanlines::after {
  content: '';
  position: absolute;
  inset: 0;
  pointer-events: none;
  background: repeating-linear-gradient(
    0deg,
    transparent,
    transparent 2px,
    rgba(0, 0, 0, 0.15) 2px,
    rgba(0, 0, 0, 0.15) 4px
  );
}
```

---

## Organic / Natural

자연에서 영감. 부드러운 곡선, 어스 톤, 유기적 형태.

### 폰트 페어링

| 역할 | 선택지 | Google Fonts |
|------|--------|-------------|
| Display | **Fraunces**, Libre Baskerville, Literata | `Fraunces:ital,opsz,wght@0,9..144,300;0,9..144,700;1,9..144,400` |
| Body | **Nunito**, Source Sans 3, DM Sans | `Nunito:wght@300;400;600` |

### CSS 변수

```css
:root {
  --font-display: 'Fraunces', 'Georgia', serif;
  --font-body: 'Nunito', 'Verdana', sans-serif;
  --font-mono: 'DM Mono', monospace;

  /* 워밍 어스 톤 */
  --color-bg: #f7f3ed;
  --color-bg-rgb: 247, 243, 237;
  --color-fg: #2d2a26;
  --color-fg-rgb: 45, 42, 38;
  --color-surface: #ffffff;
  --color-border: rgba(45, 42, 38, 0.1);
  --color-muted: #8a8279;
  --color-accent: #5a7a4a;
  --color-accent-rgb: 90, 122, 74;
  --color-on-accent: #ffffff;
  --color-accent-alt: #c4956a;

  --radius: 1.5rem;
  --border-width: 1px;
}
```

### 핵심 기법
- 큰 `border-radius` — `2rem`, `50%`, `blob` 형태
- `border-radius: 30% 70% 70% 30% / 30% 30% 70% 70%` blob 형태
- 어스 톤 그라디언트: 베이지→테라코타→모스그린
- 자연스러운 이징: `cubic-bezier(0.34, 1.56, 0.64, 1)`

---

## Playful / Toy-like

유쾌하고 에너지 넘치는 미학. 큰 라운드, 비비드 컬러.

### 폰트 페어링

| 역할 | 선택지 | Google Fonts |
|------|--------|-------------|
| Display | **Fredoka**, Grandstander, Baloo 2 | `Fredoka:wght@400;600;700` |
| Body | **Quicksand**, Comfortaa, Varela Round | `Quicksand:wght@400;500;600` |

### CSS 변수

```css
:root {
  --font-display: 'Fredoka', 'Comic Sans MS', cursive;
  --font-body: 'Quicksand', 'Verdana', sans-serif;
  --font-mono: 'Victor Mono', monospace;

  /* 밝고 비비드한 멀티컬러 */
  --color-bg: #fffbf0;
  --color-bg-rgb: 255, 251, 240;
  --color-fg: #2b2b2b;
  --color-fg-rgb: 43, 43, 43;
  --color-surface: #ffffff;
  --color-border: rgba(43, 43, 43, 0.1);
  --color-muted: #888888;
  --color-accent: #ff6b6b;
  --color-accent-rgb: 255, 107, 107;
  --color-on-accent: #ffffff;
  --color-accent-alt: #4ecdc4;
  --color-tertiary: #ffe66d;

  --radius: 1.25rem;
  --border-width: 2.5px;
  --shadow: 0 4px 0 rgba(0,0,0,0.1);
}
```

### 핵심 기법
- `border-radius: 999px` 둥근 버튼/뱃지
- `transform: rotate(-2deg)` 약간 기울인 요소
- bouncy 애니메이션: `cubic-bezier(0.68, -0.55, 0.265, 1.55)`
- `box-shadow: 0 4px 0 color` 3D 팝 효과
- 여러 accent 컬러 사용 — 모노톤 피함

---

## Art Deco / Geometric

1920s 스타일의 기하학적 우아함. 대칭, 금색, 직선.

### 폰트 페어링

| 역할 | 선택지 | Google Fonts |
|------|--------|-------------|
| Display | **Poiret One**, Tenor Sans, Cinzel Decorative | `Poiret+One` |
| Body | **Raleway**, Montserrat, Josefin Sans | `Raleway:wght@300;400;600` |

### CSS 변수

```css
:root {
  --font-display: 'Poiret One', 'Didot', serif;
  --font-body: 'Raleway', 'Trebuchet MS', sans-serif;
  --font-mono: 'Fira Code', monospace;

  /* 블랙 + 골드 + 아이보리 */
  --color-bg: #1a1a2e;
  --color-bg-rgb: 26, 26, 46;
  --color-fg: #eee8d5;
  --color-fg-rgb: 238, 232, 213;
  --color-surface: #22223b;
  --color-border: rgba(201, 169, 110, 0.25);
  --color-muted: #8a8575;
  --color-accent: #c9a96e;
  --color-accent-rgb: 201, 169, 110;
  --color-on-accent: #1a1a2e;

  --radius: 0;
  --border-width: 1px;
}
```

### 핵심 기법
- `letter-spacing: 0.2em` + `text-transform: uppercase`
- 기하학적 보더 패턴 (repeating-linear-gradient)
- `border: 1px solid var(--color-accent)` 금색 라인
- 대칭 레이아웃 (중앙 정렬 강조)
- 장식적 구분선 — 다이아몬드, 라인 패턴

---

## Soft / Pastel

부드럽고 따뜻한 파스텔 톤. 그림자 대신 컬러 면으로 깊이 표현.

### 폰트 페어링

| 역할 | 선택지 | Google Fonts |
|------|--------|-------------|
| Display | **Cabinet Grotesk** (자체호스팅), Satoshi, General Sans | `DM+Sans:wght@400;500;700` (대안) |
| Body | **DM Sans**, Rubik, Nunito Sans | `DM+Sans:wght@300;400;500` |

### CSS 변수

```css
:root {
  --font-display: 'DM Sans', 'Helvetica Neue', sans-serif;
  --font-body: 'DM Sans', 'Helvetica Neue', sans-serif;
  --font-mono: 'IBM Plex Mono', monospace;

  /* 소프트 라벤더 팔레트 */
  --color-bg: #faf8ff;
  --color-bg-rgb: 250, 248, 255;
  --color-fg: #2d2b3a;
  --color-fg-rgb: 45, 43, 58;
  --color-surface: #ffffff;
  --color-border: rgba(45, 43, 58, 0.06);
  --color-muted: #9896a6;
  --color-accent: #7c6ceb;
  --color-accent-rgb: 124, 108, 235;
  --color-on-accent: #ffffff;
  --color-accent-alt: #f0b4d2;

  --radius: 1rem;
  --border-width: 1px;
}

/* 파스텔 멀티컬러 세트 */
:root {
  --pastel-pink: #fce4ec;
  --pastel-blue: #e3f2fd;
  --pastel-green: #e8f5e9;
  --pastel-yellow: #fff9c4;
  --pastel-purple: #f3e5f5;
  --pastel-orange: #fff3e0;
}
```

### 핵심 기법
- 미세한 그림자: `box-shadow: 0 2px 12px rgba(0,0,0,0.04)`
- 파스텔 배경 블록으로 섹션 구분
- `border-radius: 1rem` 일관된 둥근 모서리
- 부드러운 그라디언트: 한 파스텔에서 다른 파스텔로

---

## Industrial / Utilitarian

공장, 인프라에서 영감. 기능이 곧 미학.

### 폰트 페어링

| 역할 | 선택지 | Google Fonts |
|------|--------|-------------|
| Display | **Barlow Condensed**, Oswald, Saira Condensed | `Barlow+Condensed:wght@400;600;700` |
| Body | **IBM Plex Sans**, Roboto Flex, Noto Sans | `IBM+Plex+Sans:wght@300;400;500` |
| Mono | **IBM Plex Mono** | `IBM+Plex+Mono:wght@400;500` |

### CSS 변수

```css
:root {
  --font-display: 'Barlow Condensed', 'Arial Narrow', sans-serif;
  --font-body: 'IBM Plex Sans', 'Helvetica', sans-serif;
  --font-mono: 'IBM Plex Mono', monospace;

  /* 콘크리트 + 옐로 경고 */
  --color-bg: #f2f0eb;
  --color-bg-rgb: 242, 240, 235;
  --color-fg: #1a1a1a;
  --color-fg-rgb: 26, 26, 26;
  --color-surface: #e8e5de;
  --color-border: rgba(26, 26, 26, 0.15);
  --color-muted: #666666;
  --color-accent: #e8b100;
  --color-accent-rgb: 232, 177, 0;
  --color-on-accent: #1a1a1a;

  --radius: 0.25rem;
  --border-width: 1px;
}
```

### 핵심 기법
- Condensed 폰트 + 대문자
- 모노스페이스 데이터 레이블
- `border: 1px solid` 격자 구조
- 경고 노란색 악센트
- 최소 장식, 정보 밀도 우선

---

## Maximalist Chaos

모든 것이 동시에. 규칙 파괴가 규칙.

### 폰트 페어링

3개 이상의 폰트를 의도적으로 섞는다.

| 역할 | 선택지 |
|------|--------|
| Display 1 | **Bungee Shade** (3D 효과) |
| Display 2 | **Rubik Mono One** (무게감) |
| Body | **Karla** (가독성 앵커) |
| Accent | **Caveat** (손글씨) |

### CSS 변수

```css
:root {
  --font-display: 'Bungee Shade', cursive;
  --font-display-alt: 'Rubik Mono One', sans-serif;
  --font-body: 'Karla', sans-serif;
  --font-handwritten: 'Caveat', cursive;
  --font-mono: 'Fira Code', monospace;

  /* 멀티컬러 — 단일 팔레트 거부 */
  --color-bg: #ff6b6b;
  --color-fg: #1a1a2e;
  --color-surface: #ffd93d;
  --color-accent: #6bcb77;
  --color-accent-alt: #4d96ff;
  --color-tertiary: #ff6bcb;
}
```

### 핵심 기법
- 요소별 다른 `background-color`
- `transform: rotate()` 불규칙 기울기
- 중첩과 오버랩
- `z-index` 레이어 플레이
- 의도적 충돌 — 세리프 + 산세리프 + 핸드라이팅

---

## Monochrome Minimal

흑백(또는 단일 색상)만으로 극도의 절제미.

### 폰트 페어링

| 역할 | 선택지 | Google Fonts |
|------|--------|-------------|
| Display | **PP Neue Montreal** (자체호스팅), Manrope, Sora | `Manrope:wght@300;400;600;700` |
| Body | 동일 폰트 (무게만 변형) | 위와 동일 |

### CSS 변수

```css
:root {
  --font-display: 'Manrope', 'Helvetica Neue', sans-serif;
  --font-body: 'Manrope', 'Helvetica Neue', sans-serif;
  --font-mono: 'JetBrains Mono', monospace;

  /* 순수 흑백 */
  --color-bg: #ffffff;
  --color-bg-rgb: 255, 255, 255;
  --color-fg: #111111;
  --color-fg-rgb: 17, 17, 17;
  --color-surface: #f8f8f8;
  --color-border: rgba(17, 17, 17, 0.08);
  --color-muted: #888888;
  --color-accent: #111111;
  --color-accent-rgb: 17, 17, 17;
  --color-on-accent: #ffffff;

  --radius: 0.5rem;
  --border-width: 1px;
}
```

### 핵심 기법
- 폰트 무게(weight)로만 위계 표현
- 여백이 디자인의 핵심 — 넉넉한 `padding`과 `gap`
- 컬러 없음 — 흑백 + 그레이스케일만
- `1px solid` 미세한 라인으로 구조 표현
- 호버: 미세한 `background` 변화만

---

## Neon Cyber

사이버펑크에서 영감. 어둠 속 네온 글로우.

### 폰트 페어링

| 역할 | 선택지 | Google Fonts |
|------|--------|-------------|
| Display | **Syncopate**, Bungee, Major Mono Display | `Syncopate:wght@400;700` |
| Body | **Chakra Petch**, Rajdhani, Saira | `Chakra+Petch:wght@300;400;600` |

### CSS 변수

```css
:root {
  --font-display: 'Syncopate', sans-serif;
  --font-body: 'Chakra Petch', sans-serif;
  --font-mono: 'Fira Code', monospace;

  /* 울트라 다크 + 네온 */
  --color-bg: #050510;
  --color-bg-rgb: 5, 5, 16;
  --color-fg: #e0e0ff;
  --color-fg-rgb: 224, 224, 255;
  --color-surface: #0a0a20;
  --color-border: rgba(138, 43, 226, 0.2);
  --color-muted: #5a5a8a;
  --color-accent: #ff00ff;
  --color-accent-rgb: 255, 0, 255;
  --color-on-accent: #050510;
  --color-accent-alt: #00ffff;
  --color-accent-alt-rgb: 0, 255, 255;

  --radius: 0.25rem;
  --border-width: 1px;
  --glow-primary: 0 0 10px rgba(255, 0, 255, 0.4), 0 0 40px rgba(255, 0, 255, 0.15);
  --glow-secondary: 0 0 10px rgba(0, 255, 255, 0.4), 0 0 40px rgba(0, 255, 255, 0.15);
}
```

### 핵심 기법
- `text-shadow: var(--glow-primary)` 글로우 텍스트
- `box-shadow: var(--glow-primary)` 네온 보더
- `border: 1px solid` + 부분 글로우
- 그라디언트 메시 배경 (마젠타-시안-퍼플)
- `mix-blend-mode: screen` 겹침 효과

---

## 폰트 로딩 전략

모든 팔레트에 공통으로 적용할 폰트 로딩 최적화.

### Google Fonts 최적화 로딩

```html
<!-- preconnect로 DNS/TLS 선행 -->
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />

<!-- display=swap으로 FOUT 허용 (깜빡임 대신 폴백 먼저 표시) -->
<link href="https://fonts.googleapis.com/css2?family=Display+Font:wght@400;700&family=Body+Font:wght@300;400;500&display=swap" rel="stylesheet" />
```

### 폴백 매칭 (CLS 최소화)

```css
/* 폴백 폰트의 메트릭을 웹폰트에 맞춤 */
@font-face {
  font-family: 'Fallback Display';
  src: local('Georgia');
  size-adjust: 105%;
  ascent-override: 95%;
  descent-override: 22%;
  line-gap-override: 0%;
}

:root {
  --font-display: 'Playfair Display', 'Fallback Display', serif;
}
```

### 변수 폰트 (고급)

```css
/* 하나의 파일로 여러 무게 */
@font-face {
  font-family: 'Inter';
  src: url('/fonts/Inter-Variable.woff2') format('woff2');
  font-weight: 100 900;
  font-display: swap;
}

/* 사용 */
.text-light { font-weight: 300; }
.text-bold  { font-weight: 700; }
```
