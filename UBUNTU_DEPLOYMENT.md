# 🐧 Ubuntu VirtualBox Deployment Guide

Deploy Xcriminal Bot with GitHub issue fixes in your Ubuntu VirtualBox environment.

---

## 📋 Prerequisites

- **Ubuntu 20.04 or later** in VirtualBox
- **4GB RAM minimum** (8GB recommended)
- **10GB disk space**
- **Internet connection**

---

## 🚀 Quick Start

### Option 1: Automated Deployment (Recommended)

```bash
# 1. Transfer project to Ubuntu (from Windows host)
# In VirtualBox, use Shared Folders or SCP/SFTP

# 2. Navigate to project directory
cd ~/Xcriminal-bot

# 3. Run deployment script
chmod +x deploy-ubuntu.sh
./deploy-ubuntu.sh
```

### Option 2: Manual Setup

```bash
# 1. Install Node.js 22+
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# 2. Install pnpm
npm install -g pnpm

# 3. Install dependencies
pnpm install

# 4. Build project
pnpm build

# 5. Test fixes
./scripts/test-fixes.sh
```

---

## 📂 Transferring Files to Ubuntu VirtualBox

### Method 1: Shared Folder (Easiest)

1. **In VirtualBox:**
   - VM Settings → Shared Folders
   - Add folder: `C:\Users\aarya\OneDrive\Desktop\Xcriminal-bot`
   - Name: `xcriminal`
   - Check "Auto-mount"

2. **In Ubuntu:**
   ```bash
   # Add user to vboxsf group
   sudo usermod -aG vboxsf $USER
   
   # Logout and login again, then:
   cp -r /media/sf_xcriminal ~/Xcriminal-bot
   cd ~/Xcriminal-bot
   ```

### Method 2: SCP from Windows to Ubuntu

```powershell
# In Windows PowerShell (adjust IP to your Ubuntu VM)
scp -r C:\Users\aarya\OneDrive\Desktop\Xcriminal-bot username@192.168.56.101:~/
```

### Method 3: Git Clone

```bash
# In Ubuntu (if you've pushed to GitHub)
git clone https://github.com/yourusername/Xcriminal-bot.git
cd Xcriminal-bot
```

---

## 🧪 Testing Fixes

### Test All Fixes
```bash
./scripts/test-fixes.sh
```

### Individual Tests

#### 1. Network Interface Fix (Issue #3200)
```bash
node -e "
const os = require('os');
try {
  const nets = os.networkInterfaces();
  console.log('✅ Network interfaces:', Object.keys(nets));
} catch (error) {
  console.log('✅ Error handled:', error.message);
}
"
```

#### 2. Session Persistence (Issue #3210)
```bash
./scripts/validate-sessions.sh

# Create test session
pnpm xcriminal agent --message "test session" &
sleep 2

# Verify
./scripts/validate-sessions.sh
```

#### 3. Matrix Media (Issue #3203)
```bash
# After configuring Matrix
pnpm xcriminal channels status --channel matrix --deep
```

#### 4. MS Teams (Issue #3204)
```bash
# Test webhook endpoint
curl -X POST http://localhost:18789/api/messages \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer test" \
  -d '{"type":"message","text":"test"}'
```

---

## ⚙️ Configuration

### 1. Environment Setup
```bash
# Create config directory
mkdir -p ~/.clawdbot

# Set environment variables
cat >> ~/.bashrc << 'EOF'
export XCRIMINAL_CONFIG_DIR="$HOME/.clawdbot"
export XCRIMINAL_LOG_LEVEL="info"
export XCRIMINAL_GATEWAY_PORT="18789"
EOF

source ~/.bashrc
```

### 2. Configure Channels
```bash
# Interactive configuration
pnpm xcriminal config wizard

# Or manually edit
nano ~/.clawdbot/config.json
```

### 3. Set API Keys
```bash
# Anthropic (Claude)
pnpm xcriminal config set providers.anthropic.apiKey "sk-ant-..."

# OpenAI
pnpm xcriminal config set providers.openai.apiKey "sk-..."

# Telegram
pnpm xcriminal config set channels.telegram.botToken "123456:ABC..."
```

---

## 🏃 Running the Bot

### Gateway Mode (Recommended)
```bash
# Start gateway
pnpm xcriminal gateway run --bind 0.0.0.0 --port 18789

# Or in background
nohup pnpm xcriminal gateway run --bind 0.0.0.0 --port 18789 > ~/xcriminal.log 2>&1 &

# Check status
pnpm xcriminal channels status --deep
```

### CLI Mode
```bash
# Send single message
pnpm xcriminal message send --to telegram --text "Hello from Ubuntu!"

# Interactive mode
pnpm xcriminal tui
```

### Docker Mode
```bash
# Build and run
docker-compose up -d

# View logs
docker-compose logs -f
```

---

## 🔍 Monitoring & Debugging

### Check Logs
```bash
# Gateway logs
tail -f ~/xcriminal.log

# Session logs
ls -lh ~/.clawdbot/agents/main/sessions/

# System logs
journalctl -u xcriminal -f
```

