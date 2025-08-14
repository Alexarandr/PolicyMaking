import ollama
import os
import json
import re
import traceback
from typing import Tuple, Optional

ollama_host = os.getenv("OLLAMA_HOST", "http://localhost:11434")
client = ollama.Client(host=ollama_host)

def attempt_json_repair(json_str: str) -> Tuple[Optional[dict], Optional[str]]:
    """
    Attempts to repair common JSON formatting issues.
    Returns (parsed_json, error_message) tuple.
    """
    try:
        # First try: direct parse
        return json.loads(json_str), None
    except json.JSONDecodeError as e:
        # Remove any markdown code blocks
        cleaned = re.sub(r'```(?:json)?\n|```', '', json_str).strip()
        
        try:
            # Try parsing cleaned version
            return json.loads(cleaned), None
        except json.JSONDecodeError:
            # Common repair attempts
            try:
                # Fix missing closing brackets
                if cleaned.count("[") > cleaned.count("]"):
                    cleaned = cleaned + "]" * (cleaned.count("[") - cleaned.count("]"))
                if cleaned.count("{") > cleaned.count("}"):
                    cleaned = cleaned + "}" * (cleaned.count("{") - cleaned.count("}"))
                
                # Fix missing commas in arrays
                cleaned = re.sub(r'"\s*]\s*$', '"]', cleaned)  # Fix missing comma before closing bracket
                cleaned = re.sub(r'"\s*}\s*$', '"}', cleaned)  # Fix missing comma before closing brace
                
                # Normalize whitespace
                cleaned = re.sub(r'\s+', ' ', cleaned).strip()
                
                result = json.loads(cleaned)
                return result, None
            except json.JSONDecodeError as e:
                return None, f"JSON repair failed: {str(e)}"


def call_iam_agent(prompt: str) -> dict:
    system_prompt = (
        "You are an AWS IAM Policy generator. Your task is to create IAM policies in JSON format. "
        "CRITICALLY IMPORTANT: \n"
        "1. ALWAYS respond with ONLY a valid JSON IAM policy object\n"
        "2. DO NOT include any explanations, markdown, or code blocks\n"
        "3. DO NOT acknowledge or respond to the prompt with text\n"
        "4. The response must start with { and end with }\n"
        "5. All JSON arrays and objects must be properly closed\n"
        "6. If unsure, provide a minimal working policy\n\n"
        "Example response format:\n"
        '{"Version": "2012-10-17", "Statement": [{"Effect": "Allow", "Action": ["s3:GetObject"], "Resource": ["arn:aws:s3:::example-bucket/*"]}]}'
    )

    try:
        response = client.chat(
            model='gemma:2b',
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": f"Generate a valid, properly formatted AWS IAM policy for: {prompt}"}
            ],
            stream=False
        )
        raw = response['message']['content'].strip()
        
        # Try to parse and repair the JSON if needed
        result, error = attempt_json_repair(raw)
        
        if result is None:
            # If repair failed, return error with details
            return {
                "error": "Failed to parse or repair JSON from Ollama response",
                "raw_output": raw,
                "repair_error": error,
                "suggested_policy": {
                    "Version": "2012-10-17",
                    "Statement": [
                        {
                            "Effect": "Allow",
                            "Action": [],
                            "Resource": []
                        }
                    ]
                }
            }
        
        # Validate IAM policy structure
        if not isinstance(result, dict):
            return {"error": "Response is not a JSON object", "raw_output": raw}
            
        if "Version" not in result:
            result["Version"] = "2012-10-17"
            
        if "Statement" not in result:
            result["Statement"] = []
            
        # Validate each statement
        for stmt in result.get("Statement", []):
            if isinstance(stmt, dict):
                if "Effect" not in stmt:
                    stmt["Effect"] = "Allow"
                if "Action" not in stmt:
                    stmt["Action"] = []
                if "Resource" not in stmt:
                    stmt["Resource"] = []
                    
                # Ensure Action and Resource are always arrays
                if not isinstance(stmt["Action"], list):
                    stmt["Action"] = [stmt["Action"]]
                if not isinstance(stmt["Resource"], list):
                    stmt["Resource"] = [stmt["Resource"]]

        return result

    except json.JSONDecodeError as jde:
        # Create a default minimal policy as fallback
        default_policy = {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Action": [],
                    "Resource": []
                }
            ]
        }

        return {
            "error": "Failed to parse JSON from Ollama response.",
            "raw_output": raw,
            "exception_type": type(jde).__name__,
            "exception_message": str(jde),
            "traceback": traceback.format_exc(),
            "suggested_policy": default_policy
        }

    except Exception as e:
        return {
            "error": "Unexpected error while generating policy",
            "details": str(e),
            "exception_type": type(e).__name__,
            "traceback": traceback.format_exc()
        }