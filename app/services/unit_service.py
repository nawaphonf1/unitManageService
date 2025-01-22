from sqlalchemy.orm import Session
from sqlalchemy.sql import func,and_

from app.models.unit import Unit
from app.models.position import Position
from app.models.dept import Dept

from app.schemas.unit import UnitCreate, UnitAll, UnitResponse, UnitUpdate

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

