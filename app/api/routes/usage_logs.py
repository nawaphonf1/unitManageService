from fastapi import APIRouter, Depends, Request
from sqlalchemy.orm import Session
from sqlalchemy import desc

from app.database import get_db

from app.schemas.usage_logs import UsageLogCreate, UsageLogResponse

from app.models.usage_logs import UsageLog

router = APIRouter()

@router.post("/", response_model=UsageLogResponse)
def create_usage_log(log: UsageLogCreate, db: Session = Depends(get_db), request: Request = None):
    log_entry = UsageLog(
        username=log.username,
        action=log.action,
        details=log.details,
        ip_address=request.client.host if request else None,
        user_agent=request.headers.get("User-Agent") if request else None
    )
    db.add(log_entry)
    db.commit()
    db.refresh(log_entry)
    return log_entry

@router.get("/", response_model=list[UsageLogResponse])
def get_usage_logs(db: Session = Depends(get_db)):
    return db.query(UsageLog).order_by(desc(UsageLog.timestamp)).all()

#get log by username have pagination
@router.get("/username/{username}", response_model=list[UsageLogResponse])
def get_usage_logs_by_username(
        username: str, 
        skip: int = 0,
        limit: int = 100, 
        db: Session = Depends(get_db)):
    return db.query(UsageLog).filter(UsageLog.username == username).order_by(desc(UsageLog.timestamp)).offset(skip).limit(limit).all()
