from typing import Dict
from fastapi import APIRouter, Body, Depends, HTTPException, Query, Response, \
    Request
from sqlalchemy.orm import Session
from backend.app.schemas.user_schemas import UserCreate, UserRead
from backend.app.services.user_service import create_user, \
    delete_user, \
    get_user, get_users, update_user
from backend.app.db.postgres import get_db

router = APIRouter()


# Identifier could be either user {ID, Email, Phone Number}
# Messages are handled in the associated service def
@router.post("/", response_model=UserRead)
def create_user_endpoint(user: UserCreate, db: Session = Depends(get_db)):
    return create_user(db, user)


@router.get("/{identifier}", response_model=UserRead)
def read_user_endpoint(identifier: str, db: Session = Depends(get_db)):
    db_user = get_user(db, identifier)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user


@router.get("/list/", response_model=list[UserRead])
def read_users_endpoint(skip: int = 0,
                        user_type: str = "all",
                        limit: int = Query(100, le=1000),
                        db: Session = Depends(get_db)):
    users = get_users(db, skip=skip, limit=limit, user_type=user_type)
    return users


@router.delete("/delete/{identifier}", response_model=dict)
def delete_user_endpoint(identifier: str,
                         delete_type: str = Query(...,
                                                  description="Type of deletion: 'soft' or 'hard'"),
                         db: Session = Depends(get_db)):
    return delete_user(db, identifier, delete_type)


@router.put("/update/{identifier}", response_model=dict)
def update_user_endpoint(
        identifier: str,
        data: Dict = Body(..., description="Fields to update"),
        db: Session = Depends(get_db)
):
    return update_user(db, identifier, data)



