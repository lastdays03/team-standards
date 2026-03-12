# YGS (QWarty) Project-Specific Configuration

This reference contains project-specific structure, domains, and examples for the YGS/QWarty backend.
Read this file when working within the QWarty project to understand the concrete domain layout.

---

## Project Structure

```
backend/
  backend/
    main.py                  # FastAPI app creation with lifespan

    api/
      v1/
        routers/             # API route handlers
          admin.py           # Dashboard, members, matching
          auth.py            # Login, signup, OAuth
          match.py           # Match weeks, history
          user.py            # User management
          upload.py          # S3 presigned URLs

    domain/                  # Domain-Driven Design
      user/
        model.py             # User, UserProfile, UserLifestyle, etc.
        repository.py        # UserRepository, UserDataLoader
        service.py           # UserService
        enums.py             # All domain enums
      auth/
        service.py           # AuthService (JWT, Firebase, Kakao)
        repository.py        # AuthRepository
      admin/
        model.py             # ConsultSchedule
        service.py           # AdminService
        repository.py        # AdminRepository
        matching_service.py  # MatchingService (scoring algorithm)
      match/
        model.py             # MatchWeek, MatchHistory, MatchFeedback
        service.py           # MatchService
        repository.py        # MatchRepository
      llm/
        matching_service.py  # LLM-enhanced matching
      shared/
        base_repository.py   # Generic BaseRepository

    dtos/                    # Pydantic DTOs
      admin.py               # Dashboard, member DTOs
      auth.py                # Login, signup, OAuth DTOs
      match.py               # Match week, history DTOs
      user.py                # User, profile DTOs
      llm_match.py           # LLM matching DTOs

    db/
      orm.py                 # Read/Write session management

    core/
      config.py              # Pydantic Settings configuration

    middleware/              # Middleware
      error_handler.py       # ErrorHandlerMiddleware
      admin_auth.py          # Admin authentication

    utils/                   # Utilities
      s3.py                  # S3 presigned URLs
      s3_private.py          # Private user data S3
      firebase.py            # Firebase verification
      password.py            # bcrypt hashing
      excel.py               # Excel export

    error/                   # Custom exceptions
      __init__.py            # AppException, NotFoundError, etc.
```

---

## Domains

- **user**: User management (User, UserProfile, UserLifestyle, UserPreference, etc.)
- **auth**: Authentication (JWT, Firebase, Kakao OAuth)
- **admin**: Admin dashboard, member management, consultations
- **match**: Match weeks, history, feedback
- **llm**: LLM-enhanced matching with Gemini
- **shared**: BaseRepository, common utilities

---

## Common Imports

```python
# Your domain
from backend.domain.user.model import User, UserProfile
from backend.domain.user.service import UserService
from backend.dtos.user import UserResponse, UserCreateRequest
from backend.error import NotFoundError, ForbiddenError, UnauthorizedError
```

---

## Service Example: UserService

```python
class UserService:
    def __init__(self, session: AsyncSession):
        self.session = session
        self._user_repo = UserRepository(session)
        self._profile_repo = UserProfileRepository(session)
        self._data_loader = UserDataLoader(session)

    async def get_user_detail(self, user_id: str) -> UserDetailResponse:
        user_with_relations = await self._data_loader.load_user_with_relations(
            user_id,
            load_profile=True,
            load_photos=True,
        )
        if not user_with_relations:
            raise NotFoundError(f"User {user_id} not found")
        return self._to_detail_response(user_with_relations)
```

---

## Repository Example: UserDataLoader (N+1 Prevention)

```python
@dataclass
class UserWithRelations:
    user: User
    profile: Optional[UserProfile] = None
    lifestyle: Optional[UserLifestyle] = None
    photos: List[UserPhoto] = field(default_factory=list)

class UserDataLoader:
    async def load_user_with_relations(
        self,
        user_id: str,
        load_profile: bool = False,
        load_photos: bool = False,
    ) -> Optional[UserWithRelations]:
        queries = [self._load_user(user_id)]
        if load_profile:
            queries.append(self._load_profile(user_id))
        if load_photos:
            queries.append(self._load_photos(user_id))
        results = await asyncio.gather(*queries)
        # ... combine results
```

---

## DTO Example: Admin

```python
from pydantic import BaseModel, Field, field_validator
from backend.domain.user.enums import GenderEnum, UserStatusEnum

class AdminBasicInfoUpdateRequest(BaseModel):
    """Request DTO for updating basic user info (admin only)."""
    name: Optional[str] = Field(None, description="User name")
    status: Optional[str] = Field(None, description="User status")
    is_admin: Optional[bool] = Field(None, description="Admin flag")
    birth_year: Optional[int] = Field(None, ge=1940, le=2010, description="Birth year")

    model_config = {"extra": "forbid"}

    @field_validator("status")
    @classmethod
    def validate_status(cls, v: Optional[str]) -> Optional[str]:
        if v is not None:
            valid_values = [e.value for e in UserStatusEnum]
            if v not in valid_values:
                raise ValueError(f"Invalid status: {v}. Valid: {valid_values}")
        return v
```

---

## Project-Specific Features

- Firebase/Kakao authentication patterns
- S3 presigned URL generation
- N+1 prevention with UserDataLoader
- Excel export utilities
- Admin dashboard with matching algorithm
