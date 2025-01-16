from fastapi import APIRouter, Depends, HTTPException,  File, UploadFile
from pathlib import Path
import shutil

from sqlalchemy.orm import Session
from ...database import SessionLocal
from ...services import unit_service
from ...models.unit import Unit

from app.services.mission_service import MissionService

from app.schemas.mission import MissionCreate, MissionOut, MissionUpdate, MissionUnits
from app.auth.dependencies import get_current_user
from app.auth.models import User
from app.database import get_db
from typing import Optional
from typing import List

router = APIRouter()


@router.get("/units/{unit_id}", response_model=List[MissionUnits])
def get_unit(unit_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_unit = MissionService.get_mission_by_units_id(db, unit_id=unit_id)
    if db_unit is None:
        raise HTTPException(status_code=404, detail="Unit not found")
    return db_unit
