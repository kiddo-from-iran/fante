"""Backfill player_stats for existing members and optional demo activities.

Usage (from repo root with venv + PYTHONPATH):
  python backend/scripts/seed_demo_player_data.py
"""
from datetime import datetime, timedelta

from backend.app.db.postgres import SessionLocal
from backend.app.models.player_profile_model import PlayerActivity, PlayerStats
from backend.app.models.role_model import Role, RoleEnum
from backend.app.models.user_model import User
from backend.app.services.profile_service import ensure_player_stats


def main() -> None:
    db = SessionLocal()
    try:
        members = (
            db.query(User)
            .join(Role, User.role_id == Role.id)
            .filter(Role.role_name == RoleEnum.MEMBER.value)
            .all()
        )
        for user in members:
            stats = ensure_player_stats(db, user.id)
            if stats.total_points > 0:
                continue

            stats.total_points = 1540
            stats.quizzes_completed = 45
            stats.polls_completed = 12
            stats.votes_completed = 8

            if not user.player_activities:
                db.add_all(
                    [
                        PlayerActivity(
                            user_id=user.id,
                            title="دنیای انیمه",
                            activity_type="quiz",
                            points_earned=320,
                            stars=4,
                            completed_at=datetime.utcnow() - timedelta(days=1),
                        ),
                        PlayerActivity(
                            user_id=user.id,
                            title="نیروهای درون",
                            activity_type="poll",
                            points_earned=50,
                            completed_at=datetime.utcnow() - timedelta(days=3),
                        ),
                    ]
                )
        db.commit()
        print(f"Seeded demo player data for {len(members)} member(s)")
    finally:
        db.close()


if __name__ == "__main__":
    main()
