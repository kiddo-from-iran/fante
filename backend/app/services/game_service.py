# backend/app/services/game_service.py
from fastapi import HTTPException, status
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import desc, func
from typing import List, Optional, Dict, Any
from datetime import datetime

from backend.app.models.question_model import QuestionType, TwoChoiceQuestion, \
    ThreeChoiceQuestion, FourChoiceQuestion, RangeQuestion
from backend.app.models.game_model import Game
from backend.app.schemas.game_schemas import GameCreate, GameUpdate


def create_game(db: Session, game_data: GameCreate):
    """Create a new game with its questions"""
    # Check if game with same title exists (optional)
    existing_game = db.query(Game).filter(Game.title == game_data.title).first()
    if existing_game:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Game with title '{game_data.title}' already exists"
        )
    
    # Create game
    db_game = Game(
        title=game_data.title,
        description=game_data.description,
        picture=game_data.picture,
        game_type=game_data.game_type.value,
        created_at=datetime.utcnow(),
        updated_at=datetime.utcnow()
    )
    db.add(db_game)
    db.flush()  # Get game ID without committing

    # Create questions
    for order, question_data in enumerate(game_data.questions, start=1):
        if question_data.question_type == QuestionType.TWO_CHOICE:
            db_question = TwoChoiceQuestion(
                order=order,
                text=question_data.text,
                picture=question_data.picture,
                contains_image=question_data.contains_image,
                option1=question_data.option1,
                option2=question_data.option2,
                game_id=db_game.id
            )
        elif question_data.question_type == QuestionType.THREE_CHOICE:
            db_question = ThreeChoiceQuestion(
                order=order,
                text=question_data.text,
                picture=question_data.picture,
                contains_image=question_data.contains_image,
                option1=question_data.option1,
                option2=question_data.option2,
                option3=question_data.option3,
                game_id=db_game.id
            )
        elif question_data.question_type == QuestionType.FOUR_CHOICE:
            db_question = FourChoiceQuestion(
                order=order,
                text=question_data.text,
                picture=question_data.picture,
                contains_image=question_data.contains_image,
                option1=question_data.option1,
                option2=question_data.option2,
                option3=question_data.option3,
                option4=question_data.option4,
                game_id=db_game.id
            )
        elif question_data.question_type == QuestionType.RANGE:
            db_question = RangeQuestion(
                order=order,
                text=question_data.text,
                picture=question_data.picture,
                contains_image=question_data.contains_image,
                option_numbers=question_data.option_numbers,
                game_id=db_game.id
            )
        else:
            db.rollback()
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST, 
                detail=f"Question type '{question_data.question_type}' is not valid"
            )

        db.add(db_question)

    db.commit()
    db.refresh(db_game)
    
    # Load questions relationship
    db_game = db.query(Game).options(
        joinedload(Game.questions)
    ).filter(Game.id == db_game.id).first()
    
    return db_game


def get_game(db: Session, game_id: int) -> Optional[Game]:
    """Get a single game by ID with its questions"""
    game = db.query(Game).options(
        joinedload(Game.questions)
    ).filter(Game.id == game_id).first()
    
    if not game:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Game with id {game_id} not found"
        )
    return game


def get_games(
    db: Session, 
    skip: int = 0, 
    limit: int = 100,
    game_type: Optional[str] = None,
    search: Optional[str] = None
) -> List[Game]:
    """Get all games with filtering and pagination"""
    query = db.query(Game)
    
    # Apply filters
    if game_type:
        query = query.filter(Game.game_type == game_type)
    
    if search:
        query = query.filter(Game.title.ilike(f"%{search}%"))
    
    # Order by creation date (newest first)
    query = query.order_by(desc(Game.created_at))
    
    # Apply pagination
    games = query.offset(skip).limit(limit).all()
    
    return games


def get_games_count(
    db: Session,
    game_type: Optional[str] = None,
    search: Optional[str] = None
) -> int:
    """Get total count of games with filters"""
    query = db.query(Game)
    
    if game_type:
        query = query.filter(Game.game_type == game_type)
    
    if search:
        query = query.filter(Game.title.ilike(f"%{search}%"))
    
    return query.count()


def update_game(db: Session, game_id: int, game_data: GameUpdate) -> Game:
    """Update a game"""
    db_game = get_game(db, game_id)  # This already handles 404
    
    # Update only provided fields
    update_data = game_data.dict(exclude_unset=True)
    
    for field, value in update_data.items():
        if field == 'game_type' and value:
            value = value.value
        setattr(db_game, field, value)
    
    db_game.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(db_game)
    
    return db_game


def delete_game(db: Session, game_id: int) -> Dict[str, str]:
    """Delete a game and all its questions (cascade will handle questions)"""
    db_game = get_game(db, game_id)  # This already handles 404
    
    db.delete(db_game)
    db.commit()
    
    return {"message": f"Game '{db_game.title}' deleted successfully"}


def batch_delete_games(db: Session, game_ids: List[int]) -> Dict[str, Any]:
    """Delete multiple games at once"""
    games = db.query(Game).filter(Game.id.in_(game_ids)).all()
    
    if not games:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No games found with the provided IDs"
        )
    
    deleted_count = len(games)
    for game in games:
        db.delete(game)
    
    db.commit()
    
    return {
        "message": f"Successfully deleted {deleted_count} game(s)",
        "deleted_count": deleted_count,
        "deleted_ids": game_ids
    }


def duplicate_game(db: Session, game_id: int) -> Game:
    """Duplicate an existing game with all its questions"""
    original_game = get_game(db, game_id)
    
    # Create new game with same data but new title
    new_game = Game(
        title=f"{original_game.title} (Copy)",
        description=original_game.description,
        picture=original_game.picture,
        game_type=original_game.game_type,
        created_at=datetime.utcnow(),
        updated_at=datetime.utcnow()
    )
    db.add(new_game)
    db.flush()
    
    # Duplicate questions
    for question in original_game.questions:
        # Create new question based on type
        question_data = {
            'order': question.order,
            'text': question.text,
            'picture': question.picture,
            'contains_image': question.contains_image,
            'game_id': new_game.id
        }
        
        if question.question_type == QuestionType.TWO_CHOICE:
            new_question = TwoChoiceQuestion(
                **question_data,
                option1=question.option1,
                option2=question.option2
            )
        elif question.question_type == QuestionType.THREE_CHOICE:
            new_question = ThreeChoiceQuestion(
                **question_data,
                option1=question.option1,
                option2=question.option2,
                option3=question.option3
            )
        elif question.question_type == QuestionType.FOUR_CHOICE:
            new_question = FourChoiceQuestion(
                **question_data,
                option1=question.option1,
                option2=question.option2,
                option3=question.option3,
                option4=question.option4
            )
        elif question.question_type == QuestionType.RANGE:
            new_question = RangeQuestion(
                **question_data,
                option_numbers=question.option_numbers
            )
        else:
            continue
            
        db.add(new_question)
    
    db.commit()
    db.refresh(new_game)
    
    return new_game