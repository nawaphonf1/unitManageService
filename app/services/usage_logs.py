from sqlalchemy.orm import Session
from sqlalchemy.sql import func,and_, or_
from sqlalchemy import desc

from app.models.usage_logs import UsageLog
from app.schemas.usage_logs import UsageLogCreate, UsageLogResponse

class UsageLogService:
    # create usage log
    def create_usage_log(log: UsageLogCreate, db: Session, request):
        log_entry = UsageLog(
            username=log.username,
            action=log.action,
            details=log.details
        )
        db.add(log_entry)
        db.commit()
        db.refresh(log_entry)
        return log_entry
