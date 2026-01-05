"""Configuration management for GrainAI."""
import json
import os
from typing import List
from pydantic import BaseModel, Field


class Settings(BaseModel):
    """Application settings."""
    
    # OLLAMA Configuration
    ollama_host: str = Field(default="http://localhost:11434", env="OLLAMA_HOST")
    ollama_model: str = Field(default="gemma:2b", env="OLLAMA_MODEL")
    
    # API Configuration
    api_host: str = Field(default="0.0.0.0", env="API_HOST")
    api_port: int = Field(default=8000, env="API_PORT")
    api_title: str = "IAM Prompt Generator API"
    
    # CORS Configuration
    cors_origins: List[str] = Field(
        default=["http://localhost:3000", "http://localhost:5173"],
        env="CORS_ORIGINS"
    )
    
    # Logging
    log_level: str = Field(default="INFO", env="LOG_LEVEL")
    
    class Config:
        env_file = ".env"
        case_sensitive = False


def load_config_from_file(config_path: str) -> Settings:
    """Load configuration from JSON file.
    
    Args:
        config_path: Path to JSON configuration file.
        
    Returns:
        Settings object with values from file.
    """
    if not os.path.exists(config_path):
        return Settings()
    
    with open(config_path, 'r') as f:
        config_dict = json.load(f)
    
    return Settings(**config_dict)
