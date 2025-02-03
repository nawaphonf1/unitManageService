from sqlalchemy.orm import Session, class_mapper
from sqlalchemy.sql import func, and_

from app.models.unit import Unit
from app.models.position import Position
from app.models.dept import Dept
from app.models.mission import Mission
from app.models.mission_unit import MissionUnit

from app.schemas.unit import UnitCreate, UnitAll, UnitUpdate
from app.schemas.mission import UpdateMissionUnitParam

from app.services import unit_service

from datetime import date
from io import BytesIO
import pandas as pd

class MissionService:
    def del_mission(db, mission_id):
        print(mission_id)
        # อัปเดตค่า is_active เป็น 0 โดยระบุเงื่อนไขที่ต้องการ
        db.query(Mission).filter(Mission.mission_id == mission_id).update({"is_active": 0})
        db.commit()  # อย่าลืม commit เพื่อบันทึกการเปลี่ยนแปลง

    def create_mission(db: Session, data: UpdateMissionUnitParam):
        mission = Mission()

        mission.mission_name = data.mission_name
        mission.mission_start = data.mission_start
        mission.mission_end = data.mission_end
        mission.mission_detail = data.mission_detail
        mission.mission_type = data.mission_type
        mission.mission_status = "r"  # ใช้สถานะที่มีความหมาย เช่น "ready" แทน "r"
        
        db.add(mission)
        db.commit()  # ทำการ commit เพื่อบันทึกภารกิจ
        db.refresh(mission)  # รีเฟรช mission หลังจาก commit เพื่อให้ได้ข้อมูลที่อัปเดตล่าสุด

        # เพิ่ม mission units ใหม่
        for unit_id in data.mission_unit_id:
            new_mission_unit = MissionUnit(mission_id=mission.mission_id, unit_id=unit_id)
            db.add(new_mission_unit)

        db.commit()  # ทำการ commit เพื่อบันทึก mission units ใหม่

        return mission


    def get_mission_by_units_id(db: Session, unit_id: int):
        query = db.query(
            Mission.mission_id,
            MissionUnit.unit_id,
            Mission.mission_name,
            Mission.mission_start,
            Mission.mission_end,
            Mission.mission_status,
        ).\
        join(MissionUnit, Mission.mission_id == MissionUnit.mission_id).\
        filter(and_(
            MissionUnit.unit_id == unit_id,
            Mission.is_active == True
        )).all()

        return query
    
    def get_missions(db: Session, skip: int = 0, limit: int = 100):
        query = db.query(
            Mission.mission_id,
            Mission.mission_name,
            Mission.mission_start,
            Mission.mission_end,
            Mission.mission_status,
            Mission.is_active,
            Mission.created_at,
            Mission.mission_type
        ).filter(Mission.is_active == True).offset(skip).limit(limit)
        

        # Get total count for pagination
        total = query.with_entities(func.count()).scalar()

        # Apply pagination
        missions = query.offset(skip).limit(limit).all()
        
        return {
        "missions": [
            {
                "mission_id": mission.mission_id,
                "mission_name": mission.mission_name,
                "mission_start": mission.mission_start,
                "mission_end": mission.mission_end,
                "mission_status": mission.mission_status,
                "is_active": mission.is_active,
                "created_at": mission.created_at,
                "mission_type": mission.mission_type
            }
            for mission in missions
        ],
        "total": total,
        "skip": skip,
        "limit": limit,
    }

    def get_mission_by_id(db: Session, mission_id: int):
        query = db.query(
            Mission.mission_id,
            Mission.mission_name,
            Mission.mission_start,
            Mission.mission_end,
            Mission.mission_status,
            Mission.is_active,
            Mission.created_at,
            Mission.mission_type,
            Mission.mission_detail
        ).filter(and_(
            Mission.mission_id == mission_id,
            Mission.is_active == True
        )).first()

        if query is None:
            return None  # คืน None เพื่อให้ตรวจสอบได้ใน Controller
        

        
        # แปลงผลลัพธ์ให้เป็น dictionary
        return {
            "mission_id": query.mission_id,
            "mission_name": query.mission_name,
            "mission_start": query.mission_start,
            "mission_end": query.mission_end,
            "mission_status": query.mission_status,
            "is_active": query.is_active,
            "created_at": query.created_at,
            "mission_type": query.mission_type,
            "mission_detail": query.mission_detail
        }

    def get_unit_by_mission_id(db: Session, mission_id: int):
        query = db.query(
                    MissionUnit.mission_id,
                    Unit.units_id,
                    Unit.first_name,
                    Unit.last_name,
                    Position.position_id,
                    Position.position_name,
                    Position.position_name_short
                ).\
                join(Unit,Unit.units_id == MissionUnit.unit_id).\
                join(Position, Position.position_id == Unit.position_id).\
                filter(MissionUnit.mission_id ==mission_id).\
                all()
        
        return query

    def update_mission_units_service(db, mission_id: int, data: UpdateMissionUnitParam):
        # ดึง mission ที่ต้องการแก้ไขจากฐานข้อมูล
        mission = db.query(Mission).filter(Mission.mission_id == mission_id).first()

        if not mission:
            return None  # ถ้าไม่เจอ mission คืนค่า None เพื่อแจ้งว่าไม่พบข้อมูล

        # อัปเดตข้อมูล mission
        mission.mission_name = data.mission_name
        mission.mission_start = data.mission_start
        mission.mission_end = data.mission_end
        mission.mission_detail = data.mission_detail
        mission.mission_type = data.mission_type
        mission.mission_status = data.mission_status

        # ลบ mission units เก่าที่เกี่ยวข้อง
        db.query(MissionUnit).filter(MissionUnit.mission_id == mission_id).delete()

        # เพิ่ม mission units ใหม่
        for unit_id in data.mission_unit_id:
            new_mission_unit = MissionUnit(mission_id=mission_id, unit_id=unit_id)
            db.add(new_mission_unit)

        db.commit()  # บันทึกการเปลี่ยนแปลงลงฐานข้อมูล
        db.refresh(mission)  # รีเฟรชข้อมูล mission หลังการแก้ไข

        return mission


    def update_status_unit(db: Session):
        MissionService.update_status_mission(db)

        current_date = date.today()

        # ดึง units ที่ไม่พร้อมใช้งาน
        units = db.query(Unit).\
            join(MissionUnit, MissionUnit.unit_id == Unit.units_id).\
            join(Mission, Mission.mission_id == MissionUnit.mission_id).\
            filter(and_(
                Mission.mission_start <= current_date,
                Mission.mission_end >= current_date,
                Mission.is_active == True
            )).all()

        # สร้างรายการ units_id ที่ไม่พร้อม
        unit_is_not_ready = {unit.units_id for unit in units}

        # ดึง units ทั้งหมด
        all_units = db.query(Unit).filter(Unit.is_active == True).all()
        print(unit_is_not_ready)
        # อัปเดตสถานะในหน่วยความจำ
        for unit in all_units:
            unit.status = "not ready" if unit.units_id in unit_is_not_ready else "ready"

        # บันทึกการเปลี่ยนแปลงครั้งเดียว
        db.commit()

        

    def update_status_mission(db:Session):
        current_date = date.today()
        mission =  db.query(Mission).filter(Mission.is_active == True).all()
        for mission in mission:
            mission.mission_status = "r" if mission.mission_start <=  current_date and mission.mission_end >= current_date else "nr"
        
        db.commit()

    async def import_excel(db, file):
        try:
            # อ่านไฟล์ Excel จาก memory (BytesIO) ด้วย pandas
            content = await file.read()
            df = pd.read_excel(BytesIO(content))
            data = []

            # ตรวจสอบข้อมูลใน Excel
            for index, row in df.iterrows():
                dept_id = None
                print(row)
                # ตรวจสอบว่าค่าของ 'Unnamed: 1' หรือคอลัมน์อื่น ๆ ไม่เป็น NaN
                if pd.notna(row['Unnamed: 1']) and pd.notna(row['Unnamed: 2']) and pd.notna(row['Unnamed: 3']) and pd.notna(row['Unnamed: 4']):
                    data.append({
                        'position_name': row['Unnamed: 1'],
                        'first_name': row['Unnamed: 2'],
                        'last_name': row['Unnamed: 3'],
                        'identify_soldier_id': row['Unnamed: 4'],
                    })

                    position = db.query(Position.position_id,Position.position_name_short).filter(Position.position_name_short.contains(row['Unnamed: 1'])).first()
                    if(position):
                        position_id = position.position_id
                        # ตรวจสอบและลบช่องว่างจากคอลัมน์ 2, 3, 4, 16 ถึง 20
                        first_name = str(row['Unnamed: 2']).replace(" ", "") if pd.notna(row['Unnamed: 2']) else ""
                        last_name = str(row['Unnamed: 3']).replace(" ", "") if pd.notna(row['Unnamed: 3']) else ""
                        identify_id = str(row['Unnamed: 4']).replace(" ", "") if pd.notna(row['Unnamed: 4']) else ""
                        
                        identify_soldier_id = str(row['Unnamed: 5']).replace(" ", "") if pd.notna(row['Unnamed: 5']) else ""

                        dept = str(row['Unnamed: 8']).replace(" ", "") if pd.notna(row['Unnamed: 8']) else ""
                        tel = str(row['Unnamed: 9']).replace(" ", "") if pd.notna(row['Unnamed: 9']) else ""
                        blood_group_id = str(row['Unnamed: 10']).replace(" ", "") if pd.notna(row['Unnamed: 10']) else ""
                        address_detail = str(row['Unnamed: 11']).replace(" ", "") if pd.notna(row['Unnamed: 11']) else ""


                        dept_data = db.query(Dept.dept_id,Dept.dept_name_short).filter(Dept.dept_name_short == dept).first()

                        if dept_data :
                            dept_id = dept_data.dept_id
                        else:
                            dept_id = None

                        duplicate_unit = db.query(Unit).filter(Unit.identify_soldier_id == identify_soldier_id).first()
                        if(duplicate_unit):
                            updateUnit = UnitUpdate(
                                first_name = first_name,
                                last_name = last_name,
                                position_id = position_id,
                                identify_soldier_id = identify_soldier_id,
                                identify_id = identify_id,
                                tel = tel,
                                blood_group_id = blood_group_id,
                                address_detail = address_detail,
                                dept_id = dept_id
                            )
                            unit_service.update_unit(db,duplicate_unit.units_id ,updateUnit)

                        else:
                            #สร้างข้อมูล
                            dataCeateUnit = UnitCreate(
                                first_name = first_name,
                                last_name = last_name,
                                position_id = position_id,
                                identify_soldier_id = identify_soldier_id,
                                identify_id = identify_id,
                                tel = tel,
                                blood_group_id = blood_group_id,
                                address_detail = address_detail,
                                dept_id = dept_id

                            )
                            unit_service.create_unit(db, dataCeateUnit)


        except Exception as e:
            return {"error": str(e)}


        


