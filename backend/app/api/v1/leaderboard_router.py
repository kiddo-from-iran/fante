from typing import Literal

from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from backend.app.db.postgres import get_db
from backend.app.schemas.leaderboard_schemas import LeaderboardResponse
from backend.app.services.leaderboard_service import get_leaderboard

router = APIRouter()


@router.get("", response_model=LeaderboardResponse)
def read_leaderboard(
    sort_by: Literal[
        "total_points",
        "quizzes_created",
        "games_participated",
    ] = "total_points",
    limit: int = Query(default=5, ge=1, le=50),
    db: Session = Depends(get_db),
):
    return get_leaderboard(db, sort_by=sort_by, limit=limit)
