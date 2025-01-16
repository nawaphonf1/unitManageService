from sqlalchemy.orm import Session
from sqlalchemy.sql import func

from app.models.unit import Unit
from app.models.position import Position
from app.models.dept import Dept
from app.models.mission import Mission
from app.models.mission_unit import MissionUnit

from app.schemas.unit import UnitCreate, UnitAll

class DeptService:
    def get_all_dept(db: Session):
        return db.query(Dept).all()

