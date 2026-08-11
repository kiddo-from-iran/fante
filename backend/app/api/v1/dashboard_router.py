from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from backend.app.core.security import manager
from backend.app.db.postgres import get_db
from backend.app.models.user_model import User
from backend.app.schemas.dashboard_schemas import (
    ActivityPointRead,
    AnnouncementRead,
    BadgeRead,
    NotificationRead,
    ReviewRead,
    TicketCreate,
    TicketRead,
)
from backend.app.services import dashboard_service as svc

router = APIRouter()


@router.get("/announcements", response_model=list[AnnouncementRead])
def get_announcements(db: Session = Depends(get_db)):
    return svc.list_announcements(db)


@router.get("/notifications", response_model=list[NotificationRead])
def get_notifications(
    db: Session = Depends(get_db),
    current_user: User = Depends(manager),
):
    return svc.list_notifications(db, current_user.id)


@router.post("/notifications/read-all")
def read_all_notifications(
    db: Session = Depends(get_db),
    current_user: User = Depends(manager),
):
    updated = svc.mark_all_notifications_read(db, current_user.id)
    return {"updated": updated}


@router.post("/notifications/{notification_id}/read", response_model=NotificationRead)
def read_notification(
    notification_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(manager),
):
    result = svc.mark_notification_read(db, current_user.id, notification_id)
    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Notification not found",
        )
    return result


@router.get("/badges", response_model=list[BadgeRead])
def get_badges(
    db: Session = Depends(get_db),
    current_user: User = Depends(manager),
):
    return svc.list_badges(db, current_user.id)


@router.get("/reviews", response_model=list[ReviewRead])
def get_reviews(db: Session = Depends(get_db)):
    return svc.list_reviews(db)


@router.get("/activity-series", response_model=list[ActivityPointRead])
def get_activity_series(
    db: Session = Depends(get_db),
    current_user: User = Depends(manager),
):
    return svc.get_activity_series(db, current_user.id)


@router.get("/tickets", response_model=list[TicketRead])
def get_tickets(
    db: Session = Depends(get_db),
    current_user: User = Depends(manager),
):
    return svc.list_tickets(db, current_user.id)


@router.post(
    "/tickets",
    response_model=TicketRead,
    status_code=status.HTTP_201_CREATED,
)
def post_ticket(
    payload: TicketCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(manager),
):
    return svc.create_ticket(db, current_user.id, payload)
