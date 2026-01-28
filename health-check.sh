#!/bin/bash
# Xcriminal Health Check Script
# Quick verification that everything is working and secure
# Run: chmod +x health-check.sh && ./health-check.sh

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

pass() { echo -e "${GREEN}✓${NC} $1"; }
fail() { echo -e "${RED}✗${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }
info() { echo -e "${BLUE}ℹ${NC} $1"; }

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════╗"
echo "║    XCRIMINAL BOT - HEALTH CHECK            ║"
echo "╚════════════════════════════════════════════╝"
echo -e "${NC}"

ISSUES=0

# 1. Node Version
echo -e "${BLUE}Checking System Environment${NC}"
NODE_VERSION=$(node -v 2>/dev/null)
if [ -z "$NODE_VERSION" ]; then
    fail "Node.js not installed"
    ISSUES=$((ISSUES + 1))
else
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_MAJOR" -ge 22 ]; then
        pass "Node.js $NODE_VERSION"
    else
        fail "Node.js $NODE_VERSION (need ≥22)"
        ISSUES=$((ISSUES + 1))
    fi
fi

# 2. Package Manager
if command -v pnpm &> /dev/null; then
    PNPM_VERSION=$(pnpm -v)
    pass "pnpm $PNPM_VERSION installed"
elif command -v npm &> /dev/null; then
    NPM_VERSION=$(npm -v)
    warn "npm $NPM_VERSION (pnpm recommended)"
else
    fail "No package manager found"
    ISSUES=$((ISSUES + 1))
fi

# 3. Dependencies
echo ""
echo -e "${BLUE}Checking Dependencies${NC}"
if [ -d "node_modules" ]; then
    PACKAGES=$(find node_modules -maxdepth 1 -type d | wc -l)
    pass "Dependencies installed ($PACKAGES packages)"
else
    fail "node_modules not found"
    warn "Run: pnpm install"
    ISSUES=$((ISSUES + 1))
fi

# 4. Build Status
echo ""
echo -e "${BLUE}Checking Project Build${NC}"
if [ -d "dist" ]; then
    BUILD_TIME=$(stat -f%Sm -t '%Y-%m-%d %H:%M:%S' "dist/index.js" 2>/dev/null || stat -c %y "dist/index.js" 2>/dev/null | cut -d' ' -f1,2)
    pass "Build output exists (last built: $BUILD_TIME)"
    
    if pnpm build > /dev/null 2>&1; then
        pass "Build succeeds without errors"
    else
        warn "Build has errors"
        ISSUES=$((ISSUES + 1))
    fi
else
    warn "dist/ directory not built yet"
    info "Run: pnpm build"
fi

# 5. Configuration
echo ""
echo -e "${BLUE}Checking Configuration${NC}"
if [ -f "package.json" ]; then
    pass "package.json found"
    
    PKG_NAME=$(grep '"name"' package.json | head -1 | cut -d'"' -f4)
    if [ "$PKG_NAME" = "xcriminal" ]; then
        pass "Package correctly named: $PKG_NAME"
    else
        warn "Package name is: $PKG_NAME"
    fi
else
    fail "package.json not found"
    ISSUES=$((ISSUES + 1))
fi

if [ -f ".env.local" ]; then
    pass ".env.local configured"
else
    warn ".env.local not found (some features may not work)"
    info "Create: cp .env.example .env.local"
fi

# 6. Git Configuration
echo ""
echo -e "${BLUE}Checking Git Security${NC}"
if [ -d ".git" ]; then
    pass "Git repository initialized"
    
    if grep -q "node_modules" .gitignore 2>/dev/null; then
        pass "node_modules ignored in git"
    else
        warn "node_modules might be tracked"
        ISSUES=$((ISSUES + 1))
    fi
    
    if grep -q "\.env" .gitignore 2>/dev/null; then
        pass ".env files ignored in git"
    else
        warn ".env files might be exposed"
        ISSUES=$((ISSUES + 1))
    fi
else
    warn "Not a git repository"
fi

# 7. Security Checks
echo ""
echo -e "${BLUE}Checking Security${NC}"
if npm audit --audit-level=critical > /dev/null 2>&1; then
    pass "No critical vulnerabilities"
else
    VULN=$(npm audit --json 2>/dev/null | grep -o '"vulnerabilities"' | wc -l)
    if [ $VULN -gt 0 ]; then
        warn "npm audit detected issues"
        info "Run: npm audit fix"
    fi
fi

# 8. Linting
echo ""
echo -e "${BLUE}Checking Code Quality${NC}"
if pnpm lint > /dev/null 2>&1; then
    pass "ESLint checks passed"
else
    warn "Linting warnings detected"
    info "Run: pnpm lint"
fi

# 9. Tests
echo ""
echo -e "${BLUE}Checking Tests${NC}"
if pnpm test > /dev/null 2>&1; then
    pass "All tests pass"
else
    warn "Some tests failing"
    info "Run: pnpm test to see details"
fi

# 10. Port Availability
echo ""
echo -e "${BLUE}Checking Gateway Port${NC}"
PORT=18789
if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
    pass "Gateway port $PORT is available"
elif command -v lsof &> /dev/null; then
    if ! lsof -i :$PORT > /dev/null 2>&1; then
        pass "Gateway port $PORT is available"
    else
        warn "Port $PORT appears to be in use"
    fi
else
    info "Cannot check port availability (lsof not found)"
fi

# Final Summary
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          HEALTH CHECK SUMMARY              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}✅ System is healthy and ready to use!${NC}"
    echo ""
    echo "Quick start commands:"
    echo "  1. Start gateway:"
    echo "     ${BLUE}pnpm gateway:watch${NC}"
    echo ""
    echo "  2. In another terminal, test it:"
    echo "     ${BLUE}pnpm moltbot agent --message 'Hello'${NC}"
    echo ""
    echo "  3. Open web dashboard:"
    echo "     ${BLUE}http://localhost:18789/apps/xcriminal${NC}"
    echo ""
    echo "  4. Run security audit:"
    echo "     ${BLUE}./security-audit.sh${NC}"
else
    echo -e "${YELLOW}⚠️  Found $ISSUES issue(s) to fix${NC}"
    echo ""
    echo "Recommended actions:"
    [ ! -d "node_modules" ] && echo "  → pnpm install"
    [ ! -d "dist" ] && echo "  → pnpm build"
    [ ! -f ".env.local" ] && echo "  → cp .env.example .env.local"
    echo ""
fi

echo "Generated: $(date +'%Y-%m-%d %H:%M:%S')"
echo ""

exit $ISSUES
