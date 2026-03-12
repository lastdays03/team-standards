# VRL Brand Design System

Modern, minimal tech brand. Lime green accent on dark navy, clean geometry, bold yet restrained.

**Logo**: `assets/vrl-logo.png` — lime green rounded square with dark lightning bolt. Use AS-IS without any CSS filters.

## Color Palette

| Color | Hex | RGB | Role |
|-------|-----|-----|------|
| **Lime Green** | `#BDFF00` | 189, 255, 0 | Primary accent: highlights, CTAs, key stats |
| **Dark Navy** | `#1E293B` | 30, 41, 59 | Dark backgrounds, cards |
| **Slate 900** | `#0F172A` | 15, 23, 42 | Primary text, darkest background |
| **White** | `#FFFFFF` | 255, 255, 255 | Light backgrounds, text on dark |
| **Slate Gray** | `#64748B` | 100, 116, 139 | Secondary text, muted elements |
| **Light Slate** | `#94A3B8` | 148, 163, 184 | Tertiary text, captions |
| **Off White** | `#F8FAFC` | 248, 250, 252 | Card backgrounds on white |
| **Slate 100** | `#F1F5F9` | 241, 245, 249 | Card background (alt) |
| **Slate 300** | `#CBD5E1` | 203, 213, 225 | Borders, dividers |
| **Orange** | `#FF6B35` | 255, 107, 53 | Secondary accent (sparingly) |
| **Lime Dark** | `#84CC16` | 132, 204, 22 | Supporting accent, success states |

### Color Themes

**Light Theme**: Background `#FFFFFF`, Text `#0F172A`, Accent `#BDFF00`, Muted `#475569`
**Dark Theme**: Background `#0F172A`, Text `#FFFFFF`, Accent `#BDFF00`, Muted `#CBD5E1`

### Contrast Rules
- `#0F172A` text on `#FFFFFF` — good
- `#FFFFFF` text on `#0F172A` — good
- `#0F172A` text on `#BDFF00` — good (use for highlighted cards)
- **Avoid**: `#BDFF00` text on `#FFFFFF` (poor contrast)
- Lime is for accents only, never body text
- Maximum 2 accent colors per slide

### Opacity Values (for dark backgrounds)
- `rgba(255,255,255,0.7)` — Body text on dark
- `rgba(255,255,255,0.4)` — Captions on dark
- `rgba(255,255,255,0.1)` — Subtle dividers

## Typography

| Element | Size | Weight | Font | Color |
|---------|------|--------|------|-------|
| Hero Title | 42-48pt | Bold | Arial, Helvetica | White (on dark) |
| Section Title | 24-28pt | Bold | Arial, Helvetica | Dark Navy |
| Subtitle | 14-16pt | Regular | Arial, Helvetica | Light Slate |
| Body | 11-13pt | Regular | Arial, Helvetica | Dark Navy or Slate |
| Caption | 9-10pt | Regular | Arial, Helvetica | Slate Gray |
| Code/data | 9-10pt | Regular | Courier New | Slate Gray |

## Logo Usage

**File**: `assets/vrl-logo.png`

The logo is a lime green rounded square with dark lightning bolt — self-contained, works on both dark and light backgrounds without modification.

### Placement by Slide Type
| Slide Type | Position | Size |
|------------|----------|------|
| Title/Hero | Centered, above title | 70-80pt |
| Content | Bottom-right (optional) | 24pt |
| Section Divider | Centered or bottom-right | 48-64pt |
| Closing | Centered | 80pt |

### Logo Rules
- Use the official file from `assets/` — never recreate
- **NEVER apply CSS filters** (no brightness, invert, hue-rotate)
- Maintain aspect ratio, minimum 24px height
- Clear space: margin equal to logo height on all sides
- No shadows, glows, rotation, or effects

### Logo HTML
```html
<div class="logo" style="width: 70pt; height: 70pt;">
  <img src="assets/vrl-logo.png" style="width: 100%; height: 100%; object-fit: contain;">
</div>
<!-- NO filter property — use logo as-is -->
```

