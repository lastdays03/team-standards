---
name: vercel-react-best-practices
description: "Performance optimization ruleset (57 rules) from Vercel Engineering for diagnosing and fixing React/Next.js performance bottlenecks. Covers: request waterfall elimination (Promise.all, Suspense boundaries), bundle size reduction (barrel imports, dynamic imports, code splitting), server-side performance (React.cache, dedup, serialization), client data fetching (SWR, dedup), re-render optimization (memo, derived state, context splitting), rendering performance (content-visibility, virtualization), and JavaScript performance (Map lookups, DOM batching). Use this skill whenever the user mentions slow page loads, large bundle sizes, unnecessary re-renders, sequential API calls, Lighthouse performance scores, LCP/FCP/TBT metrics, React DevTools Profiler findings, or wants to optimize any React/Next.js code for speed. Also trigger on '성능 최적화', '렌더링 성능', '번들 사이즈', '리렌더링', '워터폴', '데이터 페칭 최적화', '느린 로딩', 'Lighthouse 점수', '코드 스플리팅', 'dynamic import', 'SWR', 'Promise.all', 'memo', 'useMemo', 'content-visibility', or any React/Next.js performance concern."
license: MIT
metadata:
  author: vercel
  version: "2.0.0"
---

# Vercel React Best Practices

## Purpose

Comprehensive performance optimization guide for React and Next.js applications, maintained by Vercel. Contains 57 rules across 8 categories, prioritized by impact to guide automated refactoring and code generation.

> **Full compiled reference**: For all 57 rules expanded in a single document, see [AGENTS.md](AGENTS.md)

## When to Use This Skill

- Diagnosing slow page loads (LCP, TTI, FCP)
- Eliminating request waterfalls in data fetching
- Reducing bundle size and improving code splitting
- Optimizing React re-renders and rendering performance
- Reviewing code for performance anti-patterns
- Writing new React components or Next.js pages

---

## Quick Start

### Performance Audit Checklist

- [ ] No sequential awaits for independent operations → use `Promise.all()`
- [ ] No barrel file imports for large libraries → import directly or use `optimizePackageImports`
- [ ] Heavy components lazy-loaded with `next/dynamic`
- [ ] Server Components fetch data in parallel (component composition)
- [ ] Suspense boundaries wrap async data sections, not entire pages
- [ ] No expensive computation before early returns → extract to memoized components
- [ ] `content-visibility: auto` on long scrollable lists
- [ ] SWR for client-side data fetching (automatic deduplication)
- [ ] React.cache() for server-side request deduplication

---

## How to Use This Skill

When answering performance questions, **cite the specific rule by file name** (e.g., `async-parallel`, `bundle-barrel-imports`) so the user can find the detailed reference in `rules/`. Structure responses with Before/After code and link to the relevant resource file for deep dives.

---

## Topic Guides

### 1. Eliminating Waterfalls (CRITICAL)

📋 **Rules**: `async-parallel` · `async-suspense-boundaries` · `async-partial-dependencies` · `async-preload` · `async-defer-await`

Sequential async calls are the #1 performance killer. Independent operations should run in parallel.

**Before (3 round trips):**

```typescript
const user = await fetchUser()
const posts = await fetchPosts()
const comments = await fetchComments()
```

**After (1 round trip, 2-10x faster):**

```typescript
const [user, posts, comments] = await Promise.all([
  fetchUser(),
  fetchPosts(),
  fetchComments()
])
```

For RSC, use component composition — make the parent synchronous and let each child async component fetch its own data in parallel.

> **Deep dive**: [resources/eliminating-waterfalls.md](resources/eliminating-waterfalls.md) — 5 rules: Promise.all, Suspense boundaries, partial dependencies, API routes, defer-await

---

### 2. Bundle Size Optimization (CRITICAL)

📋 **Rules**: `bundle-barrel-imports` · `bundle-dynamic-imports` · `bundle-deferred-third-party` · `bundle-conditional-loading` · `bundle-preloading`

Barrel file imports and eager loading of heavy components directly impact TTI and LCP.

