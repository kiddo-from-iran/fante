from calendar import monthrange
from datetime import datetime, timedelta
from typing import List, Optional

from sqlalchemy import func, or_
from sqlalchemy.orm import Session

from backend.app.models.dashboard_model import (
    DashboardAnnouncement,
    DashboardNotification,
    GameReview,
    SupportTicket,
    UserBadge,
)
from backend.app.models.player_profile_model import PlayerActivity
from backend.app.schemas.dashboard_schemas import (
    ActivityPointRead,
    AnnouncementRead,
    BadgeRead,
    NotificationRead,
    ReviewRead,
    TicketCreate,
    TicketRead,
)

_SEEDED_ACTIVITY: List[ActivityPointRead] = [
    ActivityPointRead(label="09", value=0.25),
    ActivityPointRead(label="10", value=0.40),
    ActivityPointRead(label="11", value=0.35),
    ActivityPointRead(label="12", value=0.55),
    ActivityPointRead(label="01", value=0.45),
    ActivityPointRead(label="02", value=0.60),
    ActivityPointRead(label="03", value=0.50),
    ActivityPointRead(label="04", value=0.70),
    ActivityPointRead(label="05", value=0.65),
    ActivityPointRead(label="06", value=0.80),
    ActivityPointRead(label="07", value=0.75),
    ActivityPointRead(label="08", value=0.90),
]


def seed_dashboard_data(db: Session) -> None:
    """Seed global dashboard rows when tables are empty (Persian sample data)."""
    created: List[str] = []

    if db.query(DashboardAnnouncement).count() == 0:
        samples = [
            DashboardAnnouncement(
                title="آپدیت جدید بازی‌ها",
                body=(
                    "امکان افزودن تصویر پس‌زمینه هنگام پخش بازی اضافه شد. "
                    "از داشبورد بازی‌ها می‌توانید آن را تنظیم کنید."
                ),
                published_at=datetime(2026, 5, 13),
                is_pinned=True,
            ),
            DashboardAnnouncement(
                title="مراقب اطلاعاتتان باشید",
                body=(
                    "هرگز رمز عبور یا کد تأیید را با دیگران به اشتراک نگذارید. "
                    "پشتیبانی فنت‌کوییز هرگز آن‌ها را نمی‌پرسد."
                ),
                published_at=datetime(2026, 5, 13),
                is_pinned=False,
            ),
            DashboardAnnouncement(
                title="پروفایل شما به‌روز شد",
                body="سطح‌بندی و نشان‌ها در پروفایل عمومی نمایش داده می‌شوند.",
                published_at=datetime(2026, 5, 10),
                is_pinned=False,
            ),
            DashboardAnnouncement(
                title="مسابقه هفتگی",
                body="با ساخت سه کوییز این هفته شانس برنده شدن نشان ویژه را دارید.",
                published_at=datetime(2026, 5, 5),
                is_pinned=False,
            ),
        ]
        db.add_all(samples)
        created.append("announcements")

    if db.query(GameReview).filter(GameReview.user_id.is_(None)).count() == 0:
        now = datetime.utcnow()
        samples = [
            GameReview(
                user_id=None,
                author_name="سارا م.",
                comment="کوییز خیلی جذاب و حرفه‌ای بود، ممنون!",
                stars=5,
                game_title="دنیای انیمه",
                created_at=now - timedelta(hours=5),
            ),
            GameReview(
                user_id=None,
                author_name="رضا ک.",
                comment="سوالات خوب بود ولی بعضی گزینه‌ها مبهم بودند.",
                stars=4,
                game_title="دنیای انیمه",
                created_at=now - timedelta(days=1),
            ),
            GameReview(
                user_id=None,
                author_name="نیما پ.",
                comment="نظرسنجی عالی برای تصمیم‌گیری گروهی.",
                stars=5,
                game_title="نظرسنجی فصل جدید",
                created_at=now - timedelta(days=2),
            ),
            GameReview(
                user_id=None,
                author_name="مینا ش.",
                comment="تست شخصیت سرگرم‌کننده بود.",
                stars=3,
                game_title="تست شخصیت ماجراجو",
                created_at=now - timedelta(days=4),
            ),
        ]
        db.add_all(samples)
        created.append("reviews")

    if (
        db.query(DashboardNotification)
        .filter(DashboardNotification.user_id.is_(None))
        .count()
        == 0
    ):
        now = datetime.utcnow()
        samples = [
            DashboardNotification(
                user_id=None,
                title="اعلان سیستم",
                body="نسخه جدید داشبورد در دسترس است.",
                created_at=now - timedelta(days=3),
                is_read=False,
                link_route="/dashboard/announcements",
            ),
        ]
        db.add_all(samples)
        created.append("broadcast_notifications")

    if created:
        db.commit()
        print(f"Seeded dashboard data: {', '.join(created)}")
    else:
        print("Dashboard seed data already present")


