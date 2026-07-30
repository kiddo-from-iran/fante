import os
from backend.app.db.base import Base
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.orm import Session
from backend.app.db.seeds import seed_player_levels, seed_roles

POSTGRES_USER = os.getenv("POSTGRES_USER", "postgres")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD", "0322262")
POSTGRES_DB = os.getenv("POSTGRES_DB", "FanteQuiz")
POSTGRES_HOST = os.getenv("POSTGRES_HOST", "localhost")
POSTGRES_PORT = os.getenv("POSTGRES_PORT", 5432)

DATABASE_URL = f"postgresql://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:{POSTGRES_PORT}/{POSTGRES_DB}"

engine = create_engine(DATABASE_URL)
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
    import backend.app.models.player_level_model  # noqa: F401
    import backend.app.models.player_profile_model  # noqa: F401
    import backend.app.models.user_model  # noqa: F401

    Base.metadata.create_all(bind=engine)

    db = SessionLocal()
    try:
        seed_roles(db)
        seed_player_levels(db)
    except ImportError:
        print("seed functions not found, skipping seeds")
    finally:
        db.close()