from datetime import datetime
from typing import List, Literal, Optional

from pydantic import BaseModel, Field

TicketPriority = Literal["low", "medium", "high"]
TicketStatus = Literal["open", "in_review", "answered", "closed"]


class AnnouncementRead(BaseModel):
    id: int
    title: str
    body: str
    published_at: datetime
    is_pinned: bool = False

    class Config:
        from_attributes = True


class NotificationRead(BaseModel):
    id: int
    title: str
    body: str
    created_at: datetime
    is_read: bool = False
    link_route: Optional[str] = None

    class Config:
        from_attributes = True


class BadgeRead(BaseModel):
    id: int
    title: str
    description: str
    asset_key: str
    earned_at: datetime

    class Config:
        from_attributes = True


class ReviewRead(BaseModel):
    id: int
    author_name: str
    comment: str
    stars: int = Field(ge=1, le=5)
    created_at: datetime
    game_title: str

    class Config:
        from_attributes = True


class ActivityPointRead(BaseModel):
    label: str
    value: float = Field(ge=0.0, le=1.0)


class TicketRead(BaseModel):
    id: int
    subject: str
    description: str
    priority: TicketPriority
    status: TicketStatus
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class TicketCreate(BaseModel):
    subject: str = Field(min_length=1, max_length=255)
    description: str = Field(min_length=1)
    priority: TicketPriority = "medium"
