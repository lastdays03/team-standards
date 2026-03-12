# Next.js 15 + @sentry/nextjs v8

## Installation

```bash
npm install @sentry/nextjs
# Or use the wizard (recommended for first setup):
npx @sentry/wizard@latest -i nextjs
```

## File Structure

```
project-root/
  instrumentation-client.ts      # Client (browser) init
  instrumentation.ts             # Server + Edge init via Next.js hook
  sentry.server.config.ts        # Node.js runtime init
  sentry.edge.config.ts          # Edge runtime init
  next.config.ts                 # withSentryConfig wrapper
  app/
    global-error.tsx             # Root-level error boundary
    [route]/
      error.tsx                  # Route-level error boundary
```

---

## Configuration Files

### `instrumentation-client.ts`

Initializes Sentry in the browser. This replaces the old `sentry.client.config.ts`.

```typescript
import * as Sentry from "@sentry/nextjs";

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  sendDefaultPii: true,

  // Tracing
  tracesSampleRate: process.env.NODE_ENV === "development" ? 1.0 : 0.1,

  // Session Replay — records user sessions on error
  integrations: [
    Sentry.replayIntegration({
      maskAllText: true,
      maskAllInputs: true,
      blockAllMedia: true,
    }),
  ],
  replaysSessionSampleRate: 0.1,
  replaysOnErrorSampleRate: 1.0,
});

// App Router navigation tracing (v8+)
export const onRouterTransitionStart = Sentry.captureRouterTransitionStart;
```

### `sentry.server.config.ts`

```typescript
import * as Sentry from "@sentry/nextjs";

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  sendDefaultPii: true,
  tracesSampleRate: process.env.NODE_ENV === "development" ? 1.0 : 0.1,

  // Propagate traces to backend API for distributed tracing
  tracePropagationTargets: [
    "localhost",
    /^https:\/\/api\.yourdomain\.com/,
  ],
});
```

### `sentry.edge.config.ts`

```typescript
import * as Sentry from "@sentry/nextjs";

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  tracesSampleRate: process.env.NODE_ENV === "development" ? 1.0 : 0.1,
});
```

### `instrumentation.ts`

This is the Next.js 15 native instrumentation hook. It loads the correct Sentry config based on runtime.

```typescript
import * as Sentry from "@sentry/nextjs";

export async function register() {
  if (process.env.NEXT_RUNTIME === "nodejs") {
    await import("./sentry.server.config");
  }
  if (process.env.NEXT_RUNTIME === "edge") {
    await import("./sentry.edge.config");
  }
}

// Next.js 15 hook — captures Server Component errors with full detail.
// Without this, production RSC errors are sanitized and lose their message.
export const onRequestError = Sentry.captureRequestError;
```

### `next.config.ts`

