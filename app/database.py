from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from app.config import settings

# สร้าง engine สำหรับการเชื่อมต่อกับ PostgreSQL
engine = create_engine(settings.database_url)

# สร้าง session สำหรับใช้งานในแต่ละ request
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# สร้าง Base class สำหรับ ORM models
Base = declarative_base()

# Dependency สำหรับการใช้งาน session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
