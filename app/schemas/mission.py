from pydantic import BaseModel
from datetime import date, time, datetime
from typing import Optional, List

class MissionBase(BaseModel):
    mission_name: str
    mission_start: date
    mission_end: date
    mission_detail: Optional[str] = None
    mission_type: Optional[str] = None
    mission_status: str
    is_active: bool = True

    class Config:
        orm_mode = True

class MissionCreate(MissionBase):
    pass  # ใช้โครงสร้างเหมือน MissionBase สำหรับสร้างใหม่

class MissionUpdate(BaseModel):
    mission_name: Optional[str] = None
    mission_start: Optional[date] = None
    mission_end: Optional[date] = None
    mission_detail: Optional[str] = None
    mission_type: Optional[str] = None
    mission_status: Optional[str] = None
    is_active: Optional[bool] = None

    class Config:
        orm_mode = True

class MissionOut(MissionBase):
    mission_id: int
    created_at: Optional[datetime]

class MissionUnits(BaseModel):
    mission_id: int
    unit_id: int
    mission_name: str
    mission_start: date
    mission_end: date
    mission_status: str

class MissionResponse(BaseModel):
    missions: list[MissionOut]
    total: int
    skip: int
    limit: int

class UnitMissionResponse(BaseModel):
    mission_id: Optional[int] = None
    units_id:int
    first_name: str
    last_name: str
    position_id: int
    position_name:str
    position_name_short:str
    position_seq:int

class UpdateMissionUnitParam(MissionBase):
    mission_unit_id: List[int]  # ใช้ List[int] แทน list เพื่อกำหนดประเภทข้อมูล

    class Config:
        orm_mode = True
