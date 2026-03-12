---
name: nextjs-frontend-guidelines
description: "Next.js 15 frontend development guidelines for YGS (영영사) React 19/TypeScript application. Modern patterns including App Router, Server/Client Components, shadcn/ui components, Tailwind CSS 4, multi-method authentication (Firebase/Kakao/JWT), admin dashboard patterns, and Korean localization. Use when creating components, pages, API routes, fetching data, styling, or working with frontend code. Also trigger when '프론트엔드 개발', '컴포넌트 생성', '페이지 만들기', '스타일링', 'Next.js 라우팅', '서버 컴포넌트', '클라이언트 컴포넌트', '인증 구현', or any frontend architecture work."
---

# Next.js 15 Frontend Development Guidelines for YGS

## Purpose

Comprehensive guide for YGS (영영사) frontend development with Next.js 15, React 19, emphasizing App Router patterns, Server/Client component separation, shadcn/ui components, Tailwind CSS 4 styling, multi-method authentication, and Korean localization.

## When to Use This Skill

- Creating new components or pages
- Building new features with App Router
- Fetching data with Server Components or client-side patterns
- Styling components with shadcn/ui and Tailwind CSS 4
- Setting up API routes or Server Actions
- Authentication flows (Firebase, Kakao, custom JWT)
- Admin dashboard development
- Performance optimization
- Organizing frontend code
- TypeScript best practices

---

## Quick Start

### New Component Checklist

Creating a component? Follow this checklist:

- [ ] Determine if Server or Client Component
- [ ] Use `'use client'` directive only when needed
- [ ] Props type with TypeScript interface
- [ ] Use `@/` import alias for project imports
- [ ] Use shadcn/ui components where applicable
- [ ] Use `cn()` utility for conditional classes
- [ ] Named export for components
- [ ] Async Server Components for data fetching when possible
- [ ] Client Components for interactivity (useState, useEffect, event handlers)
- [ ] Korean text for UI labels

### New Feature Checklist

Creating a feature? Set up this structure:

- [ ] Create `src/components/{feature-name}/` directory
- [ ] Separate Server and Client components
- [ ] Create API route if needed: `src/app/api/{feature}/route.ts`
- [ ] Set up TypeScript types in `src/types/`
- [ ] Create route in `src/app/{feature-name}/page.tsx`
- [ ] Use Server Components by default
- [ ] Add Client Components only for interactivity
- [ ] Use Server Actions for mutations when appropriate
- [ ] Add constants/enums to `src/constants/enums.ts` if needed

---

## Project Structure

YGS project structure (import with `@/` alias):

```
src/
├── app/                        # Next.js App Router
│   ├── page.tsx                # Home/Landing page
│   ├── layout.tsx              # Root layout with metadata
│   ├── error.tsx               # Error boundary
│   ├── admin/                  # Admin dashboard (protected)
│   │   ├── page.tsx            # Dashboard stats
│   │   ├── layout.tsx          # Admin layout with auth check
│   │   ├── members/            # Member management
│   │   ├── consultations/      # Consultation management
│   │   ├── matching/           # Matching interface
│   │   └── couples/            # Couple management
│   ├── login/                  # Authentication
│   ├── form/                   # User profile form
│   ├── match/                  # Matching interface
│   ├── buy/                    # Membership purchase
│   └── api/
│       └── auth/session/       # Token sync endpoint
├── components/                 # React components (~60 total)
│   ├── admin/                  # Admin components (27)
│   ├── auth/                   # Auth components (4)
│   ├── layout/                 # Layout components (2)
│   ├── match/                  # Match components (3)
│   ├── sections/               # Landing page sections (7)
│   ├── seo/                    # SEO schema components (4)
│   └── ui/                     # shadcn/ui components (11)
├── lib/                        # Core utilities
│   ├── api.ts                  # Main API client (token management)
│   ├── adminApi.ts             # Admin-specific API methods
│   ├── serverAuth.ts           # Server-side auth validation
│   ├── firebaseAuth.ts         # Firebase SDK integration
│   ├── firebase.ts             # Firebase config
│   ├── kakao.ts                # Kakao SDK integration
│   ├── s3Upload.ts             # S3 upload utilities
│   └── utils.ts                # cn() helper
├── providers/                  # Context providers
│   └── AuthProvider.tsx        # Auth state context
├── types/                      # TypeScript definitions
│   ├── index.ts                # Common types
│   ├── admin.ts                # Admin types
│   └── match.ts                # Match types
├── constants/                  # Constants & enums
│   └── enums.ts                # Enum options with Korean labels
└── middleware.ts               # Route protection
```

