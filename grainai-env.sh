#!/usr/bin/env bash
# GrainAI Environment Configuration Template
# Source this file to set environment variables for GrainAI services

# Installation paths
export GRAINAI_PREFIX="/opt/grainai"
export GRAINAI_BACKEND="$GRAINAI_PREFIX/backend"
export GRAINAI_FRONTEND="$GRAINAI_PREFIX/frontend"
export GRAINAI_CONFIG="$GRAINAI_PREFIX/config/grainai.json"
export GRAINAI_LOGS="$GRAINAI_PREFIX/logs"

# Service user
export GRAINAI_USER="grainai"
export GRAINAI_GROUP="grainai"

# Port configuration
export GRAINAI_BACKEND_PORT=8000
export GRAINAI_FRONTEND_PORT=3000
export GRAINAI_OLLAMA_PORT=11434

# API endpoints
export GRAINAI_BACKEND_URL="http://localhost:$GRAINAI_BACKEND_PORT"
export GRAINAI_FRONTEND_URL="http://localhost:$GRAINAI_FRONTEND_PORT"
export GRAINAI_OLLAMA_URL="http://localhost:$GRAINAI_OLLAMA_PORT"

# Logging
export GRAINAI_LOG_LEVEL="INFO"
export GRAINAI_LOG_FILE="$GRAINAI_LOGS/grainai.log"

# systemd service management
alias grainai-start="sudo systemctl start grainai.target"
alias grainai-stop="sudo systemctl stop grainai.target"
alias grainai-restart="sudo systemctl restart grainai.target"
alias grainai-status="sudo systemctl status grainai.target"
alias grainai-logs="journalctl -u grainai-backend -f"
alias grainai-logs-ollama="journalctl -u grainai-ollama -f"
alias grainai-logs-frontend="journalctl -u grainai-frontend -f"

# Helper functions
grainai-enable() {
    echo "Enabling GrainAI services for auto-start..."
    sudo systemctl enable grainai.target
    echo "✓ Services enabled"
}

grainai-disable() {
    echo "Disabling GrainAI services from auto-start..."
    sudo systemctl disable grainai.target
    echo "✓ Services disabled"
}

grainai-install-units() {
    echo "Installing systemd units..."
    sudo cp systemd/*.service /etc/systemd/system/
    sudo cp systemd/*.target /etc/systemd/system/
    sudo systemctl daemon-reload
    echo "✓ systemd units installed"
}

echo "✓ GrainAI environment loaded"
echo "  Commands available:"
echo "    grainai-start, grainai-stop, grainai-restart, grainai-status"
echo "    grainai-logs, grainai-logs-ollama, grainai-logs-frontend"
echo "    grainai-enable, grainai-disable"
