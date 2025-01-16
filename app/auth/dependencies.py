from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from app.auth.services import decode_access_token, verify_token
from app.database import get_db
from app.auth.models import User

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/auth/")

# ฟังก์ชันสำหรับรับผู้ใช้ที่ล็อกอิน
def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    payload = verify_token(token, db)  # ส่ง db ไปที่ verify_token
    if not payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
        )
    print(payload)
    username = payload.username
    if username is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token",
        )
    user = db.query(User).filter(User.username == username).first()
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found",
        )
    return user

# ฟังก์ชันสำหรับตรวจสอบ Role
def require_permission(role: str):
    def permission_dependency(current_user: User = Depends(get_current_user)):
        if current_user.role != role:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Permission denied",
            )
        return current_user
    return permission_dependency
