from backend.app.db.base import Base
from sqlalchemy import Integer, Column, String, Text, ForeignKey, Boolean, DateTime
from datetime import datetime
from sqlalchemy.orm import relationship, validates


class Comment(Base):
    __tablename__ = "comments"
    
    id = Column(Integer, primary_key=True, index=True)
    text = Column(Text, nullable=False)
    user_id = Column(Integer, ForeignKey('users.id'))
    game_id = Column(Integer, ForeignKey('games.id'))
    is_removed = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow)
    user = relationship("User")
    game = relationship("Game")
    