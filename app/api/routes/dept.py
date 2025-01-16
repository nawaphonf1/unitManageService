from fastapi import APIRouter, Depends, HTTPException,  File, UploadFile
from pathlib import Path
import shutil

from sqlalchemy.orm import Session
from ...database import SessionLocal
from ...services import unit_service
from ...models.unit import Unit

from app.services.dept_service import DeptService

from app.schemas.dept import DeptBase, DeptResponse

from app.auth.dependencies import get_current_user
from app.auth.models import User
from app.database import get_db
from typing import Optional
from typing import List

router = APIRouter()


@router.get("/", response_model=List[DeptResponse])
def get_unit(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_unit = DeptService.get_all_dept(db)
    return db_unit
