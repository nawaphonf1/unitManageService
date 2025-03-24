from sqlalchemy import Column, Integer, String, TIMESTAMP, JSON, text
from app.database import Base

class UsageLog(Base):
    __tablename__ = "usage_logs"

    usage_logs_id = Column(Integer, primary_key=True, index=True)
    timestamp = Column(TIMESTAMP, server_default=text("CURRENT_TIMESTAMP"))
    username = Column(String(255), nullable=False)
    action = Column(String(255), nullable=False)
    details = Column(JSON, nullable=True)  # เก็บข้อมูลเป็น JSON
    ip_address = Column(String(50), nullable=True)
    user_agent = Column(String, nullable=True)
