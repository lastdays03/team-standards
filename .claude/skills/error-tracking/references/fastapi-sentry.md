# FastAPI + sentry-sdk v2.x

## Installation

```bash
pip install "sentry-sdk[fastapi]"
# With database monitoring (recommended for this project):
pip install "sentry-sdk[fastapi,asyncpg,sqlalchemy]"
```

The `[fastapi]` extra includes Starlette support. Integrations (FastAPI, asyncpg, SQLAlchemy) auto-activate when the packages are detected.

---

## Initialization

### Minimal (auto-integration)

```python
import sentry_sdk

sentry_sdk.init(
    dsn=settings.SENTRY_DSN,
    environment=settings.ENVIRONMENT,
    release=settings.APP_VERSION,
    send_default_pii=True,
    traces_sample_rate=0.1 if settings.ENVIRONMENT == "production" else 1.0,
    profiles_sample_rate=0.1 if settings.ENVIRONMENT == "production" else 1.0,
)
```

FastApiIntegration, StarletteIntegration, AsyncPGIntegration, SqlalchemyIntegration all activate automatically.

### Explicit configuration (when tuning options)

Because FastAPI builds on Starlette, **both** integrations must be configured together:

```python
from sentry_sdk.integrations.starlette import StarletteIntegration
from sentry_sdk.integrations.fastapi import FastApiIntegration
from sentry_sdk.integrations.asyncio import AsyncioIntegration
from sentry_sdk.integrations.asyncpg import AsyncPGIntegration
from sentry_sdk.integrations.sqlalchemy import SqlalchemyIntegration

sentry_sdk.init(
    dsn=settings.SENTRY_DSN,
    environment=settings.ENVIRONMENT,
    send_default_pii=True,
    traces_sample_rate=0.1,
    integrations=[
        StarletteIntegration(
            transaction_style="endpoint",
            failed_request_status_codes={403, *range(500, 600)},
            middleware_spans=True,
        ),
        FastApiIntegration(
            transaction_style="endpoint",
            failed_request_status_codes={403, *range(500, 600)},
        ),
        AsyncioIntegration(),
        AsyncPGIntegration(),
        SqlalchemyIntegration(),
    ],
    before_send=before_send,
)
```

**`transaction_style`**:
- `"url"` (default) — `/api/v1/artworks/{id}`
- `"endpoint"` — `get_artwork_by_id` (function name)

### Where to put the init call

Call `sentry_sdk.init()` at module level, before the FastAPI app is created. In the project structure:

```python
# backend/main.py
import sentry_sdk
from backend.core.config import settings

sentry_sdk.init(
    dsn=settings.SENTRY_DSN,
    environment=settings.ENVIRONMENT,
    traces_sample_rate=0.1,
    send_default_pii=True,
)

def create_application() -> FastAPI:
    app = FastAPI(...)
    # ... register routers, middleware
    return app
```

---

## Capturing Exceptions

### Automatic capture

Unhandled exceptions in route handlers are captured automatically. The integration converts them to 500 responses and sends to Sentry.

### Manual capture (caught exceptions)

```python
import sentry_sdk

@router.get("/artworks/{artwork_id}")
async def get_artwork(artwork_id: str):
    try:
        result = await artwork_service.get(artwork_id)
        return result
    except ArtworkNotFoundError as e:
        sentry_sdk.capture_exception(e)
        raise HTTPException(status_code=404, detail="Artwork not found")
```

`capture_exception()` with no argument inside an `except` block captures `sys.exc_info()` automatically.

---

## Context Enrichment

### Top-level scope functions (v2.x API)

```python
import sentry_sdk

# User identity — call in auth middleware or dependency
sentry_sdk.set_user({
    "id": str(user.id),
    "email": user.email,
})

# Tags — indexed, searchable in Sentry UI
sentry_sdk.set_tag("domain", "artwork")
sentry_sdk.set_tag("operation", "create")

# Structured context — arbitrary dict, grouped under a name
sentry_sdk.set_context("artwork", {
    "artwork_id": artwork.id,
    "artist_id": artwork.artist_id,
})

# Breadcrumbs — timeline leading to the error
sentry_sdk.add_breadcrumb(
    category="auth",
    message=f"User {user.email} authenticated",
    level="info",
)
```

### Scoped context with `new_scope` (isolated capture)

Use when context should apply to one specific `capture_*` call only:

```python
with sentry_sdk.new_scope() as scope:
    scope.set_tag("background_task", "subscription_renewal")
    scope.set_context("subscription", {
        "subscription_id": sub.id,
        "plan": sub.plan,
    })
    sentry_sdk.capture_exception(exc)
# Scope reverts after the block
```

Inside `new_scope`, call methods on the `scope` object. Do not mix top-level `sentry_sdk.set_tag()` inside a `new_scope` block.

### FastAPI dependency for automatic user enrichment

```python
from fastapi import Depends
import sentry_sdk

async def sentry_user_context(
    current_user: User = Depends(get_current_user),
):
    sentry_sdk.set_user({
        "id": str(current_user.id),
        "email": current_user.email,
    })
    return current_user

@router.get("/artworks")
async def list_artworks(user: User = Depends(sentry_user_context)):
    ...
```

