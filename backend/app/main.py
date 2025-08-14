from fastapi import FastAPI
from app.routes import iam
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="IAM Prompt Generator API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(iam.router)
