# backend/app/models/role_model.py
from enum import Enum
from sqlalchemy import Integer, Column, String, Text, CheckConstraint
from backend.app.db.base import Base

class RoleEnum(str, Enum):
    ADMIN = "admin"
    MODERATOR = "moderator"
    MEMBER = "member"
    
    @classmethod
    def get_all_roles(cls):
        return [role.value for role in cls]
    
    @classmethod
    def get_descriptions(cls):
        return {
            cls.ADMIN: "Administrator with full system access",
            cls.MODERATOR: "Moderator with content management privileges",
            cls.MEMBER: "Regular member with basic access"
        }

class Role(Base):
    __tablename__ = "roles"

    id = Column(Integer, primary_key=True, index=True)
    role_name = Column(String(50), nullable=False, unique=True, index=True)
    description = Column(Text, nullable=True)
    
    __table_args__ = (
        CheckConstraint(
            "role_name IN ('admin', 'moderator', 'member')",
            name="valid_role_names"
        ),
    )