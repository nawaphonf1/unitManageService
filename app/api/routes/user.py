from fastapi import APIRouter, Depends, HTTPException,  File, UploadFile
from pathlib import Path
import shutil
from datetime import date 

from sqlalchemy.orm import Session

from app.auth.dependencies import get_current_user
from app.auth.models import User
from app.database import get_db
from typing import Optional
from typing import List

from app.auth.schemas import UserResponseList, UserUpdate

from app.services.user_service import UserService

router = APIRouter()


@router.get("/", response_model=UserResponseList)
def get_user(
        username : Optional[str] = None,
        role: Optional[str] = None, 
        is_active: Optional[bool] = None,
        skip: int = 0,
        limit: int = 100,
        db: Session = Depends(get_db), 
        current_user: User = Depends(get_current_user)):
    db_unit = UserService.get_user(username, role, is_active, skip, limit, db)
    return db_unit

# get id
@router.get("/{user_id}")
def get_user_by_id(user_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_unit = UserService.get_user_by_id(user_id, db)
    return db_unit

# update user
@router.put("/{user_id}")
def update_user(user_id: int, user: UserUpdate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_unit = UserService.update_user(user_id, user, db)
    return db_unit
