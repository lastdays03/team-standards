---
name: fastapi-backend-guidelines
description: "FastAPI backend development guidelines for Python async applications. Domain-Driven Design with FastAPI routers, SQLModel/SQLAlchemy ORM, repository pattern, service layer, async/await patterns, Pydantic validation, and error handling. Use when creating APIs, routes, services, repositories, or working with backend code. Also trigger when '백엔드 개발', 'API 개발', '서비스 레이어', '리포지토리 패턴', 'FastAPI 라우터', '도메인 설계', '비동기 패턴', 'DTO 검증', '에러 처리', or any Python backend architecture work."
---

# FastAPI Backend Development Guidelines

## Purpose

Comprehensive guide for modern FastAPI development with async Python, emphasizing Domain-Driven Design, layered architecture (Router -> Service -> Repository), SQLModel ORM, and async best practices.

> **Project-specific details**: If working in the QWarty/YGS project, read [references/ygs-project.md](references/ygs-project.md) for concrete domain structure, imports, and examples.

## When to Use This Skill

- Creating new API routes or endpoints
- Building domain services and business logic
- Implementing repositories for data access
- Setting up database models with SQLModel
- Async/await patterns and error handling
- Organizing backend code with DDD
- Pydantic validation and DTOs

---

## Quick Start

### New API Route Checklist