## Layout Rules

### Base Template (ALL slides)
```html
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
html { background: #ffffff; }
body {
  width: 720pt; height: 405pt; margin: 0; padding: 0;
  background: #ffffff; font-family: Arial, Helvetica, sans-serif;
  display: flex;
}
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
- **Cards**: `background: #F8FAFC; padding: 18pt; border-radius: 8pt;`
- **Highlighted card**: `background: #BDFF00; color: #1E293B;`
- **No accent bars/underlines** under headers — keep clean
- **Generous whitespace** — 40%+ of slide should be empty space

## Slide Types

### 1. Title Slide (Hero)
Dark navy background, centered logo + title stack.

```html
<!-- html/body background: #1E293B -->
<div style="margin: 40pt 50pt; flex: 1; display: flex; flex-direction: column; justify-content: center; align-items: center;">
  <div style="width: 70pt; height: 70pt; margin: 0 0 25pt 0;">
    <img src="assets/vrl-logo.png" style="width: 100%; height: 100%; object-fit: contain;">
  </div>
  <h1 style="font-size: 42pt; font-weight: bold; color: #ffffff; margin: 0 0 25pt 0; text-align: center;">Presentation Title</h1>
  <p style="font-size: 14pt; color: #94A3B8; margin: 0 0 25pt 0;">Subtitle text</p>
  <p style="font-size: 10pt; color: #64748B; margin: 0;">March 2026</p>
</div>
```

### 2. Content Slide
White background, left-aligned header, card-based content.

```html
<!-- html/body background: #ffffff -->
<div style="margin: 40pt 50pt; flex: 1; display: flex; flex-direction: column;">
  <h1 style="font-size: 24pt; font-weight: bold; color: #1E293B; margin: 0 0 20pt 0;">Section Header</h1>
  <div style="display: flex; flex: 1;">
    <div style="flex: 1; margin-right: 12pt;">
      <div style="background: #F8FAFC; padding: 18pt; border-radius: 8pt; margin: 0 0 8pt 0;">
        <p style="font-size: 12pt; font-weight: bold; color: #1E293B; margin: 0 0 6pt 0;">Card Title</p>
        <p style="font-size: 11pt; color: #64748B; margin: 0; line-height: 1.5;">Card description text.</p>
      </div>
    </div>
    <div style="flex: 1; margin-left: 12pt;">
      <div style="background: #F8FAFC; padding: 18pt; border-radius: 8pt;">
        <p style="font-size: 12pt; font-weight: bold; color: #1E293B; margin: 0 0 6pt 0;">Card Title</p>
        <p style="font-size: 11pt; color: #64748B; margin: 0; line-height: 1.5;">Card description text.</p>
      </div>
    </div>
  </div>
</div>
```

### 3. Data/Stats Slide
Large lime-green numbers for key metrics.

```html
<div style="margin: 40pt 50pt; flex: 1; display: flex; flex-direction: column;">
  <h1 style="font-size: 24pt; font-weight: bold; color: #1E293B; margin: 0 0 24pt 0;">Key Metrics</h1>
  <div style="display: flex; flex: 1;">
    <div style="flex: 1; margin-right: 12pt; display: flex; flex-direction: column; align-items: center;">
      <p style="font-size: 48pt; font-weight: bold; color: #BDFF00; margin: 0 0 8pt 0;">95%</p>
      <p style="font-size: 10pt; color: #64748B; margin: 0; letter-spacing: 2pt;">METRIC LABEL</p>
    </div>
    <div style="flex: 1; margin-left: 12pt; display: flex; flex-direction: column; align-items: center;">
      <p style="font-size: 48pt; font-weight: bold; color: #1E293B; margin: 0 0 8pt 0;">2.5K</p>
      <p style="font-size: 10pt; color: #64748B; margin: 0; letter-spacing: 2pt;">METRIC LABEL</p>
    </div>
  </div>
</div>
```

### 4. Table Slide
Dark navy header, alternating rows, lime highlight column.

