from fastapi import APIRouter
from app.api.routes import unit
from app.api.routes import mission
from app.api.routes import position
from app.api.routes import dept
from app.api.routes import summary
from app.api.routes import user

api_router = APIRouter()

api_router.include_router(unit.router, prefix="/unit", tags=["unit"])
api_router.include_router(mission.router, prefix="/mission", tags=["mission"])
api_router.include_router(position.router, prefix="/position", tags=["position"])
api_router.include_router(dept.router, prefix="/dept", tags=["dept"])
api_router.include_router(summary.router, prefix="/summary", tags=["summary"])
api_router.include_router(user.router, prefix="/user", tags=["user"])





