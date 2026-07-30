from datetime import datetime
from typing import List, Literal, Optional

from pydantic import BaseModel, Field

from backend.app.schemas.user_schemas import UserRead

ActivityType = Literal["quiz", "poll", "vote"]


class PlayerLevelProgressRead(BaseModel):
    level: int = 1
    level_title: Optional[str] = None
    xp_in_level: int = 0
    xp_for_next_level: int = 1000
    xp_progress: float = Field(ge=0.0, le=1.0, default=0.0)
    xp_label: str = "0/1000"


class PlayerStatsRead(BaseModel):
    total_points: int = 0
    quizzes_completed: int = 0
    polls_completed: int = 0
    votes_completed: int = 0
    quizzes_created: int = 0
    level: PlayerLevelProgressRead

    class Config:
        from_attributes = True


class PlayerRankingRead(BaseModel):
    rank: int
    total_players: int


class PlayerActivityRead(BaseModel):
    id: int
    title: str
    activity_type: ActivityType
    points_earned: int = 0
    stars: Optional[int] = None
    completed_at: datetime
    game_id: Optional[int] = None

    class Config:
        from_attributes = True


class PlayerProfileRead(BaseModel):
    user: UserRead
    stats: PlayerStatsRead
    ranking: PlayerRankingRead
    recent_activities: List[PlayerActivityRead]
