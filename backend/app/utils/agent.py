import ollama

def call_iam_agent(prompt: str) -> dict:
    system_prompt = (
        "You are an AWS IAM Policy assistant. Given a user prompt, "
        "generate a minimal and secure JSON IAM policy using AWS syntax. "
        "Do not explain, only return raw JSON. Avoid over-permissioning."
    )

    response = ollama.chat(
        model='mistral',
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": prompt}
        ]
    )

    try:
        # Try to safely extract JSON from model response
        import json
        raw = response['message']['content']
        return json.loads(raw)
    except Exception as e:
        return {"error": "Failed to parse policy", "raw_output": raw, "exception": str(e)}