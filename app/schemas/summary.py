from pydantic import BaseModel
from datetime import date, time
from typing import Optional

# respone for summary have unit doing a mission and unit not doing a mission and unit pending
class SummaryResponse(BaseModel):
    unit_all: int
    unit_doing_mission: int
    unit_not_doing_mission: int
    unit_pending: int
    mission_all: int
    mission_doing: int
    mission_pending: int
    mission_done: int

    class Config:
        orm_mode = True


