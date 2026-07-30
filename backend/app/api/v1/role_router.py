# backend/app/api/endpoints/role.py
from typing import Dict, List
from fastapi import APIRouter, Body, Depends, HTTPException, status
from sqlalchemy.orm import Session
from backend.app.schemas.role_schemas import RoleCreate, RoleRead, RoleUpdate
from backend.app.services.role_service import (
    create_role, delete_role, get_role, get_roles, update_role, initialize_default_roles
)
from backend.app.db.postgres import get_db

router = APIRouter(tags=["roles"])


@router.post(
    "/", 
    response_model=RoleRead,
    status_code=status.HTTP_201_CREATED,
    responses={
        400: {"description": "Invalid role name or role already exists"},
        422: {"description": "Validation error"}
    }
)
def create_role_endpoint(role: RoleCreate, db: Session = Depends(get_db)):
    return create_role(db, role)


@router.get("/{role_id}", response_model=RoleRead)
def read_role_endpoint(role_id: int, db: Session = Depends(get_db)):
    db_role = get_role(db, role_id)
    if db_role is None:
        raise HTTPException(status_code=404, detail="Role not found")
    return db_role


@router.get("/", response_model=List[RoleRead])
def read_roles_endpoint(
    skip: int = 0, 
    limit: int = 100, 
    db: Session = Depends(get_db)
):
    roles = get_roles(db, skip=skip, limit=limit)
    return roles


@router.put("/update/{role_id}", response_model=dict)
def update_role_endpoint(
    role_id: int,
    data: Dict = Body(..., description="Fields to update"),
    db: Session = Depends(get_db)
):
    return update_role(db, role_id, data)


@router.delete("/delete/{role_id}", response_model=dict)
def delete_role_endpoint(role_id: int, db: Session = Depends(get_db)):
    return delete_role(db, role_id)


@router.post("/initialize", response_model=dict)
def initialize_roles_endpoint(db: Session = Depends(get_db)):
    """Initialize default roles (admin, moderator, member)"""
    created = initialize_default_roles(db)
    return {
        "message": f"Initialized roles",
        "created_roles": created
    }