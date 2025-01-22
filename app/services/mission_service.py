from sqlalchemy.orm import Session, class_mapper
from sqlalchemy.sql import func, and_

from app.models.unit import Unit
from app.models.position import Position
from app.models.dept import Dept
from app.models.mission import Mission
from app.models.mission_unit import MissionUnit

from app.schemas.unit import UnitCreate, UnitAll
from app.schemas.mission import UpdateMissionUnitParam

from datetime import date

class MissionService:
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
        filter(MissionUnit.unit_id == unit_id).all()

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
        ).offset(skip).limit(limit)

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
        ).filter(Mission.mission_id == mission_id).first()

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
                Mission.mission_end >= current_date
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

        


