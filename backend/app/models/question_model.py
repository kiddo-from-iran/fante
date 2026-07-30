from sqlalchemy import Column, Integer, String, Text, SMALLINT, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from backend.app.db.base import Base


class QuestionType:
    TWO_CHOICE = "two_choice"
    THREE_CHOICE = "three_choice"
    FOUR_CHOICE = "four_choice"
    RANGE = "range"


# we use joinedload when contains_image is true
class QuestionImage(Base):
    __tablename__ = "question_images"
    id = Column(Integer, primary_key=True)
    question_id = Column(Integer, ForeignKey("questions.id"))
    image_url = Column(String(255), nullable=False)

    question = relationship("Question", back_populates="images")


class Question(Base):
    __tablename__ = "questions"

    id = Column(Integer, primary_key=True, index=True)
    order = Column(SMALLINT, nullable=False)
    text = Column(Text, nullable=False)
    picture = Column(String(255), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    question_type = Column(String(50), nullable=False)
    contains_image = Column(Boolean, nullable=False, default=False)
    game_id = Column(Integer, ForeignKey('games.id'))
    images = relationship("QuestionImage", back_populates="question", cascade="all, delete-orphan")
    game = relationship("Game", back_populates="questions")

    __mapper_args__ = {
        'polymorphic_on': question_type,
        'polymorphic_identity': 'base'
    }


class TwoChoiceQuestion(Question):
    __tablename__ = "two_choice_questions"
    id = Column(Integer, ForeignKey("questions.id"), primary_key=True)
    option1 = Column(String(255), nullable=True)
    option2 = Column(String(255), nullable=True)

    __mapper_args__ = {
        'polymorphic_identity': QuestionType.TWO_CHOICE,
        'inherit_condition': id == Question.id
    }


class ThreeChoiceQuestion(Question):
    __tablename__ = "three_choice_questions"
    id = Column(Integer, ForeignKey("questions.id"), primary_key=True)
    option1 = Column(String(255), nullable=True)
    option2 = Column(String(255), nullable=True)
    option3 = Column(String(255), nullable=True)

    __mapper_args__ = {
        'polymorphic_identity': QuestionType.THREE_CHOICE,
        'inherit_condition': id == Question.id
    }


class FourChoiceQuestion(Question):
    __tablename__ = "four_choice_questions"
    id = Column(Integer, ForeignKey("questions.id"), primary_key=True)
    option1 = Column(String(255), nullable=True)
    option2 = Column(String(255), nullable=True)
    option3 = Column(String(255), nullable=True)
    option4 = Column(String(255), nullable=True)

    __mapper_args__ = {
        'polymorphic_identity': QuestionType.FOUR_CHOICE,
        'inherit_condition': id == Question.id
    }


class RangeQuestion(Question):
    __tablename__ = "range_questions"
    id = Column(Integer, ForeignKey("questions.id"), primary_key=True)
    option_numbers = Column(SMALLINT, nullable=True)

    __mapper_args__ = {
        'polymorphic_identity': QuestionType.RANGE,
        'inherit_condition': id == Question.id
    }
