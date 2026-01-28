# 🚀 Xcriminal Bot - Complete Setup & Security Guide

Welcome! This guide will help you get **Xcriminal** running securely and check for any vulnerabilities or malware.

---

## Table of Contents
1. [Quick Start (5 minutes)](#quick-start)
2. [Detailed Setup](#detailed-setup)
3. [Security Scanning](#security-scanning)
4. [Vulnerability Detection](#vulnerability-detection)
5. [Malware/Trojan Detection](#malware--trojan-detection)
6. [Running the Bot](#running-the-bot)
7. [Troubleshooting](#troubleshooting)

---

## Quick Start

### Windows (Easiest)
```powershell
# Open PowerShell and run:
powershell -ExecutionPolicy Bypass -File quick-start.ps1

# Then start the gateway:
pnpm gateway:watch
```

### macOS / Linux
```bash
# Make scripts executable
chmod +x quick-start.sh health-check.sh security-audit.sh

# Run quick start
./quick-start.sh

# Then start the gateway:
pnpm gateway:watch
```

---

## Detailed Setup

### Prerequisites
- **Node.js 22+** (get from https://nodejs.org)
- **pnpm** (lightweight package manager)
- **Git** (for version control)

### Step 1: Verify System Requirements
```bash
# Check Node version (must be 22 or higher)
node -v        # Example: v22.12.0

# Check/Install pnpm
npm install -g pnpm
pnpm -v        # Example: 10.23.0
```

### Step 2: Clone and Setup
```bash
# Navigate to Xcriminal directory
cd "Xcriminal-bot"

# Install all dependencies
pnpm install

# This will:
# - Download 1000+ npm packages (~500MB)
# - Validate package signatures
# - Build native modules
# - Take 2-5 minutes
```

### Step 3: Configure Environment
```bash
# Copy example configuration
cp .env.example .env.local

# Edit .env.local with your API keys:
# - ANTHROPIC_API_KEY (Claude API key from Anthropic)
# - OPENAI_API_KEY (GPT API key from OpenAI)
# - XCRIMINAL_GATEWAY_PORT (default: 18789)
```

### Step 4: Build Project
```bash
# Compile TypeScript to JavaScript
pnpm build

# This creates the 'dist/' directory with compiled code
# Should complete in 30-60 seconds
```

### Step 5: Verify Installation
```bash
# Run health check
./health-check.sh          # macOS/Linux
health-check.bat          # Windows (Command Prompt)
powershell ./health-check.ps1  # Windows (PowerShell)
```

---

## Security Scanning

### Automated Security Audit (Recommended)
```bash
# macOS/Linux
chmod +x security-audit.sh
./security-audit.sh

# Windows Command Prompt
security-audit.bat

# Windows PowerShell
powershell -ExecutionPolicy Bypass -File security-audit.sh
```

This runs 10 comprehensive security checks:
1. ✓ Node version validation
2. ✓ Dependency vulnerability scan
3. ✓ TypeScript compilation
4. ✓ Code linting
5. ✓ Secret detection
6. ✓ Suspicious code patterns
7. ✓ Package integrity
8. ✓ Test suite validation
9. ✓ Configuration security
10. ✓ Git safety checks

---

## Vulnerability Detection

### 1. Check npm Dependencies
```bash
# List all vulnerabilities
npm audit

# Get detailed JSON report
npm audit --json > vulnerability-report.json

# Automatically fix known vulnerabilities
npm audit fix

# Fix only critical issues
npm audit fix --force
```

### 2. Check Specific Packages
```bash
# Check which version of a package is installed
npm list <package-name>

# Check if a package has known vulnerabilities
npm view <package-name> > package-info.json

# Examples:
npm list @whiskeysockets/baileys
npm list grammy
npm list express
```

### 3. Using Snyk (Cloud-based)
```bash
# Install Snyk
npm install -g snyk

# Authenticate
snyk auth

# Test project
snyk test

# Monitor continuously
snyk monitor

# Generate report
snyk test --json > snyk-vulnerability-report.json
```

### 4. License Compliance
```bash
# Check for GPL or problematic licenses
npx license-report --only=prod > licenses.json

# Example output:
# - MIT: 450 packages (safe)
# - Apache 2.0: 80 packages (safe)
# - GPL v3: 5 packages (may conflict with MIT - review!)
```

---

## Malware / Trojan Detection

### 1. Scan Package Registry History
```bash
# Check when each package was last updated
npm view package-name time --json

# Verify it's still actively maintained
npm view package-name repository.url
```

### 2. Check for Suspicious Files
```bash
# Look for unexpected executables
find node_modules -type f \( -name "*.exe" -o -name "*.bat" -o -name "*.vbs" \)

# Look for scripts that might exfiltrate data
grep -r "http://" node_modules --include="*.js" | grep -v "localhost\|127.0.0.1" | head -20

# Check for suspicious requires
grep -r "require.*crypto\|require.*net\|require.*child_process" node_modules --include="*.js" | head -20
```

### 3. Verify Package Integrity
```bash
# npm automatically checks for malware during install
# But you can verify signatures:
npm audit signatures

# Ensure lock file hasn't been tampered
pnpm install --frozen-lockfile
npm ci --audit
```

### 4. Use Malware Detection Tools
```bash
# Using ClamAV (open-source antivirus)
clamscan -r node_modules

# Using Windows Defender (built-in)
"C:\Program Files\Windows Defender\MpCmdRun.exe" -Scan -ScanType 3 -File "%cd%\node_modules"
```

### 5. Check for Backdoors in Source Code
```bash
# Look for eval() - code execution vulnerability
grep -r "eval(" src/ --include="*.ts" | grep -v "test\|//"

# Look for dynamic requires
grep -r "require(\[a-zA-Z\]" src/ --include="*.ts" | grep -v "test"

# Look for child process spawning
grep -r "child_process\|exec(\|spawn(" src/ --include="*.ts" | grep -v "test\|security"

# Look for cryptographic operations that steal data
grep -r "crypto\." src/ --include="*.ts" | grep -v "crypto.randomBytes\|crypto.sign"

# Look for network exfiltration
grep -r "http.request\|fetch\|axios" src/ --include="*.ts" | grep -v "test\|mock"
```

### 6. Code Quality Analysis
```bash
# ESLint finds security issues
pnpm lint

# TypeScript strict mode catches unsafe code
pnpm build

# Run security-focused tests
pnpm test -- --grep="security"
```

---

## Running the Bot

### Start the Gateway (Control Plane)
```bash
# Development mode with auto-reload
pnpm gateway:watch

# Production mode
pnpm moltbot gateway --port 18789
```

### Access the Web Dashboard
```
http://localhost:18789/apps/xcriminal
```

Features:
- Real-time agent status
- Message history
- Channel configuration
- Session management
- Security logs

### Send a Test Message
```bash
# Talk to the bot
pnpm moltbot agent --message "Hello, Xcriminal! What time is it?"

# Send via WhatsApp/Telegram
pnpm moltbot message send --to +1234567890 --message "Test message"

# With thinking enabled (detailed reasoning)
pnpm moltbot agent --message "Explain quantum computing" --thinking high
```

### Configure Channels (WhatsApp, Telegram, etc.)
```bash
# Start interactive setup wizard
pnpm moltbot onboard

# This will guide you through:
# 1. Setting up API keys
# 2. Configuring gateway
# 3. Connecting messaging channels
# 4. Setting up skills
```

---

## Security Best Practices

### 1. Protect Your API Keys
```bash
# ✓ DO: Store keys in .env.local
echo "ANTHROPIC_API_KEY=sk-xxxx" >> .env.local

# ✗ DON'T: Commit keys to git
git add .env.local        # Never do this!

# ✓ DO: Ignore .env files in git
grep ".env" .gitignore    # Should see it

# ✗ DON'T: Share .env.local with anyone
chmod 600 .env.local      # Read-only for you
```

### 2. Keep Dependencies Updated
```bash
# Check for outdated packages
npm outdated

# Update safely
npm update

# Update everything (may break things)
npm install --save-latest
```

### 3. Review New Dependencies
```bash
# Before adding a package, check:
npm view package-name

# Look at:
# - Repository URL (GitHub, GitLab, etc.)
# - License (MIT, Apache 2.0, etc.)
# - Maintainers (reputable developers)
# - Download stats (active use)
# - Last update (recently maintained)
```

### 4. Monitor for Security Updates
```bash
# GitHub automatically notifies about vulnerabilities
# Configure email alerts at: Settings > Security > Code scanning

# Or use this for local notification:
npm outdated --all
npm audit --audit-level=moderate
```

---

## Troubleshooting

### "Node.js not found"
```bash
# Download and install from: https://nodejs.org/
# Verify installation:
node -v
npm -v

# Make sure it's in PATH
echo $PATH  # Should include node directory
```

### "pnpm command not found"
```bash
# Install globally
npm install -g pnpm

# Or use npm instead
npm install  # Instead of: pnpm install
npm run build  # Instead of: pnpm build
npm run gateway:watch  # Instead of: pnpm gateway:watch
```

### "Port 18789 already in use"
```bash
# Find what's using the port
lsof -i :18789           # macOS/Linux
netstat -ano | find ":18789"  # Windows

# Kill the process (if safe)
kill -9 <PID>            # macOS/Linux
taskkill /PID <PID> /F   # Windows

# Or use different port
pnpm moltbot gateway --port 18790
```

### "Build fails with TypeScript errors"
```bash
# Clear build cache
rm -rf dist

# Reinstall dependencies
rm -rf node_modules
pnpm install

# Try building again
pnpm build

# If still failing, check:
pnpm build --verbose
```

### "npm audit reports vulnerabilities"
```bash
# Fix automatically
npm audit fix

# If auto-fix doesn't work, fix manually
npm audit --json > audit.json  # Review which packages
npm install [package]@latest
pnpm build
pnpm test
```

---

## Security Checklist

Before deployment, verify:

- [ ] Node.js version ≥ 22
- [ ] All dependencies installed
- [ ] `npm audit` shows no critical issues
- [ ] `pnpm build` succeeds without errors
- [ ] `pnpm test` passes all tests
- [ ] `.env.local` configured with API keys
- [ ] `.env.local` in `.gitignore`
- [ ] No secrets in git history: `git log --all -S "api_key"`
- [ ] Gateway auth token generated
- [ ] Only localhost access: `--bind localhost`
- [ ] Security audit passed: `./security-audit.sh`
- [ ] Health check passed: `./health-check.sh`

---

## Getting Help

### Documentation
- Full guide: `SETUP_AND_SECURITY.md`
- API docs: https://docs.molt.bot
- GitHub Issues: https://github.com/moltbot/moltbot/issues
- Discord Community: https://discord.gg/clawd

### Security Issues
- **NEVER** post security vulnerabilities publicly
- Email with details
- Allow 48 hours for response
- See `SECURITY.md` for disclosure policy

### Common Commands Reference
```bash
pnpm install          # Install dependencies
pnpm build           # Compile TypeScript
pnpm lint            # Check code quality
pnpm test            # Run unit tests
pnpm test:coverage   # Test coverage (70% threshold)
pnpm gateway:watch   # Start gateway with auto-reload
pnpm moltbot onboard # Interactive setup wizard
npm audit            # Check vulnerabilities
npm audit fix        # Fix vulnerabilities
./security-audit.sh  # Full security audit
./health-check.sh    # System health check
```

---

## Quick Command Summary

| Goal | Command |
|------|---------|
| Full Setup | `pnpm install && pnpm build` |
| Start Bot | `pnpm gateway:watch` |
| Security Check | `npm audit && ./security-audit.sh` |
| Run Tests | `pnpm test:coverage` |
| Check Health | `./health-check.sh` |
| Open Dashboard | `http://localhost:18789/apps/xcriminal` |
| Send Message | `pnpm moltbot agent --message "Hi"` |

---

## Summary

1. **Setup** (5 min): `pnpm install && pnpm build`
2. **Security** (2 min): `./security-audit.sh`
3. **Run** (instant): `pnpm gateway:watch`
4. **Test** (1 min): Visit `http://localhost:18789/apps/xcriminal`

**You're ready to go!** 🚀

For issues or questions, see the troubleshooting section or check GitHub Issues.
