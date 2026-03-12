# Anthropic Brand Design System

Official Anthropic brand identity for presentations. Warm, refined, and human-centered.

## Color Palette

| Color | Hex | Role |
|-------|-----|------|
| **Dark** | `#141413` | Primary text, dark backgrounds |
| **Light** | `#faf9f5` | Light backgrounds, text on dark |
| **Mid Gray** | `#b0aea5` | Secondary elements, muted text |
| **Light Gray** | `#e8e6dc` | Subtle backgrounds, cards |
| **Orange** | `#d97757` | Primary accent: highlights, CTAs |
| **Blue** | `#6a9bcc` | Secondary accent |
| **Green** | `#788c5d` | Tertiary accent |

### Opacity Values (for dark backgrounds)
- `rgba(250,249,245,0.7)` — Body text on dark
- `rgba(250,249,245,0.4)` — Captions on dark
- `rgba(250,249,245,0.1)` — Subtle dividers on dark

## Typography

| Element | Size | Weight | Font | Color |
|---------|------|--------|------|-------|
| Cover title | 42-48pt | bold | Poppins, Arial | #141413 or #faf9f5 |
| Section title | 28-36pt | bold | Poppins, Arial | #141413 or #faf9f5 |
| Content title | 24pt | bold | Poppins, Arial | #141413 |
| Body text | 13-14pt | regular | Lora, Georgia | #141413 |
| Labels/captions | 9-10pt | regular | Poppins, Arial | #b0aea5 |
| Accent numbers | 22pt | bold | Poppins, Arial | #d97757 |

### Font Notes
- **Poppins** for headings (24pt+), falls back to Arial
- **Lora** for body text, falls back to Georgia
- Both are web-safe fallback compatible

## Layout Rules

### Base Template (ALL slides)
```html
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
html { background: #faf9f5; }
body {
  width: 720pt; height: 405pt; margin: 0; padding: 0;
  background: #faf9f5; font-family: Lora, Georgia, serif;
  display: flex;
}
h1, h2, h3, h4, h5, h6 { font-family: Poppins, Arial, sans-serif; }
</style>
</head>
<body>
<div style="margin: 40pt 50pt; flex: 1; display: flex; flex-direction: column;">
  <!-- content here -->
</div>
</body>
</html>
```

### Critical Layout Rules
- **ALWAYS use flexbox** — NEVER use `position: absolute`
- **Content wrapper**: `margin: 40pt 50pt`
- **Accent bar**: `<div style="width: 40pt; height: 3pt; background: #d97757; margin: 0 0 20pt 0;"></div>`
- **Cards**: `background: #e8e6dc; padding: 14pt;`

## Slide Types

### 1. Cover Slide
Warm light background with centered hierarchy.

```html
<!-- html/body background: #faf9f5 -->
<div style="margin: 40pt 50pt; flex: 1; display: flex; flex-direction: column; justify-content: center; align-items: center;">
  <p style="font-size: 10pt; font-family: Poppins, Arial, sans-serif; font-weight: 700; color: #d97757; letter-spacing: 4pt; margin: 0 0 20pt 0;">CATEGORY</p>
  <h1 style="font-size: 48pt; font-family: Poppins, Arial, sans-serif; font-weight: bold; color: #141413; letter-spacing: -1pt; line-height: 1.15; margin: 0 0 16pt 0; text-align: center;">Presentation Title</h1>
  <p style="font-size: 14pt; font-family: Lora, Georgia, serif; color: #b0aea5; margin: 0;">Subtitle or date</p>
</div>
```

### 2. Section Divider (dark)
Dark background with warm tones.

```html
<!-- html/body background: #141413 -->
<div style="margin: 40pt 50pt; flex: 1; display: flex; flex-direction: column; justify-content: flex-end;">
  <div style="width: 40pt; height: 3pt; background: #d97757; margin: 0 0 20pt 0;"></div>
  <h1 style="font-size: 36pt; font-family: Poppins, Arial, sans-serif; font-weight: bold; color: #faf9f5; margin: 0 0 10pt 0;">Section Title</h1>
  <p style="font-size: 10pt; font-family: Poppins, Arial, sans-serif; color: rgba(250,249,245,0.4); margin: 0; letter-spacing: 2pt;">SUBTITLE</p>
</div>
```

