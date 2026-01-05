#!/bin/bash
"""
GrainAI Complete Installation & Orchestration Script

Installs and configures GrainAI with systemd service management.
Replicates Docker Compose services using native systemd units.

Services:
  • OLLAMA (Language Model Runtime)
  • Backend (FastAPI + Python)
  • Frontend (React)

Usage:
  sudo ./install.sh [OPTIONS]

Options:
  --prefix /path/to/install    Base installation directory (default: /opt/grainai)
  --user username              System user to run services (default: grainai)
  --backend-port 8000          Backend API port (default: 8000)
  --frontend-port 3000         Frontend port (default: 3000)
  --ollama-port 11434          OLLAMA port (default: 11434)
  --skip-ollama                Skip OLLAMA installation
  --help                       Show this help message
"""

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default Configuration
INSTALL_PREFIX="/opt/grainai"
SERVICE_USER="grainai"
SERVICE_GROUP="grainai"
BACKEND_PORT=8000
FRONTEND_PORT=3000
OLLAMA_PORT=11434
SKIP_OLLAMA=false
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Logging functions
log_info() { echo -e "${BLUE}ℹ ${NC}$1"; }
log_success() { echo -e "${GREEN}✓ ${NC}$1"; }
log_error() { echo -e "${RED}✗ ${NC}$1"; }
log_section() { echo ""; echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; echo -e "${YELLOW}  $1${NC}"; echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; }

# Parse arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --prefix) INSTALL_PREFIX="$2"; shift 2 ;;
            --user) SERVICE_USER="$2"; SERVICE_GROUP="$2"; shift 2 ;;
            --backend-port) BACKEND_PORT="$2"; shift 2 ;;
            --frontend-port) FRONTEND_PORT="$2"; shift 2 ;;
            --ollama-port) OLLAMA_PORT="$2"; shift 2 ;;
            --skip-ollama) SKIP_OLLAMA=true; shift ;;
            --help) echo "$0" | head -n 40; exit 0 ;;
            *) log_error "Unknown option: $1"; exit 1 ;;
        esac
    done
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root (use: sudo ./install.sh)"
        exit 1
    fi
}

check_prerequisites() {
    log_section "Checking Prerequisites"
    
    local missing=false
    
    for cmd in git python3 curl; do
        if command -v "$cmd" &> /dev/null; then
            log_success "Found: $cmd"
        else
            log_error "Missing: $cmd"
            missing=true
        fi
    done
    
    # Special handling for npm (may be in nvm)
    if command -v npm &> /dev/null; then
        log_success "Found: npm"
    elif [ -f "$HOME/.nvm/nvm.sh" ]; then
        log_success "Found: npm (via nvm, will source before build)"
    else
        log_error "Missing: npm"
        missing=true
    fi
    
    if [ "$missing" = true ]; then
        log_error "Please install missing dependencies"
        exit 1
    fi
}

create_service_user() {
    log_section "Creating Service User"
    
    if id "$SERVICE_USER" &>/dev/null; then
        log_success "User '$SERVICE_USER' exists"
    else
        log_info "Creating system user '$SERVICE_USER'..."
        useradd --system --home "$INSTALL_PREFIX" --shell /bin/bash "$SERVICE_USER" 2>/dev/null || true
        log_success "User '$SERVICE_USER' created"
    fi
}

create_directories() {
    log_section "Creating Directory Structure"
    
    mkdir -p "$INSTALL_PREFIX"/{backend,frontend,ollama,config,logs}
    chown -R "$SERVICE_USER:$SERVICE_GROUP" "$INSTALL_PREFIX"
    chmod 755 "$INSTALL_PREFIX"
    
    log_success "Created: $INSTALL_PREFIX"
}

