# Quick Reference - Install & Uninstall

## Installation

```bash
sudo ./install.sh
```

**What it does:**
- Checks prerequisites (git, python3, npm, curl)
- Creates system user `grainai`
- Builds backend binary with PyInstaller
- Builds React frontend
- Sets up OLLAMA
- Creates/enables systemd services

**Duration:** ~10 minutes (includes compilation)

**Result:** Full stack running and ready to use

---

## Service Management

### Start Services
```bash
sudo systemctl start grainai.target
```

### Check Status
```bash
sudo systemctl status grainai.target
```

### View Logs
```bash
# Backend logs
journalctl -u grainai-backend -f

# Frontend logs  
journalctl -u grainai-frontend -f

# OLLAMA logs
journalctl -u grainai-ollama -f
```

### Stop Services
```bash
sudo systemctl stop grainai.target
```

### Restart Services
```bash
sudo systemctl restart grainai.target
```

---

## Access Services

| Service | URL | Port |
|---------|-----|------|
| Frontend | http://localhost:3000 | 3000 |
| Backend API | http://localhost:8000/docs | 8000 |
| OLLAMA | http://localhost:11434/api/tags | 11434 |

---

## Uninstallation

### Standard (Keep Config)
```bash
sudo ./uninstall.sh
```

**What it does:**
- Stops all services
- Removes systemd units
- Backs up configuration
- Removes installation directory
- Cleans build artifacts
- Removes service user

**Duration:** ~2 seconds

**Result:** System clean, config backed up

### Complete Removal (Delete Config)
```bash
sudo ./uninstall.sh --purge
```

**What it does:**
- Everything above, plus
- Deletes configuration files

---

## Troubleshooting

### Service won't start
```bash
# Check logs for errors
journalctl -u grainai-backend -n 50

# Try restarting
sudo systemctl restart grainai-backend.service
```

### Check if ports are in use
```bash
lsof -i :3000   # Frontend
lsof -i :8000   # Backend
lsof -i :11434  # OLLAMA
```

### View installation location
```bash
ls -la /opt/grainai/
```

### View configuration
```bash
cat /opt/grainai/config/grainai.json
```

---

## File Locations

| Component | Location |
|-----------|----------|
| Installation | `/opt/grainai/` |
| Backend Binary | `/opt/grainai/backend/grainai` |
| Frontend Build | `/opt/grainai/frontend/build/` |
| Configuration | `/opt/grainai/config/grainai.json` |
| Logs | `/opt/grainai/logs/` |
| systemd Units | `/etc/systemd/system/grainai*.service` |

---

## Configuration

### Edit Configuration
```bash
sudo nano /opt/grainai/config/grainai.json
```

### Restart After Config Change
```bash
sudo systemctl restart grainai.target
```

---

## Advanced Options

### Install to Custom Location
```bash
sudo ./install.sh --prefix /custom/path
```

### Install with Custom Ports
```bash
sudo ./install.sh --backend-port 8080 --frontend-port 3001
```

### Skip OLLAMA Installation
```bash
sudo ./install.sh --skip-ollama
```

### Custom Service User
```bash
sudo ./install.sh --user myuser
```

---

## Removal Options

### Remove Specific User
```bash
sudo ./uninstall.sh --user myuser
```

---

## Health Checks

```bash
# Check all services running
sudo systemctl status grainai.target

# Check individual services
sudo systemctl status grainai-frontend.service
sudo systemctl status grainai-backend.service
sudo systemctl status grainai-ollama.service

# Monitor in real-time
watch -n 1 'sudo systemctl status grainai.target'
```

---

## Useful Commands

### View recent errors
```bash
journalctl -u grainai-backend --since "5 minutes ago" -p err
```

### Follow logs in real-time
```bash
journalctl -u grainai-backend -f --no-pager
```

### Check service dependencies
```bash
systemctl show grainai.target | grep Wants
```

### Reload systemd after manual changes
```bash
sudo systemctl daemon-reload
```

---

## Notes

- Installation requires root (sudo)
- Services run as dedicated `grainai` user
- All services log to journald
- Configuration is preserved on uninstall
- Backend requires OLLAMA to be running
- Frontend is independent
- systemd handles auto-restart on failure

---

**For detailed documentation, see:**
- `INSTALLATION_TESTING_REPORT.md` - Complete testing results
- `SYSTEMD_DEPLOYMENT.md` - Operations guide
