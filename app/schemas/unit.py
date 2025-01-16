from pydantic import BaseModel
from typing import Optional

class UnitBase(BaseModel):
    first_name: str
    last_name: str
    tel: Optional[str] = None
    identify_id: Optional[str] = None  # เปลี่ยนเป็น str ตามตาราง
    position_id: int
    dept_id: int
    blood_group_id: Optional[int] = None
    province_id: Optional[int] = None
    district_id: Optional[int] = None
    parish_id: Optional[int] = None
    post_code: Optional[int] = None
    address_detail: Optional[str] = None
    status: Optional[str] = None  # เพิ่มฟิลด์ status
    is_active: Optional[bool] = True  # เพิ่มฟิลด์ is_active และตั้งค่าเริ่มต้นเป็น True
    img_path: Optional[str] = None  # เพิ่มฟิลด์ img_path
    identify_soldier_id: Optional[str] = None  # เพิ่มฟิลด์ identify_soldier_id

    class Config:
        orm_mode = True

# Schema สำหรับการสร้าง Unit
class UnitCreate(UnitBase):
    pass

# Schema สำหรับการตอบกลับข้อมูล Unit
class UnitOut(UnitBase):
    units_id: int
    dept_name: str
    position_name: str

class UnitUpdate(UnitBase):
    pass

class UnitAll(BaseModel):
    name: str
    position_id: int
    dept_id: int
    skip: int = 0
    limit: int = 100

class Unittable(BaseModel):
    units_id: int
    dept_name: str
    first_name: str
    last_name: str
    position_name: str
    status: str

class UnitResponse(BaseModel):
    units: list[Unittable]
    total: int
    skip: int
    limit: int
    
