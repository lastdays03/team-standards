---
name: error-tracking
description: "Sentry error tracking and performance monitoring for Next.js 15 frontend and FastAPI backend. Use this skill when adding error handling, setting up Sentry integration, instrumenting API routes or server actions, tracking database performance, or adding custom spans. Also trigger when the user mentions 'Sentry', 'error tracking', 'error monitoring', '에러 추적', '에러 모니터링', 'capture exception', or wants to add observability to any part of the application."
---

# Sentry Error Tracking & Performance Monitoring

Unified error tracking guide for the project's dual-stack architecture: **Next.js 15** (frontend) + **FastAPI** (backend). Each stack uses its own Sentry SDK with different initialization and capture patterns.

## When to Use This Skill

- Setting up Sentry in a new service
- Adding error handling to routes, services, or components
- Instrumenting async operations with custom spans
- Tracking database query performance
- Adding user context or tags to error events
- Debugging why errors aren't appearing in Sentry

## Stack Selection

| Stack | SDK | Reference |
|-------|-----|-----------|
| **Next.js 15** (App Router) | `@sentry/nextjs` v8 | [nextjs-sentry.md](references/nextjs-sentry.md) |
| **FastAPI** (async Python) | `sentry-sdk[fastapi]` v2 | [fastapi-sentry.md](references/fastapi-sentry.md) |

Read the reference for your target stack. The patterns below are cross-cutting principles that apply to both.

---

## Quick Start

### Frontend (Next.js 15)

```bash
npm install @sentry/nextjs
# Or use the wizard:
npx @sentry/wizard@latest -i nextjs
```

Key files: `instrumentation-client.ts`, `instrumentation.ts`, `sentry.server.config.ts`, `next.config.ts`

**[Complete Guide: references/nextjs-sentry.md](references/nextjs-sentry.md)**

### Backend (FastAPI)

```bash
pip install "sentry-sdk[fastapi]"
```

Single init call — integrations auto-activate:

```python
import sentry_sdk

sentry_sdk.init(
    dsn=settings.SENTRY_DSN,
    environment=settings.ENVIRONMENT,
    traces_sample_rate=0.1,
    send_default_pii=True,
)
```

**[Complete Guide: references/fastapi-sentry.md](references/fastapi-sentry.md)**

---

## Cross-Cutting Principles

### 1. Auto-Capture vs Manual Capture

Both SDKs auto-capture **unhandled** exceptions. Manual capture is needed when you catch an error and return a graceful response:

```python
# FastAPI
try:
    result = await service.process(data)
except ValidationError as e:
    sentry_sdk.capture_exception(e)         # manual — error is caught
    raise HTTPException(status_code=400)
```

```typescript
// Next.js
try {
  const data = await fetchData();
} catch (error) {
  Sentry.captureException(error);           // manual — error is caught
  return NextResponse.json({ error: "Failed" }, { status: 500 });
}
```

**Rule of thumb**: if you `catch` and don't re-`raise`/`throw`, you must capture manually.

### 2. Error Context Enrichment

Errors without context are nearly useless for debugging. Always attach:

| Context | Why | How |
|---------|-----|-----|
| **User** | Who experienced the error | `set_user({ id, email })` |
| **Tags** | Searchable/filterable in Sentry UI | `set_tag("domain", "artwork")` |
| **Extra data** | Debugging details (not indexed) | `set_context("payload", {...})` |
| **Breadcrumbs** | Timeline leading to error | `add_breadcrumb(...)` |

### 3. Error Severity Levels

| Level | When to use | Example |
|-------|-------------|---------|
| **fatal** | System unusable | Database connection pool exhausted |
| **error** | Operation failed | Payment processing failed |
| **warning** | Degraded but functional | Rate limit approaching threshold |
| **info** | Notable events | User completed onboarding |

### 4. Sensitive Data

Never include passwords, tokens, credit card numbers, or PII beyond user ID/email in error context. Use `before_send` (Python) or `beforeSend` (JS) to scrub if needed.

