from typing import Dict, Optional
from fastapi import HTTPException
from sqlalchemy.orm import Session
from backend.app.models.user_model import User
from backend.app.schemas.user_schemas import UserCreate, UserResponse
from backend.app.services.password_service import get_hash_password


from backend.app.utils.phone_utils import normalize_phone_number


def get_user_by_phone(db: Session, phone_number: str) -> Optional[User]:
    normalized = normalize_phone_number(phone_number)
    return (
        db.query(User)
        .filter(User.phone_number == normalized)
        .first()
    )


def get_user_by_email(db: Session, email: str) -> Optional[User]:
    return (
        db.query(User)
        .filter(User.email == email.strip().lower())
        .first()
    )


def get_user_by_google_id(db: Session, google_id: str) -> Optional[User]:
    return db.query(User).filter(User.google_id == google_id).first()


def create_user(db: Session, user: UserCreate):
    if user.email:
        db_user_email = db.query(User).filter(User.email == user.email).first()
    else:
        db_user_email = None
    if user.phone_number:
        db_user_phone = get_user_by_phone(db, user.phone_number)
    else:
        db_user_phone = None

    if db_user_email or db_user_phone:
        raise HTTPException(
            status_code=400,
            detail="User with this email or phone number already exists"
        )

    user_data = user.model_dump()
    user_data["password"] = get_hash_password(user.password)
    db_user = User(**user_data)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


def get_user(db: Session, identifier: str):
    if identifier.isdigit():
        db_user = db.query(User).filter(User.id == int(identifier)).first()
    else:
        db_user = db.query(User).filter(User.email == identifier).first()
        if not db_user:
            db_user = get_user_by_phone(db, identifier)
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user


def get_users(db: Session, skip: int = 0,
              limit: int = 100,
              user_type: str = "all"):
    filters = {
        "all": None,
        "soft_deleted": User.is_removed == True,
        "available": User.is_removed == False,
        "deactivated": User.is_active == False,
        "active": User.is_active == True
    }

    if user_type not in filters:
        raise HTTPException(status_code=400, detail="Invalid type")

    query = db.query(User)
    if filters[user_type] is not None:
        query = query.filter(filters[user_type])

    query = query.offset(skip).limit(limit)

    users = query.all()
    if not users:
        raise HTTPException(status_code=404, detail="No user found")

    return users


def delete_user(db: Session, identifier: str, delete_type: str):
    if identifier.isdigit():
        db_user = db.query(User).filter(User.id == int(identifier)).first()
    else:
        db_user = db.query(User).filter(User.email == identifier).first()
        if not db_user:
            db_user = db.query(User).filter(
                User.phone_number == identifier).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")

    if delete_type == "soft":
        db_user.is_removed = True
        db.commit()
        return {"message": "User soft deleted successfully"}
    elif delete_type == "hard":
        db.delete(db_user)
        db.commit()
        return {"message": "User hard deleted successfully"}
    else:
        raise HTTPException(status_code=400, detail="Invalid delete type. "
                                                    "User Soft or Hard")


def update_user(db: Session, identifier: str, data: Dict):
    if identifier.isdigit():
        db_user = db.query(User).filter(User.id == int(identifier)).first()
    else:
        db_user = db.query(User).filter(User.email == identifier).first()
        if not db_user:
            db_user = db.query(User).filter(
                User.phone_number == identifier).first()

    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")

    for key, value in data.items():
        if hasattr(db_user, key):
            setattr(db_user, key, value)

    db.commit()
    db.refresh(db_user)

    return {
        "message": "User updated successfully",
        "user": UserResponse.model_validate(db_user)
    }
