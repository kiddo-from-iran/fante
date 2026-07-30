# backend/app/schemas/role_schemas.py
from typing import Optional
from pydantic import BaseModel, Field, field_validator
from datetime import datetime

# Define allowed roles
ALLOWED_ROLES = ["admin", "moderator", "member"]

class RoleBase(BaseModel):
    role_name: str = Field(..., description="Role name must be one of: admin, moderator, member")
    description: Optional[str] = None
    
    @field_validator('role_name')
    @classmethod
    def validate_role_name(cls, v: str) -> str:
        if v not in ALLOWED_ROLES:
            raise ValueError(f'Role must be one of: {", ".join(ALLOWED_ROLES)}')
        return v.lower()  # Normalize to lowercase

class RoleCreate(RoleBase):
    pass

class RoleUpdate(BaseModel):
    role_name: Optional[str] = Field(None, description="Role name must be one of: admin, moderator, member")
    description: Optional[str] = None
    
    @field_validator('role_name')
    @classmethod
    def validate_role_name(cls, v: Optional[str]) -> Optional[str]:
        if v is not None and v not in ALLOWED_ROLES:
            raise ValueError(f'Role must be one of: {", ".join(ALLOWED_ROLES)}')
        return v.lower() if v else v

class RoleRead(RoleBase):
    id: int

    class Config:
        from_attributes = True  # Note: 'orm_mode' is now 'from_attributes' in Pydantic V2