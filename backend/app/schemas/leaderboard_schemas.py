from typing import List, Literal

from pydantic import BaseModel, Field

LeaderboardSortBy = Literal[
    "total_points",
    "quizzes_created",
    "games_participated",
]


class LeaderboardEntryRead(BaseModel):
    rank: int
    user_id: int
    full_name: str | None = None
    profile_picture: str | None = None
    score: int


class LeaderboardResponse(BaseModel):
    sort_by: LeaderboardSortBy
    entries: List[LeaderboardEntryRead] = Field(default_factory=list)
