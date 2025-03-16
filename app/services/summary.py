from sqlalchemy.orm import Session
from sqlalchemy.sql import func, and_

from datetime import date

from app.models.unit import Unit
from app.models.position import Position
from app.models.dept import Dept
from app.models.mission import Mission
from app.models.mission_unit import MissionUnit

from app.schemas.unit import UnitCreate, UnitAll

class SummaryService:
    def get_summary(db, date_start, date_end):
        # get all unit
        unit = db.query(
            Unit.units_id,
            MissionUnit.mission_id,
            Mission.mission_start,
            Mission.mission_end,
        ).outerjoin(MissionUnit, MissionUnit.unit_id == Unit.units_id).\
        outerjoin(Mission, Mission.mission_id == MissionUnit.mission_id).\
        filter(and_(Unit.is_active == True,Mission.is_active == True)).\
        all()

        date_today = date.today()
        
        unit_all_lsit = []
        unit_not_doing_mission_list = []
        unit_pending_list = []

        for u in unit:
            if u.units_id not in unit_all_lsit:
                unit_all_lsit.append(u.units_id)

            if u.units_id not in unit_not_doing_mission_list:
                if u.mission_end:
                    if u.mission_end < date_today:
                        unit_not_doing_mission_list.append(u.units_id)
                    if u.mission_end > date_today:
                        if u.units_id in unit_not_doing_mission_list:
                            unit_not_doing_mission_list.remove(u.units_id)

            if u.units_id not in unit_pending_list:
                if u.mission_start:
                    if u.mission_start > date_today:
                        unit_pending_list.append(u.units_id)

        unit_all = len(unit_all_lsit)
        unit_not_doing_mission = len(unit_not_doing_mission_list)
        unit_pending = len(unit_pending_list)
        unit_doing_mission = unit_all - (unit_not_doing_mission + unit_pending) 


        # get all mission
        mission_data = db.query(Mission).filter(Mission.is_active == True).all()

        mission_all = len(mission_data)
        mission_doing = 0
        mission_pending = 0
        mission_done = 0

        for mission in mission_data:
            if mission.mission_status == 'r':
                mission_doing += 1
            if mission.mission_status == 'w':
                mission_pending += 1
            if mission.mission_status == 'n':
                mission_done += 1

        return {
            "unit_all": unit_all,
            "unit_doing_mission": unit_doing_mission,
            "unit_not_doing_mission": unit_not_doing_mission,
            "unit_pending": unit_pending,
            "mission_all": mission_all,
            "mission_doing": mission_doing,
            "mission_pending": mission_pending,
            "mission_done": mission_done,
        }


