from pydantic import BaseModel, model_validator, validator
from typing import Optional
from datetime import datetime


class UserBase(BaseModel):
    id: int
    is_removed: bool
    created_at: datetime
    full_name: Optional[str] = None
    email: Optional[str] = None
    phone_number: Optional[str] = None
    profile_picture: Optional[str] = None
    is_active: Optional[bool] = None
    role_id: int = None


class UserCreate(UserBase):
    password: str

    # you need to take care of validation
    # this validation is for schemes
    @model_validator(mode='before')
    def validate_email_or_phone(cls, values):
        email = values.get('email')
        phone_number = values.get('phone_number')
        if not email and not phone_number:
                raise ValueError("At least either email or phone number must "
                                 "be provided")
        return values


class UserRead(UserBase):
    id: int
    is_active: bool
    is_removed: bool
    role_id: Optional[int] = None

    class Config:
        from_attributes = True


class UserResponse(UserBase):
    updated_at: datetime

    class Config:
        from_attributes = True