def _ensure_user_notifications(db: Session, user_id: int) -> None:
    personal = (
        db.query(DashboardNotification)
        .filter(DashboardNotification.user_id == user_id)
        .count()
    )
    if personal > 0:
        return

    now = datetime.utcnow()
    db.add_all(
        [
            DashboardNotification(
                user_id=user_id,
                title="پاسخ تیکت شما",
                body="پشتیبانی به تیکت «مشکل در انتشار کوییز» پاسخ داد.",
                created_at=now - timedelta(hours=2),
                is_read=False,
                link_route="/dashboard/tickets",
            ),
            DashboardNotification(
                user_id=user_id,
                title="بازی منتشر شد",
                body="کوییز «دنیای انیمه» با موفقیت منتشر شد.",
                created_at=now - timedelta(days=1),
                is_read=True,
                link_route="/dashboard/games",
            ),
            DashboardNotification(
                user_id=user_id,
                title="نظر جدید",
                body="یک کاربر به بازی شما ۵ ستاره داد.",
                created_at=now - timedelta(days=2),
                is_read=False,
                link_route="/dashboard/reviews",
            ),
        ]
    )
    db.commit()


def _ensure_user_badges(db: Session, user_id: int) -> None:
    if db.query(UserBadge).filter(UserBadge.user_id == user_id).count() > 0:
        return

    now = datetime.utcnow()
    db.add_all(
        [
            UserBadge(
                user_id=user_id,
                title="مخترع",
                description="اولین بازی خود را منتشر کردید",
                asset_key="silver",
                earned_at=now - timedelta(days=12),
            ),
            UserBadge(
                user_id=user_id,
                title="تست ساز",
                description="سه تست شخصیت ساختید",
                asset_key="bronze",
                earned_at=now - timedelta(days=8),
            ),
            UserBadge(
                user_id=user_id,
                title="نظرسنجی حرفه‌ای",
                description="پنج نظرسنجی فعال دارید",
                asset_key="bronze",
                earned_at=now - timedelta(days=3),
            ),
            UserBadge(
                user_id=user_id,
                title="کوییزمستر",
                description="ده کوییز منتشر کردید",
                asset_key="silver",
                earned_at=now - timedelta(days=1),
            ),
        ]
    )
    db.commit()


def _ensure_user_tickets(db: Session, user_id: int) -> None:
    if db.query(SupportTicket).filter(SupportTicket.user_id == user_id).count() > 0:
        return

    now = datetime.utcnow()
    db.add_all(
        [
            SupportTicket(
                user_id=user_id,
                subject="مشکل در انتشار کوییز",
                description="هنگام انتشار کوییز خطای ناشناخته می‌گیرم.",
                priority="medium",
                status="answered",
                created_at=now - timedelta(days=2),
                updated_at=now - timedelta(hours=2),
            ),
            SupportTicket(
                user_id=user_id,
                subject="درخواست قابلیت جدید",
                description="امکان فیلتر نتایج بر اساس تاریخ را اضافه کنید.",
                priority="high",
                status="in_review",
                created_at=now - timedelta(days=3),
                updated_at=now - timedelta(days=1),
            ),
            SupportTicket(
                user_id=user_id,
                subject="مشکل در نمایش نتایج",
                description="صفحه نتایج روی موبایل درست رندر نمی‌شود.",
                priority="low",
                status="open",
                created_at=now - timedelta(days=4),
                updated_at=now - timedelta(days=2),
            ),
        ]
    )
    db.commit()


def list_announcements(db: Session, *, limit: int = 50) -> List[AnnouncementRead]:
    rows = (
        db.query(DashboardAnnouncement)
        .order_by(
            DashboardAnnouncement.is_pinned.desc(),
            DashboardAnnouncement.published_at.desc(),
        )
        .limit(limit)
        .all()
    )
    return [AnnouncementRead.model_validate(row) for row in rows]


