from sqlalchemy import Column, Integer, String, Boolean, Time, CHAR, func
from app.database import Base

class User(Base):
    __tablename__ = "users"

    user_id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    is_active = Column(Boolean, default=False)
    role = Column(String, default="user")  # เช่น "admin" หรือ "user"
    created_at = Column(Time(timezone=True), nullable=False, server_default=func.now()) 