---

## Import Patterns

| Pattern | Usage | Example |
|---------|-------|---------|
| `@/` | Project imports (primary) | `import { api } from '@/lib/api'` |
| Relative | Same directory | `import { Component } from './Component'` |
| `type` | Type-only imports | `import type { User } from '@/types'` |

### Common Imports Cheatsheet

```typescript
// Server Component (no 'use client')
import { Suspense } from 'react';
import { redirect } from 'next/navigation';
import { cookies } from 'next/headers';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { getServerSession } from '@/lib/serverAuth';
import type { Metadata } from 'next';

// Client Component
'use client';
import { useState, useEffect, useCallback } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { useAuth } from '@/providers/AuthProvider';
import { api } from '@/lib/api';
import { cn } from '@/lib/utils';
import { Loader2 } from 'lucide-react';

// Admin API
import { getMembers, updateMemberBasic, getDashboardStats } from '@/lib/adminApi';

// Types & Constants
import type { AdminMember, MemberDetail, MemberFilter } from '@/types/admin';
import { USER_STATUS_OPTIONS, GENDER_OPTIONS, getEnumLabel } from '@/constants/enums';
```

---

## Topic Guides

### Component Patterns

**Server vs Client Components:**
- **Server Components (default)**: Data fetching, static content, no interactivity
- **Client Components ('use client')**: State, effects, event handlers, browser APIs

**Key Rules:**
- Server Components are async and fetch data directly
- Client Components need `'use client'` directive at the top
- Minimize Client Components for better performance
- Pass data from Server to Client Components via props
- Component structure: Props -> Hooks -> Handlers -> Render -> Export

**YGS-Specific:**
- Most admin components are Client Components (heavy state management)
- Landing page sections are Server Components (static content)
- Forms use manual state management (not react-hook-form)

**[Complete Guide: resources/component-patterns.md](resources/component-patterns.md)**

---

### Authentication

Multi-method auth system: Firebase Social (Google/Apple), Kakao OAuth, Custom JWT (60-min access / 30-day refresh).

**Key patterns:**
- Client-side: `useAuth()` hook from `AuthProvider` for login/logout/user state
- Server-side: `getServerSession()` from `lib/serverAuth.ts` for JWT validation in layouts
- Admin protection: Check `is_admin` claim in JWT within `app/admin/layout.tsx`
- Hydration safety: Use `mounted` state pattern to avoid SSR/CSR mismatch

**Key files:** `providers/AuthProvider.tsx`, `lib/serverAuth.ts`, `lib/firebaseAuth.ts`, `lib/kakao.ts`, `middleware.ts`

**[Complete Guide: resources/auth.md](resources/auth.md)** | Also see [resources/common-patterns.md](resources/common-patterns.md)

---

### Data Fetching

**Two primary patterns:**
1. **Server Component** (recommended): `async` component with direct API calls via `Promise.all`
2. **Client-side**: `useState` + `useEffect` with loading/error states (used in admin)

**API Clients:**
- `lib/api.ts` — Main client with token management (`api.get`, `api.post`, `api.patch`)
- `lib/adminApi.ts` — Admin-specific methods (dashboard, members, consultations, matching)

**[Complete Guide: resources/data-fetching.md](resources/data-fetching.md)**

---

### UI Components & Styling

**shadcn/ui** (components in `src/components/ui/`):
- Copy/paste components built on Radix UI, styled with Tailwind CSS
- Available: button, input, textarea, card, dialog, select, checkbox, badge, alert, skeleton, image-upload
- Add new: `npx shadcn@latest add <component>`

**Tailwind CSS 4 essentials:**
- Use `cn()` from `lib/utils.ts` for conditional/merged class names
- YGS brand: primary (Coral/Orange), gradients `from-amber-500 to-orange-500`
- Responsive: `grid-cols-1 lg:grid-cols-4`, `hidden md:flex`, `px-4 sm:px-6 md:px-12`

**[Complete Guide: resources/ui-styling.md](resources/ui-styling.md)** | Also see [resources/styling-guide.md](resources/styling-guide.md)