build_backend() {
    log_section "Building Backend Binary"
    
    if [ ! -f "$REPO_ROOT/backend/requirements.txt" ]; then
        log_error "Backend requirements.txt not found"
        exit 1
    fi
    
    log_info "Setting up Python environment..."
    cd "$REPO_ROOT/backend"
    python3 -m venv venv
    source venv/bin/activate
    
    log_info "Installing dependencies..."
    pip install -q --upgrade pip setuptools wheel
    pip install -q -r requirements.txt
    pip install -q pyinstaller
    
    # Create cli.py if it doesn't exist
    if [ ! -f "cli.py" ]; then
        log_info "Creating CLI entrypoint..."
        cat > cli.py << 'EOFCLI'
#!/usr/bin/env python3
import sys
import argparse
import logging
from pathlib import Path

backend_path = Path(__file__).parent
if str(backend_path) not in sys.path:
    sys.path.insert(0, str(backend_path))

from app.main import app as fastapi_app
import uvicorn

def main():
    parser = argparse.ArgumentParser(prog="grainai", description="GrainAI Backend API")
    parser.add_argument("--host", default="0.0.0.0", help="Bind address")
    parser.add_argument("--port", type=int, default=8000, help="Listen port")
    parser.add_argument("--log-level", default="INFO", choices=["DEBUG", "INFO", "WARNING", "ERROR"])
    args = parser.parse_args()
    
    logging.basicConfig(
        level=getattr(logging, args.log_level),
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    )
    
    uvicorn.run(fastapi_app, host=args.host, port=args.port, log_level=args.log_level.lower())

if __name__ == "__main__":
    main()
EOFCLI
    fi
    
    # Create grainai.spec if it doesn't exist
    if [ ! -f "grainai.spec" ]; then
        log_info "Creating PyInstaller spec..."
        cat > grainai.spec << 'EOFSPEC'
block_cipher = None

a = Analysis(
    ['cli.py'],
    pathex=[],
    binaries=[],
    datas=[('app', 'app')],
    hiddenimports=['ollama', 'fastapi', 'uvicorn', 'uvicorn.lifespan', 'uvicorn.loops', 'uvicorn.loops.auto', 'uvicorn.protocols', 'uvicorn.protocols.http', 'uvicorn.protocols.http.auto', 'uvicorn.protocols.websocket', 'uvicorn.protocols.websocket.auto', 'pydantic', 'pydantic.json', 'starlette'],
    hookspath=[],
    runtime_hooks=[],
    excludedimports=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='grainai',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
)
EOFSPEC
    fi
    
    log_info "Building binary with PyInstaller..."
    pyinstaller grainai.spec
    
    log_info "Installing binary..."
    cp dist/grainai "$INSTALL_PREFIX/backend/"
    chmod 755 "$INSTALL_PREFIX/backend/grainai"
    chown "$SERVICE_USER:$SERVICE_GROUP" "$INSTALL_PREFIX/backend/grainai"
    
    log_success "Backend binary built and installed"
    
    deactivate
    cd - > /dev/null
}

build_frontend() {
    log_section "Building Frontend"
    
    if [ ! -f "$REPO_ROOT/frontend/package.json" ]; then
        log_error "Frontend package.json not found"
        exit 1
    fi
    
    # Source nvm if available (for npm access)
    if [ -f "$HOME/.nvm/nvm.sh" ]; then
        source "$HOME/.nvm/nvm.sh"
    fi
    
    log_info "Installing npm dependencies..."
    cd "$REPO_ROOT/frontend"
    npm ci --silent
    
    log_info "Building React app..."
    npm run build --silent
    
    log_info "Installing to $INSTALL_PREFIX/frontend..."
    cp -r build "$INSTALL_PREFIX/frontend/"
    chown -R "$SERVICE_USER:$SERVICE_GROUP" "$INSTALL_PREFIX/frontend/"
    
    log_success "Frontend built and installed"
    
    cd - > /dev/null
}

setup_ollama() {
    if [ "$SKIP_OLLAMA" = true ]; then
        log_info "Skipping OLLAMA installation (--skip-ollama)"
        return
    fi
    
    log_section "Setting Up OLLAMA"
    
    if command -v ollama &> /dev/null; then
        log_success "OLLAMA already installed"
    else
        log_info "Installing OLLAMA..."
        curl -fsSL https://ollama.ai/install.sh | sh
        log_success "OLLAMA installed"
    fi
}

create_config() {
    log_section "Creating Configuration"
    
    mkdir -p "$INSTALL_PREFIX/config"
    
    cat > "$INSTALL_PREFIX/config/grainai.json" << EOF
{
  "ollama_host": "http://localhost:$OLLAMA_PORT",
  "api_host": "0.0.0.0",
  "api_port": $BACKEND_PORT,
  "log_level": "INFO",
  "cors_origins": ["http://localhost:$FRONTEND_PORT"]
}
EOF
    
    chown "$SERVICE_USER:$SERVICE_GROUP" "$INSTALL_PREFIX/config/grainai.json"
    chmod 644 "$INSTALL_PREFIX/config/grainai.json"
    
    log_success "Configuration created"
}

