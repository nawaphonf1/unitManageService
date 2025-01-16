from sqlalchemy import Column, Integer, String, BigInteger, Text, Boolean, Sequence
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Unit(Base):
    __tablename__ = 'units'

    units_id = Column(
        Integer, 
        primary_key=True, 
        index=True, 
        default=Sequence('units_units_id_seq', start=1, increment=1)
    )
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    tel = Column(String(10), nullable=True)
    position_id = Column(Integer, nullable=False)
    dept_id = Column(Integer, nullable=False)
    blood_group_id = Column(String(2), nullable=True)
    province_id = Column(Integer, nullable=True)
    district_id = Column(Integer, nullable=True)
    parish_id = Column(Integer, nullable=True)
    post_code = Column(BigInteger, nullable=True)
    address_detail = Column(Text, nullable=True)
    identify_id = Column(Text, nullable=True)
    status = Column(Text, nullable=True)
    is_active = Column(Boolean, nullable=False, default=True)
    img_path = Column(Text, nullable=True)
    identify_soldier_id = Column(Text, nullable=True)
