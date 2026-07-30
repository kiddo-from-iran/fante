# backend/app/schemas/question_schemas.py
from pydantic import BaseModel, validator, Field
from typing import List, Optional, Union
from datetime import datetime
from enum import Enum


class QuestionTypeEnum(str, Enum):
    TWO_CHOICE = "two_choice"
    THREE_CHOICE = "three_choice"
    FOUR_CHOICE = "four_choice"
    RANGE = "range"


# Question Image Schema
class QuestionImageCreate(BaseModel):
    image_url: str


class QuestionImageRead(BaseModel):
    id: int
    question_id: int
    image_url: str

    class Config:
        from_attributes = True


# Base Question Schema
class QuestionBase(BaseModel):
    order: int = Field(..., ge=1, description="Question order in the game")
    text: str = Field(..., min_length=1, description="Question text")
    picture: Optional[str] = Field(None, description="Main question picture URL")
    contains_image: bool = Field(False, description="Whether question contains images")
    question_type: QuestionTypeEnum


# Two Choice Question Schemas
class TwoChoiceQuestionCreate(QuestionBase):
    question_type: QuestionTypeEnum = QuestionTypeEnum.TWO_CHOICE
    option1: str = Field(..., min_length=1, description="First option")
    option2: str = Field(..., min_length=1, description="Second option")
    
    @validator('option1', 'option2')
    def options_not_empty(cls, v):
        if not v or not v.strip():
            raise ValueError('Option cannot be empty')
        return v.strip()


class TwoChoiceQuestionUpdate(BaseModel):
    order: Optional[int] = Field(None, ge=1)
    text: Optional[str] = Field(None, min_length=1)
    picture: Optional[str] = None
    contains_image: Optional[bool] = None
    option1: Optional[str] = Field(None, min_length=1)
    option2: Optional[str] = Field(None, min_length=1)


class TwoChoiceQuestionRead(QuestionBase):
    id: int
    game_id: int
    created_at: datetime
    option1: str
    option2: str
    images: List[QuestionImageRead] = []

    class Config:
        from_attributes = True


# Three Choice Question Schemas
class ThreeChoiceQuestionCreate(QuestionBase):
    question_type: QuestionTypeEnum = QuestionTypeEnum.THREE_CHOICE
    option1: str = Field(..., min_length=1)
    option2: str = Field(..., min_length=1)
    option3: str = Field(..., min_length=1)
    
    @validator('option1', 'option2', 'option3')
    def options_not_empty(cls, v):
        if not v or not v.strip():
            raise ValueError('Option cannot be empty')
        return v.strip()


class ThreeChoiceQuestionUpdate(BaseModel):
    order: Optional[int] = Field(None, ge=1)
    text: Optional[str] = Field(None, min_length=1)
    picture: Optional[str] = None
    contains_image: Optional[bool] = None
    option1: Optional[str] = Field(None, min_length=1)
    option2: Optional[str] = Field(None, min_length=1)
    option3: Optional[str] = Field(None, min_length=1)


class ThreeChoiceQuestionRead(QuestionBase):
    id: int
    game_id: int
    created_at: datetime
    option1: str
    option2: str
    option3: str
    images: List[QuestionImageRead] = []

    class Config:
        from_attributes = True


# Four Choice Question Schemas
class FourChoiceQuestionCreate(QuestionBase):
    question_type: QuestionTypeEnum = QuestionTypeEnum.FOUR_CHOICE
    option1: str = Field(..., min_length=1)
    option2: str = Field(..., min_length=1)
    option3: str = Field(..., min_length=1)
    option4: str = Field(..., min_length=1)
    
    @validator('option1', 'option2', 'option3', 'option4')
    def options_not_empty(cls, v):
        if not v or not v.strip():
            raise ValueError('Option cannot be empty')
        return v.strip()


class FourChoiceQuestionUpdate(BaseModel):
    order: Optional[int] = Field(None, ge=1)
    text: Optional[str] = Field(None, min_length=1)
    picture: Optional[str] = None
    contains_image: Optional[bool] = None
    option1: Optional[str] = Field(None, min_length=1)
    option2: Optional[str] = Field(None, min_length=1)
    option3: Optional[str] = Field(None, min_length=1)
    option4: Optional[str] = Field(None, min_length=1)


class FourChoiceQuestionRead(QuestionBase):
    id: int
    game_id: int
    created_at: datetime
    option1: str
    option2: str
    option3: str
    option4: str
    images: List[QuestionImageRead] = []

    class Config:
        from_attributes = True


# Range Question Schemas
class RangeQuestionCreate(QuestionBase):
    question_type: QuestionTypeEnum = QuestionTypeEnum.RANGE
    option_numbers: int = Field(..., ge=1, le=10, description="Number of options in range")
    
    @validator('option_numbers')
    def validate_range(cls, v):
        if v < 1 or v > 10:
            raise ValueError('Range must be between 1 and 10')
        return v


class RangeQuestionUpdate(BaseModel):
    order: Optional[int] = Field(None, ge=1)
    text: Optional[str] = Field(None, min_length=1)
    picture: Optional[str] = None
    contains_image: Optional[bool] = None
    option_numbers: Optional[int] = Field(None, ge=1, le=10)


class RangeQuestionRead(QuestionBase):
    id: int
    game_id: int
    created_at: datetime
    option_numbers: int
    images: List[QuestionImageRead] = []

    class Config:
        from_attributes = True


# Union types for flexibility
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

QuestionUpdateUnion = Union[
    TwoChoiceQuestionUpdate,
    ThreeChoiceQuestionUpdate,
    FourChoiceQuestionUpdate,
    RangeQuestionUpdate
]