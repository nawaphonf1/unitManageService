from fastapi import APIRouter
from app.api.routes import unit
from app.api.routes import mission

api_router = APIRouter()

api_router.include_router(unit.router, prefix="/unit", tags=["unit"])
api_router.include_router(mission.router, prefix="/mission", tags=["mission"])



