#!/bin/sh
# Lancer le serveur Ollama
ollama serve &

# Wait for Ollama to be ready
until curl -s http://localhost:11434/api/tags > /dev/null; do
  echo "⏳ Waiting for Ollama to be ready..."
  sleep 2
done
# Check if the model is already available and pull it if not
if ! ollama show gemma:2b > /dev/null 2>&1; then
  echo "📦 Pulling model gemma:2b..."
  ollama pull gemma:2b
else
  echo "✅ Model gemma:2b already available"
fi
# Maintain the foreground process
wait
