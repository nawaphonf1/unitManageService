from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class LoginRequest(BaseModel):
    username: str
    password: str

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    username: str | None = None

class UserBase(BaseModel):
    username: str

class UserCreate(UserBase):
    password: str

class UserResponse(UserBase):
    id: int
    is_active: bool

    class Config:
        orm_mode = True

class UserB(BaseModel):
    username: str
    role: str
    is_active: bool
    created_at: datetime


class UserResponseList(BaseModel):
    user: list[UserB]
    total: int
    skip: int
    limit: int
