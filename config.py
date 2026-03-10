import os


class Config:
    SECRET_KEY = os.getenv("SECRET_KEY", "expotecnica-secret-key")
    SQLALCHEMY_DATABASE_URI = os.getenv(
        "DATABASE_URL",
        "mysql+pymysql://root:123456@localhost/expotecnica_db?charset=utf8mb4",
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False

