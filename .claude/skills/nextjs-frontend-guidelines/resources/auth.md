# Authentication - YGS Multi-Method Auth

## Overview

YGS uses a multi-method authentication system:
1. **Firebase Social Auth**: Google, Apple
2. **Kakao OAuth**: Server-side token validation with Firebase exchange
3. **Custom JWT**: 60-min access token, 30-day refresh token

---

## AuthProvider Pattern

Client-side auth state is managed via a centralized AuthProvider:

```typescript
'use client';

import { useAuth } from '@/providers/AuthProvider';

export function MyComponent() {
  const {
    user,
    isLoading,
    isAuthenticated,
    signupRequired,
    loginWithKakao,
    loginWithGoogle,
    logout,
    refreshUser,
  } = useAuth();

  if (isLoading) return <Loading />;
  if (!isAuthenticated) return <LoginPrompt />;

  return <div>Welcome, {user?.nickname}</div>;
}
```

---

## Server-Side Auth Check (Admin Layout)

```typescript
// app/admin/layout.tsx
import { redirect } from 'next/navigation';
import { getServerSession } from '@/lib/serverAuth';

export default async function AdminLayout({ children }) {
  const session = await getServerSession();

  if (!session.isAuthenticated) {
    redirect('/login');
  }

  // Check admin claim from JWT
  const claims = parseJwtClaims(session.accessToken);
  if (!claims?.is_admin) {
    redirect('/');
  }

  return (
    <div className="flex min-h-screen">
      <AdminSidebar />
      <main className="flex-1">{children}</main>
    </div>
  );
}
```

---

## Hydration Protection Pattern

Prevents hydration mismatches for auth-dependent UI:

```typescript
'use client';

import { useState, useEffect } from 'react';
import { useAuth } from '@/providers/AuthProvider';

export function Navbar() {
  const { user, isLoading, isAuthenticated } = useAuth();
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  return (
    <nav>
      {/* Always render static content */}
      <Logo />

      {/* Auth-dependent content only after mount */}
      {mounted && !isLoading ? (
        isAuthenticated ? <UserMenu user={user} /> : <LoginButton />
      ) : (
        <div className="w-[72px] h-10" /> // Placeholder
      )}
    </nav>
  );
}
```

---

## Key Files

| File | Purpose |
|------|---------|
| `src/providers/AuthProvider.tsx` | Client-side auth state context |
| `src/lib/serverAuth.ts` | Server-side JWT validation |
| `src/lib/firebaseAuth.ts` | Firebase SDK integration |
| `src/lib/firebase.ts` | Firebase config |
| `src/lib/kakao.ts` | Kakao SDK integration |
| `src/lib/api.ts` | Token management (getAccessToken, setTokens, clearTokens) |
| `src/middleware.ts` | Route protection middleware |
