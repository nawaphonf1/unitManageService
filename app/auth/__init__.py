from fastapi import APIRouter
from app.auth import api

auth_api_router = APIRouter()

auth_api_router.include_router(api.router, tags=["Auth"])
