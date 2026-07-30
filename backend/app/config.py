import os

from dotenv import load_dotenv

APP_TITLE = "FanteQuiz"
APP_DESCRIPTION = "Backend API for your FanteQuiz App"
APP_VERSION = "v0.1"

ACCESS_TOKEN_EXPIRES_MINUTES = 60
dotenv_path = "X:\\FanteQuiz\\backend\\app\\.env"

load_dotenv(dotenv_path)

GOOGLE_CLIENT_ID = os.getenv("GOOGLE_CLIENT_ID", "")
