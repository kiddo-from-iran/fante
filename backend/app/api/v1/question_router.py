# backend/app/api/v1/question_router.py
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session
from typing import List, Optional

from backend.app.schemas.question_schemas import (
    TwoChoiceQuestionCreate,
    ThreeChoiceQuestionCreate,
    FourChoiceQuestionCreate,
    RangeQuestionCreate,
    TwoChoiceQuestionRead,
    ThreeChoiceQuestionRead,
    FourChoiceQuestionRead,
    RangeQuestionRead,
    TwoChoiceQuestionUpdate,
    ThreeChoiceQuestionUpdate,
    FourChoiceQuestionUpdate,
    RangeQuestionUpdate,
    QuestionImageCreate,
    QuestionImageRead,
    QuestionCreateUnion,
    QuestionReadUnion,
    QuestionUpdateUnion
)
from backend.app.services.question_service import (
    create_question,
    get_question,
    get_game_questions,
    update_question,
    delete_question,
    reorder_questions,
    add_image_to_question,
    remove_image_from_question,
    get_question_images,
    batch_create_questions,
    batch_delete_questions
)
from backend.app.db.postgres import get_db

router = APIRouter(prefix="/questions", tags=["questions"])


@router.post(
    "/game/{game_id}",
    response_model=QuestionReadUnion,
    status_code=status.HTTP_201_CREATED,
    summary="Create a new question",
    description="Create a new question for a specific game"
)
def create_question_endpoint(
    game_id: int,
    question: QuestionCreateUnion,
    db: Session = Depends(get_db)
):
    """
    Create a new question for a game.
    
    - **game_id**: The ID of the game to add the question to
    - **question**: The question data (type depends on question_type)
    """
    return create_question(db, question, game_id)


@router.post(
    "/game/{game_id}/batch",
    response_model=List[QuestionReadUnion],
    status_code=status.HTTP_201_CREATED,
    summary="Create multiple questions",
    description="Create multiple questions for a game at once"
)
def batch_create_questions_endpoint(
    game_id: int,
    questions: List[QuestionCreateUnion],
    db: Session = Depends(get_db)
):
    """
    Create multiple questions for a game in a single request.
    
    - **game_id**: The ID of the game
    - **questions**: List of question objects
    """
    return batch_create_questions(db, game_id, questions)


@router.get(
    "/{question_id}",
    response_model=QuestionReadUnion,
    summary="Get question by ID",
    description="Get detailed information about a specific question"
)
def read_question_endpoint(
    question_id: int,
    db: Session = Depends(get_db)
):
    """Get a specific question by its ID."""
    return get_question(db, question_id)


@router.get(
    "/game/{game_id}",
    response_model=List[QuestionReadUnion],
    summary="Get game questions",
    description="Get all questions for a specific game"
)
def read_game_questions_endpoint(
    game_id: int,
    skip: int = Query(0, ge=0, description="Number of questions to skip"),
    limit: int = Query(100, ge=1, le=500, description="Number of questions to return"),
    db: Session = Depends(get_db)
):
    """
    Get all questions for a specific game.
    
    - **game_id**: The ID of the game
    - **skip**: Number of questions to skip (for pagination)
    - **limit**: Maximum number of questions to return
    """
    return get_game_questions(db, game_id, skip=skip, limit=limit)


@router.put(
    "/{question_id}",
    response_model=QuestionReadUnion,
    summary="Update question",
    description="Update an existing question"
)
def update_question_endpoint(
    question_id: int,
    question_data: QuestionUpdateUnion,
    db: Session = Depends(get_db)
):
    """
    Update a question's information.
    
    - **question_id**: The ID of the question to update
    - Any fields not provided will remain unchanged
    """
    return update_question(db, question_id, question_data)


@router.delete(
    "/{question_id}",
    response_model=dict,
    summary="Delete question",
    description="Delete a specific question"
)
def delete_question_endpoint(
    question_id: int,
    db: Session = Depends(get_db)
):
    """Delete a specific question by its ID."""
    return delete_question(db, question_id)


@router.post(
    "/batch-delete",
    response_model=dict,
    summary="Delete multiple questions",
    description="Delete multiple questions at once"
)
def batch_delete_questions_endpoint(
    question_ids: List[int],
    db: Session = Depends(get_db)
):
    """Delete multiple questions by their IDs."""
    return batch_delete_questions(db, question_ids)


@router.put(
    "/game/{game_id}/reorder",
    response_model=dict,
    summary="Reorder questions",
    description="Change the order of questions in a game"
)
def reorder_questions_endpoint(
    game_id: int,
    question_order: List[int] = Query(..., description="List of question IDs in the new order"),
    db: Session = Depends(get_db)
):
    """
    Reorder questions in a game.
    
    - **game_id**: The ID of the game
    - **question_order**: Array of question IDs in the desired order
    """
    return reorder_questions(db, game_id, question_order)


# Question Image Endpoints
@router.post(
    "/{question_id}/images",
    response_model=QuestionImageRead,
    status_code=status.HTTP_201_CREATED,
    summary="Add image to question",
    description="Add an image to a specific question"
)
def add_image_endpoint(
    question_id: int,
    image: QuestionImageCreate,
    db: Session = Depends(get_db)
):
    """Add an image to a question."""
    return add_image_to_question(db, question_id, image)


@router.get(
    "/{question_id}/images",
    response_model=List[QuestionImageRead],
    summary="Get question images",
    description="Get all images for a specific question"
)
def get_images_endpoint(
    question_id: int,
    db: Session = Depends(get_db)
):
    """Get all images associated with a question."""
    return get_question_images(db, question_id)


@router.delete(
    "/images/{image_id}",
    response_model=dict,
    summary="Remove image",
    description="Remove an image from a question"
)
def remove_image_endpoint(
    image_id: int,
    db: Session = Depends(get_db)
):
    """Remove a specific image from a question."""
    return remove_image_from_question(db, image_id)