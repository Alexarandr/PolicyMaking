from app.utils.agent import call_iam_agent
from app.utils.linter import lint_iam_policy

def generate_policy_from_prompt(prompt: str):
    policy = call_iam_agent(prompt)
    lint_warnings = lint_iam_policy(policy)
    return {
        "policy_json": policy,
        "warnings": lint_warnings
    }
