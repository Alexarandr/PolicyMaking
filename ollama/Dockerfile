FROM ollama/ollama

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy and make executable the startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose the Ollama API port
EXPOSE 11434

# Run the startup script
ENTRYPOINT ["/start.sh"]