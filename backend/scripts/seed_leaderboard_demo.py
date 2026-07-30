"""Seed varied leaderboard stats for members.

Usage (from repo root with venv + PYTHONPATH):
  python backend/scripts/seed_leaderboard_demo.py
"""
from backend.app.db.postgres import SessionLocal
from backend.app.models.role_model import Role, RoleEnum
from backend.app.models.user_model import User
from backend.app.services.profile_service import ensure_player_stats

DEMO_STATS = [
    {
        "total_points": 2450,
        "quizzes_created": 18,
        "quizzes_completed": 52,
        "polls_completed": 14,
        "votes_completed": 9,
    },
    {
        "total_points": 2210,
        "quizzes_created": 24,
        "quizzes_completed": 41,
        "polls_completed": 11,
        "votes_completed": 7,
    },
    {
        "total_points": 1980,
        "quizzes_created": 12,
        "quizzes_completed": 38,
        "polls_completed": 16,
        "votes_completed": 12,
    },
    {
        "total_points": 1760,
        "quizzes_created": 31,
        "quizzes_completed": 29,
        "polls_completed": 9,
        "votes_completed": 5,
    },
    {
        "total_points": 1540,
        "quizzes_created": 8,
        "quizzes_completed": 45,
        "polls_completed": 12,
        "votes_completed": 8,
    },
]


def main() -> None:
    db = SessionLocal()
    try:
        members = (
            db.query(User)
            .join(Role, User.role_id == Role.id)
            .filter(Role.role_name == RoleEnum.MEMBER.value)
            .order_by(User.id.asc())
            .all()
        )
        for index, user in enumerate(members):
            stats = ensure_player_stats(db, user.id)
            template = DEMO_STATS[index % len(DEMO_STATS)]
            for field, value in template.items():
                setattr(stats, field, value)
        db.commit()
        print(f"Updated leaderboard demo stats for {len(members)} member(s)")
    finally:
        db.close()


if __name__ == "__main__":
    main()
