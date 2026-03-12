# Web Interface Guidelines Rules

Source: vercel-labs/web-interface-guidelines

## Rules

### Accessibility

- Icon-only buttons need `aria-label`
- Form controls need `<label>` or `aria-label`
- Interactive elements need keyboard handlers (`onKeyDown`/`onKeyUp`)
- `<button>` for actions, `<a>`/`<Link>` for navigation (not `<div onClick>`)
- Images need `alt` (or `alt=""` if decorative)
- Decorative icons need `aria-hidden="true"`
- Async updates (toasts, validation) need `aria-live="polite"`
- Use semantic HTML (`<button>`, `<a>`, `<label>`, `<table>`) before ARIA
- Headings hierarchical `<h1>`-`<h6>`; include skip link for main content
- `scroll-margin-top` on heading anchors

### Focus States

- Interactive elements need visible focus: `focus-visible:ring-*` or equivalent
- Never `outline-none` / `outline: none` without focus replacement
- Use `:focus-visible` over `:focus` (avoid focus ring on click)
- Group focus with `:focus-within` for compound controls

### Forms

- Inputs need `autocomplete` and meaningful `name`
- Use correct `type` (`email`, `tel`, `url`, `number`) and `inputmode`
- Never block paste (`onPaste` + `preventDefault`)
- Labels clickable (`htmlFor` or wrapping control)
- Disable spellcheck on emails, codes, usernames (`spellCheck={false}`)
- Checkboxes/radios: label + control share single hit target (no dead zones)
- Submit button stays enabled until request starts; spinner during request
- Errors inline next to fields; focus first error on submit
- Placeholders end with `...` and show example pattern
- `autocomplete="off"` on non-auth fields to avoid password manager triggers
- Warn before navigation with unsaved changes (`beforeunload` or router guard)

### Animation

- Honor `prefers-reduced-motion` (provide reduced variant or disable)
- Animate `transform`/`opacity` only (compositor-friendly)
- Never `transition: all`-list properties explicitly
- Set correct `transform-origin`
- SVG: transforms on `<g>` wrapper with `transform-box: fill-box; transform-origin: center`
- Animations interruptible-respond to user input mid-animation

### Typography

- `...` not `...`
- Curly quotes not straight quotes
- Non-breaking spaces: `10&nbsp;MB`, `Cmd&nbsp;K`, brand names
- Loading states end with `...`: `"Loading..."`, `"Saving..."`
- `font-variant-numeric: tabular-nums` for number columns/comparisons
- Use `text-wrap: balance` or `text-pretty` on headings (prevents widows)

### Content Handling

- Text containers handle long content: `truncate`, `line-clamp-*`, or `break-words`
- Flex children need `min-w-0` to allow text truncation
- Handle empty states-don't render broken UI for empty strings/arrays
- User-generated content: anticipate short, average, and very long inputs

### Images

- `<img>` needs explicit `width` and `height` (prevents CLS)
- Below-fold images: `loading="lazy"`
- Above-fold critical images: `priority` or `fetchpriority="high"`

### Performance

- Large lists (>50 items): virtualize (`virtua`, `content-visibility: auto`)
- No layout reads in render (`getBoundingClientRect`, `offsetHeight`, `offsetWidth`, `scrollTop`)
- Batch DOM reads/writes; avoid interleaving
- Prefer uncontrolled inputs; controlled inputs must be cheap per keystroke
- Add `<link rel="preconnect">` for CDN/asset domains
- Critical fonts: `<link rel="preload" as="font">` with `font-display: swap`

### Navigation & State

- URL reflects state-filters, tabs, pagination, expanded panels in query params
- Links use `<a>`/`<Link>` (Cmd/Ctrl+click, middle-click support)
- Deep-link all stateful UI (if uses `useState`, consider URL sync via nuqs or similar)
- Destructive actions need confirmation modal or undo window-never immediate

### Touch & Interaction

- `touch-action: manipulation` (prevents double-tap zoom delay)
- `-webkit-tap-highlight-color` set intentionally
- `overscroll-behavior: contain` in modals/drawers/sheets
- During drag: disable text selection, `inert` on dragged elements
- `autoFocus` sparingly-desktop only, single primary input; avoid on mobile

### Safe Areas & Layout

- Full-bleed layouts need `env(safe-area-inset-*)` for notches
- Avoid unwanted scrollbars: `overflow-x-hidden` on containers, fix content overflow
- Flex/grid over JS measurement for layout

### Dark Mode & Theming

- `color-scheme: dark` on `<html>` for dark themes (fixes scrollbar, inputs)
- `<meta name="theme-color">` matches page background
- Native `<select>`: explicit `background-color` and `color` (Windows dark mode)

### Locale & i18n

- Dates/times: use `Intl.DateTimeFormat` not hardcoded formats
- Numbers/currency: use `Intl.NumberFormat` not hardcoded formats
- Detect language via `Accept-Language` / `navigator.languages`, not IP

### Hydration Safety

- Inputs with `value` need `onChange` (or use `defaultValue` for uncontrolled)
- Date/time rendering: guard against hydration mismatch (server vs client)
- `suppressHydrationWarning` only where truly needed

### Hover & Interactive States

- Buttons/links need `hover:` state (visual feedback)
- Interactive states increase contrast: hover/active/focus more prominent than rest

### Content & Copy

