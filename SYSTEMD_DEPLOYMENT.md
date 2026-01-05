# GrainAI Full Stack Deployment with systemd

Complete orchestrated deployment of GrainAI backend, frontend, and OLLAMA with systemd service management.

## Quick Start

### One-Command Installation

```bash
# Download the repository
git clone https://github.com/Alexarandr/PolicyMaking
cd PolicyMaking

# Run installation (requires root/sudo)
sudo ./install.sh
```

This will:
1. ✅ Create service user (`grainai`)
2. ✅ Build backend binary
3. ✅ Build frontend React app
4. ✅ Install OLLAMA
5. ✅ Create systemd units
6. ✅ Enable auto-start

### Post-Installation

```bash
# Start all services
sudo systemctl start grainai.target

# Check status
sudo systemctl status grainai.target

# View logs
journalctl -u grainai-backend -f
journalctl -u grainai-ollama -f
journalctl -u grainai-frontend -f

# Stop all services
sudo systemctl stop grainai.target
```

---

## Installation Customization

### Custom Installation Directory

```bash
sudo ./install.sh --prefix /srv/grainai --user myuser
```

### Custom Ports

```bash
sudo ./install.sh \
  --backend-port 8080 \
  --frontend-port 3001 \
  --ollama-port 11435
```

### Skip Components

```bash
# Skip frontend installation
sudo ./install.sh --skip-frontend

# Skip OLLAMA installation (if already installed)
sudo ./install.sh --skip-ollama

# Skip systemd units (manual setup)
sudo ./install.sh --skip-systemd
```

### Full Example

```bash
sudo ./install.sh \
  --prefix /opt/grainai \
  --user grainai \
  --backend-port 8000 \
  --frontend-port 3000 \
  --ollama-port 11434
```

---

## systemd Service Management

### Service Units

After installation, four systemd units are available:

#### `grainai.target`
Master target that groups all GrainAI services

```bash
# Start all services
sudo systemctl start grainai.target

# Stop all services
sudo systemctl stop grainai.target

# Restart all services
sudo systemctl restart grainai.target

# Check status
sudo systemctl status grainai.target
```

#### `grainai-backend.service`
FastAPI backend with OLLAMA client

```bash
# Start backend only
sudo systemctl start grainai-backend.service

# View logs
journalctl -u grainai-backend -f

# Check status
systemctl status grainai-backend.service
```

#### `grainai-ollama.service`
OLLAMA language model runtime

```bash
# Start OLLAMA only
sudo systemctl start grainai-ollama.service

# View logs
journalctl -u grainai-ollama -f

# Check status
systemctl status grainai-ollama.service
```

#### `grainai-frontend.service`
React frontend served via Python HTTP server

```bash
# Start frontend only
sudo systemctl start grainai-frontend.service

# View logs
journalctl -u grainai-frontend -f

# Check status
systemctl status grainai-frontend.service
```

### Enable Auto-Start

```bash
# Enable all services to start on boot
sudo systemctl enable grainai.target

# Check if enabled
systemctl is-enabled grainai.target
```

### Disable Auto-Start

```bash
# Disable auto-start
sudo systemctl disable grainai.target
```

---

## Environment Variables & Aliases

Load the provided environment configuration for convenient commands:

```bash
source grainai-env.sh
```

This provides convenient aliases:

```bash
# Service control
grainai-start                # Start all services
grainai-stop                 # Stop all services
grainai-restart              # Restart all services
grainai-status               # Check status

# Logging
grainai-logs                 # Follow backend logs
grainai-logs-ollama          # Follow OLLAMA logs
grainai-logs-frontend        # Follow frontend logs

# Configuration
grainai-enable               # Enable auto-start
grainai-disable              # Disable auto-start
grainai-install-units        # Install systemd units
```

---

## Configuration

### Main Configuration File

Located at: `/opt/grainai/config/grainai.json`

```json
{
  "ollama_host": "http://localhost:11434",
  "api_host": "0.0.0.0",
  "api_port": 8000,
  "log_level": "INFO",
  "cors_origins": ["http://localhost:3000"]
}
```

**Edit and restart service:**

```bash
sudo nano /opt/grainai/config/grainai.json
sudo systemctl restart grainai-backend.service
```

---

## Logging & Monitoring

### View Logs

All services log to systemd journal:

