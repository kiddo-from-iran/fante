# backend/app/services/question_service.py
from fastapi import HTTPException, status
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import and_
from typing import List, Optional, Dict, Any
from datetime import datetime

from backend.app.models.question_model import (
    Question, QuestionType, TwoChoiceQuestion, ThreeChoiceQuestion,
    FourChoiceQuestion, RangeQuestion, QuestionImage
)
from backend.app.models.game_model import Game
from backend.app.schemas.question_schemas import (
    TwoChoiceQuestionCreate, ThreeChoiceQuestionCreate,
    FourChoiceQuestionCreate, RangeQuestionCreate,
    TwoChoiceQuestionUpdate, ThreeChoiceQuestionUpdate,
    FourChoiceQuestionUpdate, RangeQuestionUpdate,
    QuestionImageCreate
)


def create_question(db: Session, question_data: Any, game_id: int):
    """Create a new question for a specific game"""
    
    # Check if game exists
    game = db.query(Game).filter(Game.id == game_id).first()
    if not game:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Game with id {game_id} not found"
        )
    
    # Check if order is unique for this game
    existing_question = db.query(Question).filter(
        and_(Question.game_id == game_id, Question.order == question_data.order)
    ).first()
    if existing_question:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Question with order {question_data.order} already exists in this game"
        )
    
    # Create question based on type
    if question_data.question_type.value == QuestionType.TWO_CHOICE:
        db_question = TwoChoiceQuestion(
            order=question_data.order,
            text=question_data.text,
            picture=question_data.picture,
            contains_image=question_data.contains_image,
            option1=question_data.option1,
            option2=question_data.option2,
            game_id=game_id,
            created_at=datetime.utcnow()
        )
    elif question_data.question_type.value == QuestionType.THREE_CHOICE:
        db_question = ThreeChoiceQuestion(
            order=question_data.order,
            text=question_data.text,
            picture=question_data.picture,
            contains_image=question_data.contains_image,
            option1=question_data.option1,
            option2=question_data.option2,
            option3=question_data.option3,
            game_id=game_id,
            created_at=datetime.utcnow()
        )
    elif question_data.question_type.value == QuestionType.FOUR_CHOICE:
        db_question = FourChoiceQuestion(
            order=question_data.order,
            text=question_data.text,
            picture=question_data.picture,
            contains_image=question_data.contains_image,
            option1=question_data.option1,
            option2=question_data.option2,
            option3=question_data.option3,
            option4=question_data.option4,
            game_id=game_id,
            created_at=datetime.utcnow()
        )
    elif question_data.question_type.value == QuestionType.RANGE:
        db_question = RangeQuestion(
            order=question_data.order,
            text=question_data.text,
            picture=question_data.picture,
            contains_image=question_data.contains_image,
            option_numbers=question_data.option_numbers,
            game_id=game_id,
            created_at=datetime.utcnow()
        )
    else:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid question type: {question_data.question_type}"
        )
    
    db.add(db_question)
    db.commit()
    db.refresh(db_question)
    
    return db_question


def get_question(db: Session, question_id: int):
    """Get a single question by ID with its images"""
    question = db.query(Question).options(
        joinedload(Question.images)
    ).filter(Question.id == question_id).first()
    
    if not question:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Question with id {question_id} not found"
        )
    return question


def get_game_questions(db: Session, game_id: int, skip: int = 0, limit: int = 100):
    """Get all questions for a specific game"""
    # Check if game exists
    game = db.query(Game).filter(Game.id == game_id).first()
    if not game:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Game with id {game_id} not found"
        )
    
    questions = db.query(Question).options(
        joinedload(Question.images)
    ).filter(Question.game_id == game_id).order_by(Question.order).offset(skip).limit(limit).all()
    
    return questions


def update_question(db: Session, question_id: int, question_data: Any):
    """Update an existing question"""
    db_question = get_question(db, question_id)
    
    # Update common fields
    update_data = question_data.dict(exclude_unset=True)
    
    for field, value in update_data.items():
        if hasattr(db_question, field):
            setattr(db_question, field, value)
    
    db_question.updated_at = datetime.utcnow() if hasattr(db_question, 'updated_at') else None
    db.commit()
    db.refresh(db_question)
    
    return db_question


def delete_question(db: Session, question_id: int):
    """Delete a question"""
    db_question = get_question(db, question_id)
    
    db.delete(db_question)
    db.commit()
    
    return {"message": f"Question {question_id} deleted successfully"}


def reorder_questions(db: Session, game_id: int, question_order: List[int]):
    """Reorder questions in a game"""
    # Check if game exists
    game = db.query(Game).filter(Game.id == game_id).first()
    if not game:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Game with id {game_id} not found"
        )
    
    # Update order for each question
    for new_order, question_id in enumerate(question_order, start=1):
        question = db.query(Question).filter(
            and_(Question.id == question_id, Question.game_id == game_id)
        ).first()
        
        if not question:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Question {question_id} not found in game {game_id}"
            )
        
        question.order = new_order
    
    db.commit()
    
    return {"message": "Questions reordered successfully", "new_order": question_order}


def add_image_to_question(db: Session, question_id: int, image_data: QuestionImageCreate):
    """Add an image to a question"""
    question = get_question(db, question_id)
    
    db_image = QuestionImage(
        question_id=question_id,
        image_url=image_data.image_url
    )
    
    db.add(db_image)
    db.commit()
    db.refresh(db_image)
    
    # Update contains_image flag if needed
    if not question.contains_image:
        question.contains_image = True
        db.commit()
    
    return db_image


def remove_image_from_question(db: Session, image_id: int):
    """Remove an image from a question"""
    db_image = db.query(QuestionImage).filter(QuestionImage.id == image_id).first()
    
    if not db_image:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Image with id {image_id} not found"
        )
    
    question_id = db_image.question_id
    db.delete(db_image)
    db.commit()
    
    # Check if question still has images
    remaining_images = db.query(QuestionImage).filter(QuestionImage.question_id == question_id).count()
    if remaining_images == 0:
        question = db.query(Question).filter(Question.id == question_id).first()
        if question:
            question.contains_image = False
            db.commit()
    
    return {"message": "Image removed successfully"}


def get_question_images(db: Session, question_id: int):
    """Get all images for a question"""
    question = get_question(db, question_id)
    return question.images


def batch_create_questions(db: Session, game_id: int, questions_data: List[Any]):
    """Create multiple questions for a game at once"""
    created_questions = []
    
    for question_data in questions_data:
        try:
            question = create_question(db, question_data, game_id)
            created_questions.append(question)
        except HTTPException as e:
            db.rollback()
            raise HTTPException(
                status_code=e.status_code,
                detail=f"Failed to create question: {e.detail}"
            )
    
    return created_questions


def batch_delete_questions(db: Session, question_ids: List[int]):
    """Delete multiple questions at once"""
    questions = db.query(Question).filter(Question.id.in_(question_ids)).all()
    
    if not questions:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No questions found with the provided IDs"
        )
    
    deleted_count = len(questions)
    for question in questions:
        db.delete(question)
    
    db.commit()
    
    return {
        "message": f"Successfully deleted {deleted_count} question(s)",
        "deleted_count": deleted_count,
        "deleted_ids": question_ids
    }