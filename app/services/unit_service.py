from sqlalchemy.orm import Session
from sqlalchemy.sql import func,and_

from app.models.unit import Unit
from app.models.position import Position
from app.models.dept import Dept

from app.schemas.unit import UnitCreate, UnitAll, UnitResponse, UnitUpdate

import pandas as pd
import os
import datetime
from datetime import timedelta

from io import BytesIO
from openpyxl.drawing.image import Image

from sqlalchemy.orm import Session

from openpyxl import Workbook
from openpyxl.styles import Alignment, Font, PatternFill, Border, Side
from openpyxl.utils import get_column_letter
from io import BytesIO

from sqlalchemy import and_, func


def create_unit(db: Session, unit: UnitCreate):
    db_unit = Unit(**unit.dict())
    db.add(db_unit)
    db.commit()
    db.refresh(db_unit)
    return db_unit

def update_unit(db: Session, unit_id: int, unit: UnitUpdate):
    db.query(Unit).filter(Unit.units_id == unit_id).update(unit.dict())
    db.commit()
    return db.query(Unit).filter(Unit.units_id == unit_id).first()

def get_unit(db: Session, unit_id: int):
    query = db.query(
        Unit.units_id,
        Unit.first_name,
        Unit.last_name,
        Unit.tel,
        Unit.identify_id,
        Unit.position_id,
        Unit.dept_id,
        Unit.blood_group_id,
        Unit.province_id,
        Unit.district_id,
        Unit.parish_id,
        Unit.post_code,
        Unit.address_detail,
        Unit.status,
        Unit.is_active,
        Unit.img_path,
        Unit.identify_soldier_id,
        Position.position_name,
        Dept.dept_name,
    ).join(Position, Unit.position_id == Position.position_id) \
     .join(Dept, Unit.dept_id == Dept.dept_id) \
     .filter(Unit.units_id == unit_id) \
     .first()

    if query:
        return {
            "units_id": query.units_id,
            "first_name": query.first_name,
            "last_name": query.last_name,
            "tel": query.tel,
            "identify_id": query.identify_id,
            "position_id": query.position_id,
            "dept_id": query.dept_id,
            "blood_group_id": query.blood_group_id,
            "province_id": query.province_id,
            "district_id": query.district_id,
            "parish_id": query.parish_id,
            "post_code": query.post_code,
            "address_detail": query.address_detail,
            "status": query.status,
            "is_active": query.is_active,
            "position_name": query.position_name,
            "dept_name": query.dept_name,
            "img_path": query.img_path,
            "identify_soldier_id": query.identify_soldier_id,
        }
    return None


def get_all_units(db: Session, name=None, position_id=None, dept_id=None,status=None, skip=0, limit=100):
    # Base query with join
    query = (
        db.query(
            Unit.units_id,
            Unit.first_name,
            Unit.last_name,
            Unit.status,
            Position.position_name,
            Dept.dept_name,
        )
        .join(Position, Unit.position_id == Position.position_id)
        .join(Dept, Unit.dept_id == Dept.dept_id)
    )

    # Apply filters
    if name:
        query = query.filter(Unit.first_name.contains(name) | Unit.last_name.contains(name))
    if position_id:
        query = query.filter(Unit.position_id == position_id)
    if dept_id:
        query = query.filter(Unit.dept_id == dept_id)
    if status:
        query = query.filter(Unit.status == status)

    # Get total count for pagination
    total = query.with_entities(func.count()).scalar()

    # Apply pagination
    units = query.offset(skip).limit(limit).all()

    # Format the response
    return {
        "units": [
            {
                "units_id": unit.units_id,
                "dept_name": unit.dept_name,
                "first_name": unit.first_name,
                "last_name": unit.last_name,
                "position_name": unit.position_name,
                "status": unit.status,
            }
            for unit in units
        ],
        "total": total,
        "skip": skip,
        "limit": limit,
    }

def get_units_active(db, position_id, first_name,last_name):
    unit = db.query(
            Unit.units_id,
            Unit.first_name,
            Unit.last_name,
            Position.position_id,
            Position.position_name,
            Position.position_name_short
        ).filter(
            and_(
                Unit.status == 'ready',
                Unit.is_active == True
            )
        ).\
        join(Position, Position.position_id == Unit.position_id)
        
    if first_name:
        unit = unit.filter(Unit.first_name.contains(first_name))
    if position_id:
        unit = unit.filter(Unit.position_id == position_id)
    if last_name:
        unit = unit.filter(Unit.last_name.contains(last_name))

    unit.all()

    return unit


