import os

from google.auth.transport import requests
from google.oauth2 import id_token

from backend.app.config import GOOGLE_CLIENT_ID


class GoogleAuthError(Exception):
    pass


def verify_google_id_token(token: str) -> dict:
    if not GOOGLE_CLIENT_ID:
        raise GoogleAuthError("Google Sign-In is not configured on the server")

    try:
        payload = id_token.verify_oauth2_token(
            token,
            requests.Request(),
            GOOGLE_CLIENT_ID,
        )
    except ValueError as exc:
        raise GoogleAuthError("Invalid Google ID token") from exc

    if payload.get("iss") not in {
        "accounts.google.com",
        "https://accounts.google.com",
    }:
        raise GoogleAuthError("Invalid Google token issuer")

    google_id = payload.get("sub")
    email = payload.get("email")
    if not google_id or not email:
        raise GoogleAuthError("Google token is missing required user info")

    return {
        "google_id": google_id,
        "email": email,
        "full_name": payload.get("name") or email.split("@")[0],
        "profile_picture": payload.get("picture"),
    }
