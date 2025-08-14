import ollama
import os
import json
import re
import traceback
import traceback

ollama_host = os.getenv("OLLAMA_HOST", "http://localhost:11434")
client = ollama.Client(host=ollama_host)


def call_iam_agent(prompt: str) -> dict:
    system_prompt = (
        "You are an AWS IAM Policy assistant. Given a user prompt, "
        "generate a minimal and secure JSON IAM policy using AWS syntax. "
        "Always respond with a single valid JSON object only, no code fences, no prose. "
        "If the requested permissions are overly broad or insecure, DO NOT refuse; "
        "instead, return the closest least-privilege policy that satisfies the task. "
        "Never add explanations."
    )

    try:
        response = client.chat(
            model='gemma:2b',
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": prompt}
            ],
            stream=False
        )
        raw = response['message']['content']

        cleaned = re.sub(r"^```json\n|\n```$", "", raw.strip())

        return json.loads(cleaned)

    except json.JSONDecodeError as jde:
        return {
            "error": "Failed to parse JSON from Ollama response.",
            "raw_output": raw,
            "exception_type": type(jde).__name__,
            "exception_message": str(jde),
            "traceback": traceback.format_exc()
        }

    except Exception as e:
        return {
            "error": "Unexpected Ollama failure",
            "details": str(e),
            "exception_type": type(e).__name__,
            "traceback": traceback.format_exc()
        }