- Active voice: "Install the CLI" not "The CLI will be installed"
- Title Case for headings/buttons (Chicago style)
- Numerals for counts: "8 deployments" not "eight"
- Specific button labels: "Save API Key" not "Continue"
- Error messages include fix/next step, not just problem
- Second person; avoid first person
- `&` over "and" where space-constrained

### Design Quality

- Visual hierarchy: one dominant element per section (size, weight, or color)—not everything equal
- Spacing system: consistent spacing scale (4px/8px increments)—no arbitrary pixel values
- Color contrast: text meets WCAG AA (4.5:1 body, 3:1 large text)—check with `contrast-ratio`
- Typography pairing: max 2-3 font families—display + body + optional mono
- Component consistency: same pattern for same purpose (don't mix card styles within one page)
- Interactive feedback: every clickable element has hover/active/focus states—no "dead" buttons
- Loading states: skeleton or spinner for async content—never blank space or layout jump
- Empty states: meaningful message + action for empty lists/search/data—not blank or "No data"
- Error states: inline field errors with recovery action—not just red border or generic toast
- Responsive quality: test at 320px, 768px, 1024px, 1440px—no horizontal scroll, no overlap, no orphans
- Whitespace intention: generous padding inside cards/sections, tighter within groups—hierarchy through space
- Alignment: elements on a consistent grid—no "almost aligned" positioning
- Icon sizing: icons match text line-height or follow 16/20/24px scale—not arbitrary sizes
- Border & shadow consistency: one border-radius scale and shadow depth system per project
- Color usage: semantic colors (success/warning/error/info) applied consistently—not ad-hoc hex values

### Design Quality Bad/Good Examples

**Visual hierarchy — no dominant element:**

```tsx
// Bad: everything same size and weight
<div className="p-4">
  <p className="text-base font-medium">Dashboard</p>
  <p className="text-base font-medium">Total Users: 1,234</p>
  <p className="text-base font-medium">Revenue: $45,000</p>
  <p className="text-base font-medium">Active Sessions: 89</p>
</div>

// Good: clear hierarchy with size and weight
<div className="p-6">
  <h1 className="text-2xl font-bold mb-6">Dashboard</h1>
  <div className="grid grid-cols-3 gap-4">
    <div className="p-4 rounded-lg border">
      <p className="text-sm text-muted-foreground">Total Users</p>
      <p className="text-3xl font-bold tabular-nums">1,234</p>
    </div>
    ...
  </div>
</div>
```

**Interactive feedback — dead button:**

```tsx
// Bad: no hover/active state, no loading feedback
<button className="bg-blue-500 text-white px-4 py-2 rounded">
  Save
</button>

// Good: hover, active, focus, disabled, loading states
<Button
  className="hover:bg-primary/90 active:scale-[0.98] focus-visible:ring-2"
  disabled={isPending}
>
  {isPending ? (
    <>
      <Loader2 className="mr-2 h-4 w-4 animate-spin" />
      Saving...
    </>
  ) : (
    'Save'
  )}
</Button>
```

**Empty state — blank content:**

```tsx
// Bad: renders nothing when empty
{items.length > 0 && items.map(item => <Card key={item.id} />)}

// Good: meaningful empty state with action
{items.length === 0 ? (
  <div className="flex flex-col items-center py-12 text-center">
    <InboxIcon className="h-12 w-12 text-muted-foreground mb-4" />
    <h3 className="text-lg font-semibold mb-1">No items yet</h3>
    <p className="text-sm text-muted-foreground mb-4">
      Get started by creating your first item.
    </p>
    <Button onClick={onCreate}>Create Item</Button>
  </div>
) : (
  items.map(item => <Card key={item.id} />)
)}
```

**Spacing — arbitrary values:**

```tsx
// Bad: inconsistent arbitrary spacing
<div className="mt-[13px] mb-[7px] px-[11px]">
  <h2 className="mb-[5px]">Title</h2>
  <p className="mt-[9px]">Content</p>
</div>

// Good: consistent spacing scale
<div className="mt-4 mb-2 px-3">
  <h2 className="mb-1.5">Title</h2>
  <p className="mt-2">Content</p>
</div>
```

**Accessibility — icon button without label:**

```tsx
// Bad: screen reader says "button"
<button onClick={onClose}>
  <X className="h-4 w-4" />
</button>

// Good: screen reader says "Close dialog"
<button onClick={onClose} aria-label="Close dialog">
  <X className="h-4 w-4" aria-hidden="true" />
</button>
```

### Anti-patterns (flag these)

- `user-scalable=no` or `maximum-scale=1` disabling zoom
- `onPaste` with `preventDefault`
- `transition: all`
- `outline-none` without focus-visible replacement
- Inline `onClick` navigation without `<a>`
- `<div>` or `<span>` with click handlers (should be `<button>`)
- Images without dimensions
- Large arrays `.map()` without virtualization
- Form inputs without labels
- Icon buttons without `aria-label`
- Hardcoded date/number formats (use `Intl.*`)
- `autoFocus` without clear justification

## Output Format

Group by file. Use `file:line` format (VS Code clickable). Terse findings.

```text
## src/Button.tsx

src/Button.tsx:42 - icon button missing aria-label
src/Button.tsx:18 - input lacks label
src/Button.tsx:55 - animation missing prefers-reduced-motion
src/Button.tsx:67 - transition: all -> list properties

## src/Modal.tsx

src/Modal.tsx:12 - missing overscroll-behavior: contain
src/Modal.tsx:34 - "..." -> "..."

## src/Card.tsx

pass
```

State issue + location. Skip explanation unless fix non-obvious. No preamble.
