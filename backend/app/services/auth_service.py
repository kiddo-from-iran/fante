from datetime import timedelta

from sqlalchemy.orm import Session

from backend.app.config import ACCESS_TOKEN_EXPIRES_MINUTES
from backend.app.core.security import manager
from backend.app.models.role_model import Role, RoleEnum
from backend.app.models.user_model import User
from backend.app.utils.phone_utils import normalize_phone_number
from backend.app.services.password_service import (
    generate_random_password_hash,
    get_hash_password,
    verify_password,
)
from backend.app.services.profile_service import ensure_player_stats
from backend.app.services.user_service import (
    get_user_by_email,
    get_user_by_google_id,
    get_user_by_phone,
)


def find_user_by_identifier(db: Session, identifier: str) -> User | None:
    if identifier.isdigit() and len(identifier) <= 8:
        user = db.query(User).filter(User.id == int(identifier)).first()
        if user:
            return user
    user = db.query(User).filter(User.email == identifier).first()
    if user:
        return user
    return get_user_by_phone(db, identifier)


def authenticate_user(db: Session, identifier: str, password: str):
    user = find_user_by_identifier(db, identifier)
    if not user:
        return None
    if not verify_password(plain_password=password, hashed_password=user.password):
        return None
    return user


def create_access_token_for_user(user: User) -> str:
    payload = {"sub": str(user.id)}
    return manager.create_access_token(
        data=payload,
        expires=timedelta(minutes=ACCESS_TOKEN_EXPIRES_MINUTES),
    )


def create_user_with_phone(
    db: Session,
    phone_number: str,
    full_name: str,
    password: str,
    profile_picture: str | None = None,
) -> User:
    existing = get_user_by_phone(db, phone_number)
    if existing:
        raise ValueError("User with this phone number already exists")

    member_role = (
        db.query(Role).filter(Role.role_name == RoleEnum.MEMBER.value).first()
    )
    hashed_password = get_hash_password(password)

    db_user = User(
        full_name=full_name,
        phone_number=normalize_phone_number(phone_number),
        password=hashed_password,
        profile_picture=profile_picture,
        role_id=member_role.id if member_role else None,
        is_active=True,
        is_removed=False,
    )
    db.add(db_user)
    db.flush()
    ensure_player_stats(db, db_user.id)
    db.commit()
    db.refresh(db_user)
    return db_user


def get_or_create_google_user(
    db: Session,
    *,
    google_id: str,
    email: str,
    full_name: str,
    profile_picture: str | None = None,
) -> User:
    normalized_email = email.strip().lower()
    picture = (profile_picture or "")[:255] or None

    user = get_user_by_google_id(db, google_id)
    if user:
        if picture and not user.profile_picture:
            user.profile_picture = picture
        if full_name and not user.full_name:
            user.full_name = full_name
        db.commit()
        db.refresh(user)
        return user

    user = get_user_by_email(db, normalized_email)
    if user:
        if user.google_id and user.google_id != google_id:
            raise ValueError("Email is already linked to another Google account")
        user.google_id = google_id
        if picture and not user.profile_picture:
            user.profile_picture = picture
        if full_name and not user.full_name:
            user.full_name = full_name
        db.commit()
        db.refresh(user)
        return user

    member_role = (
        db.query(Role).filter(Role.role_name == RoleEnum.MEMBER.value).first()
    )
    db_user = User(
        full_name=full_name,
        email=normalized_email,
        google_id=google_id,
        password=generate_random_password_hash(),
        profile_picture=picture,
        role_id=member_role.id if member_role else None,
        is_active=True,
        is_removed=False,
    )
    db.add(db_user)
    db.flush()
    ensure_player_stats(db, db_user.id)
    db.commit()
    db.refresh(db_user)
    return db_user


@manager.user_loader()
def load_user(user_id: str) -> User | None:
    from backend.app.db.postgres import SessionLocal

    db = SessionLocal()
    try:
        if not user_id.isdigit():
            return None
        return db.query(User).filter(User.id == int(user_id)).first()
    finally:
        db.close()
