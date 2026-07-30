"""player profile tables and levels

Revision ID: c8f1a2b3d4e5
Revises: b7c4e9a1d2f3
Create Date: 2026-06-23
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


revision: str = "c8f1a2b3d4e5"
down_revision: Union[str, Sequence[str], None] = "b7c4e9a1d2f3"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "player_levels",
        sa.Column("level", sa.Integer(), nullable=False),
        sa.Column("xp_threshold", sa.Integer(), nullable=False),
        sa.Column("title", sa.String(length=64), nullable=True),
        sa.PrimaryKeyConstraint("level"),
    )
    op.create_table(
        "player_stats",
        sa.Column("user_id", sa.Integer(), nullable=False),
        sa.Column("total_points", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("quizzes_completed", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("polls_completed", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("votes_completed", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("updated_at", sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"]),
        sa.PrimaryKeyConstraint("user_id"),
    )
    op.create_table(
        "player_activities",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("user_id", sa.Integer(), nullable=False),
        sa.Column("game_id", sa.Integer(), nullable=True),
        sa.Column("title", sa.String(length=255), nullable=False),
        sa.Column("activity_type", sa.String(length=20), nullable=False),
        sa.Column("points_earned", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("stars", sa.Integer(), nullable=True),
        sa.Column("completed_at", sa.DateTime(), nullable=False),
        sa.ForeignKeyConstraint(["game_id"], ["games.id"]),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_player_activities_id"),
        "player_activities",
        ["id"],
        unique=False,
    )
    op.create_index(
        op.f("ix_player_activities_user_id"),
        "player_activities",
        ["user_id"],
        unique=False,
    )


def downgrade() -> None:
    op.drop_index(op.f("ix_player_activities_user_id"), table_name="player_activities")
    op.drop_index(op.f("ix_player_activities_id"), table_name="player_activities")
    op.drop_table("player_activities")
    op.drop_table("player_stats")
    op.drop_table("player_levels")
