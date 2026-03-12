---
name: pytest-backend-testing
description: "Comprehensive pytest testing guide for FastAPI backends. Covers unit testing, integration testing, async patterns, mocking, fixtures, coverage, and FastAPI-specific testing with TestClient. Use when writing or updating test code for backend services, repositories, or API routes. Also trigger when '테스트 작성', '백엔드 테스트', '단위 테스트', '통합 테스트', '비동기 테스트', '목킹', '픽스처', '테스트 커버리지', 'pytest 설정', or any backend testing work."
---

# Pytest Backend Testing Guidelines

## Purpose

Complete guide for writing comprehensive tests for FastAPI backend applications using pytest, pytest-asyncio, and FastAPI TestClient. Emphasizes async testing, proper mocking, layered testing (repository -> service -> router), and achieving high test coverage.

> **Project-specific examples**: If working in the QWarty/YGS project, read [references/ygs-examples.md](references/ygs-examples.md) for concrete domain test templates and pytest configuration.

## When to Use This Skill

- Writing new test files for backend code
- Testing repositories, services, or API routes
- Setting up test fixtures and mocks
- Debugging failing tests
- Improving test coverage
- Writing async tests with pytest-asyncio
- Testing database operations
- Using FastAPI TestClient for route testing

---

## Quick Start

### New Test File Checklist

- [ ] Create test file: `tests/unit/{domain}/test_{module}.py`
- [ ] Import pytest and pytest-asyncio
- [ ] Set up necessary fixtures (session, client, etc.)
- [ ] Use `@pytest.mark.asyncio` for async tests
- [ ] Follow AAA pattern: Arrange, Act, Assert
- [ ] Mock external dependencies
- [ ] Test both success and error cases
- [ ] Verify coverage meets 80% threshold
- [ ] Use descriptive test names: `test_<what>_<when>_<expected>`

### Test Coverage Checklist

- [ ] Test all public methods/functions
- [ ] Test error handling and exceptions
- [ ] Test edge cases and boundary conditions
- [ ] Test validation logic
- [ ] Mock external dependencies (database, APIs)
- [ ] Verify async/await behavior
- [ ] Run `pytest --cov={project} --cov-report=term-missing`
- [ ] Check coverage report for gaps
- [ ] Aim for 80%+ coverage

---

## Common Test Patterns Quick Reference

### Basic Async Test

```python
import pytest
from sqlmodel.ext.asyncio.session import AsyncSession

@pytest.mark.asyncio
async def test_get_item_by_id(db_session: AsyncSession):
    # Arrange
    item_id = "test-item-id"

    # Act
    result = await repository.get_by_id(item_id)

    # Assert
    assert result is not None
    assert result.id == item_id
```

### Mocking Database Session

```python
from unittest.mock import AsyncMock, MagicMock

@pytest.mark.asyncio
async def test_create_item_success():
    # Arrange
    mock_session = AsyncMock(spec=AsyncSession)
    mock_session.execute = AsyncMock()
    mock_session.commit = AsyncMock()

    # Act
    service = ItemService(mock_session)
    result = await service.create_item(data)

    # Assert
    assert mock_session.commit.called
```

### Testing FastAPI Routes

```python
from fastapi.testclient import TestClient

@pytest.fixture
def client():
    app = create_application()
    return TestClient(app)

def test_get_item_endpoint(client):
    response = client.get("/api/v1/items/test-id")
    assert response.status_code == 200
    assert response.json()["id"] == "test-id"
```

---

## Test Organization Principles

### Test Structure (AAA Pattern)

1. **Arrange**: Set up test data, mocks, fixtures
2. **Act**: Execute the code under test
3. **Assert**: Verify the expected outcome

### Test Naming Convention

```python
# Pattern: test_<what>_<when>_<expected>
def test_create_item_with_valid_data_returns_item()
def test_get_item_when_not_found_raises_not_found_error()
def test_update_item_with_duplicate_name_raises_conflict_error()
```

### Test Organization

- **Unit tests**: Test individual functions/methods in isolation
- **Integration tests**: Test multiple components working together
- **Group related tests**: Use test classes for related functionality

---

## Topic Guides

### Testing Architecture

**Three-Layer Testing Strategy:**
1. **Repository Layer**: Test database queries, CRUD operations
2. **Service Layer**: Test business logic, orchestration
3. **Router Layer**: Test API endpoints, request/response handling

**Key Concepts:**
- Mock dependencies at layer boundaries
- Test each layer independently
- Use integration tests for end-to-end flows
- Maintain test isolation

---

### Unit Testing

- Test single responsibility
- Mock external dependencies
- Fast execution (no database, no network)
- Independent and isolated
- Test both success and failure paths

```python
@pytest.mark.asyncio
async def test_service_create():
    # Mock repository
    mock_repo = AsyncMock()
    mock_repo.create = AsyncMock(return_value=model_instance)

    service = MyService(mock_repo)
    result = await service.create(data)

    assert result.name == data.name
```

