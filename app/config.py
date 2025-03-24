from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    database_url: str

    class Config:
        env_file = ".env"

SECRET_KEY = "password123"  # แก้เป็น Key ที่ใช้จริง
ALGORITHM = "HS256"




        

settings = Settings()
