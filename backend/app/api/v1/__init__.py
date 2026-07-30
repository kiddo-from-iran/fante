# backend/app/api/v1/__init__.py
from backend.app.api.v1 import auth, user_router, role_router, game_router, question_router

__all__ = ["auth", "user_router", "role_router", "game_router", "question_router"]