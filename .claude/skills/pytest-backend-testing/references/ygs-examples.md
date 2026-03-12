# QWarty Project Test Examples

Concrete test examples and configuration for the QWarty/YGS backend project.
Read this file when writing tests within the QWarty project for domain-specific patterns.

---

## Project Testing Structure

```
backend/
  tests/
    conftest.py              # Global fixtures
    unit/
      domain/
        artist/
          test_artist_repository.py
          test_artist_service.py
        artwork/
        auth/
        ...
      middleware/
        test_error_handler.py
      utils/
        test_utils.py
    integration/             # End-to-end tests
      test_artist_api.py
      test_auth_flow.py
```

---

## Full Test Template: Artist Domain

```python
"""Tests for Artist domain."""
import pytest
from unittest.mock import AsyncMock, MagicMock
from sqlmodel.ext.asyncio.session import AsyncSession

from backend.domain.artist.service import ArtistService
from backend.domain.artist.repository import ArtistRepository
from backend.domain.artist.model import Artist
from backend.dtos.artist import ArtistRequestDto
from backend.error import NotFoundError


@pytest.fixture
def sample_artist():
    """Fixture for sample artist data."""
    return Artist(
        id="test-artist-id",
        name="Test Artist",
        bio="Test bio"
    )


@pytest.fixture
def mock_session():
    """Fixture for mocked database session."""
    return AsyncMock(spec=AsyncSession)


class TestArtistRepository:
    """Test suite for ArtistRepository."""

    @pytest.mark.asyncio
    async def test_get_by_id_success(self, mock_session, sample_artist):
        """Test get_by_id returns artist when found."""
        # Arrange
        mock_result = MagicMock()
        mock_result.scalar_one_or_none.return_value = sample_artist
        mock_session.execute = AsyncMock(return_value=mock_result)
        repository = ArtistRepository(mock_session)

        # Act
        result = await repository.get_by_id("test-artist-id")

        # Assert
        assert result is not None
        assert result.id == sample_artist.id
        assert result.name == sample_artist.name

    @pytest.mark.asyncio
    async def test_get_by_id_not_found(self, mock_session):
        """Test get_by_id returns None when not found."""
        # Arrange
        mock_result = MagicMock()
        mock_result.scalar_one_or_none.return_value = None
        mock_session.execute = AsyncMock(return_value=mock_result)
        repository = ArtistRepository(mock_session)

        # Act
        result = await repository.get_by_id("nonexistent-id")

        # Assert
        assert result is None


class TestArtistService:
    """Test suite for ArtistService."""

    @pytest.mark.asyncio
    async def test_create_artist_success(self, mock_session, sample_artist):
        """Test create_artist creates and returns artist."""
        # Arrange
        mock_repo = AsyncMock()
        mock_repo.create = AsyncMock(return_value=sample_artist)
        service = ArtistService(mock_session)
        service._repository = mock_repo

        request_dto = ArtistRequestDto(
            name="Test Artist",
            bio="Test bio"
        )

        # Act
        result = await service.create_artist(request_dto)

        # Assert
        assert result.name == request_dto.name
        mock_repo.create.assert_awaited_once()
```

---

## pytest Configuration (pyproject.toml)

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
filterwarnings = ["ignore::DeprecationWarning"]
markers = [
    "security: marks tests as security tests (SQL injection, etc.)",
    "performance: marks tests as performance benchmarks",
]
addopts = [
    "--cov=backend",
    "--cov-report=term-missing",
    "--cov-report=html",
    "--cov-fail-under=80",
]
```

## Test Dependencies

- pytest 8.4.2+
- pytest-asyncio 0.24.0+
- pytest-cov 6.0.0+

## Coverage Exclusions

- Tests themselves (`tests/*`)
- `__init__.py` files
- Main application entry (`backend/main.py`)
- Some routers and specific domains (see pyproject.toml)