### Health Check
```bash
# Full status
pnpm xcriminal channels status --all

# Deep probe (tests connections)
pnpm xcriminal channels status --deep

# Diagnostic report
pnpm xcriminal doctor
```

### Performance Monitoring
```bash
# Process stats
ps aux | grep xcriminal

# Memory usage
free -h

# Network connections
ss -tulpn | grep 18789

# CPU usage
top -p $(pgrep -f xcriminal)
```

---

## 🐛 Troubleshooting

### Issue: "pnpm: command not found"
```bash
npm install -g pnpm
export PATH="$HOME/.local/share/pnpm:$PATH"
```

### Issue: "Permission denied" on scripts
```bash
chmod +x deploy-ubuntu.sh
chmod +x scripts/*.sh
```

### Issue: Port 18789 already in use
```bash
# Find process
sudo lsof -i :18789

# Kill process
sudo kill -9 <PID>

# Or use different port
pnpm xcriminal gateway run --port 19000
```

### Issue: Network interface error
```bash
# Test fix
node -e "const { getSystemInfoSafe } = require('./dist/infra/system-presence.js'); console.log(getSystemInfoSafe())"

# Should return info without crashing
```

### Issue: Sessions not persisting
```bash
# Run repair tool
pnpm xcriminal doctor --repair-sessions

# Validate
./scripts/validate-sessions.sh
```

---

## 🔒 Security Considerations

### 1. Firewall Setup
```bash
# Allow gateway port
sudo ufw allow 18789/tcp

# Enable firewall
sudo ufw enable
```

### 2. Run Security Scan
```bash
# NPM audit
pnpm audit

# Full security check
./security-check.sh
```

### 3. Secure Configuration
```bash
# Protect config files
chmod 600 ~/.clawdbot/config.json
chmod 700 ~/.clawdbot/credentials/

# Don't expose API keys in logs
pnpm xcriminal config set logging.redactSecrets true
```

---

## 📊 Performance Tuning

### For Low-Spec VMs (2GB RAM)
```bash
# Reduce concurrency
export NODE_OPTIONS="--max-old-space-size=1024"

# Limit concurrent agents
pnpm xcriminal config set gateway.maxConcurrentAgents 2
```

### For High-Spec VMs (8GB+ RAM)
```bash
# Increase memory
export NODE_OPTIONS="--max-old-space-size=4096"

# Enable more workers
pnpm xcriminal config set gateway.maxConcurrentAgents 8
```

---

## 🔄 Auto-Start on Boot

### Using systemd
```bash
# Create service file
sudo nano /etc/systemd/system/xcriminal.service
```

```ini
[Unit]
Description=Xcriminal Bot Gateway
After=network.target

[Service]
Type=simple
User=youruser
WorkingDirectory=/home/youruser/Xcriminal-bot
ExecStart=/usr/bin/pnpm xcriminal gateway run --bind 0.0.0.0 --port 18789
Restart=always
RestartSec=10
StandardOutput=append:/home/youruser/xcriminal.log
StandardError=append:/home/youruser/xcriminal.log

[Install]
WantedBy=multi-user.target
```

```bash
# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable xcriminal
sudo systemctl start xcriminal

# Check status
sudo systemctl status xcriminal
```

---

## 📈 Monitoring Dashboard

### Simple Status Page
```bash
# Create monitoring script
cat > ~/monitor-xcriminal.sh << 'EOF'
#!/bin/bash
while true; do
  clear
  echo "=== Xcriminal Bot Status ==="
  echo "Time: $(date)"
  echo ""
  echo "Process:"
  ps aux | grep xcriminal | grep -v grep || echo "Not running"
  echo ""
  echo "Memory:"
  free -h | grep Mem
  echo ""
  echo "Connections:"
  ss -tulpn | grep 18789 || echo "No connections"
  echo ""
  echo "Recent logs:"
  tail -n 5 ~/xcriminal.log
  sleep 5
done
EOF

chmod +x ~/monitor-xcriminal.sh
./monitor-xcriminal.sh
```

---

## 🆘 Support & Resources

- **Documentation:** `/docs/` directory
- **GitHub Issues:** [GITHUB_ISSUES_FIXES.md](GITHUB_ISSUES_FIXES.md)
- **Security Guide:** [SETUP_AND_SECURITY.md](SETUP_AND_SECURITY.md)
- **Logs Location:** `~/.clawdbot/logs/`
- **Config Location:** `~/.clawdbot/config.json`

---

## ✅ Verification Checklist

After deployment, verify:

- [ ] Node.js 22+ installed
- [ ] pnpm installed and working
- [ ] Dependencies installed (`pnpm install`)
- [ ] Project built successfully (`pnpm build`)
- [ ] All test scripts pass (`./scripts/test-fixes.sh`)
- [ ] Gateway starts without errors
- [ ] Channels configured and connected
- [ ] Session persistence working
- [ ] Network interface fix working
- [ ] Logs are being written
- [ ] No security warnings

---

**Deployment Date:** January 28, 2026  
**Project:** Xcriminal Bot (rebranded from Moltbot)  
**Platform:** Ubuntu 20.04+ on VirtualBox
