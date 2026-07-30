import random
from datetime import datetime, timedelta
from typing import Dict, Optional

OTP_EXPIRY_MINUTES = 5
OTP_LENGTH = 5

# In-memory store — replace with Redis/DB for production multi-instance setups.
_otp_store: Dict[str, dict] = {}


from backend.app.utils.phone_utils import normalize_phone_number


def _normalize_phone(phone_number: str) -> str:
    return normalize_phone_number(phone_number)


def generate_otp(phone_number: str) -> str:
    """Generate and store a one-time code for the given phone number."""
    phone = _normalize_phone(phone_number)
    code = "".join(str(random.randint(0, 9)) for _ in range(OTP_LENGTH))
    _otp_store[phone] = {
        "code": code,
        "expires_at": datetime.utcnow() + timedelta(minutes=OTP_EXPIRY_MINUTES),
    }
    return code


def is_otp_valid(phone_number: str, code: str) -> bool:
    """Check OTP without consuming it."""
    phone = _normalize_phone(phone_number)
    entry = _otp_store.get(phone)
    if not entry:
        return False
    if datetime.utcnow() > entry["expires_at"]:
        _otp_store.pop(phone, None)
        return False
    return entry["code"] == code.strip()


def consume_otp(phone_number: str) -> None:
    """Remove a validated OTP so it cannot be reused."""
    phone = _normalize_phone(phone_number)
    _otp_store.pop(phone, None)


def verify_otp(phone_number: str, code: str) -> bool:
    """Validate and consume OTP in one step."""
    if not is_otp_valid(phone_number, code):
        return False
    consume_otp(phone_number)
    return True


def get_stored_code(phone_number: str) -> Optional[str]:
    """Return the active code — useful for tests and dev tooling."""
    phone = _normalize_phone(phone_number)
    entry = _otp_store.get(phone)
    if not entry or datetime.utcnow() > entry["expires_at"]:
        return None
    return entry["code"]


def send_otp_sms(phone_number: str, code: str) -> None:
    """Placeholder for a real SMS provider integration (Kavenegar, Twilio, etc.)."""
    print(f"[SMS placeholder] OTP for {phone_number}: {code}")
