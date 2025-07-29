from pydantic import BaseModel
from typing import List, Union

class PromptRequest(BaseModel):
    prompt: str

class PolicyResponse(BaseModel):
    policy_json: dict
    warnings: Union[List[str], None] = []