from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import Response
from sqlalchemy.orm import Session
from jose import jwt, JWTError
from app.models.usage_logs import UsageLog
from app.database import SessionLocal
from app.config import SECRET_KEY, ALGORITHM

from app.auth.services import get_current_user

class LoggingMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        db: Session = SessionLocal()
        response = await call_next(request)

        # ดึง Token จาก Header
        auth_header = request.headers.get("Authorization")
        username = "anonymous"  # ค่า default ถ้าไม่มี token



        if auth_header and auth_header.startswith("Bearer "):
            token = auth_header.split(" ")[1]

            try:
                geruser = get_current_user(db, token)
                username = geruser.username  # ดึง username จาก payload
            except JWTError:
                pass  # ถ้า token ไม่ถูกต้องจะใช้ "anonymous"

        if request.url.path != "/docs" or request.url.path != "/openapi.json" or request.url.path.like("/static"):

            # บันทึก Log ลงฐานข้อมูล
            log_entry = UsageLog(
                username=username,
                action=f"{request.method} {request.url.path}",
                details={"query_params": dict(request.query_params)},
                ip_address=request.client.host,
                user_agent=request.headers.get("User-Agent"),
            )

            db.add(log_entry)
            db.commit()
            db.close()

            return response