---

### App Router & Routing

**File conventions:** `page.tsx`, `layout.tsx`, `loading.tsx`, `error.tsx`, `route.ts`

**Key patterns:**
- Constants/enums: Define in `constants/enums.ts` with Korean labels + `getEnumLabel()` helper
- URL-based state: `useSearchParams` + `useRouter` for pagination/filtering
- Loading: Route-level `loading.tsx` with Skeleton components
- Error: Route-level `error.tsx` with Korean error messages and retry button

**[Complete Guide: resources/app-router.md](resources/app-router.md)** | Also see [resources/routing-guide.md](resources/routing-guide.md)

---

### File Organization

- shadcn/ui components in `src/components/ui/`
- Feature components in `src/components/{feature}/`
- Admin components in `src/components/admin/`
- Keep Server and Client components separate

**[Complete Guide: resources/file-organization.md](resources/file-organization.md)**

---

### Performance

**Next.js 15 optimizations:**
- Server Components by default (zero JS to client)
- Dynamic imports: `const Heavy = dynamic(() => import('./Heavy'))`
- Image optimization: `next/image` component
- Turbopack: Faster dev builds (already enabled)

**React 19 patterns:** `useMemo` (expensive computations), `useCallback` (handlers passed to children), `React.memo` (prevent re-renders)

**[Complete Guide: resources/performance.md](resources/performance.md)**

---

### TypeScript

**Standards:**
- Strict mode enabled
- Explicit return types on functions
- Type imports: `import type { User } from '@/types'`
- Component prop interfaces with JSDoc
- No `any` type (use `unknown` if needed)

**Key type files:** `types/admin.ts` (AdminMember, MemberDetail, update request types), `types/match.ts`, `types/index.ts`

**[Complete Guide: resources/typescript-standards.md](resources/typescript-standards.md)**

---

### Forms

**YGS uses manual state management** (not react-hook-form):
- Pattern 1: `useState` for formData + errors + loading, `validateForm()` before submit
- Pattern 2: Modal forms with `Dialog` component, `useEffect` to reset on open, diff-only submission

**[Complete Guide: resources/ui-styling.md](resources/ui-styling.md)** | Also see [resources/common-patterns.md](resources/common-patterns.md)

---

## Navigation Guide

| Need to... | Read this resource |
|------------|-------------------|
| Create a component | [component-patterns.md](resources/component-patterns.md) |
| Set up authentication | [auth.md](resources/auth.md) |
| Fetch data | [data-fetching.md](resources/data-fetching.md) |
| Style components / forms | [ui-styling.md](resources/ui-styling.md) |
| Organize files/folders | [file-organization.md](resources/file-organization.md) |
| Set up routing | [app-router.md](resources/app-router.md) |
| Handle loading/errors | [loading-and-error-states.md](resources/loading-and-error-states.md) |
| Optimize performance | [performance.md](resources/performance.md) |
| TypeScript types | [typescript-standards.md](resources/typescript-standards.md) |
| Forms/Auth/API Routes | [common-patterns.md](resources/common-patterns.md) |
| Full styling reference | [styling-guide.md](resources/styling-guide.md) |
| Routing patterns | [routing-guide.md](resources/routing-guide.md) |
| See full examples | [complete-examples.md](resources/complete-examples.md) |

---

## Core Principles

1. **Server Components First**: Use Server Components by default, Client Components only for interactivity
2. **Async Data Fetching**: Fetch data directly in Server Components
3. **Minimize Client JS**: Less JavaScript sent to the browser = better performance
4. **App Router Conventions**: Use loading.tsx, error.tsx, layout.tsx appropriately
5. **shadcn/ui Components**: Use pre-built accessible components from `@/components/ui/`
6. **cn() for Classes**: Always use `cn()` for conditional/merged class names
7. **Import with @/ alias**: Consistent import paths across the project
8. **Type Safety**: Strict TypeScript with explicit types
9. **Korean Localization**: All user-facing text in Korean
10. **AuthProvider**: Use `useAuth()` hook for client-side auth state

---

## Related Skills

- **error-tracking**: Error tracking with Sentry (applies to frontend too)
- **fastapi-backend-guidelines**: Backend API patterns that frontend consumes

---

**Skill Status**: Updated for YGS project with comprehensive coverage of actual codebase patterns
