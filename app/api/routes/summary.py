from fastapi import APIRouter, Depends, HTTPException,  File, UploadFile
from pathlib import Path
import shutil
from datetime import date 

from sqlalchemy.orm import Session
from ...database import SessionLocal
from ...services import unit_service
from ...models.unit import Unit

from app.services.summary import SummaryService

from app.schemas.summary import SummaryResponse

from app.auth.dependencies import get_current_user
from app.auth.models import User
from app.database import get_db
from typing import Optional
from typing import List

router = APIRouter()


@router.get("/", response_model=SummaryResponse)
def get_unit(date_start:Optional[date],date_end:Optional[date],db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_unit = SummaryService.get_summary(db, date_start,date_end)
    return db_unit
