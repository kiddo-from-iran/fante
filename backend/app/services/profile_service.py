from sqlalchemy.orm import Session

from backend.app.models.player_level_model import PlayerLevel
from backend.app.models.player_profile_model import PlayerActivity, PlayerStats
from backend.app.models.role_model import Role, RoleEnum
from backend.app.models.user_model import User
from backend.app.schemas.profile_schemas import (
    PlayerActivityRead,
    PlayerLevelProgressRead,
    PlayerProfileRead,
    PlayerRankingRead,
    PlayerStatsRead,
)
from backend.app.schemas.user_schemas import UserRead


def ensure_player_stats(db: Session, user_id: int) -> PlayerStats:
    stats = db.query(PlayerStats).filter(PlayerStats.user_id == user_id).first()
    if stats:
        return stats
    stats = PlayerStats(user_id=user_id)
    db.add(stats)
    db.commit()
    db.refresh(stats)
    return stats


def _compute_level_progress(db: Session, total_points: int) -> PlayerLevelProgressRead:
    levels = (
        db.query(PlayerLevel)
        .order_by(PlayerLevel.level.asc())
        .all()
    )
    if not levels:
        return PlayerLevelProgressRead(
            level=1,
            xp_in_level=total_points,
            xp_for_next_level=1000,
            xp_progress=min(total_points / 1000, 1.0),
            xp_label=f"{total_points}/1000",
        )

    current = levels[0]
    nxt = levels[1] if len(levels) > 1 else None

    for index, level_row in enumerate(levels):
        if total_points >= level_row.xp_threshold:
            current = level_row
            nxt = levels[index + 1] if index + 1 < len(levels) else None
        else:
            break

    if nxt is None:
        xp_in_level = total_points - current.xp_threshold
        xp_for_next = max(xp_in_level, 1)
        return PlayerLevelProgressRead(
            level=current.level,
            level_title=current.title,
            xp_in_level=xp_in_level,
            xp_for_next_level=xp_for_next,
            xp_progress=1.0,
            xp_label=f"{xp_in_level}/{xp_for_next}",
        )

    xp_in_level = total_points - current.xp_threshold
    xp_for_next = nxt.xp_threshold - current.xp_threshold
    progress = xp_in_level / xp_for_next if xp_for_next > 0 else 0.0

    return PlayerLevelProgressRead(
        level=current.level,
        level_title=current.title,
        xp_in_level=xp_in_level,
        xp_for_next_level=xp_for_next,
        xp_progress=min(max(progress, 0.0), 1.0),
        xp_label=f"{xp_in_level}/{xp_for_next}",
    )


def _compute_ranking(db: Session, user_id: int, total_points: int) -> PlayerRankingRead:
    member_filter = (
        db.query(PlayerStats)
        .join(User, PlayerStats.user_id == User.id)
        .join(Role, User.role_id == Role.id)
        .filter(
            Role.role_name == RoleEnum.MEMBER.value,
            User.is_removed.is_(False),
            User.is_active.is_(True),
        )
    )

    total_players = member_filter.count()
    if total_players == 0:
        return PlayerRankingRead(rank=1, total_players=1)

    higher_count = (
        member_filter.filter(PlayerStats.total_points > total_points).count()
    )
    return PlayerRankingRead(rank=higher_count + 1, total_players=total_players)


def get_member_profile(db: Session, user: User) -> PlayerProfileRead:
    role_name = user.role.role_name if user.role else None
    if role_name != RoleEnum.MEMBER.value:
        raise PermissionError("Player profile is only available for members")

    stats_row = ensure_player_stats(db, user.id)
    level_progress = _compute_level_progress(db, stats_row.total_points)
    ranking = _compute_ranking(db, user.id, stats_row.total_points)

    activities = (
        db.query(PlayerActivity)
        .filter(PlayerActivity.user_id == user.id)
        .order_by(PlayerActivity.completed_at.desc())
        .limit(10)
        .all()
    )

    return PlayerProfileRead(
        user=UserRead.model_validate(user),
        stats=PlayerStatsRead(
            total_points=stats_row.total_points,
            quizzes_completed=stats_row.quizzes_completed,
            polls_completed=stats_row.polls_completed,
            votes_completed=stats_row.votes_completed,
            quizzes_created=stats_row.quizzes_created,
            level=level_progress,
        ),
        ranking=ranking,
        recent_activities=[
            PlayerActivityRead.model_validate(activity) for activity in activities
        ],
    )
