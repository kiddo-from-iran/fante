from sqlalchemy.orm import Session
from backend.app.models.role_model import Role


def seed_roles(db: Session) -> None:
    """Initialize default roles if they don't exist"""
    # Import here to avoid circular imports
    from backend.app.models.role_model import Role, RoleEnum
    
    default_descriptions = {
        RoleEnum.ADMIN: "Administrator with full system access",
        RoleEnum.MODERATOR: "Moderator with content management privileges",
        RoleEnum.MEMBER: "Regular member with basic access"
    }
    
    created_roles = []
    for role_enum in RoleEnum:
        role_name = role_enum.value
        existing_role = db.query(Role).filter(Role.role_name == role_name).first()
        
        if not existing_role:
            role = Role(
                role_name=role_name,
                description=default_descriptions[role_enum]
            )
            db.add(role)
            created_roles.append(role_name)
    
    if created_roles:
        db.commit()
        print(f"Created default roles: {', '.join(created_roles)}")
    else:
        print("All default roles already exist")


def seed_player_levels(db: Session) -> None:
    from backend.app.models.player_level_model import PlayerLevel

    defaults = [
        (1, 0, "تازه‌وارد"),
        (2, 1000, "کاوشگر"),
        (3, 2500, "بااستعداد"),
        (4, 4500, "حرفه‌ای"),
        (5, 7000, "استاد"),
        (6, 10000, "افسانه"),
        (7, 13500, "قهرمان"),
        (8, 17500, "اسطوره"),
        (9, 22000, "نابغه"),
        (10, 27000, "افسانه زنده"),
    ]

    created = []
    for level, xp_threshold, title in defaults:
        existing = (
            db.query(PlayerLevel).filter(PlayerLevel.level == level).first()
        )
        if not existing:
            db.add(
                PlayerLevel(
                    level=level,
                    xp_threshold=xp_threshold,
                    title=title,
                )
            )
            created.append(str(level))

    if created:
        db.commit()
        print(f"Created player levels: {', '.join(created)}")
    else:
        print("All player levels already exist")
