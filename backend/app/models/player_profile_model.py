from datetime import datetime

from sqlalchemy import Column, DateTime, ForeignKey, Index, Integer, String
from sqlalchemy.orm import relationship

from backend.app.db.base import Base


class PlayerStats(Base):
    """Aggregated stats for a member (player) profile."""

    __tablename__ = "player_stats"
    __table_args__ = (
        Index("ix_player_stats_total_points", "total_points"),
        Index("ix_player_stats_quizzes_created", "quizzes_created"),
    )

    user_id = Column(Integer, ForeignKey("users.id"), primary_key=True)
    total_points = Column(Integer, nullable=False, default=0)
    quizzes_completed = Column(Integer, nullable=False, default=0)
    polls_completed = Column(Integer, nullable=False, default=0)
    votes_completed = Column(Integer, nullable=False, default=0)
    quizzes_created = Column(Integer, nullable=False, default=0)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    user = relationship("User", back_populates="player_stats")


class PlayerActivity(Base):
    """A completed quiz, poll, or vote by a player."""

    __tablename__ = "player_activities"
    __table_args__ = (
        Index("ix_player_activities_user_completed", "user_id", "completed_at"),
    )

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    game_id = Column(Integer, ForeignKey("games.id"), nullable=True)
    title = Column(String(255), nullable=False)
    activity_type = Column(String(20), nullable=False)  # quiz | poll | vote
    points_earned = Column(Integer, nullable=False, default=0)
    stars = Column(Integer, nullable=True)
    completed_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="player_activities")
