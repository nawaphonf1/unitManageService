from fastapi import APIRouter, Depends, HTTPException,  File, UploadFile
from pathlib import Path
import shutil
from typing import List

from sqlalchemy.orm import Session
from ...database import SessionLocal
from ...services import unit_service
from ...models.unit import Unit
from ...schemas.unit import UnitCreate, UnitOut, UnitAll, UnitResponse, UnitUpdate, UnitBase
from app.schemas.mission import UnitMissionResponse

from app.auth.dependencies import get_current_user
from app.auth.models import User
from app.database import get_db
from typing import Optional

router = APIRouter()

UPLOAD_DIR = Path("uploads")
UPLOAD_DIR.mkdir(exist_ok=True)

@router.post("/upload-image")
async def upload_image(file: UploadFile = File(...)):
    file_path = UPLOAD_DIR / file.filename

    with file_path.open("wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    return {"imageUrl": f"/uploads/{file.filename}"}

@router.post("/", response_model=UnitOut)
def create_unit(unit: UnitCreate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    # current_user จะได้รับค่าผู้ใช้จากการตรวจสอบ token
    return unit_service.create_unit(db=db, unit=unit)

@router.get("/units/{unit_id}", response_model=UnitOut)
def get_unit(unit_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_unit = unit_service.get_unit(db, unit_id=unit_id)
    if db_unit is None:
        raise HTTPException(status_code=404, detail="Unit not found")
    return db_unit


@router.get("/", response_model=UnitResponse)
def get_all_units(
    name: Optional[str] = None,
    position_id: Optional[int] = None,
    dept_id: Optional[int] = None,
    status: Optional[str] = None,
    skip: int = 0,
    limit: int = 100, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return unit_service.get_all_units(db, name, position_id, dept_id,status, skip, limit)

@router.put("/{unit_id}", response_model=UnitBase)
def update_unit(unit_id: int, unit: UnitUpdate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_unit = unit_service.update_unit(db, unit_id, unit)
    if db_unit is None:
        raise HTTPException(status_code=404, detail="Unit not found")
    return db_unit

#get units active
@router.get("/units_ready", response_model=List[UnitMissionResponse])
def get_units_active(position_id:Optional[int] = None,first_name:Optional[str] = None,last_name:Optional[str] = None,  db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_unit = unit_service.get_units_active(db, position_id, first_name,last_name)
    if db_unit is None:
        raise HTTPException(status_code=404, detail="Unit not found")
    return db_unit

