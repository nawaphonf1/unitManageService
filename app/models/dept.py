from sqlalchemy import Column, Integer, String, BigInteger, Text, Boolean, Sequence
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Dept(Base):
    __tablename__ = 'dept'

    dept_id = Column(
        Integer, 
        primary_key=True, 
        index=True, 
        default=Sequence('dept_dept_id_seq', start=1, increment=1)
    )
    dept_name = Column(String(100), nullable=False)
    dept_name_short = Column(String(100), nullable=False)