#!/bin/bash
set -e

# Start Ollama server in background
echo "🚀 Starting Ollama server..."
ollama serve &
OLLAMA_PID=$!

# Wait for Ollama to be ready
echo "⏳ Waiting for Ollama to be ready..."
for i in {1..30}; do
  if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    echo "✅ Ollama is ready"
    break
  fi
  echo "⏳ Still waiting... ($i/30)"
  sleep 2
done

# Pull model if not already available
echo "📦 Checking for model gemma:2b..."
if ollama list | grep -q "gemma:2b"; then
  echo "✅ Model gemma:2b is already available"
else
  echo "📥 Pulling model gemma:2b (this may take a few minutes)..."
  ollama pull gemma:2b
fi

echo "✨ Ollama is ready with gemma:2b model"

# Keep the container running
wait $OLLAMA_PID