```html
<div style="margin: 40pt 50pt; flex: 1; display: flex; flex-direction: column;">
  <h1 style="font-size: 24pt; font-weight: bold; color: #1E293B; margin: 0 0 20pt 0;">Comparison</h1>
  <!-- Table header -->
  <div style="display: flex; background: #1E293B; padding: 10pt 14pt;">
    <p style="flex: 2; font-size: 10pt; font-weight: bold; color: #ffffff; margin: 0;">Feature</p>
    <p style="flex: 1; font-size: 10pt; font-weight: bold; color: #ffffff; margin: 0; text-align: center;">Plan A</p>
    <p style="flex: 1; font-size: 10pt; font-weight: bold; color: #1E293B; margin: 0; text-align: center; background: #BDFF00; padding: 2pt 8pt;">Plan B</p>
  </div>
  <!-- Table row -->
  <div style="display: flex; background: #ffffff; padding: 10pt 14pt; border-bottom: 1pt solid #F1F5F9;">
    <p style="flex: 2; font-size: 11pt; color: #1E293B; margin: 0;">Row item</p>
    <p style="flex: 1; font-size: 11pt; color: #64748B; margin: 0; text-align: center;">Value</p>
    <p style="flex: 1; font-size: 11pt; color: #1E293B; margin: 0; text-align: center;">Value</p>
  </div>
  <!-- Alternating row -->
  <div style="display: flex; background: #F8FAFC; padding: 10pt 14pt; border-bottom: 1pt solid #F1F5F9;">
    <p style="flex: 2; font-size: 11pt; color: #1E293B; margin: 0;">Row item</p>
    <p style="flex: 1; font-size: 11pt; color: #64748B; margin: 0; text-align: center;">Value</p>
    <p style="flex: 1; font-size: 11pt; color: #1E293B; margin: 0; text-align: center;">Value</p>
  </div>
</div>
```

### 5. Section Divider (dark)
Lime accent on dark background with large section name.

```html
<!-- html/body background: #0F172A -->
<div style="margin: 40pt 50pt; flex: 1; display: flex; flex-direction: column; justify-content: center;">
  <p style="font-size: 10pt; color: #BDFF00; margin: 0 0 16pt 0; letter-spacing: 4pt;">SECTION 01</p>
  <h1 style="font-size: 36pt; font-weight: bold; color: #ffffff; margin: 0 0 12pt 0;">Section Title</h1>
  <p style="font-size: 12pt; color: rgba(255,255,255,0.4); margin: 0;">Brief description of this section</p>
</div>
```

### 6. Closing Slide
Dark navy, centered logo + summary stats in lime.

```html
<!-- html/body background: #1E293B -->
<div style="margin: 40pt 50pt; flex: 1; display: flex; flex-direction: column; justify-content: center; align-items: center;">
  <div style="width: 80pt; height: 80pt; margin: 0 0 25pt 0;">
    <img src="assets/vrl-logo.png" style="width: 100%; height: 100%; object-fit: contain;">
  </div>
  <h1 style="font-size: 28pt; font-weight: bold; color: #ffffff; margin: 0 0 20pt 0; text-align: center;">Thank You</h1>
  <p style="font-size: 14pt; color: #BDFF00; margin: 0;">Key takeaway in lime green</p>
</div>
```

## Design Principles

1. **Minimal and clean** — remove unnecessary elements, one focal point per slide
2. **Lime sparingly** — only for key stats, highlights, CTAs; never body text
3. **No decorative elements** — no accent bars, underlines, circular badges, borders
4. **Dark for emphasis** — Dark Navy/Slate 900 for hero/closing/section dividers
5. **White for content** — clean white slides with Off White cards
6. **Generous whitespace** — 40%+ of slide should be empty
7. **Maximum 3 colors per slide** — background + text + one accent
8. **Consistent card pattern** — Off White (#F8FAFC), 8pt radius, 18pt padding

## Writing Style
- Short sentences, active voice
- One idea per slide
- Bullet points for lists
- Technical but accessible