---

## Custom Exception Handler Integration

Works alongside the project's `ErrorHandlerMiddleware`:

```python
from fastapi import Request
from fastapi.responses import JSONResponse
import sentry_sdk

@app.exception_handler(AppException)
async def app_exception_handler(request: Request, exc: AppException):
    with sentry_sdk.new_scope() as scope:
        scope.set_tag("endpoint", request.url.path)
        scope.set_context("request_info", {
            "method": request.method,
            "url": str(request.url),
        })
        sentry_sdk.capture_exception(exc)

    return JSONResponse(
        status_code=exc.status_code,
        content={"detail": exc.message},
    )
```

---

## Custom Spans

### Context manager

```python
@router.post("/artworks")
async def create_artwork(payload: ArtworkCreate):
    with sentry_sdk.start_span(name="validate_artwork", op="validation"):
        await validate_artwork(payload)

    with sentry_sdk.start_span(name="upload_to_s3", op="http.client"):
        url = await upload_image(payload.image)

    with sentry_sdk.start_span(name="save_artwork", op="db"):
        artwork = await artwork_repo.create(payload, url)

    return artwork
```

### Decorator (reusable functions)

```python
@sentry_sdk.trace
async def fetch_artist_profile(artist_id: str) -> Artist:
    return await artist_repo.get(artist_id)

# With explicit op and name
@sentry_sdk.trace(op="cache", name="get_artwork_from_cache")
async def get_cached_artwork(artwork_id: str):
    return await redis.get(f"artwork:{artwork_id}")
```

### Attaching data to spans

```python
async def process_match(match_id: str):
    with sentry_sdk.start_span(name="process_match", op="task") as span:
        span.set_data("match_id", match_id)
        result = await matching_service.run(match_id)
        span.set_data("match_count", len(result))
    return result
```

---

## Database Monitoring

Both integrations activate automatically:
- **SQLAlchemy** — breadcrumbs (visible in error event trail)
- **asyncpg** — spans on Performance waterfall (with `traces_sample_rate > 0`)

asyncpg creates separate spans for:
- Connection acquisition
- Each SQL query execution

No extra configuration needed — just install `sentry-sdk[asyncpg,sqlalchemy]`.

---

## Service Layer Pattern

Full example integrating Sentry with the project's DDD service pattern:

```python
import sentry_sdk
from backend.error import NotFoundError

class ArtworkService:
    def __init__(self, session: AsyncSession):
        self.session = session
        self._repo = ArtworkRepository(session)

    @sentry_sdk.trace(op="service", name="artwork.create")
    async def create(self, payload: ArtworkCreate, user_id: str) -> Artwork:
        sentry_sdk.set_tag("artwork.media_type", payload.media_type)

        try:
            artwork = await self._repo.create(payload, user_id)

            sentry_sdk.add_breadcrumb(
                category="artwork",
                message=f"Artwork {artwork.id} created",
                level="info",
            )
            return artwork

        except IntegrityError as e:
            with sentry_sdk.new_scope() as scope:
                scope.set_context("db_error", {
                    "constraint": str(e.orig),
                })
                sentry_sdk.capture_exception(e)
            raise ConflictError("Artwork already exists") from e
```

---

## Filtering & PII Scrubbing

```python
def before_send(event, hint):
    # Drop expected operational errors
    exc_info = hint.get("exc_info")
    if exc_info:
        exc = exc_info[1]
        if isinstance(exc, (KeyboardInterrupt, asyncio.CancelledError)):
            return None

    # Scrub sensitive fields from request body
    request = event.get("request", {})
    data = request.get("data", {})
    for key in ("password", "token", "card_number"):
        if key in data:
            data[key] = "[Filtered]"

    return event

def filter_transactions(event, hint):
    url = event.get("request", {}).get("url", "")
    if url.endswith("/health") or url.endswith("/ping"):
        return None
    return event

sentry_sdk.init(
    before_send=before_send,
    before_send_transaction=filter_transactions,
    ...
)
```

---

## Async Task Scope Propagation

When using `asyncio.create_task()`, `AsyncioIntegration` ensures scope context (user, tags) propagates to child tasks:

```python
from sentry_sdk.integrations.asyncio import AsyncioIntegration

sentry_sdk.init(
    integrations=[AsyncioIntegration()],
    ...
)

# Scope is automatically propagated to child tasks
asyncio.create_task(send_notification(user.id))
```

---

## Known Gotchas

| Issue | Detail |
|-------|--------|
| `SentryAsgiMiddleware` | Deprecated in v2. `FastApiIntegration` replaces it. |
| `configure_scope` / `push_scope` | Removed in v2. Use `sentry_sdk.set_tag()` or `new_scope()`. |
| `send_default_pii=True` required | Without this, request body, user IP, and headers are NOT attached. |
| `AsyncioIntegration` init order | Must be enabled after event loop is running. Use `enable_asyncio_integration()` in lifespan if SDK is initialized at module level. |
| `before_send` scope frozen | Don't call `sentry_sdk.set_tag()` inside `before_send`. Modify `event` dict directly. |
