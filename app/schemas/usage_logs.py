from pydantic import BaseModel
from typing import Optional, Dict
from datetime import datetime

class UsageLogBase(BaseModel):
    username: str
    action: str
    details: Optional[Dict] = None
    ip_address: Optional[str] = None
    user_agent: Optional[str] = None

class UsageLogCreate(UsageLogBase):
    pass

class UsageLogResponse(UsageLogBase):
    usage_logs_id: int
    timestamp: datetime

    class Config:
        from_attributes = True
