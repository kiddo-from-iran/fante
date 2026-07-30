import hashlib
import secrets

import bcrypt


def get_hash_password(plain_password: str) -> str:
    pwd_bytes = plain_password.encode("utf-8")
    if len(pwd_bytes) > 72:
        pwd_bytes = pwd_bytes[:72]
    return bcrypt.hashpw(pwd_bytes, bcrypt.gensalt()).decode("utf-8")


def verify_password(plain_password: str, hashed_password: str) -> bool:
    # OTP-only placeholder passwords use the sha256: prefix.
    if hashed_password.startswith("sha256:"):
        digest = hashlib.sha256(plain_password.encode("utf-8")).hexdigest()
        return hashed_password == f"sha256:{digest}"

    try:
        return bcrypt.checkpw(
            plain_password.encode("utf-8"),
            hashed_password.encode("utf-8"),
        )
    except (ValueError, TypeError):
        return False


def generate_random_password_hash() -> str:
    """Placeholder password for OTP-only accounts (not used for password login)."""
    digest = hashlib.sha256(secrets.token_bytes(32)).hexdigest()
    return f"sha256:{digest}"
