from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session, joinedload

from backend.app.core.security import manager
from backend.app.db.postgres import get_db
from backend.app.models.user_model import User
from backend.app.schemas.profile_schemas import PlayerProfileRead
from backend.app.services.profile_service import get_member_profile

router = APIRouter()


@router.get("/me", response_model=PlayerProfileRead)
def get_my_player_profile(
    db: Session = Depends(get_db),
    current_user: User = Depends(manager),
):
    user = (
        db.query(User)
        .options(joinedload(User.role))
        .filter(User.id == current_user.id)
        .first()
    )
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )

    try:
        return get_member_profile(db, user)
    except PermissionError as exc:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=str(exc),
        ) from exc