### 3. Content Slide
Light background, title + accent bar + body.

```html
<!-- html/body background: #faf9f5 -->
<div style="margin: 40pt 50pt; flex: 1; display: flex; flex-direction: column;">
  <h1 style="font-size: 24pt; font-family: Poppins, Arial, sans-serif; font-weight: bold; color: #141413; margin: 0 0 8pt 0;">Content Title</h1>
  <div style="width: 40pt; height: 3pt; background: #d97757; margin: 0 0 20pt 0;"></div>
  <div style="display: flex; flex: 1;">
    <div style="flex: 1; margin-right: 20pt;">
      <p style="font-size: 13pt; font-family: Lora, Georgia, serif; color: #141413; line-height: 1.7; margin: 0;">Body text content</p>
    </div>
    <div style="flex: 1; margin-left: 20pt;">
      <p style="font-size: 13pt; font-family: Lora, Georgia, serif; color: #141413; line-height: 1.7; margin: 0;">More content</p>
    </div>
  </div>
</div>
```

### 4. Content Slide with Cards
Cards use light gray background.

```html
<div style="background: #e8e6dc; padding: 14pt; margin: 0 0 8pt 0;">
  <p style="font-size: 12pt; font-family: Poppins, Arial, sans-serif; font-weight: bold; color: #141413; margin: 0 0 4pt 0;">Card Title</p>
  <p style="font-size: 11pt; font-family: Lora, Georgia, serif; color: #b0aea5; margin: 0; line-height: 1.5;">Card description text.</p>
</div>

<!-- Accent border card -->
<div style="background: #e8e6dc; padding: 14pt; border-left: 3pt solid #d97757;">
  <p style="font-size: 12pt; font-family: Poppins, Arial, sans-serif; font-weight: bold; color: #141413; margin: 0 0 4pt 0;">Highlighted Card</p>
  <p style="font-size: 11pt; font-family: Lora, Georgia, serif; color: #b0aea5; margin: 0; line-height: 1.5;">Important content here.</p>
</div>
```

### 5. Closing Slide (dark)
Dark background with warm accent.

```html
<!-- html/body background: #141413 -->
<div style="margin: 40pt 50pt; flex: 1; display: flex; flex-direction: column; justify-content: center; align-items: center;">
  <h1 style="font-size: 30pt; font-family: Poppins, Arial, sans-serif; font-weight: bold; color: #faf9f5; margin: 0 0 20pt 0; text-align: center;">Closing Message</h1>
  <div style="width: 40pt; height: 3pt; background: #d97757; margin: 0 0 20pt 0;"></div>
  <p style="font-size: 14pt; font-family: Lora, Georgia, serif; color: rgba(250,249,245,0.7); margin: 0; text-align: center;">Contact or call-to-action</p>
</div>
```

## Shape & Accent Colors

When using accent colors for non-text shapes:
- **Primary accent**: Orange `#d97757` — accent bars, highlights
- **Secondary accent**: Blue `#6a9bcc` — secondary emphasis, charts
- **Tertiary accent**: Green `#788c5d` — success states, variety
- Cycle through accents to maintain visual interest

## Design Principles

1. **Warm neutrals** — Use `#faf9f5` (not pure white) for backgrounds
2. **Orange sparingly** — Only for accent bars, key numbers, CTAs
3. **Serif body text** — Lora/Georgia gives a refined, human feel
4. **Sans-serif headings** — Poppins/Arial for clear hierarchy
5. **Generous whitespace** — 40pt/50pt margins, never cramped
6. **Maximum 3 colors per slide** — Background + text + one accent
7. **Alternate backgrounds** — Light for content, Dark (#141413) for section dividers