**Before (loads 1,583 modules, ~2.8s extra in dev):**

```tsx
import { Check, X, Menu } from 'lucide-react'
```

**After (loads only 3 modules, ~2KB):**

```tsx
import Check from 'lucide-react/dist/esm/icons/check'
import X from 'lucide-react/dist/esm/icons/x'
import Menu from 'lucide-react/dist/esm/icons/menu'

// Or in next.config.js:
// experimental: { optimizePackageImports: ['lucide-react'] }
```

Heavy components should be dynamically imported:

```tsx
const MonacoEditor = dynamic(
  () => import('./monaco-editor').then(m => m.MonacoEditor),
  { ssr: false }
)
```

> **Deep dive**: [resources/bundle-size.md](resources/bundle-size.md) — 5 rules: barrel imports, dynamic imports, deferred third-party, conditional loading, preloading

---

### 3. Server-Side Performance (HIGH)

📋 **Rules**: `server-cache` · `server-lru-cache` · `server-dedup-props` · `server-serialization` · `server-parallel` · `server-auth-actions` · `server-after`

Deduplicate server requests with React.cache(), minimize serialization, and use non-blocking operations.

**Before (cache miss due to inline object):**

```typescript
const getUser = cache(async (params: { uid: number }) => {
  return await db.user.findUnique({ where: { id: params.uid } })
})
getUser({ uid: 1 })
getUser({ uid: 1 })  // Cache miss — new object reference
```

**After (cache hit with primitive args):**

```typescript
const getUser = cache(async (uid: number) => {
  return await db.user.findUnique({ where: { id: uid } })
})
getUser(1)
getUser(1)  // Cache hit — same primitive value
```

> **Deep dive**: [resources/server-performance.md](resources/server-performance.md) — 7 rules: React.cache, LRU cache, dedup props, serialization, parallel fetching, auth actions, after()

---

### 4. Client-Side Data Fetching (MEDIUM-HIGH)

📋 **Rules**: `client-swr-dedup` · `client-event-dedup` · `client-passive-listeners` · `client-localstorage-schema`

Use SWR for automatic request deduplication, caching, and revalidation.

**Before (each component instance fetches independently):**

```tsx
const [users, setUsers] = useState([])
useEffect(() => {
  fetch('/api/users').then(r => r.json()).then(setUsers)
}, [])
```

**After (multiple instances share one request):**

```tsx
const { data: users } = useSWR('/api/users', fetcher)
```

> **Deep dive**: [resources/client-data-fetching.md](resources/client-data-fetching.md) — 4 rules: SWR dedup, event listener dedup, passive listeners, localStorage schema

---

### 5. Re-render Optimization (MEDIUM)

📋 **Rules**: `rerender-memo` · `rerender-derived-state` · `rerender-functional-setstate` · `rerender-lazy-init` · `rerender-transitions` · `rerender-refs` · `rerender-effects` · `rerender-primitive-deps` · `rerender-composition` · `rerender-context-split` · `rerender-compiler` · `rerender-early-return`

Extract expensive work into memoized components, derive state during render, and use primitive dependencies.

**Before (computes avatar even when loading):**

```tsx
function Profile({ user, loading }: Props) {
  const avatar = useMemo(() => {
    const id = computeAvatarId(user)
    return <Avatar id={id} />
  }, [user])

  if (loading) return <Skeleton />
  return <div>{avatar}</div>
}
```

**After (skips computation when loading):**

```tsx
const UserAvatar = memo(function UserAvatar({ user }: { user: User }) {
  const id = useMemo(() => computeAvatarId(user), [user])
  return <Avatar id={id} />
})

function Profile({ user, loading }: Props) {
  if (loading) return <Skeleton />
  return <div><UserAvatar user={user} /></div>
}
```

> **Deep dive**: [resources/rerender-optimization.md](resources/rerender-optimization.md) — 12 rules: memo, derived state, functional setState, lazy init, transitions, refs, effects

---

### 6. Rendering Performance (MEDIUM)

