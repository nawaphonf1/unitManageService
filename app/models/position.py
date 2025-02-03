from sqlalchemy import Column, Integer, String, BigInteger, Text, Boolean, Sequence
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Position(Base):
    __tablename__ = 'position'

    position_id = Column(
        Integer, 
        primary_key=True, 
        index=True, 
        default=Sequence('position_position_id_seq', start=1, increment=1)
    )
    position_name = Column(String(100), nullable=False)
    position_name_short = Column(String(100), nullable=False)
    position_seq = Column(Integer, nullable=False)