def list_notifications(
    db: Session, user_id: int, *, limit: int = 50
) -> List[NotificationRead]:
    rows = (
        db.query(DashboardNotification)
        .filter(
            or_(
                DashboardNotification.user_id == user_id,
                DashboardNotification.user_id.is_(None),
            )
        )
        .order_by(DashboardNotification.created_at.desc())
        .limit(limit)
        .all()
    )
    return [NotificationRead.model_validate(row) for row in rows]


def mark_notification_read(
    db: Session, user_id: int, notification_id: int
) -> Optional[NotificationRead]:
    row = (
        db.query(DashboardNotification)
        .filter(
            DashboardNotification.id == notification_id,
            or_(
                DashboardNotification.user_id == user_id,
                DashboardNotification.user_id.is_(None),
            ),
        )
        .first()
    )
    if not row:
        return None

    row.is_read = True
    db.commit()
    db.refresh(row)
    return NotificationRead.model_validate(row)


def mark_all_notifications_read(db: Session, user_id: int) -> int:
    updated = (
        db.query(DashboardNotification)
        .filter(
            DashboardNotification.user_id == user_id,
            DashboardNotification.is_read.is_(False),
        )
        .update({"is_read": True}, synchronize_session=False)
    )
    db.commit()
    return int(updated or 0)


def list_badges(db: Session, user_id: int, *, limit: int = 50) -> List[BadgeRead]:
    rows = (
        db.query(UserBadge)
        .filter(UserBadge.user_id == user_id)
        .order_by(UserBadge.earned_at.desc())
        .limit(limit)
        .all()
    )
    return [BadgeRead.model_validate(row) for row in rows]


def list_reviews(db: Session, *, limit: int = 50) -> List[ReviewRead]:
    rows = (
        db.query(GameReview)
        .order_by(GameReview.created_at.desc())
        .limit(limit)
        .all()
    )
    return [ReviewRead.model_validate(row) for row in rows]


def list_tickets(db: Session, user_id: int, *, limit: int = 50) -> List[TicketRead]:
    rows = (
        db.query(SupportTicket)
        .filter(SupportTicket.user_id == user_id)
        .order_by(SupportTicket.updated_at.desc())
        .limit(limit)
        .all()
    )
    return [TicketRead.model_validate(row) for row in rows]


def create_ticket(db: Session, user_id: int, payload: TicketCreate) -> TicketRead:
    now = datetime.utcnow()
    ticket = SupportTicket(
        user_id=user_id,
        subject=payload.subject.strip(),
        description=payload.description.strip(),
        priority=payload.priority,
        status="open",
        created_at=now,
        updated_at=now,
    )
    db.add(ticket)
    db.commit()
    db.refresh(ticket)
    return TicketRead.model_validate(ticket)


def _month_start(dt: datetime) -> datetime:
    return datetime(dt.year, dt.month, 1)


def _add_months(dt: datetime, months: int) -> datetime:
    year = dt.year + (dt.month - 1 + months) // 12
    month = (dt.month - 1 + months) % 12 + 1
    day = min(dt.day, monthrange(year, month)[1])
    return datetime(year, month, day, dt.hour, dt.minute, dt.second)


def get_activity_series(db: Session, user_id: int) -> List[ActivityPointRead]:
    now = datetime.utcnow()
    start = _month_start(_add_months(now, -11))

    month_expr = func.date_trunc("month", PlayerActivity.completed_at)
    points_expr = func.coalesce(func.sum(PlayerActivity.points_earned), 0)
    rows = (
        db.query(month_expr.label("month"), points_expr.label("points"))
        .filter(
            PlayerActivity.user_id == user_id,
            PlayerActivity.completed_at >= start,
        )
        .group_by(month_expr)
        .all()
    )

    buckets: dict[str, int] = {}
    labels: List[str] = []
    for i in range(11, -1, -1):
        d = _add_months(_month_start(now), -i)
        key = f"{d.year}-{d.month:02d}"
        labels.append(key)
        buckets[key] = 0

    if not rows:
        return list(_SEEDED_ACTIVITY)

    for month_dt, points in rows:
        if month_dt is None:
            continue
        key = f"{month_dt.year}-{month_dt.month:02d}"
        if key in buckets:
            buckets[key] = int(points or 0)

    max_val = max(buckets.values()) if buckets else 0
    denom = max_val if max_val > 0 else 1

    return [
        ActivityPointRead(
            label=key[5:],
            value=round(buckets.get(key, 0) / denom, 4),
        )
        for key in labels
    ]
