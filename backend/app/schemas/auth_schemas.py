from typing import Literal, Optional

from pydantic import BaseModel, Field, field_validator

from backend.app.schemas.user_schemas import UserRead
from backend.app.utils.phone_utils import is_valid_iran_mobile, normalize_phone_number


def _validate_phone(value: str) -> str:
    normalized = normalize_phone_number(value)
    if not is_valid_iran_mobile(normalized):
        raise ValueError("Phone number must be 11 digits starting with 09")
    return normalized


class OtpRequest(BaseModel):
    phone_number: str = Field(..., min_length=10, max_length=20)
    purpose: Literal["login", "register"] = "register"

    @field_validator("phone_number")
    @classmethod
    def validate_phone(cls, value: str) -> str:
        return _validate_phone(value)


class PhoneOtpRequest(BaseModel):
    phone_number: str = Field(..., min_length=10, max_length=20)

    @field_validator("phone_number")
    @classmethod
    def validate_phone(cls, value: str) -> str:
        return _validate_phone(value)


class OtpVerifyRequest(BaseModel):
    phone_number: str = Field(..., min_length=10, max_length=20)
    code: str = Field(..., min_length=5, max_length=5)

    @field_validator("phone_number")
    @classmethod
    def validate_phone(cls, value: str) -> str:
        return _validate_phone(value)


class RegisterRequest(BaseModel):
    phone_number: str = Field(..., min_length=10, max_length=20)
    code: str = Field(..., min_length=5, max_length=5)
    full_name: str = Field(..., min_length=2, max_length=120)
    password: str = Field(..., min_length=6, max_length=72)
    profile_picture: Optional[str] = None

    @field_validator("phone_number")
    @classmethod
    def validate_phone(cls, value: str) -> str:
        return _validate_phone(value)


class PasswordLoginRequest(BaseModel):
    phone_number: str = Field(..., min_length=10, max_length=20)
    password: str = Field(..., min_length=6, max_length=72)

    @field_validator("phone_number")
    @classmethod
    def validate_phone(cls, value: str) -> str:
        return _validate_phone(value)


class GoogleAuthRequest(BaseModel):
    id_token: str = Field(..., min_length=20)


class TokenResponse(BaseModel):
    token_type: str = "bearer"
    access_token: str
    expires_in: int
    user_id: int


class AuthResponse(TokenResponse):
    user: UserRead
    debug_code: Optional[str] = None


class OtpRequestResponse(BaseModel):
    message: str
    debug_code: Optional[str] = None
