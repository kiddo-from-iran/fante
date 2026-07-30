from sqlalchemy import Column, Integer, String

from backend.app.db.base import Base


class PlayerLevel(Base):
    """XP thresholds per level (cumulative total XP required to reach each level)."""

    __tablename__ = "player_levels"

    level = Column(Integer, primary_key=True)
    xp_threshold = Column(Integer, nullable=False)
    title = Column(String(64), nullable=True)
