from sqlalchemy.orm import Session
from sqlalchemy.sql import func, and_

from datetime import date

from app.auth.models import User
from app.auth.schemas import UserResponseList, UserUpdate

from app.auth.services import hash_password


class UserService:
    def get_user(username: str, role: str, is_active: bool, skip: int, limit: int, db: Session):
        db_unit = db.query(User)

        if username:
            db_unit = db_unit.filter(User.username.like(f"%{username}%"))
        
        if role:
            db_unit = db_unit.filter(User.role == role)

        if is_active is not None:
            db_unit = db_unit.filter(User.is_active == is_active)

        db_unit = db_unit.offset(skip).limit(limit).all()

        total = len(db_unit)

        return {
            "user": db_unit,
            "total": total,
            "skip": skip,
            "limit": limit,
        }

    # get_user_by_id
    def get_user_by_id(user_id: int, db: Session):
        return db.query(User).filter(User.user_id == user_id).first()
    
    # update_user
    def update_user(user_id: int, user: UserUpdate, db: Session):
        db_unit = db.query(User).filter(User.user_id == user_id).first()
        db_unit.username = user.username
        db_unit.role = user.role
        if user.password:
            db_unit.hashed_password = hash_password(user.password)

        db_unit.is_active = user.is_active
        db.commit()
        db.refresh(db_unit)
        return db_unit