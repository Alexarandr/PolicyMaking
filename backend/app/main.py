"""FastAPI application entrypoint."""
import logging
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routes import iam
from app.config import Settings, load_config_from_file

logger = logging.getLogger(__name__)


def create_app(config: Settings = None, config_path: str = None) -> FastAPI:
    """Create and configure FastAPI application.
    
    Args:
        config: Settings object. If None, loads from config_path.
        config_path: Path to configuration file. Required if config is None.
        
    Returns:
        Configured FastAPI application instance.
    """
    if config is None:
        if config_path is None:
            config = Settings()
            logger.info("Using default configuration")
        else:
            config = load_config_from_file(config_path)
            logger.info(f"Loaded configuration from {config_path}")
    
    app = FastAPI(title="IAM Prompt Generator API")
    
    # Store config on app for later access
    app.config = config
    
    # Configure CORS
    app.add_middleware(
        CORSMiddleware,
        allow_origins=config.cors_origins,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )
    
    # Include routers
    app.include_router(iam.router)
    
    logger.info(
        f"Application initialized: {config.api_host}:{config.api_port} "
        f"(OLLAMA: {config.ollama_host})"
    )
    
    return app


# Default app instance for direct uvicorn execution
app = create_app()


if __name__ == "__main__":
    import uvicorn
    config = Settings()
    logging.basicConfig(
        level=getattr(logging, config.log_level),
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    )
    uvicorn.run(
        app,
        host=config.api_host,
        port=config.api_port
    )
