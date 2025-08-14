import ollama
import os
import json
import re

ollama_host = os.getenv("OLLAMA_HOST", "http://localhost:11434")
client = ollama.Client(host=ollama_host)


def call_iam_agent(prompt: str) -> dict:
    system_prompt = (
        "You are a strict AWS IAM policy generator. "
        "Only return valid JSON IAM policies. No explanations."
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

        # 💡 Nettoyage des ```json blocs Markdown
        cleaned = re.sub(r"^```json\n|\n```$", "", raw.strip())

        return json.loads(cleaned)

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
