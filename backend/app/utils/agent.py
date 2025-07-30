import ollama
import os
import json

ollama_host = os.getenv("OLLAMA_HOST", "http://localhost:11434")
client = ollama.Client(host=ollama_host)


def call_iam_agent(prompt: str) -> dict:
    system_prompt = (
        "You are a strict AWS IAM policy generator. "
        "Only return valid JSON IAM policies. No explanations."
    )

    try:
        response = client.chat(
            model='mistral',
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": prompt}
            ],
            stream=False
        )
        raw = response['message']['content']
        return json.loads(raw)

    except json.JSONDecodeError:
        return {
            "error": "❌ Failed to parse JSON from Ollama response.",
            "raw_output": raw
        }

    except Exception as e:
        return {
            "error": "💥 Unexpected Ollama failure",
            "details": str(e)
        }