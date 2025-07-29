from fastapi import APIRouter
from app.models.policy import PromptRequest, PolicyResponse
from app.services.iam_generator import generate_policy_from_prompt

router = APIRouter(prefix="/iam", tags=["IAM"])

@router.post("/generate", response_model=PolicyResponse)
def generate_iam_policy(payload: PromptRequest):
    return generate_policy_from_prompt(payload.prompt)