```bash
# Backend logs
journalctl -u grainai-backend -f

# OLLAMA logs
journalctl -u grainai-ollama -f

# Frontend logs
journalctl -u grainai-frontend -f

# All GrainAI logs
journalctl -u grainai-backend -u grainai-ollama -u grainai-frontend -f

# Last 50 lines of backend logs
journalctl -u grainai-backend -n 50

# Logs since last hour
journalctl -u grainai-backend --since "1 hour ago"
```

### Service Status

```bash
# Check all services
sudo systemctl status grainai.target

# Check individual service
systemctl status grainai-backend.service

# List all GrainAI units
systemctl list-units grainai*
```

---

## Access Points

After starting services, access GrainAI components at:

| Component | URL | Purpose |
|-----------|-----|---------|
| Frontend | http://localhost:3000 | Web UI |
| Backend API | http://localhost:8000 | API endpoint |
| API Docs | http://localhost:8000/docs | Interactive API documentation |
| OLLAMA API | http://localhost:11434 | LLM runtime (internal) |

---

## Troubleshooting

### Service Won't Start

```bash
# Check status and error messages
systemctl status grainai-backend.service

# View detailed logs
journalctl -u grainai-backend -n 100

# Check if ports are in use
lsof -i :8000
lsof -i :3000
lsof -i :11434
```

### OLLAMA Connection Error

```bash
# Verify OLLAMA is running
systemctl status grainai-ollama.service

# Test OLLAMA connectivity
curl http://localhost:11434/api/tags

# Restart OLLAMA
sudo systemctl restart grainai-ollama.service
```

### Backend API Not Responding

```bash
# Restart backend
sudo systemctl restart grainai-backend.service

# Check logs for errors
journalctl -u grainai-backend -f

# Verify it's listening
netstat -tlnp | grep 8000
```

### Permission Denied Errors

```bash
# Check ownership
ls -la /opt/grainai/

# Fix permissions
sudo chown -R grainai:grainai /opt/grainai/
sudo chmod 755 /opt/grainai/backend/grainai
```

---

## Uninstallation

### Remove All Services

```bash
# Stop services
sudo systemctl stop grainai.target

# Disable auto-start
sudo systemctl disable grainai.target

# Remove systemd units
sudo rm /etc/systemd/system/grainai*.service
sudo rm /etc/systemd/system/grainai.target
sudo systemctl daemon-reload

# Remove installation directory
sudo rm -rf /opt/grainai

# Remove service user (optional)
sudo userdel grainai
```

---

## Resource Limits

The systemd units include resource constraints:

| Service | Memory | CPU |
|---------|--------|-----|
| OLLAMA | 8GB | 50% |
| Backend | 2GB | 100% |
| Frontend | 512MB | 50% |

Adjust in the service files if needed:

```bash
sudo nano /etc/systemd/system/grainai-backend.service
# Edit: MemoryLimit=2G and CPUQuota=100%
sudo systemctl daemon-reload
sudo systemctl restart grainai-backend.service
```

---

## Production Considerations

### Use Reverse Proxy (Nginx)

For production, use Nginx or Apache as a reverse proxy:

```bash
sudo apt-get install nginx
```

Configure `/etc/nginx/sites-available/grainai`:

```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location /api/ {
        proxy_pass http://localhost:8000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### Monitor Services

Use monitoring tools like:

```bash
# Monitor with watch
watch -n 1 'systemctl status grainai.target'

# Or use htop for resource monitoring
htop -u grainai
```

### Backup Configuration

```bash
# Backup config
sudo cp /opt/grainai/config/grainai.json ~/grainai-config.backup.json

# Backup installation
sudo tar -czf ~/grainai-backup.tar.gz /opt/grainai/
```

---

## Updates

### Update Backend Binary

```bash
# Rebuild backend
cd PolicyMaking/backend
source venv/bin/activate
pyinstaller grainai.spec
sudo cp dist/grainai /opt/grainai/backend/
sudo chown grainai:grainai /opt/grainai/backend/grainai

# Restart backend service
sudo systemctl restart grainai-backend.service
```

### Update Frontend

```bash
# Rebuild frontend
cd PolicyMaking/frontend
npm ci
npm run build
sudo rm -rf /opt/grainai/frontend/build
sudo cp -r build /opt/grainai/frontend/
sudo chown -R grainai:grainai /opt/grainai/frontend/

# Restart frontend service
sudo systemctl restart grainai-frontend.service
```

---

## Support

For issues and questions:
- 📖 [GitHub Repository](https://github.com/Alexarandr/PolicyMaking)
- 🐛 [Issue Tracker](https://github.com/Alexarandr/PolicyMaking/issues)
- 📝 [Documentation](./README.md)