📋 **Rules**: `rendering-content-visibility` · `rendering-svg` · `rendering-hydration` · `rendering-activity` · `rendering-conditional` · `rendering-transition` · `rendering-hoist-static` · `rendering-virtualize` · `rendering-fragment`

Use CSS `content-visibility` for long lists, hoist static JSX, and handle hydration correctly.

**CSS for long lists (10x faster initial render for 1000 items):**

```css
.message-item {
  content-visibility: auto;
  contain-intrinsic-size: 0 80px;
}
```

> **Deep dive**: [resources/rendering-performance.md](resources/rendering-performance.md) — 9 rules: content-visibility, SVG optimization, hydration, Activity component, conditional rendering, useTransition

---

### 7. JavaScript Performance (LOW-MEDIUM)

📋 **Rules**: `js-index-map` · `js-dom-batch` · `js-cache-access` · `js-combine-iterations` · `js-set-lookup` · `js-regexp-hoist` · `js-immutable-sort` · `js-early-return` · `js-template-literals` · `js-optional-chaining` · `js-nullish-coalescing` · `js-structured-clone`

Build index Maps for repeated lookups, cache property access, and combine iterations.

**Before (O(n^2) — 1M operations for 1000x1000):**

```typescript
return orders.map(order => ({
  ...order,
  user: users.find(u => u.id === order.userId)
}))
```

**After (O(n) — 2K operations):**

```typescript
const userById = new Map(users.map(u => [u.id, u]))
return orders.map(order => ({
  ...order,
  user: userById.get(order.userId)
}))
```

> **Deep dive**: [resources/javascript-performance.md](resources/javascript-performance.md) — 12 rules: DOM batching, caching, iterations, Set/Map lookups, RegExp hoisting, immutable sorting

---

### 8. Advanced Patterns (LOW)

📋 **Rules**: `advanced-event-handler-refs` · `advanced-init-once` · `advanced-use-latest`

Stable callback refs with useEffectEvent, one-time initialization, and useLatest pattern.

> **Deep dive**: [resources/advanced-patterns.md](resources/advanced-patterns.md) — 3 rules: event handler refs, init-once, useLatest

---

## Navigation Guide

| Need to... | Read |
|-----------|------|
| Fix slow page loads | [eliminating-waterfalls](resources/eliminating-waterfalls.md) + [bundle-size](resources/bundle-size.md) |
| Reduce bundle size | [bundle-size](resources/bundle-size.md) |
| Optimize server rendering | [server-performance](resources/server-performance.md) |
| Fix client-side data fetching | [client-data-fetching](resources/client-data-fetching.md) |
| Reduce re-renders | [rerender-optimization](resources/rerender-optimization.md) |
| Improve rendering speed | [rendering-performance](resources/rendering-performance.md) |
| Optimize JS algorithms | [javascript-performance](resources/javascript-performance.md) |
| Audit a specific rule | `rules/{prefix}-{name}.md` (57 individual rule files) |
| Read all rules at once | [AGENTS.md](AGENTS.md) (compiled 100KB reference) |

---

## Core Principles

1. **Fix waterfalls first** — Sequential async calls are the single biggest performance win
2. **Measure before optimizing** — Use Lighthouse, React DevTools Profiler, bundle analyzer
3. **Server over client** — Prefer Server Components for data fetching
4. **Lazy load aggressively** — Dynamic imports for anything not needed on initial render
5. **Deduplicate requests** — React.cache() on server, SWR on client
6. **Minimize serialization** — Only pass needed data from Server to Client Components
7. **Derive, don't sync** — Compute derived state during render, not in effects
8. **Memoize strategically** — Extract expensive work, use primitive dependencies
9. **CSS before JS** — content-visibility, will-change before JavaScript solutions
10. **React Compiler awareness** — Manual memoization may be unnecessary with React Compiler

---

## Related Skills

- **nextjs-frontend-guidelines**: Next.js App Router patterns and component architecture
- **web-design-guidelines**: UI quality review (design quality vs performance)
- **frontend-design**: Frontend interface creation
- **error-tracking**: Sentry performance monitoring integration
