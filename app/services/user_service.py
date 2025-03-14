from sqlalchemy.orm import Session
from sqlalchemy.sql import func, and_

from datetime import date

from app.auth.models import User


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
