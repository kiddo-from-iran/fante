# backend/app/services/role_service.py
from typing import Dict, Optional
from fastapi import HTTPException
from sqlalchemy.orm import Session
from backend.app.models.role_model import Role, RoleEnum
from backend.app.schemas.role_schemas import RoleCreate, ALLOWED_ROLES


def create_role(db: Session, role: RoleCreate):
    # Validate role name is allowed
    if role.role_name not in ALLOWED_ROLES:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid role name. Must be one of: {', '.join(ALLOWED_ROLES)}"
        )
    
    # Check if role already exists
    db_role_name = db.query(Role).filter(Role.role_name == role.role_name).first()
    if db_role_name:
        raise HTTPException(
            status_code=400,
            detail=f"Role with name '{role.role_name}' already exists"
        )

    # Create role with optional default description
    db_role = Role(
        role_name=role.role_name,
        description=role.description or RoleEnum.get_descriptions().get(role.role_name)
    )
    
    db.add(db_role)
    db.commit()
    db.refresh(db_role)
    return db_role


def get_role(db: Session, role_id: int):
    return db.query(Role).filter(Role.id == role_id).first()


def get_roles(db: Session, skip: int = 0, limit: int = 100):
    return db.query(Role).offset(skip).limit(limit).all()


def update_role(db: Session, role_id: int, data: Dict):
    db_role = db.query(Role).filter(Role.id == role_id).first()
    if not db_role:
        raise HTTPException(status_code=404, detail="Role not found")
    
    # Prevent updating to invalid role name
    if 'role_name' in data:
        new_role_name = data['role_name']
        if new_role_name not in ALLOWED_ROLES:
            raise HTTPException(
                status_code=400,
                detail=f"Cannot update to invalid role name. Must be one of: {', '.join(ALLOWED_ROLES)}"
            )
    
    # Prevent updating system roles if needed (optional)
    # Uncomment if you want to prevent updating core roles
    # if db_role.role_name in ['admin', 'moderator'] and 'role_name' in data:
    #     raise HTTPException(
    #         status_code=403,
    #         detail=f"Cannot rename system role '{db_role.role_name}'"
    #     )

    for key, value in data.items():
        if hasattr(db_role, key):
            setattr(db_role, key, value)
            print(db_role, key, value)

    db.commit()
    db.refresh(db_role)
    return {
        "message": "Role updated successfully",
        "role": db_role
    }


def delete_role(db: Session, role_id: int):
    db_role = db.query(Role).filter(Role.id == int(role_id)).first()
    if not db_role:
        raise HTTPException(status_code=404, detail="Role not found")
    
    # Prevent deleting critical system roles
    if db_role.role_name in ['admin', 'moderator']:
        raise HTTPException(
            status_code=403,
            detail=f"Cannot delete system role '{db_role.role_name}'"
        )
    
    # Optional: Check if any users are assigned to this role before deletion
    # if db_role.users:
    #     raise HTTPException(
    #         status_code=400,
    #         detail=f"Cannot delete role '{db_role.role_name}' because it has assigned users"
    #     )

    db.delete(db_role)
    db.commit()
    return {"message": "Role deleted successfully"}


def initialize_default_roles(db: Session):
    """Initialize default roles if they don't exist"""
    created_roles = []
    for role_enum in RoleEnum:
        existing_role = db.query(Role).filter(Role.role_name == role_enum.value).first()
        if not existing_role:
            role = Role(
                role_name=role_enum.value,
                description=RoleEnum.get_descriptions()[role_enum]
            )
            db.add(role)
            created_roles.append(role_enum.value)
    if created_roles:
        db.commit()
        print(f"Created default roles: {', '.join(created_roles)}")
    return created_roles