---

### Integration Testing

- Test multiple components together
- Use real database (test database)
- Verify end-to-end workflows
- Test API contracts

```python
@pytest.mark.asyncio
async def test_create_item_flow(db_session, client):
    response = client.post("/api/v1/items", json=item_data)
    assert response.status_code == 201

    # Verify in database
    item = await db_session.get(Item, response.json()["id"])
    assert item is not None
```

---

### Async Testing

- Use `@pytest.mark.asyncio` decorator
- Configure pytest-asyncio in conftest.py
- Mock async functions with AsyncMock
- Test async context managers
- Handle async exceptions

```python
from unittest.mock import AsyncMock

@pytest.mark.asyncio
async def test_async_function():
    mock_func = AsyncMock(return_value="result")
    result = await mock_func()
    assert result == "result"
    mock_func.assert_awaited_once()
```

---

### Mocking & Fixtures

- Mock external dependencies (database, APIs, S3)
- Use pytest fixtures for reusable test data
- Mock at layer boundaries
- Use MagicMock for sync, AsyncMock for async

```python
import pytest

@pytest.fixture
def sample_item():
    return Item(id="test-id", name="Test Item")

@pytest.fixture
async def db_session():
    async with get_test_session() as session:
        yield session
        await session.rollback()
```

---

### Coverage Best Practices

- Aim for 80%+ coverage (project requirement)
- Focus on critical business logic
- Test error paths and edge cases
- Use coverage reports to find gaps

```bash
# Run tests with coverage
pytest --cov={project} --cov-report=term-missing

# Generate HTML report
pytest --cov={project} --cov-report=html

# Check coverage threshold
pytest --cov={project} --cov-fail-under=80
```

---

### FastAPI Testing

- Use TestClient for route testing
- Test request validation
- Test response serialization
- Test authentication/authorization
- Test error handling middleware

```python
from fastapi.testclient import TestClient

def test_create_item_endpoint(client: TestClient):
    response = client.post(
        "/api/v1/items",
        json={"name": "Item", "description": "Desc"}
    )
    assert response.status_code == 201
    data = response.json()
    assert data["name"] == "Item"
```

---

## Quick Reference: Generic Test Template

```python
"""Tests for {Domain} domain."""
import pytest
from unittest.mock import AsyncMock, MagicMock
from sqlmodel.ext.asyncio.session import AsyncSession


@pytest.fixture
def sample_entity():
    """Fixture for sample entity data."""
    return MyModel(id="test-id", name="Test Entity")


@pytest.fixture
def mock_session():
    """Fixture for mocked database session."""
    return AsyncMock(spec=AsyncSession)


class TestMyRepository:
    @pytest.mark.asyncio
    async def test_get_by_id_success(self, mock_session, sample_entity):
        # Arrange
        mock_result = MagicMock()
        mock_result.scalar_one_or_none.return_value = sample_entity
        mock_session.execute = AsyncMock(return_value=mock_result)
        repository = MyRepository(mock_session)

        # Act
        result = await repository.get_by_id("test-id")

        # Assert
        assert result is not None
        assert result.id == sample_entity.id

    @pytest.mark.asyncio
    async def test_get_by_id_not_found(self, mock_session):
        mock_result = MagicMock()
        mock_result.scalar_one_or_none.return_value = None
        mock_session.execute = AsyncMock(return_value=mock_result)
        repository = MyRepository(mock_session)

        result = await repository.get_by_id("nonexistent-id")
        assert result is None


class TestMyService:
    @pytest.mark.asyncio
    async def test_create_success(self, mock_session, sample_entity):
        mock_repo = AsyncMock()
        mock_repo.create = AsyncMock(return_value=sample_entity)
        service = MyService(mock_session)
        service._repository = mock_repo

        result = await service.create(request_dto)

        assert result.name == request_dto.name
        mock_repo.create.assert_awaited_once()
```

---

## Core Principles

1. **Test Isolation**: Each test runs independently, no shared state
2. **AAA Pattern**: Arrange, Act, Assert for clear test structure
3. **Async Testing**: Use pytest-asyncio for async code
4. **Mock Dependencies**: Mock external systems (database, APIs)
5. **Layered Testing**: Test each layer (repository, service, router) separately
6. **Coverage Goals**: Aim for 80%+ coverage, focus on business logic
7. **Descriptive Names**: Clear test names explain what, when, expected
8. **Error Testing**: Test both success and failure paths
9. **Fast Tests**: Unit tests should be fast (no real database)
10. **Fixtures**: Use fixtures for reusable test data and setup

---

## Related Skills

- **fastapi-backend-guidelines**: Backend development patterns (what you're testing)
- **error-tracking**: Error handling patterns to test
