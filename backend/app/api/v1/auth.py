from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session

from backend.app.config import ACCESS_TOKEN_EXPIRES_MINUTES
from backend.app.core.security import manager
from backend.app.db.postgres import get_db
from backend.app.schemas.auth_schemas import (
    AuthResponse,
    GoogleAuthRequest,
    OtpRequest,
    OtpRequestResponse,
    OtpVerifyRequest,
    PasswordLoginRequest,
    PhoneOtpRequest,
    RegisterRequest,
    TokenResponse,
)
from backend.app.schemas.user_schemas import UserRead
from backend.app.services.auth_service import (
    authenticate_user,
    create_access_token_for_user,
    create_user_with_phone,
    get_or_create_google_user,
)
from backend.app.services.google_auth_service import GoogleAuthError, verify_google_id_token
from backend.app.services.otp_service import (
    consume_otp,
    generate_otp,
    is_otp_valid,
    send_otp_sms,
)
from backend.app.services.user_service import get_user, get_user_by_phone

router = APIRouter()


def _build_auth_response(user, debug_code: str | None = None) -> AuthResponse:
    token = create_access_token_for_user(user)
    return AuthResponse(
        access_token=token,
        expires_in=int(ACCESS_TOKEN_EXPIRES_MINUTES * 60),
        user_id=user.id,
        user=UserRead.model_validate(user),
        debug_code=debug_code,
    )


@router.post("/otp/request/login", response_model=OtpRequestResponse)
def request_login_otp(body: PhoneOtpRequest, db: Session = Depends(get_db)):
    phone = body.phone_number
    user = get_user_by_phone(db, phone)
    if not user or user.is_removed:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="USER_NOT_FOUND",
        )
    code = generate_otp(phone)
    send_otp_sms(phone, code)
    return OtpRequestResponse(
        message="Verification code generated",
        debug_code=code,
    )


@router.post("/otp/request/register", response_model=OtpRequestResponse)
def request_register_otp(body: PhoneOtpRequest, db: Session = Depends(get_db)):
    phone = body.phone_number
    if get_user_by_phone(db, phone):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User with this phone number already exists",
        )
    code = generate_otp(phone)
    send_otp_sms(phone, code)
    return OtpRequestResponse(
        message="Verification code generated",
        debug_code=code,
    )


@router.post("/otp/request", response_model=OtpRequestResponse)
def request_otp(body: OtpRequest, db: Session = Depends(get_db)):
    phone = body.phone_number
    if body.purpose == "login":
        user = get_user_by_phone(db, phone)
        if not user or user.is_removed:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="USER_NOT_FOUND",
            )
    elif get_user_by_phone(db, phone):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User with this phone number already exists",
        )

    code = generate_otp(phone)
    send_otp_sms(phone, code)
    return OtpRequestResponse(
        message="Verification code generated",
        debug_code=code,
    )


@router.post("/otp/validate")
def validate_otp(body: OtpVerifyRequest):
    """Check OTP without consuming it — used before the set-password step."""
    if not is_otp_valid(body.phone_number, body.code):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid or expired verification code",
        )
    return {"message": "Verification code is valid"}


@router.post("/otp/verify", response_model=AuthResponse)
def verify_otp_login(body: OtpVerifyRequest, db: Session = Depends(get_db)):
    if not is_otp_valid(body.phone_number, body.code):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid or expired verification code",
        )

    user = get_user_by_phone(db, body.phone_number)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="USER_NOT_FOUND",
        )

    consume_otp(body.phone_number)
    return _build_auth_response(user)


@router.post("/register", response_model=AuthResponse)
def register_with_otp(body: RegisterRequest, db: Session = Depends(get_db)):
    if not is_otp_valid(body.phone_number, body.code):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid or expired verification code",
        )

    if get_user_by_phone(db, body.phone_number):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User with this phone number already exists",
        )

    try:
        user = create_user_with_phone(
            db,
            phone_number=body.phone_number,
            full_name=body.full_name,
            password=body.password,
            profile_picture=body.profile_picture,
        )
    except ValueError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(exc),
        ) from exc

    consume_otp(body.phone_number)
    return _build_auth_response(user)


@router.post("/login/password", response_model=AuthResponse)
def login_with_password(body: PasswordLoginRequest, db: Session = Depends(get_db)):
    user = authenticate_user(
        db,
        identifier=body.phone_number,
        password=body.password,
    )
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect phone number or password",
        )
    return _build_auth_response(user)


@router.post("/google", response_model=AuthResponse)
def google_auth(body: GoogleAuthRequest, db: Session = Depends(get_db)):
    try:
        google_user = verify_google_id_token(body.id_token)
    except GoogleAuthError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(exc),
        ) from exc

    try:
        user = get_or_create_google_user(
            db,
            google_id=google_user["google_id"],
            email=google_user["email"],
            full_name=google_user["full_name"],
            profile_picture=google_user.get("profile_picture"),
        )
    except ValueError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(exc),
        ) from exc

    return _build_auth_response(user)


@router.post("/login", response_model=TokenResponse)
def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db),
):
    user = authenticate_user(
        db,
        identifier=form_data.username,
        password=form_data.password,
    )
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
        )

    token = create_access_token_for_user(user)
    return TokenResponse(
        access_token=token,
        expires_in=int(ACCESS_TOKEN_EXPIRES_MINUTES * 60),
        user_id=user.id,
    )


@router.get("/me", response_model=UserRead)
def get_current_user_profile(
    db: Session = Depends(get_db),
    user=Depends(manager),
):
    return get_user(db, str(user.id))
