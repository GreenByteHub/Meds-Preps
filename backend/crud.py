from sqlalchemy import select
from sqlalchemy.exc import IntegrityError

from backend.database import AsyncSession
from backend.models import User
from backend.schemas import UserCreate
from backend.utils import hash_password
from backend.exceptions import UserAlreadyExists, UserNotFound
from passlib.context import CryptContext


async def get_user_by_login(session: AsyncSession, login: str) -> User | None:
    result = await session.execute(select(User).where(User.login == login))
    return result.scalar_one_or_none()

async def create_user(
        db: AsyncSession,
        user_data: UserCreate,
        is_google: bool = False
) -> User:
    if is_google:
        hashed_password = None
    else:
        if not user_data.password:
            raise ValueError("Password is required for non-Google users")
        pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
        hashed_password = pwd_context.hash(user_data.password)

    existing_user = await get_user_by_login(db, user_data.login)
    if existing_user:
        raise UserAlreadyExists(f"User with login {user_data.login} already exists")

    new_user = User(
        login=user_data.login,
        hashed_password=hashed_password,
        is_google=is_google
    )

    db.add(new_user)
    await db.commit()
    await db.refresh(new_user)

    return new_user
async def update_refresh_token(session: AsyncSession, user_id: int, refresh_token_: str | None):
    result = await session.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()

    if not user:
        raise UserNotFound(f"User with id {user_id} not found")

    user.refresh_token = refresh_token_
    await session.commit()
    await session.refresh(user)
    return user
