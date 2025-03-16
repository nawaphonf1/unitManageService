from fastapi import FastAPI, Form, Request
from fastapi.responses import RedirectResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from app.api import api_router
from app.auth import auth_api_router

app = FastAPI()

# Static Files and Templates
app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")
app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")

# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Include API Routers
app.include_router(api_router, prefix="/api")
app.include_router(auth_api_router, prefix="/api")

# Route for Login Page
@app.get("/")
def login_page(request: Request):
    return templates.TemplateResponse("login.html", {"request": request})

# Route for Index Page
@app.get("/index")
def index_page(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})

# Route for Index Page
@app.get("/unit")
def unit_page(request: Request):
    return templates.TemplateResponse("unit.html", {"request": request})

@app.get("/mission")
def unit_page(request: Request):
    return templates.TemplateResponse("mission.html", {"request": request})


@app.get("/register")
def unit_page(request: Request):
    return templates.TemplateResponse("register.html", {"request": request})

@app.get("/user_manage")
def unit_page(request: Request):
    return templates.TemplateResponse("user_manage.html", {"request": request})

