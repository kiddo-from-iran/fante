import os

from dotenv import load_dotenv
from fastapi_login import LoginManager

from backend.app.config import dotenv_path

load_dotenv(dotenv_path)
SECRET_KEY = os.getenv("SECRET_KEY", "dev-secret-key-change-me")

manager = LoginManager(
    secret=SECRET_KEY,
    token_url="/api/v1/auth/login",
    use_cookie=False,
)
manager.cookie_name = "auth"
