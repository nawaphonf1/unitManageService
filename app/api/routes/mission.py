from fastapi import APIRouter, Depends, HTTPException,  File, UploadFile
from pathlib import Path
from datetime import date
import shutil

from sqlalchemy.orm import Session
from ...database import SessionLocal
from ...services import unit_service
from ...models.unit import Unit

from app.services.mission_service import MissionService

from app.schemas.mission import MissionCreate, MissionOut, MissionUpdate, UpdateMissionUnitParam,MissionUnits, MissionResponse, UnitMissionResponse
from app.auth.dependencies import get_current_user
from app.auth.models import User
from app.database import get_db
from typing import Optional
from typing import List

from fastapi.responses import StreamingResponse

router = APIRouter()

@router.post("/", response_model=None)
def create_mission(data: UpdateMissionUnitParam, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_unit = MissionService.create_mission(db, data)
    if db_unit is None:
        raise HTTPException(status_code=404, detail="Unit not found")
    MissionService.update_status_unit(db)
    return db_unit

@router.get("/units/{unit_id}", response_model=List[MissionUnits])
def get_unit(unit_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_unit = MissionService.get_mission_by_units_id(db, unit_id=unit_id)
    if db_unit is None:
        raise HTTPException(status_code=404, detail="Unit not found")
    return db_unit

#get all missions
@router.get("/", response_model=MissionResponse)
def get_missions(
        skip: int = 0,
        limit: int = 100, 
        mission_name: Optional[str] = None,
        mission_start: Optional[date] = None,
        mission_end: Optional[date] = None,
        mission_type: Optional[str] = None,
        mission_status: Optional[str] = None,
        db: Session = Depends(get_db), 
        current_user: User = Depends(get_current_user)):
    db_missions = MissionService.get_missions(db, skip, limit, mission_name, mission_start, mission_end, mission_type, mission_status)
    MissionService.update_status_unit(db)
    return db_missions 

#get mission by id
@router.get("/{mission_id}", response_model=MissionOut)
def get_mission(mission_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_mission = MissionService.get_mission_by_id(db, mission_id=mission_id)
    if db_mission is None:
        raise HTTPException(status_code=404, detail="Mission not found")
    return db_mission

#get unit by mission_id
@router.get("/mission_units/{mission_id}", response_model=List[UnitMissionResponse])
def get_unit_by_mission_id(mission_id:int,db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_mission = MissionService.get_unit_by_mission_id(db, mission_id=mission_id)
    if db_mission is None:
        raise HTTPException(status_code=404, detail="Mission not found")
    return db_mission

#update_mission_units
@router.post("/update_mission_units/{mission_id}", response_model=None)
def update_mission_units(mission_id:int, data:UpdateMissionUnitParam ,db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_mission = MissionService.update_mission_units_service(db,mission_id, data)
    if db_mission is None:
        raise HTTPException(status_code=404, detail="Mission not found")
    MissionService.update_status_unit(db)
    return db_mission

@router.delete("/{mission_id}", response_model=None)
def del_mission(mission_id:int,db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_mission = MissionService.del_mission(db,mission_id)
    return db_mission

@router.post("/import_excel")
async def import_excel(db: Session = Depends(get_db),current_user: User = Depends(get_current_user),file: UploadFile = File(...)):
    db_mission = await MissionService.import_excel(db,file)
    return db_mission
    
@router.get("/export_mission/{mission_id}")
async def export_mission(mission_id: int,db: Session = Depends(get_db)):
    excel_file = MissionService.export_mission(db,mission_id)

    return StreamingResponse(
        excel_file,
        media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers={"Content-Disposition": "attachment; filename=unitExport.xlsx"}
    )

@router.get("export_missions/unit")
async def export_mission_unit( 
        mission_name: Optional[str] = None,
        mission_start: Optional[date] = None,
        mission_end: Optional[date] = None,
        mission_type: Optional[str] = None,
        mission_status: Optional[str] = None,
        position_detail: Optional[str] = None,
        position_name: Optional[str] = None,
        db: Session = Depends(get_db)):
    excel_file = MissionService.export_mission_unit(db, mission_name, mission_start, mission_end, mission_type, mission_status, position_detail, position_name)

    # return excel_file
    return StreamingResponse(
        excel_file,
        media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers={"Content-Disposition": "attachment; filename=unitExport.xlsx"}
    )