#!/bin/bash
"""
GrainAI Complete Uninstallation Script

Safely removes all GrainAI components, services, and system integration.
Preserves user data in config files for backup purposes.

Usage:
  sudo ./uninstall.sh [OPTIONS]

Options:
  --purge              Remove all data including config files (default: keep config)
  --user username      System user to remove (default: grainai)
  --help               Show this help message
"""

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default Configuration
SERVICE_USER="grainai"
PURGE_DATA=false
INSTALL_PREFIX="/opt/grainai"

# Logging functions
log_info() { echo -e "${BLUE}ℹ ${NC}$1"; }
log_success() { echo -e "${GREEN}✓ ${NC}$1"; }
log_error() { echo -e "${RED}✗ ${NC}$1"; }
log_section() { echo ""; echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; echo -e "${YELLOW}  $1${NC}"; echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; }

# Parse arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --purge) PURGE_DATA=true; shift ;;
            --user) SERVICE_USER="$2"; shift 2 ;;
            --help) head -n 20 "$0"; exit 0 ;;
            *) log_error "Unknown option: $1"; exit 1 ;;
        esac
    done
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root (use: sudo ./uninstall.sh)"
        exit 1
    fi
}

stop_services() {
    log_section "Stopping Services"
    
    if systemctl is-active --quiet grainai.target 2>/dev/null; then
        log_info "Stopping grainai.target..."
        systemctl stop grainai.target
        log_success "Services stopped"
    else
        log_info "Services not running"
    fi
}

disable_services() {
    log_section "Disabling Services"
    
    if systemctl is-enabled --quiet grainai.target 2>/dev/null; then
        log_info "Disabling services..."
        systemctl disable grainai.target 2>/dev/null || true
        systemctl disable grainai-ollama.service 2>/dev/null || true
        systemctl disable grainai-backend.service 2>/dev/null || true
        systemctl disable grainai-frontend.service 2>/dev/null || true
        log_success "Services disabled"
    else
        log_info "Services not enabled"
    fi
}

remove_systemd_units() {
    log_section "Removing systemd Units"
    
    log_info "Removing unit files..."
    rm -f /etc/systemd/system/grainai.target
    rm -f /etc/systemd/system/grainai-ollama.service
    rm -f /etc/systemd/system/grainai-backend.service
    rm -f /etc/systemd/system/grainai-frontend.service
    
    rm -f /etc/systemd/system/multi-user.target.wants/grainai.target
    rm -f /etc/systemd/system/multi-user.target.wants/grainai-ollama.service
    rm -f /etc/systemd/system/multi-user.target.wants/grainai-backend.service
    rm -f /etc/systemd/system/multi-user.target.wants/grainai-frontend.service
    
    log_info "Reloading systemd..."
    systemctl daemon-reload
    
    log_success "systemd units removed"
}

remove_installation() {
    log_section "Removing Installation Directory"
    
    if [ -d "$INSTALL_PREFIX" ]; then
        log_info "Removing $INSTALL_PREFIX..."
        rm -rf "$INSTALL_PREFIX"
        log_success "Installation directory removed"
    else
        log_info "Installation directory not found"
    fi
}

remove_build_artifacts() {
    log_section "Removing Build Artifacts"
    
    REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    if [ -d "$REPO_ROOT/backend/venv" ]; then
        log_info "Removing Python venv..."
        rm -rf "$REPO_ROOT/backend/venv"
        log_success "Python venv removed"
    fi
    
    if [ -d "$REPO_ROOT/backend/dist" ]; then
        log_info "Removing PyInstaller dist directory..."
        rm -rf "$REPO_ROOT/backend/dist"
        log_success "PyInstaller dist removed"
    fi
    
    if [ -d "$REPO_ROOT/backend/build" ]; then
        log_info "Removing PyInstaller build directory..."
        rm -rf "$REPO_ROOT/backend/build"
        log_success "PyInstaller build removed"
    fi
    
    if [ -f "$REPO_ROOT/backend/cli.py" ]; then
        log_info "Removing cli.py..."
        rm -f "$REPO_ROOT/backend/cli.py"
        log_success "cli.py removed"
    fi
    
    if [ -f "$REPO_ROOT/backend/grainai.spec" ]; then
        log_info "Removing grainai.spec..."
        rm -f "$REPO_ROOT/backend/grainai.spec"
        log_success "grainai.spec removed"
    fi
}

remove_service_user() {
    log_section "Removing Service User"
    
    if id "$SERVICE_USER" &>/dev/null 2>&1; then
        log_info "Removing user '$SERVICE_USER'..."
        userdel -r "$SERVICE_USER" 2>/dev/null || userdel "$SERVICE_USER"
        log_success "User '$SERVICE_USER' removed"
    else
        log_info "User '$SERVICE_USER' not found"
    fi
}

backup_config() {
    log_section "Configuration Files"
    
    if [ "$PURGE_DATA" = true ]; then
        log_info "Purging configuration files..."
        rm -rf "$INSTALL_PREFIX/config"
        log_success "Configuration files purged"
    else
        if [ -d "$INSTALL_PREFIX/config" ]; then
            BACKUP_DIR="$HOME/.grainai-backup-$(date +%Y%m%d-%H%M%S)"
            log_info "Backing up configuration to $BACKUP_DIR..."
            mkdir -p "$BACKUP_DIR"
            cp -r "$INSTALL_PREFIX/config/"* "$BACKUP_DIR/" 2>/dev/null || true
            log_success "Configuration backed up"
        fi
    fi
}

print_summary() {
    log_section "Uninstallation Complete"
    
    echo ""
    echo "📋 Summary:"
    echo "   ✓ systemd units removed"
    echo "   ✓ Installation directory removed"
    echo "   ✓ Build artifacts cleaned"
    echo "   ✓ Service user removed"
    
    if [ "$PURGE_DATA" = true ]; then
        echo "   ✓ Configuration files purged"
    else
        echo "   ✓ Configuration files backed up"
    fi
    
    echo ""
    echo "🗑️  GrainAI has been completely removed from your system."
    echo ""
    echo "To reinstall:"
    echo "   sudo ./install.sh"
    echo ""
}

main() {
    parse_args "$@"
    check_root
    
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║                      GrainAI Uninstallation                                ║"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""
    
    if [ "$PURGE_DATA" = true ]; then
        echo -e "${RED}WARNING: Running in PURGE mode - all data will be deleted!${NC}"
        echo "Waiting 5 seconds before proceeding..."
        sleep 5
    fi
    
    stop_services
    disable_services
    remove_systemd_units
    backup_config
    remove_installation
    remove_build_artifacts
    remove_service_user
    print_summary
}

main "$@"
