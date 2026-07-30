# backend/app/schemas/game_schemas.py
from pydantic import BaseModel, validator
from typing import List, Optional, Union
from datetime import datetime
from enum import Enum

from backend.app.schemas.question_schemas import (
    FourChoiceQuestionCreate, 
    RangeQuestionCreate, 
    ThreeChoiceQuestionCreate, 
    TwoChoiceQuestionCreate,
    FourChoiceQuestionRead,
    RangeQuestionRead,
    ThreeChoiceQuestionRead,
    TwoChoiceQuestionRead
)


class GameType(str, Enum):
    TEST = "test"
    QUIZ = "quiz"
    VOTE = "vote"
    
    @classmethod
    def get_all_types(cls):
        return [game_type.value for game_type in cls]


# Union type for all question types
QuestionCreateUnion = Union[
    TwoChoiceQuestionCreate,
    ThreeChoiceQuestionCreate,
    FourChoiceQuestionCreate,
    RangeQuestionCreate
]

QuestionReadUnion = Union[
    TwoChoiceQuestionRead,
    ThreeChoiceQuestionRead,
    FourChoiceQuestionRead,
    RangeQuestionRead
]


class GameCreate(BaseModel):
    title: str
    description: Optional[str] = None
    picture: str
    game_type: GameType
    questions: List[QuestionCreateUnion]
    
    @validator('title')
    def title_not_empty(cls, v):
        if not v or not v.strip():
            raise ValueError('Title cannot be empty')
        return v.strip()
    
    @validator('questions')
    def questions_not_empty(cls, v):
        if not v:
            raise ValueError('At least one question is required')
        return v


class GameUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    picture: Optional[str] = None
    game_type: Optional[GameType] = None
    
    @validator('title')
    def title_not_empty(cls, v):
        if v is not None and not v.strip():
            raise ValueError('Title cannot be empty')
        return v.strip() if v else v


class GameRead(BaseModel):
    id: int
    title: str
    description: Optional[str] = None
    picture: str
    game_type: GameType
    created_at: datetime
    updated_at: datetime
    questions: List[QuestionReadUnion]

    class Config:
        from_attributes = True


class GameListRead(BaseModel):
    id: int
    title: str
    description: Optional[str] = None
    picture: str
    game_type: GameType
    created_at: datetime
    updated_at: datetime
    questions_count: int

    class Config:
        from_attributes = True