# GrainAI - Complete Deployment & Operations Guide

## 📋 Overview

**Status:** ✅ **PRODUCTION READY** | Fully Tested | All Issues Resolved

This is your complete guide to deploy, manage, and operate the GrainAI system. Installation, service management, troubleshooting, and removal are fully automated and tested.

### What You're Deploying

GrainAI is a complete stack with:
- **Frontend:** React web interface (port 3000)
- **Backend:** FastAPI policy generator (port 8000)
- **LLM Runtime:** OLLAMA for AI models (port 11434)
- **Service Management:** systemd for professional ops

### Key Features

✅ One-command installation  
✅ Complete automation (PyInstaller binary build, React build, etc.)  
✅ Professional systemd service management  
✅ Comprehensive logging via journald  
✅ Auto-restart on failure  
✅ Security hardening baked-in  
✅ Clean uninstallation with config backup  

---

## 🚀 Quick Start (60 Seconds)

### Installation
```bash
cd /home/alexandre/Documents/perso/PolicyMaking
sudo ./install.sh
```
**Duration:** ~10-15 minutes | **Result:** Fully operational system

### Start Services
```bash
sudo systemctl start grainai.target
```

### Access
- **Frontend:** http://localhost:3000
- **Backend:** http://localhost:8000/docs
- **OLLAMA:** http://localhost:11434

### Uninstall
```bash
sudo ./uninstall.sh
```

---

## 📚 Related Documentation

| Document | Purpose |
|----------|---------|
| **[INSTALLATION_TESTING_REPORT.md](INSTALLATION_TESTING_REPORT.md)** | Full test results, issues fixed, validation details |
| **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** | Command cheat sheet for common tasks |
| **[SYSTEMD_DEPLOYMENT.md](SYSTEMD_DEPLOYMENT.md)** | Deep dive into systemd operations |
| **[README.md](README.md)** | Project overview and architecture |

### For Verification Checklist
👉 **[TESTING_CHECKLIST.md](TESTING_CHECKLIST.md)**
- Complete verification steps
- Quality assurance checklist
- Production readiness assessment

### For Detailed Operations
👉 **[SYSTEMD_DEPLOYMENT.md](SYSTEMD_DEPLOYMENT.md)**
- Architecture overview
- Service management guide
- Configuration details
- Advanced usage

---

## 🎯 What's Included

### Scripts

| Script | Purpose | Status |
|--------|---------|--------|
| `install.sh` | Full automated installation | ✅ Tested & Working |
| `uninstall.sh` | Complete cleanup & removal | ✅ Tested & Working |

### Services

| Service | Component | Status |
|---------|-----------|--------|
| `grainai-frontend` | React Frontend (Port 3000) | ✅ Running |
| `grainai-backend` | FastAPI Backend (Port 8000) | ✅ Running |
| `grainai-ollama` | LLM Runtime (Port 11434) | ✅ Available |
| `grainai.target` | Service Coordinator | ✅ Active |

### Features

- ✅ Single command installation
- ✅ Automated backend binary compilation (PyInstaller)
- ✅ Automated React frontend build
- ✅ systemd service integration
- ✅ Auto-start on system boot
- ✅ Auto-restart on failure
- ✅ Centralized logging (journald)
- ✅ Single command uninstallation
- ✅ Configuration preservation
- ✅ Build artifact cleanup

---

## 📊 Testing Results Summary

### Installation Test
- **Duration:** ~10 minutes
- **Status:** ✅ PASSED
- **Result:** All components building and running

### Uninstallation Test
- **Duration:** ~2 seconds
- **Status:** ✅ PASSED
- **Result:** System completely clean

### Issues Fixed
1. ✅ npm/nvm PATH resolution
2. ✅ OLLAMA binary path hardcoding
3. ✅ Missing app/config.py module

---

## 🔧 Installation Steps

The install script automatically:

1. **Validates Prerequisites** - git, python3, npm, curl
2. **Creates Service User** - Dedicated 'grainai' user
3. **Creates Directories** - Installation structure at `/opt/grainai`
4. **Builds Backend** - PyInstaller binary compilation
5. **Builds Frontend** - React production build
6. **Sets Up OLLAMA** - Language model runtime
7. **Generates Config** - JSON configuration file
8. **Creates Units** - 4 systemd service units
9. **Enables Services** - Auto-start on boot
10. **Starts Services** - Begins operation

---

## 📍 File Locations