import requests
from io import BytesIO
from PIL import Image as PILImage
from openpyxl.drawing.image import Image as openpyxl_Image

def export_units(db):
    data = db.query(
                Unit.img_path,
                Position.position_name_short,
                Unit.first_name,
                Unit.last_name,
                Dept.dept_name_short,
                Unit.identify_id,
                Unit.identify_soldier_id,
                Unit.tel,
                Unit.blood_group_id,
                Unit.address_detail
            ).\
            join(Position, Position.position_id == Unit.position_id).\
            join(Dept, Dept.dept_id == Unit.dept_id).\
            all()
            
    orders_list = []
    index = 1
    for item in data:
        orders_list.append({
            "ลำดับ": index,
            "รูปภาพ": item.img_path,
            "ยศ": item.position_name_short,
            "ชื่อ": item.first_name,
            "นามสกุล": item.last_name,
            "สังกัด": item.dept_name_short,
            "หมายเลขประจำตัว": item.identify_id,
            "หมายเลขประจำตัวทหาร": item.identify_soldier_id,
            "เบอร์โทร": item.tel,
            "กรุ๊ปเลือด": item.blood_group_id,
            "ที่อยู่": item.address_detail
        })
        index += 1

    # สร้าง DataFrame จากข้อมูล
    df = pd.DataFrame(orders_list)

    # สร้างไฟล์ Excel พร้อม Style
    excel_file = BytesIO()

    with pd.ExcelWriter(excel_file, engine='openpyxl') as writer:
        df.to_excel(writer, index=False, sheet_name="รายงาน")
        workbook = writer.book
        worksheet = writer.sheets["รายงาน"]

        # ปรับความกว้างของคอลัมน์
        for column_cells in worksheet.columns:
            max_length = 0
            col_letter = column_cells[0].column_letter
            for cell in column_cells:
                try:
                    if cell.value:
                        max_length = max(max_length, len(str(cell.value)))
                except:
                    pass
            worksheet.column_dimensions[col_letter].width = max_length + 2

        # กำหนด Style
        header_font = Font(bold=True, color="FFFFFF")
        header_fill = PatternFill(fill_type="solid", fgColor="4F81BD")
        border_style = Border(
            left=Side(border_style="thin"),
            right=Side(border_style="thin"),
            top=Side(border_style="thin"),
            bottom=Side(border_style="thin"),
        )
        alignment = Alignment(horizontal="center", vertical="center")

        # จัดการหัวตาราง
        for cell in worksheet[1]:
            cell.font = header_font
            cell.fill = header_fill
            cell.border = border_style
            cell.alignment = alignment

        # แทรกรูปภาพในคอลัมน์ "รูปภาพ"
        for i, item in enumerate(data, start=2):  # เริ่มที่แถวที่ 2 (แถวข้อมูล)
            print(item)
            img_path = item.img_path
            if img_path:  # เช็คว่ามี path ของภาพ
                try:
                    # ดาวน์โหลดภาพจาก URL
                    response = requests.get(img_path)
                    if response.status_code == 200:
                        img = PILImage.open(BytesIO(response.content))
                        img = img.resize((40, 40))  # ปรับขนาดรูปภาพเป็น 40x40 พิกเซล

                        # แปลงรูปภาพให้เป็น Image ของ openpyxl
                        img_io = BytesIO()
                        img.save(img_io, format="PNG")
                        img_io.seek(0)

                        img_openpyxl = openpyxl_Image(img_io)
                        img_openpyxl.width = 40
                        img_openpyxl.height = 40

                        # แทรกภาพลงในเซลล์ที่ต้องการ (คอลัมน์ "รูปภาพ")
                        worksheet.add_image(img_openpyxl, f'A{i}')  # แทรกในคอลัมน์ "A" ที่แถว i
                    else:
                        print(f"Failed to download image from {img_path}")
                except Exception as e:
                    print(f"Error loading image {img_path}: {e}")
    # รีเซ็ต pointer และส่งไฟล์
    excel_file.seek(0)
    return excel_file

