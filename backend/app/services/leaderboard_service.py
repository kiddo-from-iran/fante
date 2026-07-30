from sqlalchemy import desc
from sqlalchemy.orm import Session

from backend.app.models.player_profile_model import PlayerStats
from backend.app.models.role_model import Role, RoleEnum
from backend.app.models.user_model import User
from backend.app.schemas.leaderboard_schemas import (
    LeaderboardEntryRead,
    LeaderboardResponse,
    LeaderboardSortBy,
)


def _games_participated_expr():
    return (
        PlayerStats.quizzes_completed
        + PlayerStats.polls_completed
        + PlayerStats.votes_completed
    )


def _metric_for_sort(stats: PlayerStats, sort_by: LeaderboardSortBy) -> int:
    if sort_by == "total_points":
        return stats.total_points
    if sort_by == "quizzes_created":
        return stats.quizzes_created
    return (
        stats.quizzes_completed
        + stats.polls_completed
        + stats.votes_completed
    )


def get_leaderboard(
    db: Session,
    *,
    sort_by: LeaderboardSortBy = "total_points",
    limit: int = 5,
) -> LeaderboardResponse:
    base_query = (
        db.query(User, PlayerStats)
        .join(PlayerStats, PlayerStats.user_id == User.id)
        .join(Role, User.role_id == Role.id)
        .filter(
            Role.role_name == RoleEnum.MEMBER.value,
            User.is_removed.is_(False),
            User.is_active.is_(True),
        )
    )

    if sort_by == "total_points":
        base_query = base_query.order_by(
            desc(PlayerStats.total_points),
            User.id.asc(),
        )
    elif sort_by == "quizzes_created":
        base_query = base_query.order_by(
            desc(PlayerStats.quizzes_created),
            User.id.asc(),
        )
    else:
        participation = _games_participated_expr()
        base_query = base_query.order_by(
            desc(participation),
            User.id.asc(),
        )

    rows = base_query.limit(limit).all()

    entries = [
        LeaderboardEntryRead(
            rank=index + 1,
            user_id=user.id,
            full_name=user.full_name,
            profile_picture=user.profile_picture,
            score=_metric_for_sort(stats, sort_by),
        )
        for index, (user, stats) in enumerate(rows)
    ]

    return LeaderboardResponse(sort_by=sort_by, entries=entries)