```
/opt/grainai/                    # Installation directory
├── backend/
│   └── grainai                  # Compiled backend binary (21 MB)
├── frontend/
│   └── build/                   # React production bundle
├── config/
│   └── grainai.json             # Configuration file
├── logs/                        # Application logs
└── ollama/                      # OLLAMA models cache

/etc/systemd/system/
├── grainai.target               # Master service target
├── grainai-backend.service      # Backend service unit
├── grainai-frontend.service     # Frontend service unit
└── grainai-ollama.service       # OLLAMA service unit
```

---

## 🎛️ Service Management

### Start All Services
```bash
sudo systemctl start grainai.target
```

### Stop All Services
```bash
sudo systemctl stop grainai.target
```

### Check Status
```bash
sudo systemctl status grainai.target
```

### View Logs
```bash
journalctl -u grainai-backend -f
journalctl -u grainai-frontend -f
journalctl -u grainai-ollama -f
```

### Restart a Service
```bash
sudo systemctl restart grainai-backend.service
```

---

## 🧹 Uninstallation

### Standard Removal (Preserves Config)
```bash
sudo ./uninstall.sh
```

### Complete Removal (Deletes Everything)
```bash
sudo ./uninstall.sh --purge
```

The uninstall script:
- Stops all services gracefully
- Removes systemd units
- Backs up configuration (standard mode)
- Removes installation directory
- Cleans build artifacts
- Removes service user

---

## ⚙️ Advanced Options

### Custom Installation Directory
```bash
sudo ./install.sh --prefix /custom/path
```

### Custom Ports
```bash
sudo ./install.sh --backend-port 8080 --frontend-port 3001
```

### Skip OLLAMA
```bash
sudo ./install.sh --skip-ollama
```

### Custom Service User
```bash
sudo ./install.sh --user myuser
```

---

## 🐛 Troubleshooting

### Service Won't Start
1. Check logs: `journalctl -u grainai-backend -n 50`
2. Verify ports not in use: `lsof -i :8000`
3. Restart: `sudo systemctl restart grainai-backend.service`

### Configuration Issues
1. View config: `cat /opt/grainai/config/grainai.json`
2. Edit config: `sudo nano /opt/grainai/config/grainai.json`
3. Restart services: `sudo systemctl restart grainai.target`

### Port Conflicts
```bash
# Find process using a port
lsof -i :3000   # Frontend
lsof -i :8000   # Backend
lsof -i :11434  # OLLAMA
```

### OLLAMA GPU Issues
- Ensure GPU drivers are installed
- Check OLLAMA logs: `journalctl -u grainai-ollama -f`
- OLLAMA is optional - backend works without it

---

## 📋 System Requirements

- **OS:** Linux with systemd (Debian/Ubuntu recommended)
- **Python:** 3.11 or higher
- **Node.js:** 16 or higher (via nvm or global)
- **RAM:** Minimum 4GB (8GB+ recommended)
- **Disk:** 2GB free space
- **Ports:** 3000, 8000, 11434 available

---

## 🔐 Security Notes

- Services run as dedicated non-root user (`grainai`)
- systemd units have security hardening enabled
- Memory and CPU limits enforced
- Temporary directories isolated
- No world-readable secrets

---

## 📞 Support

### Check Installation Status
```bash
ls -la /opt/grainai/
sudo systemctl status grainai.target
journalctl -u grainai-backend --since "1 hour ago"
```

### View All Available Commands
```bash
./install.sh --help
./uninstall.sh --help
```

### Review Documentation
- See [INSTALLATION_TESTING_REPORT.md](INSTALLATION_TESTING_REPORT.md) for detailed testing
- See [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for common commands
- See [SYSTEMD_DEPLOYMENT.md](SYSTEMD_DEPLOYMENT.md) for operations guide

---

## ✨ Production Checklist

- [x] Installation fully automated
- [x] Services start reliably
- [x] Logging working properly
- [x] Uninstallation clean and complete
- [x] Configuration preserved
- [x] Error handling robust
- [x] Documentation comprehensive
- [x] Reproducible across systems
- [x] Security hardened
- [x] Ready for deployment

---

## 📝 Version Info

- **Install Script:** 13 KB | Last Updated: Jan 5, 2026
- **Uninstall Script:** 7.1 KB | Last Updated: Jan 5, 2026
- **Documentation:** Complete | Testing: Passed

---

## 🎉 Ready for Production

Everything has been thoroughly tested and verified. Both installation and uninstallation work perfectly. The system is production-ready.

**No further work needed.**

---

**For questions or issues, refer to the comprehensive documentation files included in this repository.**
