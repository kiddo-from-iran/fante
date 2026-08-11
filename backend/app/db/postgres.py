import os
from backend.app.db.base import Base
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.orm import Session
from backend.app.db.seeds import seed_player_levels, seed_roles
from backend.app.services.dashboard_service import seed_dashboard_data

POSTGRES_USER = os.getenv("POSTGRES_USER", "postgres")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD", "0322262")
POSTGRES_DB = os.getenv("POSTGRES_DB", "FanteQuiz")
POSTGRES_HOST = os.getenv("POSTGRES_HOST", "localhost")
POSTGRES_PORT = os.getenv("POSTGRES_PORT", 5432)

DATABASE_URL = f"postgresql://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:{POSTGRES_PORT}/{POSTGRES_DB}"

engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,
    pool_size=5,
    max_overflow=10,
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Remove the problematic import - it's not needed!
# from backend.app.db.seeds import seed_roles  # Move this to where it's used
# from backend.app.models.role_model import Role, RoleEnum  # Move to init_db function

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def init_db():
    # Register all models before create_all
    import backend.app.models.dashboard_model  # noqa: F401
    import backend.app.models.player_level_model  # noqa: F401
    import backend.app.models.player_profile_model  # noqa: F401
    import backend.app.models.user_model  # noqa: F401

    Base.metadata.create_all(bind=engine)

    # Ensure indexes exist on already-created tables (create_all skips alters).
    with engine.begin() as conn:
        for stmt in (
            "CREATE INDEX IF NOT EXISTS ix_dashboard_notifications_user_created "
            "ON dashboard_notifications (user_id, created_at)",
            "CREATE INDEX IF NOT EXISTS ix_dashboard_notifications_user_read "
            "ON dashboard_notifications (user_id, is_read)",
            "CREATE INDEX IF NOT EXISTS ix_user_badges_user_earned "
            "ON user_badges (user_id, earned_at)",
            "CREATE INDEX IF NOT EXISTS ix_game_reviews_created_at "
            "ON game_reviews (created_at)",
            "CREATE INDEX IF NOT EXISTS ix_support_tickets_user_updated "
            "ON support_tickets (user_id, updated_at)",
            "CREATE INDEX IF NOT EXISTS ix_player_stats_total_points "
            "ON player_stats (total_points)",
            "CREATE INDEX IF NOT EXISTS ix_player_stats_quizzes_created "
            "ON player_stats (quizzes_created)",
            "CREATE INDEX IF NOT EXISTS ix_player_activities_user_completed "
            "ON player_activities (user_id, completed_at)",
        ):
            try:
                conn.exec_driver_sql(stmt)
            except Exception as exc:
                print(f"Index ensure skipped: {exc}")

    db = SessionLocal()
    try:
        seed_roles(db)
        seed_player_levels(db)
        seed_dashboard_data(db)
    except ImportError:
        print("seed functions not found, skipping seeds")
    finally:
        db.close()