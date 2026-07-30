# backend/app/api/v1/game_router.py
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session
from typing import Optional, List

from backend.app.schemas.game_schemas import (
    GameCreate, 
    GameRead, 
    GameUpdate, 
    GameListRead
)
from backend.app.services.game_service import (
    create_game, 
    get_game, 
    get_games, 
    update_game, 
    delete_game,
    get_games_count,
    batch_delete_games,
    duplicate_game
)
from backend.app.db.postgres import get_db

router = APIRouter(prefix="/games", tags=["games"])


@router.post(
    "/", 
    response_model=GameRead,
    status_code=status.HTTP_201_CREATED,
    summary="Create a new game",
    description="Create a new game with multiple questions"
)
def create_game_endpoint(
    game: GameCreate, 
    db: Session = Depends(get_db)
):
    """
    Create a new game with questions.
    
    - **title**: Game title (required)
    - **description**: Optional game description
    - **picture**: URL or path to game picture
    - **game_type**: Type of game (test, quiz, vote)
    - **questions**: List of questions (minimum 1)
    """
    return create_game(db, game)


@router.get(
    "/", 
    response_model=List[GameListRead],
    summary="Get all games",
    description="Get paginated list of games with optional filters"
)
def read_games_endpoint(
    skip: int = Query(0, ge=0, description="Number of records to skip"),
    limit: int = Query(100, ge=1, le=500, description="Number of records to return"),
    game_type: Optional[str] = Query(None, description="Filter by game type"),
    search: Optional[str] = Query(None, description="Search by title"),
    db: Session = Depends(get_db)
):
    """
    Get all games with pagination and filtering.
    
    - **skip**: Number of games to skip (for pagination)
    - **limit**: Maximum number of games to return
    - **game_type**: Filter by game type (test, quiz, vote)
    - **search**: Search in game titles
    """
    games = get_games(db, skip=skip, limit=limit, game_type=game_type, search=search)
    return games


@router.get(
    "/count",
    response_model=int,
    summary="Get total count of games",
    description="Get total number of games matching the filters"
)
def get_games_count_endpoint(
    game_type: Optional[str] = Query(None, description="Filter by game type"),
    search: Optional[str] = Query(None, description="Search by title"),
    db: Session = Depends(get_db)
):
    """Get total count of games with optional filters"""
    return get_games_count(db, game_type=game_type, search=search)


@router.get(
    "/{game_id}", 
    response_model=GameRead,
    summary="Get game by ID",
    description="Get detailed information about a specific game including all questions"
)
def read_game_endpoint(
    game_id: int,
    db: Session = Depends(get_db)
):
    """
    Get a specific game by its ID.
    
    - **game_id**: The ID of the game to retrieve
    """
    return get_game(db, game_id)


@router.put(
    "/{game_id}", 
    response_model=GameRead,
    summary="Update game",
    description="Update an existing game"
)
def update_game_endpoint(
    game_id: int,
    game_data: GameUpdate,
    db: Session = Depends(get_db)
):
    """
    Update a game's information.
    
    - **game_id**: The ID of the game to update
    - Any fields not provided will remain unchanged
    """
    return update_game(db, game_id, game_data)


@router.delete(
    "/{game_id}",
    response_model=dict,
    summary="Delete game",
    description="Delete a game and all its associated questions"
)
def delete_game_endpoint(
    game_id: int,
    db: Session = Depends(get_db)
):
    """
    Delete a specific game by its ID.
    
    - **game_id**: The ID of the game to delete
    """
    return delete_game(db, game_id)


@router.post(
    "/batch-delete",
    response_model=dict,
    summary="Delete multiple games",
    description="Delete multiple games at once"
)
def batch_delete_games_endpoint(
    game_ids: List[int],
    db: Session = Depends(get_db)
):
    """
    Delete multiple games by their IDs.
    
    - **game_ids**: List of game IDs to delete
    """
    return batch_delete_games(db, game_ids)


@router.post(
    "/{game_id}/duplicate",
    response_model=GameRead,
    status_code=status.HTTP_201_CREATED,
    summary="Duplicate game",
    description="Create a copy of an existing game with all its questions"
)
def duplicate_game_endpoint(
    game_id: int,
    db: Session = Depends(get_db)
):
    """
    Duplicate an existing game.
    
    - **game_id**: The ID of the game to duplicate
    - Creates a new game with '(Copy)' appended to the title
    """
    return duplicate_game(db, game_id)