### 5. Performance Monitoring

Both SDKs support custom spans for tracing slow operations:

```python
# FastAPI — decorator or context manager
@sentry_sdk.trace
async def heavy_computation(data):
    ...

with sentry_sdk.start_span(name="upload_to_s3", op="http.client"):
    await upload(file)
```

```typescript
// Next.js — callback pattern
const result = await Sentry.startSpan(
  { name: "process-payment", op: "function" },
  async (span) => {
    span.setAttribute("amount", amount);
    return await stripe.charges.create({ amount });
  },
);
```

### 6. Sampling Strategy

| Environment | `traces_sample_rate` | `profiles_sample_rate` |
|-------------|---------------------|----------------------|
| Development | `1.0` (100%) | `1.0` |
| Staging | `0.5` (50%) | `0.5` |
| Production | `0.1` (10%) | `0.1` |

Capture all errors (`sample_rate` defaults to `1.0`), but sample traces to control costs.

---

## Implementation Checklist

When adding Sentry to new code:

- [ ] Correct SDK imported (`@sentry/nextjs` or `sentry_sdk`)
- [ ] Caught exceptions are manually captured before returning graceful response
- [ ] Meaningful context attached (user, tags, domain info)
- [ ] No sensitive data in error context
- [ ] Custom spans added for slow operations (DB queries, external API calls)
- [ ] `error.tsx` / `global-error.tsx` includes `Sentry.captureException` (Next.js)
- [ ] `before_send` / `beforeSend` scrubs PII if applicable

## Common Mistakes

| Mistake | Why it's a problem |
|---------|--------------------|
| `console.error(e)` without `captureException` | Error is logged locally but invisible in Sentry |
| Swallowing errors in catch blocks | Silent failures are the hardest to debug |
| Missing `Sentry.flush()` in serverless | Process terminates before event is sent |
| Using `@sentry/node` in Next.js | Use `@sentry/nextjs` — it handles SSR/CSR split |
| `SentryAsgiMiddleware` in FastAPI | Deprecated in v2. `FastApiIntegration` replaces it |
| `configure_scope()` in Python | Removed in v2. Use `sentry_sdk.set_tag()` or `new_scope()` |

---

## Testing Sentry Integration

### FastAPI

```bash
curl http://localhost:28080/api/v1/sentry/test-error
```

```python
@router.get("/sentry/test-error")
async def test_sentry():
    raise RuntimeError("Sentry test error — if you see this in Sentry, it works")
```

### Next.js

```typescript
// app/api/sentry/test/route.ts
export async function GET() {
  throw new Error("Sentry test error");
}
```

After triggering, verify the error appears in your Sentry project dashboard.

---

## Navigation Guide

| Need to... | Read this reference |
|------------|-------------------|
| Set up Sentry in Next.js 15 | [nextjs-sentry.md](references/nextjs-sentry.md) |
| Set up Sentry in FastAPI | [fastapi-sentry.md](references/fastapi-sentry.md) |
| Handle Server Component errors | [nextjs-sentry.md § Server Components](references/nextjs-sentry.md) |
| Handle Server Actions errors | [nextjs-sentry.md § Server Actions](references/nextjs-sentry.md) |
| Instrument async Python code | [fastapi-sentry.md § Custom Spans](references/fastapi-sentry.md) |
| Monitor database performance | [fastapi-sentry.md § Database Monitoring](references/fastapi-sentry.md) |
| Add user context in FastAPI | [fastapi-sentry.md § Context Enrichment](references/fastapi-sentry.md) |
| Set up error boundaries | [nextjs-sentry.md § Error Boundaries](references/nextjs-sentry.md) |

---

## Related Skills

- **fastapi-backend-guidelines** — Backend architecture patterns (error handling via custom exceptions + ErrorHandlerMiddleware)
- **nextjs-frontend-guidelines** — Frontend patterns (error.tsx, loading.tsx conventions)
- **pytest-backend-testing** — Testing error handling paths
