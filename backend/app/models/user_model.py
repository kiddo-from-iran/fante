from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship, validates
from datetime import datetime
from backend.app.db.base import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    full_name = Column(String, nullable=True)
    email = Column(String(100), unique=True, index=True, nullable=True)
    phone_number = Column(String(20), unique=True, index=True, nullable=True)
    google_id = Column(String(128), unique=True, index=True, nullable=True)
    password = Column(String(255), nullable=False)
    profile_picture = Column(String(255), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow)
    role_id = Column(Integer, ForeignKey('roles.id'))
    is_active = Column(Boolean, default=True)
    is_removed = Column(Boolean, default=False)
    role = relationship("Role")
    player_stats = relationship(
        "PlayerStats",
        back_populates="user",
        uselist=False,
        cascade="all, delete-orphan",
    )
    player_activities = relationship(
        "PlayerActivity",
        back_populates="user",
        cascade="all, delete-orphan",
    )

    @validates('email', 'phone_number')
    def validate_email_or_phone(self, key, value):
        if key == 'email':
            if value is None and self.phone_number is None:
                raise ValueError(
                    'At least either email or phone number must be provided'
                )
        elif key == 'phone_number':
            if value is None and self.email is None:
                raise ValueError(
                    'At least either email or phone number must be provided'
                )
        return value
