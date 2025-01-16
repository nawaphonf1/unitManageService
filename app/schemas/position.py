from pydantic import BaseModel
from datetime import date, time
from typing import Optional

class PositionBase(BaseModel):
    position_name: str
    position_name_short: str

    class Config:
        orm_mode = True

class ResponsePosition(PositionBase):
    position_id: int
