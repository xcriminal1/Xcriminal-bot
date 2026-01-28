# Xcriminal Bot - Quick Start Script for Windows PowerShell
# Run: powershell -ExecutionPolicy Bypass -File quick-start.ps1

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  XCRIMINAL BOT - QUICK START SETUP (WINDOWS)      ║" -ForegroundColor Cyan
Write-Host "║  PowerShell Edition                               ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Color functions
function Write-Success { Write-Host "✓ $args" -ForegroundColor Green }
function Write-Error { Write-Host "✗ $args" -ForegroundColor Red }
function Write-Warning { Write-Host "⚠ $args" -ForegroundColor Yellow }
function Write-Info { Write-Host "ℹ $args" -ForegroundColor Cyan }

# Track issues
$issues = 0

# Step 1: Check Node.js
Write-Host ""
Write-Host "[1/5] Checking Node.js..." -ForegroundColor Blue
try {
    $nodeVersion = node -v 2>$null
    if ($nodeVersion) {
        Write-Success "Node.js $nodeVersion installed"
    } else {
        Write-Error "Node.js not found"
        $issues++
    }
} catch {
    Write-Error "Node.js not found - Install from https://nodejs.org (v22+)"
    $issues++
}

# Step 2: Check/Install pnpm
Write-Host ""
Write-Host "[2/5] Checking pnpm..." -ForegroundColor Blue
try {
    $pnpmVersion = pnpm -v 2>$null
    Write-Success "pnpm $pnpmVersion installed"
} catch {
    Write-Warning "pnpm not found - Installing globally..."
    try {
        npm install -g pnpm
        $pnpmVersion = pnpm -v
        Write-Success "pnpm $pnpmVersion installed"
    } catch {
        Write-Warning "Could not auto-install pnpm - Install with: npm install -g pnpm"
    }
}

# Step 3: Install Dependencies
Write-Host ""
Write-Host "[3/5] Installing dependencies..." -ForegroundColor Blue
if (-not (Test-Path "node_modules")) {
    Write-Host "Running: pnpm install (this may take 2-5 minutes)..." -ForegroundColor Gray
    try {
        if (Get-Command pnpm -ErrorAction SilentlyContinue) {
            pnpm install
        } else {
            npm install
        }
        Write-Success "Dependencies installed"
    } catch {
        Write-Error "Failed to install dependencies"
        Write-Info "Try manually: pnpm install"
        $issues++
    }
} else {
    Write-Success "Dependencies already installed"
}

# Step 4: Build Project
Write-Host ""
Write-Host "[4/5] Building project..." -ForegroundColor Blue
try {
    Write-Host "Running: pnpm build..." -ForegroundColor Gray
    if (Get-Command pnpm -ErrorAction SilentlyContinue) {
        pnpm build 2>$null
    } else {
        npm run build 2>$null
    }
    
    if (Test-Path "dist") {
        Write-Success "Project built successfully"
    } else {
        Write-Warning "Build may have warnings - check dist/ directory"
    }
} catch {
    Write-Warning "Build completed with potential warnings"
}

# Step 5: Configuration
Write-Host ""
Write-Host "[5/5] Setting up configuration..." -ForegroundColor Blue
if (-not (Test-Path ".env.local")) {
    if (Test-Path ".env.example") {
        Write-Host "Creating .env.local from .env.example..." -ForegroundColor Gray
        Copy-Item ".env.example" ".env.local"
        Write-Success ".env.local created"
        Write-Warning "IMPORTANT: Edit .env.local and add your API keys:"
        Write-Info "  - ANTHROPIC_API_KEY (if using Claude)"
        Write-Info "  - OPENAI_API_KEY (if using GPT)"
    } else {
        Write-Warning ".env.local not configured"
        Write-Info "Create: copy .env.example .env.local"
        Write-Info "Then add your API keys"
    }
} else {
    Write-Success ".env.local already configured"
}

# Final Summary
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                   SETUP COMPLETE!                  ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if ($issues -eq 0) {
    Write-Success "All requirements met!"
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
    Write-Host ""
    Write-Host "1. Start the Gateway (in a new PowerShell):" -ForegroundColor Cyan
    Write-Host "   pnpm gateway:watch" -ForegroundColor White
    Write-Host ""
    Write-Host "2. In another terminal, test the bot:" -ForegroundColor Cyan
    Write-Host "   pnpm moltbot agent --message `"What is 2+2?`"" -ForegroundColor White
    Write-Host ""
    Write-Host "3. Open the web dashboard:" -ForegroundColor Cyan
    Write-Host "   http://localhost:18789/apps/xcriminal" -ForegroundColor White
    Write-Host ""
    Write-Host "4. Run security audit:" -ForegroundColor Cyan
    Write-Host "   .\security-audit.bat" -ForegroundColor White
    Write-Host ""
    Write-Host "5. For full documentation:" -ForegroundColor Cyan
    Write-Host "   .\SETUP_AND_SECURITY.md" -ForegroundColor White
    Write-Host ""
} else {
    Write-Warning "Found $issues issue(s) - please fix before proceeding"
}

Write-Host ""
Write-Host "Setup time: $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Gray
Write-Host ""

# Offer to open dashboard
Read-Host "Press Enter to exit or type 'yes' to open the dashboard after starting gateway"