In v8, `withSentryConfig` accepts exactly **two arguments** (changed from v7's three):

```typescript
import type { NextConfig } from "next";
import { withSentryConfig } from "@sentry/nextjs";

const nextConfig: NextConfig = {
  experimental: {
    // Required for App Router distributed tracing
    clientTraceMetadata: ["sentry-trace", "baggage"],
  },
};

export default withSentryConfig(nextConfig, {
  org: process.env.SENTRY_ORG,
  project: process.env.SENTRY_PROJECT,
  authToken: process.env.SENTRY_AUTH_TOKEN,
  silent: !process.env.CI,
  widenClientFileUpload: true,
  // Route Sentry requests through /monitoring to bypass ad blockers
  tunnelRoute: "/monitoring",
});
```

---

## Server Components

Auto-instrumented via the webpack plugin for special files (`page.tsx`, `layout.tsx`, `loading.tsx`). The `onRequestError` export in `instrumentation.ts` captures errors with full server-side detail.

**Nested Server Components**: errors bubble up to the nearest `page.tsx` or `layout.tsx` (which ARE auto-wrapped). Let errors propagate naturally — don't catch them in nested RSCs unless you need custom handling.

**Production caveat**: Next.js sanitizes RSC error messages in production. `captureRequestError` captures the full error server-side before sanitization. Always check the server-side Sentry event.

---

## Client Components

Unhandled client errors are automatically captured. No extra setup beyond `instrumentation-client.ts`.

---

## Server Actions

### Full instrumentation (recommended)

```typescript
"use server";
import * as Sentry from "@sentry/nextjs";
import { headers } from "next/headers";

export async function submitForm(formData: FormData) {
  return Sentry.withServerActionInstrumentation(
    "submitForm",
    {
      headers: await headers(),
      formData,
      recordResponse: true,
    },
    async () => {
      const result = await processForm(formData);
      return { success: true, data: result };
      // Thrown errors are auto-captured and re-thrown
    },
  );
}
```

### Manual capture (when you catch and return gracefully)

```typescript
"use server";
import * as Sentry from "@sentry/nextjs";

export async function createPost(formData: FormData) {
  try {
    const post = await db.posts.create({ ... });
    return { success: true, id: post.id };
  } catch (error) {
    Sentry.captureException(error, {
      tags: { action: "createPost" },
    });
    return { success: false, error: "작성에 실패했습니다" };
  }
}
```

---

## Route Handlers (app/api/)

Auto-instrumented in v8. Manual capture only needed for caught errors:

```typescript
// app/api/artworks/route.ts
import { NextRequest, NextResponse } from "next/server";
import * as Sentry from "@sentry/nextjs";

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const artwork = await createArtwork(body);
    return NextResponse.json(artwork, { status: 201 });
  } catch (error) {
    Sentry.captureException(error, {
      tags: { route: "/api/artworks", method: "POST" },
    });
    // Flush in serverless — process may terminate before event is sent
    await Sentry.flush(2000);
    return NextResponse.json({ error: "Internal Server Error" }, { status: 500 });
  }
}

// Unhandled errors are auto-captured:
export async function GET() {
  const data = await fetchData(); // if this throws, Sentry captures automatically
  return NextResponse.json(data);
}
```

---

## Error Boundaries

### Route-level `error.tsx`

```tsx
"use client";
import { useEffect } from "react";
import * as Sentry from "@sentry/nextjs";

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    // error.tsx catches errors, hiding them from Sentry's global handler.
    // Manual capture is required here.
    Sentry.captureException(error);
  }, [error]);

  return (
    <div>
      <h2>문제가 발생했습니다</h2>
      <button onClick={() => reset()}>다시 시도</button>
    </div>
  );
}
```

### `global-error.tsx` (root layout failures)

```tsx
"use client";
import * as Sentry from "@sentry/nextjs";
import NextError from "next/error";
import { useEffect } from "react";

export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    Sentry.captureException(error);
  }, [error]);

  return (
    <html>
      <body>
        <NextError statusCode={0} />
      </body>
    </html>
  );
}
```

`global-error.tsx` only fires when the root `layout.tsx` itself fails — rare but critical.

### Auto vs Manual Capture Summary

| Scenario | Auto-Captured | Action Needed |
|----------|:------------:|---------------|
| Unhandled client exception | Yes | None |
| Unhandled server crash (re-thrown) | Yes | None |
| `error.tsx` boundary | No | `captureException` in `useEffect` |
| `global-error.tsx` boundary | No | `captureException` in `useEffect` |
| try/catch with graceful return | No | `captureException` before returning |
| try/catch with re-throw | Yes | None |

---

## Custom Spans

```typescript
import * as Sentry from "@sentry/nextjs";

const result = await Sentry.startSpan(
  { name: "upload-to-s3", op: "http.client" },
  async (span) => {
    span.setAttribute("file.size", file.size);
    return await uploadToS3(file);
  },
);
```

---

## Automatic Tracing (zero config)

v8 captures automatically:
- Page loads with Core Web Vitals (LCP, CLS, TTFB, INP)
- Client-side route navigations (via `onRouterTransitionStart`)
- All fetch/XHR requests during traced transactions
- Long tasks (>50ms)
- Server-side: HTTP, PostgreSQL, MongoDB (OpenTelemetry-based)

---

## v7 → v8 Breaking Changes

| v7 | v8 |
|----|----|
| `withSentryConfig(config, webpackOpts, sdkOpts)` | `withSentryConfig(config, mergedOpts)` |
| `sentry.client.config.ts` | `instrumentation-client.ts` |
| `nextRouterInstrumentation` | `onRouterTransitionStart` export |
| `configureScope()` | `getCurrentScope()` |
| `new Replay()` | `replayIntegration()` |
| `tracingOrigins` | `tracePropagationTargets` |
