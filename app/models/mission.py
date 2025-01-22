from sqlalchemy import Column, Integer, String, Text, Boolean, Sequence, Date, Time, CHAR, func
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Mission(Base):
    __tablename__ = 'mission'

    mission_id = Column(
        Integer, 
        primary_key=True, 
        index=True, 
        default=Sequence('mission_id_seq', start=1, increment=1)
    )
    mission_name = Column(Text, nullable=False)  # Text type for mission_name
    mission_start = Column(Date, nullable=False)
    mission_end = Column(Date, nullable=False)
    mission_detail = Column(Text, nullable=True)
    mission_type = Column(Text, nullable=False)
    mission_status = Column(CHAR, nullable=False)  # CHAR type for mission_status
    created_at = Column(Time(timezone=True), nullable=False, server_default=func.now())  # Default to now()
    is_active = Column(Boolean, nullable=False, default=True)  # Default to true