create_systemd_units() {
    log_section "Installing systemd Units"
    
    # Find ollama path
    local OLLAMA_PATH=$(which ollama 2>/dev/null || echo "/usr/local/bin/ollama")
    
    # OLLAMA service
    cat > /etc/systemd/system/grainai-ollama.service << EOF
[Unit]
Description=GrainAI OLLAMA Language Model Service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$SERVICE_USER
Group=$SERVICE_GROUP
WorkingDirectory=$INSTALL_PREFIX/ollama
ExecStart=$OLLAMA_PATH serve --host 0.0.0.0 --port $OLLAMA_PORT
Restart=on-failure
RestartSec=5s
StandardOutput=journal
StandardError=journal
SyslogIdentifier=grainai-ollama
MemoryLimit=8G
CPUQuota=50%

[Install]
WantedBy=multi-user.target
EOF
    
    # Backend service
    cat > /etc/systemd/system/grainai-backend.service << EOF
[Unit]
Description=GrainAI Backend API Service
After=network-online.target grainai-ollama.service
Wants=network-online.target
Requires=grainai-ollama.service

[Service]
Type=simple
User=$SERVICE_USER
Group=$SERVICE_GROUP
WorkingDirectory=$INSTALL_PREFIX/backend
ExecStart=$INSTALL_PREFIX/backend/grainai --host 0.0.0.0 --port $BACKEND_PORT --log-level INFO
Restart=on-failure
RestartSec=5s
StartLimitInterval=600s
StartLimitBurst=3
StandardOutput=journal
StandardError=journal
SyslogIdentifier=grainai-backend
Environment="OLLAMA_HOST=http://localhost:$OLLAMA_PORT"
MemoryLimit=2G
CPUQuota=100%
NoNewPrivileges=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
    
    # Frontend service
    cat > /etc/systemd/system/grainai-frontend.service << EOF
[Unit]
Description=GrainAI Frontend Web Service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$SERVICE_USER
Group=$SERVICE_GROUP
WorkingDirectory=$INSTALL_PREFIX/frontend
ExecStart=/usr/bin/python3 -m http.server $FRONTEND_PORT --directory build
Restart=on-failure
RestartSec=5s
StartLimitInterval=600s
StartLimitBurst=3
StandardOutput=journal
StandardError=journal
SyslogIdentifier=grainai-frontend
MemoryLimit=512M
CPUQuota=50%
NoNewPrivileges=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
    
    # Target
    cat > /etc/systemd/system/grainai.target << EOF
[Unit]
Description=GrainAI Full Stack (OLLAMA + Backend + Frontend)
Wants=grainai-ollama.service grainai-backend.service grainai-frontend.service

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    
    log_success "systemd units installed"
}

enable_services() {
    log_section "Enabling Services"
    
    systemctl enable grainai.target
    systemctl enable grainai-ollama.service
    systemctl enable grainai-backend.service
    systemctl enable grainai-frontend.service
    
    log_success "Services enabled for auto-start"
}

print_summary() {
    log_section "Installation Complete"
    
    echo ""
    echo "📍 Installation Directory: $INSTALL_PREFIX"
    echo "👤 Service User: $SERVICE_USER"
    echo ""
    echo "🚀 START SERVICES:"
    echo "   sudo systemctl start grainai.target"
    echo ""
    echo "📊 CHECK STATUS:"
    echo "   sudo systemctl status grainai.target"
    echo ""
    echo "📜 VIEW LOGS:"
    echo "   journalctl -u grainai-backend -f"
    echo "   journalctl -u grainai-ollama -f"
    echo "   journalctl -u grainai-frontend -f"
    echo ""
    echo "🌐 ACCESS:"
    echo "   Frontend:  http://localhost:$FRONTEND_PORT"
    echo "   Backend:   http://localhost:$BACKEND_PORT/docs"
    echo "   OLLAMA:    http://localhost:$OLLAMA_PORT/api/tags"
    echo ""
    echo "⏸️  STOP SERVICES:"
    echo "   sudo systemctl stop grainai.target"
    echo ""
}

main() {
    parse_args "$@"
    
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════╗"
    echo "║  GrainAI Full Stack Installation       ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    
    check_root
    check_prerequisites
    create_service_user
    create_directories
    build_backend
    build_frontend
    setup_ollama
    create_config
    create_systemd_units
    enable_services
    print_summary
}

main "$@"

