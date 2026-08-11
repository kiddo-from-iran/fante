from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend.app.api.v1 import (
    auth,
    user_router,
    role_router,
    game_router,
    question_router,
    profile_router,
    leaderboard_router,
    dashboard_router,
)
from backend.app.db.postgres import init_db
from dotenv import load_dotenv
from fastapi_standalone_docs import StandaloneDocs
from contextlib import asynccontextmanager
from backend.app.config import *
from backend.app.core.security import manager
from backend.app.services import auth_service  # noqa: F401 — registers user_loader

load_dotenv(dotenv_path=dotenv_path)



# Method A: Using lifespan (FastAPI >= 0.93.0)
@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: Run this code when the application starts
    print("Starting up FastAPI application...")
    print("Auth password backend: sha256 OTP placeholders + bcrypt for password login")
    init_db()
    print("Database initialization complete")
    yield
    print("Shutting down FastAPI application...")
    
    
app = FastAPI(
    title=APP_TITLE,
    description=APP_DESCRIPTION,
    version=APP_VERSION,
    lifespan=lifespan
)

StandaloneDocs(app=app) 

# CORS for Flutter web (Bearer auth; localhost any port)
app.add_middleware(
    CORSMiddleware,
    allow_origin_regex=r"https?://(localhost|127\.0\.0\.1)(:\d+)?",
    allow_methods=["*"],
    allow_headers=["*"],
    allow_credentials=True,
)

app.include_router(auth.router, prefix="/api/v1/auth", tags=["auth"])
app.include_router(user_router.router, prefix="/api/v1/user", tags=["user"])
app.include_router(role_router.router, prefix="/api/v1/role", tags=["roles"])
app.include_router(game_router.router, prefix="/api/v1", tags=["games"])
app.include_router(profile_router.router, prefix="/api/v1/profile", tags=["profile"])
app.include_router(
    leaderboard_router.router,
    prefix="/api/v1/leaderboard",
    tags=["leaderboard"],
)
app.include_router(
    dashboard_router.router,
    prefix="/api/v1/dashboard",
    tags=["dashboard"],
)
app.include_router(question_router.router, prefix="/api/v1", tags=["questions"])


@app.get("/")
async def root():
    return {
        "message": "FanteQuiz is taking breadth...",
        "status": "alive",
        "app": APP_TITLE,
        "version": APP_VERSION
    }
