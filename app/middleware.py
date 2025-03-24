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

        # อ่าน body มาก่อน เพราะหลังจาก call_next จะอ่านไม่ได้
        body_bytes = await request.body()
        print("Body payload:", body_bytes.decode("utf-8"))

        # จำเป็นต้องสร้าง request ใหม่ เพราะ body ถูกอ่านไปแล้ว
        request = Request(request.scope, receive=lambda: {"type": "http.request", "body": body_bytes})

        response = await call_next(request)

        # ดึง Token จาก Header
        auth_header = request.headers.get("Authorization")
        username = "anonymous"

        if auth_header and auth_header.startswith("Bearer "):
            token = auth_header.split(" ")[1]
            try:
                geruser = get_current_user(db, token)
                username = geruser.username
            except JWTError:
                pass

        # ไม่บันทึก log สำหรับ paths เหล่านี้
        if not (
            request.url.path.startswith("/docs")
            or request.url.path.startswith("/openapi.json")
            or request.url.path.startswith("/static")
        ):
            log_entry = UsageLog(
                username=username,
                action=f"{request.method} {request.url.path}",
                details={
                    "query_params": dict(request.query_params),
                    "body": body_bytes.decode("utf-8")
                },
                ip_address=request.client.host,
                user_agent=request.headers.get("User-Agent"),
            )

            db.add(log_entry)
            db.commit()
            db.close()

        return response
