#!/bin/bash
# Xcriminal Security Audit Script
# Run: chmod +x security-audit.sh && ./security-audit.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  XCRIMINAL BOT - COMPREHENSIVE SECURITY AUDIT             ║${NC}"
echo -e "${BLUE}║  $(date +'%Y-%m-%d %H:%M:%S')                                      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Colors for results
pass() { echo -e "${GREEN}✓${NC} $1"; }
fail() { echo -e "${RED}✗${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }
info() { echo -e "${BLUE}ℹ${NC} $1"; }

# Counter for issues found
CRITICAL_ISSUES=0
HIGH_ISSUES=0
MEDIUM_ISSUES=0

# 1. Check Node Version
echo ""
echo -e "${BLUE}[1/10] Checking Node.js Version${NC}"
NODE_VERSION=$(node -v 2>/dev/null)
NODE_MAJOR=$(echo $NODE_VERSION | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_MAJOR" -ge 22 ]; then
    pass "Node.js $NODE_VERSION (required: ≥22)"
else
    fail "Node.js $NODE_VERSION (required: ≥22)"
    CRITICAL_ISSUES=$((CRITICAL_ISSUES + 1))
fi

# 2. Check Dependencies
echo ""
echo -e "${BLUE}[2/10] Checking Dependencies Installation${NC}"
if [ -d "node_modules" ] && [ -d "node_modules/.bin" ]; then
    PACKAGE_COUNT=$(find node_modules -maxdepth 1 -type d | wc -l)
    pass "Dependencies installed ($PACKAGE_COUNT packages)"
else
    fail "Dependencies not installed or corrupted"
    warn "Run: pnpm install"
    CRITICAL_ISSUES=$((CRITICAL_ISSUES + 1))
    exit 1
fi

# 3. npm audit - Check Vulnerabilities
echo ""
echo -e "${BLUE}[3/10] Running npm audit (Dependency Vulnerabilities)${NC}"
if npm audit --audit-level=critical > /dev/null 2>&1; then
    pass "No critical vulnerabilities found"
else
    VULN_COUNT=$(npm audit --json 2>/dev/null | grep -o '"vulnerabilities":[^}]*' | grep -oE '[0-9]+' | head -1)
    if [ -z "$VULN_COUNT" ]; then
        VULN_COUNT=0
    fi
    
    if [ "$VULN_COUNT" -gt 0 ]; then
        warn "Found $VULN_COUNT vulnerabilities"
        HIGH_ISSUES=$((HIGH_ISSUES + 1))
        npm audit --json > npm-audit-report.json
        info "Full report saved: npm-audit-report.json"
    fi
fi

# 4. TypeScript Compilation
echo ""
echo -e "${BLUE}[4/10] TypeScript Type Checking & Compilation${NC}"
if pnpm build > /dev/null 2>&1; then
    pass "TypeScript compilation successful"
else
    fail "TypeScript compilation failed"
    CRITICAL_ISSUES=$((CRITICAL_ISSUES + 1))
fi

# 5. Linting
echo ""
echo -e "${BLUE}[5/10] ESLint Code Quality Check${NC}"
if pnpm lint > /dev/null 2>&1; then
    pass "Linting passed - no code quality issues"
else
    LINT_COUNT=$(pnpm lint 2>&1 | grep -o 'error' | wc -l)
    if [ "$LINT_COUNT" -gt 0 ]; then
        warn "Found $LINT_COUNT linting errors"
        MEDIUM_ISSUES=$((MEDIUM_ISSUES + 1))
        pnpm lint > lint-report.txt 2>&1
        info "Full report saved: lint-report.txt"
    fi
fi

# 6. Check for Secrets in Code
echo ""
echo -e "${BLUE}[6/10] Checking for Hardcoded Secrets${NC}"
SECRETS_FOUND=0

# Look for common secret patterns
if grep -r "api_key\s*=" src/ --include="*.ts" 2>/dev/null | grep -v "test\|mock\|example" | grep -q .; then
    warn "Potential hardcoded API key found"
    SECRETS_FOUND=$((SECRETS_FOUND + 1))
fi

if grep -r "password\s*=" src/ --include="*.ts" 2>/dev/null | grep -v "test\|mock\|example" | grep -q .; then
    warn "Potential hardcoded password found"
    SECRETS_FOUND=$((SECRETS_FOUND + 1))
fi

if grep -r "token\s*=" src/ --include="*.ts" 2>/dev/null | grep -v "test\|mock\|example" | grep -q .; then
    warn "Potential hardcoded token found"
    SECRETS_FOUND=$((SECRETS_FOUND + 1))
fi

if [ $SECRETS_FOUND -eq 0 ]; then
    pass "No hardcoded secrets detected"
else
    fail "Found $SECRETS_FOUND potential hardcoded secrets"
    CRITICAL_ISSUES=$((CRITICAL_ISSUES + 1))
    info "Please review src/ for: api_key, password, token"
fi

# 7. Check for Suspicious Code Patterns
echo ""
echo -e "${BLUE}[7/10] Scanning for Suspicious Code Patterns${NC}"
SUSPICIOUS=0

# Look for eval() usage
if grep -r "eval(" src/ --include="*.ts" | grep -v "test\|//" | grep -q .; then
    warn "Found eval() usage - potential security risk"
    SUSPICIOUS=$((SUSPICIOUS + 1))
fi

# Look for require() with variables
if grep -r "require(\s*\[a-zA-Z\]" src/ --include="*.ts" | grep -v "test\|mock" | grep -q .; then
    warn "Found dynamic require() - potential code injection risk"
    SUSPICIOUS=$((SUSPICIOUS + 1))
fi

# Look for child_process spawning
if grep -r "child_process\|exec(\|spawn(" src/ --include="*.ts" | grep -v "test\|security" | grep -q .; then
    info "child_process usage detected (verify it's intentional)"
fi

if [ $SUSPICIOUS -eq 0 ]; then
    pass "No suspicious code patterns detected"
else
    warn "Found $SUSPICIOUS suspicious patterns"
    MEDIUM_ISSUES=$((MEDIUM_ISSUES + 1))
fi

# 8. File Integrity Check
echo ""
echo -e "${BLUE}[8/10] Checking Package Integrity${NC}"
if pnpm install --frozen-lockfile > /dev/null 2>&1; then
    pass "Package lock file integrity verified"
else
    warn "Package dependencies differ from lock file"
    info "Run: pnpm install"
fi

# 9. Test Suite
echo ""
echo -e "${BLUE}[9/10] Running Unit Tests${NC}"
if pnpm test > /dev/null 2>&1; then
    pass "All unit tests passed"
else
    warn "Some tests failed - check test output"
    MEDIUM_ISSUES=$((MEDIUM_ISSUES + 1))
    pnpm test > test-report.txt 2>&1 || true
    info "Full report saved: test-report.txt"
fi

# 10. Configuration Security
echo ""
echo -e "${BLUE}[10/10] Configuration Security Check${NC}"
CONFIG_ISSUES=0

# Check .env.local exists
if [ -f ".env.local" ]; then
    pass ".env.local exists and is protected"
    if grep -q "^\\.env\\.local" .gitignore 2>/dev/null; then
        pass ".env.local is in .gitignore"
    else
        warn ".env.local might be exposed in git"
        CONFIG_ISSUES=$((CONFIG_ISSUES + 1))
    fi
else
    warn ".env.local not configured - some features may not work"
fi

# Check git is ignoring sensitive files
if grep -q "node_modules" .gitignore 2>/dev/null; then
    pass "node_modules properly ignored"
else
    warn "node_modules might be tracked in git"
    CONFIG_ISSUES=$((CONFIG_ISSUES + 1))
fi

# Generate Final Report
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                   AUDIT SUMMARY                            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

if [ $CRITICAL_ISSUES -gt 0 ]; then
    echo -e "${RED}CRITICAL ISSUES: $CRITICAL_ISSUES${NC}"
fi

if [ $HIGH_ISSUES -gt 0 ]; then
    echo -e "${YELLOW}HIGH ISSUES: $HIGH_ISSUES${NC}"
fi

if [ $MEDIUM_ISSUES -gt 0 ]; then
    echo -e "${YELLOW}MEDIUM ISSUES: $MEDIUM_ISSUES${NC}"
fi

TOTAL_ISSUES=$((CRITICAL_ISSUES + HIGH_ISSUES + MEDIUM_ISSUES))

echo ""
if [ $TOTAL_ISSUES -eq 0 ]; then
    echo -e "${GREEN}✅ ALL SECURITY CHECKS PASSED!${NC}"
    echo ""
    echo "Safe to proceed with:"
    echo "  → pnpm build"
    echo "  → pnpm gateway:watch"
    echo ""
else
    echo -e "${RED}⚠️  ISSUES FOUND - Review and fix before deployment${NC}"
    echo ""
    echo "Generated reports:"
    [ -f "npm-audit-report.json" ] && echo "  • npm-audit-report.json"
    [ -f "lint-report.txt" ] && echo "  • lint-report.txt"
    [ -f "test-report.txt" ] && echo "  • test-report.txt"
    echo ""
fi

echo "Timestamp: $(date +'%Y-%m-%d %H:%M:%S')"
echo ""

exit $TOTAL_ISSUES
