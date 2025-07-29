from fastapi import FastAPI
from app.routes import iam

app = FastAPI(title="IAM Prompt Generator API")

app.include_router(iam.router)
