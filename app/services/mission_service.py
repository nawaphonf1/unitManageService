from sqlalchemy.orm import Session
from sqlalchemy.sql import func

from app.models.unit import Unit
from app.models.position import Position
from app.models.dept import Dept
from app.models.mission import Mission
from app.models.mission_unit import MissionUnit

from app.schemas.unit import UnitCreate, UnitAll

class MissionService:
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

