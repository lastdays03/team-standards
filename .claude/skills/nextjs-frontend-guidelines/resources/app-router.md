# App Router - Next.js 15

## Overview

YGS uses the Next.js 15 App Router with file-system based routing. Key conventions:

- `page.tsx` — Route page
- `layout.tsx` — Shared layout (persistent across child routes)
- `loading.tsx` — Route-level loading UI
- `error.tsx` — Route-level error boundary
- `route.ts` — API route handler

---

## App Router File Structure

```
src/app/
├── page.tsx                # Home/Landing page (/)
├── layout.tsx              # Root layout with metadata
├── error.tsx               # Error boundary
├── admin/                  # Admin dashboard (protected)
│   ├── page.tsx            # Dashboard stats
│   ├── layout.tsx          # Admin layout with auth check
│   ├── members/            # Member management
│   │   ├── page.tsx        # Member list
│   │   └── [id]/page.tsx   # Member detail (dynamic)
│   ├── consultations/      # Consultation management
│   ├── matching/           # Matching interface
│   └── couples/            # Couple management
├── login/                  # Authentication
│   ├── page.tsx            # Login page
│   └── kakao-callback/     # Kakao OAuth callback
├── form/                   # User profile form
├── match/                  # Matching interface
├── buy/                    # Membership purchase
└── api/
    └── auth/session/       # Token sync endpoint
```

---

## Constants & Enums Pattern

Define in `constants/enums.ts` for Korean-labeled options:

```typescript
// constants/enums.ts
export const USER_STATUS_OPTIONS = [
  { value: "draft", label: "상담 전" },
  { value: "pending_review", label: "상담 예정" },
  { value: "active", label: "상담 완료" },
  { value: "suspended", label: "정지" },
  { value: "withdrawn", label: "탈퇴" },
] as const;

export const GENDER_OPTIONS = [
  { value: "male", label: "남성" },
  { value: "female", label: "여성" },
] as const;

// Helper functions
export function getEnumLabel(
  options: readonly { value: string; label: string }[],
  value: string | null | undefined
): string {
  if (!value) return "-";
  return options.find(o => o.value === value)?.label ?? value;
}
```

Usage in components:

```typescript
import { USER_STATUS_OPTIONS, getEnumLabel } from '@/constants/enums';

// In Select component
<Select value={status} onValueChange={setStatus}>
  <SelectTrigger>
    <SelectValue placeholder="상태 선택" />
  </SelectTrigger>
  <SelectContent>
    {USER_STATUS_OPTIONS.map(option => (
      <SelectItem key={option.value} value={option.value}>
        {option.label}
      </SelectItem>
    ))}
  </SelectContent>
</Select>

// Display label
<span>{getEnumLabel(USER_STATUS_OPTIONS, member.status)}</span>
```

---

## URL-Based State Pattern (Pagination/Filtering)

```typescript
'use client';

import { useCallback } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import type { MemberFilter } from '@/types/admin';

export function useMemberFilters() {
  const searchParams = useSearchParams();
  const router = useRouter();

  const filters: MemberFilter = {
    status: searchParams.get('status') || '',
    gender: searchParams.get('gender') || '',
    search: searchParams.get('search') || '',
    skip: Number(searchParams.get('skip')) || 0,
    limit: Number(searchParams.get('limit')) || 20,
  };

  const updateURL = useCallback((newFilters: Partial<MemberFilter>) => {
    const params = new URLSearchParams();
    const merged = { ...filters, ...newFilters };

    if (merged.status) params.set('status', merged.status);
    if (merged.gender) params.set('gender', merged.gender);
    if (merged.search) params.set('search', merged.search);
    if (merged.skip) params.set('skip', String(merged.skip));
    if (merged.limit !== 20) params.set('limit', String(merged.limit));

    router.push(`/admin/members${params.toString() ? `?${params}` : ''}`);
  }, [filters, router]);

  return { filters, updateURL };
}
```

---

## Loading & Error States

### Route-Level Loading

```typescript
// loading.tsx
import { Skeleton } from '@/components/ui/skeleton';

export default function Loading() {
  return (
    <div className="space-y-4">
      <Skeleton className="h-8 w-48" />
      <div className="grid grid-cols-1 lg:grid-cols-4 gap-4">
        {[...Array(4)].map((_, i) => (
          <Skeleton key={i} className="h-24" />
        ))}
      </div>
    </div>
  );
}
```

### Route-Level Error Handling (Korean)

```typescript
// error.tsx
'use client';

import { Button } from '@/components/ui/button';
import { AlertCircle } from 'lucide-react';

export default function Error({ error, reset }: { error: Error; reset: () => void }) {
  return (
    <div className="flex flex-col items-center justify-center py-12">
      <AlertCircle className="h-12 w-12 text-destructive mb-4" />
      <h2 className="text-xl font-bold mb-2">오류가 발생했습니다</h2>
      <p className="text-muted-foreground mb-4">페이지를 불러오는 중 문제가 발생했습니다.</p>
      <Button onClick={reset}>다시 시도</Button>
    </div>
  );
}
```
