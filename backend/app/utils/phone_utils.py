import re

_IRAN_MOBILE_RE = re.compile(r"^09\d{9}$")


def normalize_phone_number(phone_number: str) -> str:
    """Normalize Iranian mobile numbers to 09xxxxxxxxx format."""
    phone = phone_number.strip().replace(" ", "").replace("-", "")
    if phone.startswith("+98"):
        phone = "0" + phone[3:]
    elif phone.startswith("98") and len(phone) == 12:
        phone = "0" + phone[2:]
    elif len(phone) == 10 and phone.startswith("9"):
        phone = "0" + phone
    return phone


def is_valid_iran_mobile(phone_number: str) -> bool:
    return bool(_IRAN_MOBILE_RE.match(normalize_phone_number(phone_number)))
