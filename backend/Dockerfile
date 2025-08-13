FROM python:3.11-slim

WORKDIR /app

# Install curl for healthcheck
RUN apt-get update && apt-get install -y curl

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

# Add healthcheck script - using correct endpoint
RUN echo '#!/bin/bash\n\
curl -sf http://ollama:11434/api/tags && \
curl -sf -X POST http://ollama:11434/api/generate -d '"'"'{"model": "gemma:2b", "prompt": "test"}'"'"'' > /healthcheck.sh && \
chmod +x /healthcheck.sh

# Add healthcheck
HEALTHCHECK --interval=10s --timeout=5s --start-period=20s --retries=3 \
    CMD /healthcheck.sh

# Start the FastAPI application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]