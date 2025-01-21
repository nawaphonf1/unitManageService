from pydantic import BaseModel
from datetime import date, time, datetime
from typing import Optional

class MissionBase(BaseModel):
    mission_name: str
    mission_start: date
    mission_end: date
    mission_detail: Optional[str] = None
    mission_type: int
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
    mission_type: Optional[int] = None
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