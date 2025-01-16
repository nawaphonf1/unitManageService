from pydantic import BaseModel
from datetime import date, time
from typing import Optional

class DeptBase(BaseModel):
    dept_name: str
    dept_name_short: str

    class Config:
        orm_mode = True

class DeptResponse(DeptBase):
    dept_id: int