- [ ] Define route in `{project}/api/v1/routers/{domain}.py`
- [ ] Use FastAPI dependency injection for session
- [ ] Use read session for GET, write session for mutations
- [ ] Call service layer (don't access repository directly)
- [ ] Use Pydantic DTOs for request/response
- [ ] Handle errors with custom exceptions
- [ ] Add proper HTTP status codes
- [ ] Use async/await throughout

### New Domain Feature Checklist

- [ ] Create `{project}/domain/{domain}/` directory
- [ ] Create `model.py` - SQLModel database models with ULID ID generation
- [ ] Create `repository.py` - Data access layer extending BaseRepository
- [ ] Create `service.py` - Business logic layer
- [ ] Create DTOs in `{project}/dtos/{domain}.py`
- [ ] Create router in `{project}/api/v1/routers/{domain}.py`
- [ ] Register router in `main.py`

---

## Topic Guides

### Layered Architecture

**Three-Layer Pattern:**
1. **Router Layer**: API endpoints, request validation, response formatting
2. **Service Layer**: Business logic, orchestration, domain rules
3. **Repository Layer**: Data access, queries, database operations

**Key Rules:**
- Routers call Services (never Repositories directly)
- Services orchestrate business logic
- Repositories handle all database operations
- Async/await throughout the stack
- Read/Write session separation

---

### API Routes & Routers

- Create routers in `{project}/api/v1/routers/`
- Use dependency injection for sessions
- Use read session dependency for GET requests
- Use write session dependency for POST/PATCH/DELETE
- Follow REST conventions

**Router Structure:**
```python
from fastapi import APIRouter, Depends
from sqlmodel.ext.asyncio.session import AsyncSession

router = APIRouter(prefix="/items", tags=["items"])

@router.get("/{item_id}")
async def get_item(
    item_id: str,
    session: AsyncSession = Depends(get_read_session_dependency),
) -> ItemResponse:
    service = ItemService(session)
    return await service.get_item(item_id)

@router.post("", status_code=201)
async def create_item(
    request: ItemCreateRequest,
    session: AsyncSession = Depends(get_write_session_dependency),
) -> ItemResponse:
    service = ItemService(session)
    return await service.create_item(request)
```

---

### Database & ORM

**SQLModel + SQLAlchemy:**
- SQLModel for models (combines SQLAlchemy + Pydantic)
- Async sessions with asyncpg driver
- Read/Write session separation with caching
- Repository pattern for all queries
- ULID-based ID generation with prefixes

**Model Pattern:**
```python
from sqlmodel import SQLModel, Field, Column, DateTime, Text
from datetime import datetime, timezone
from ulid import ULID

def generate_item_id() -> str:
    return f"itm_{ULID()}"

class Item(SQLModel, table=True):
    __tablename__ = "item"

    id: str = Field(
        default_factory=generate_item_id,
        primary_key=True,
        max_length=30,
    )
    name: str = Field(sa_column=Column(Text, nullable=False))

    # Soft delete pattern
    deleted_at: Optional[datetime] = Field(
        sa_column=Column(DateTime(timezone=True), nullable=True),
        default=None,
    )

    # Timestamps
    created_at: datetime = Field(
        sa_column=Column(DateTime(timezone=True), nullable=False),
        default_factory=lambda: datetime.now(tz=timezone.utc),
    )
    updated_at: datetime = Field(
        sa_column=Column(DateTime(timezone=True), nullable=False),
        default_factory=lambda: datetime.now(tz=timezone.utc),
    )
```

---

### Domain-Driven Design

**Domain Organization:**
- Each domain in `{project}/domain/{name}/`
- Contains: `model.py`, `repository.py`, `service.py`
- Clear separation of concerns
- Business logic in services, data access in repositories

---

### Service Layer

**Service Pattern:**
- Business logic orchestration
- Domain rule enforcement
- Calls repositories for data
- Returns DTOs, not models directly
- Uses asyncio.gather for parallel queries

```python
class ItemService:
    def __init__(self, session: AsyncSession):
        self.session = session
        self._repository = ItemRepository(session)

    async def get_item(self, item_id: str) -> ItemResponse:
        item = await self._repository.get_by_id(item_id)
        if not item:
            raise NotFoundError(f"Item {item_id} not found")
        return ItemResponse.model_validate(item)
```

---

### Repository Pattern

**Repository Pattern:**
- Encapsulates data access
- Extends BaseRepository for CRUD
- Domain-specific queries
- Returns domain models
- All queries are async, soft delete support

```python
from {project}.domain.shared.base_repository import BaseRepository

class ItemRepository(BaseRepository[Item]):
    def __init__(self, session: AsyncSession):
        super().__init__(session, Item)

    async def find_by_name(self, name: str) -> Optional[Item]:
        stmt = select(Item).where(
            Item.name == name,
            Item.deleted_at.is_(None),
        )
        result = await self.session.execute(stmt)
        return result.scalar_one_or_none()
```

---

### DTOs & Validation

**Pydantic DTOs:**
- Request/Response data transfer objects in `{project}/dtos/`
- Validation with Pydantic
- Separate from domain models
- Use field_validator for enum validation

```python
from pydantic import BaseModel, Field

class ItemResponse(BaseModel):
    id: str
    name: str
    created_at: datetime

class ItemCreateRequest(BaseModel):
    name: str = Field(..., min_length=1, max_length=255)
    model_config = {"extra": "forbid"}
```

---

### Async/Await Patterns

```python
# Parallel queries with asyncio.gather
async def get_dashboard_data(self) -> dict:
    total, monthly, weekly, today = await asyncio.gather(
        self._get_total_count(),
        self._get_monthly_count(),
        self._get_weekly_count(),
        self._get_today_count(),
    )
    return {
        "total": total,
        "monthly": monthly,
        "weekly": weekly,
        "today": today,
    }
```

---

### Error Handling

```python
# Custom exception hierarchy
class AppException(Exception):
    def __init__(self, message: str):
        self.message = message
        super().__init__(self.message)

class NotFoundError(AppException):
    pass

class ForbiddenError(AppException):
    pass

class UnauthorizedError(AppException):
    pass

# In service
if not item:
    raise NotFoundError(f"Item {item_id} not found")

# ErrorHandlerMiddleware handles conversion to HTTP response
# NotFoundError -> 404, ForbiddenError -> 403, etc.
```

---

## Common Imports Cheatsheet

```python
# FastAPI
from fastapi import APIRouter, Depends, HTTPException, Query, Request
from fastapi.responses import StreamingResponse

# SQLModel & SQLAlchemy
from sqlmodel import select, or_, and_, col
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlalchemy import func, desc
from sqlalchemy.orm import selectinload

# Pydantic
from pydantic import BaseModel, Field, field_validator, EmailStr

# Type hints
from typing import List, Optional, Dict, Any

# ID generation
from ulid import ULID
```

---

## Quick Reference: New Domain Template

```python
# {project}/domain/{domain}/model.py
class MyFeature(SQLModel, table=True):
    __tablename__ = "my_feature"
    id: str = Field(default_factory=lambda: f"mf_{ULID()}", primary_key=True, max_length=30)
    name: str = Field(sa_column=Column(Text, nullable=False))
    created_at: datetime = Field(sa_column=Column(DateTime(timezone=True), nullable=False), default_factory=lambda: datetime.now(tz=timezone.utc))
    deleted_at: Optional[datetime] = Field(sa_column=Column(DateTime(timezone=True), nullable=True), default=None)

# {project}/domain/{domain}/repository.py
class MyFeatureRepository(BaseRepository[MyFeature]):
    def __init__(self, session: AsyncSession):
        super().__init__(session, MyFeature)

# {project}/domain/{domain}/service.py
class MyFeatureService:
    def __init__(self, session: AsyncSession):
        self.session = session
        self._repository = MyFeatureRepository(session)

    async def get_feature(self, id: str) -> MyFeatureResponse:
        feature = await self._repository.get_by_id(id)
        if not feature:
            raise NotFoundError(f"Feature {id} not found")
        return MyFeatureResponse.model_validate(feature)

# {project}/dtos/{domain}.py
class MyFeatureResponse(BaseModel):
    id: str
    name: str
    created_at: datetime

class MyFeatureCreateRequest(BaseModel):
    name: str = Field(..., min_length=1, max_length=255)

# {project}/api/v1/routers/{domain}.py
router = APIRouter(prefix="/myfeature", tags=["myfeature"])

@router.get("/{id}")
async def get_feature(id: str, session: AsyncSession = Depends(get_read_session_dependency)) -> MyFeatureResponse:
    return await MyFeatureService(session).get_feature(id)

@router.post("", status_code=201)
async def create_feature(request: MyFeatureCreateRequest, session: AsyncSession = Depends(get_write_session_dependency)) -> MyFeatureResponse:
    return await MyFeatureService(session).create_feature(request)
```

---

## Core Principles

1. **Layered Architecture**: Router -> Service -> Repository (never skip layers)
2. **Domain-Driven Design**: Organize by domain, not by type
3. **Async Everything**: Use async/await throughout the stack
4. **Repository Pattern**: All data access through repositories
5. **Service Layer**: Business logic in services, not routers or repositories
6. **DTOs for API**: Use Pydantic DTOs for request/response
7. **Type Hints**: Explicit types on all functions and parameters
8. **Error Handling**: Custom exceptions, middleware for HTTP mapping
9. **Read/Write Split**: Separate sessions for read and write operations
10. **Dependency Injection**: Use FastAPI's Depends() for sessions
11. **ULID IDs**: Use ULID with entity prefixes
12. **Soft Delete**: Use deleted_at timestamp instead of hard deletes
13. **N+1 Prevention**: Use asyncio.gather and DataLoader patterns

---

## Related Skills

- **nextjs-frontend-guidelines**: Frontend patterns that consume this API
- **error-tracking**: Error tracking with Sentry (backend integration)
- **pytest-backend-testing**: Testing patterns for FastAPI backends
