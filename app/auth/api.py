from fastapi import APIRouter, Depends, HTTPException, Form
from sqlalchemy.orm import Session
from datetime import timedelta
from app.database import get_db
from app.auth.services import create_user, authenticate_user, create_access_token
from app.auth.schemas import UserCreate, Token, LoginRequest
from app.auth.dependencies import get_current_user

router = APIRouter()

@router.post("/register", response_model=Token)
def register_user(user: UserCreate, db: Session = Depends(get_db)):
    user_in_db = create_user(db, user)
    access_token = create_access_token(data={"sub": user_in_db.username})
    return {"access_token": access_token, "token_type": "bearer"}


@router.post("/auth/", response_model=Token)
def login_user(
    username: str = Form(...),  # รับข้อมูลจาก Form Data
    password: str = Form(...),  # รับข้อมูลจาก Form Data
    db: Session = Depends(get_db)
):
    # ตรวจสอบข้อมูลผู้ใช้
    user = authenticate_user(db, username, password)
    if not user:
        raise HTTPException(status_code=400, detail="Invalid username or password")
    
    # สร้าง token และส่งกลับ
    access_token = create_access_token(data={"sub": user.username})
    return {"access_token": access_token, "token_type": "bearer"}