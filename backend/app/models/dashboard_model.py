from datetime import datetime

from sqlalchemy import (
    Boolean,
    CheckConstraint,
    Column,
    DateTime,
    ForeignKey,
    Index,
    Integer,
    String,
    Text,
)
from sqlalchemy.orm import relationship

from backend.app.db.base import Base


class DashboardAnnouncement(Base):
    __tablename__ = "dashboard_announcements"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255), nullable=False)
    body = Column(Text, nullable=False)
    published_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    is_pinned = Column(Boolean, default=False, nullable=False)


class DashboardNotification(Base):
    __tablename__ = "dashboard_notifications"
    __table_args__ = (
        Index("ix_dashboard_notifications_user_created", "user_id", "created_at"),
        Index("ix_dashboard_notifications_user_read", "user_id", "is_read"),
    )

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=True, index=True)
    title = Column(String(255), nullable=False)
    body = Column(Text, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False, index=True)
    is_read = Column(Boolean, default=False, nullable=False)
    link_route = Column(String(255), nullable=True)

    user = relationship("User")


class UserBadge(Base):
    """Earned badge stored inline (title/description/asset_key per row)."""

    __tablename__ = "user_badges"
    __table_args__ = (
        Index("ix_user_badges_user_earned", "user_id", "earned_at"),
    )

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    title = Column(String(255), nullable=False)
    description = Column(Text, nullable=False, default="")
    asset_key = Column(String(64), nullable=False, default="silver")
    earned_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    user = relationship("User")


class GameReview(Base):
    __tablename__ = "game_reviews"
    __table_args__ = (
        CheckConstraint("stars >= 1 AND stars <= 5", name="ck_game_reviews_stars"),
        Index("ix_game_reviews_created_at", "created_at"),
    )

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=True, index=True)
    author_name = Column(String(255), nullable=False)
    comment = Column(Text, nullable=False)
    stars = Column(Integer, nullable=False)
    game_title = Column(String(255), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    user = relationship("User")


class SupportTicket(Base):
    __tablename__ = "support_tickets"
    __table_args__ = (
        Index("ix_support_tickets_user_updated", "user_id", "updated_at"),
    )

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    subject = Column(String(255), nullable=False)
    description = Column(Text, nullable=False)
    priority = Column(String(32), nullable=False, default="medium")
    status = Column(String(32), nullable=False, default="open")
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(
        DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False
    )

    user = relationship("User")
