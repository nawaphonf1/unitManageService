from sqlalchemy import Column, Integer, String, Text, Boolean, Sequence, Date, Time, CHAR, func
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class MissionUnit(Base):
    __tablename__ = 'mission_unit'

    mission_unit_id = Column(
        Integer, 
        primary_key=True, 
        index=True, 
        default=Sequence('mission_unit_id_seq', start=1, increment=1)
    )
    unit_id = Column(Integer, nullable=False)
    mission_id = Column(Integer, nullable=False)
    created_at= Column(Time(timezone=True), nullable=False, server_default=func.now())
