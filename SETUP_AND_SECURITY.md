# Xcriminal Bot - Setup & Security Guide

## Part 1: Getting Xcriminal Bot Working

### Prerequisites
- **Node.js**: ≥22.12.0 (required)
- **Package Manager**: pnpm (recommended), npm, or bun
- **OS**: macOS, Linux, Windows (WSL2 strongly recommended for Windows)

### Quick Start Setup

#### 1. Install Dependencies
```bash
# Using pnpm (recommended)
pnpm install

# OR using npm
npm install

# OR using bun
bun install
```

#### 2. Build the Project
```bash
# Type-check and compile TypeScript to dist/
pnpm build

# Or for development with auto-reload
pnpm gateway:watch
```

#### 3. Run the Gateway
```bash
# Start the gateway (control plane)
pnpm moltbot gateway --port 18789

# OR in dev mode with auto-reload
pnpm gateway:watch
```

#### 4. Send Your First Message
In a new terminal:
```bash
# Send a message via WhatsApp/Telegram
pnpm moltbot message send --to +1234567890 --message "Hello from Xcriminal"

# Talk to the assistant
pnpm moltbot agent --message "What time is it?" --thinking high
```

#### 5. Web UI Dashboard
Once gateway is running:
```
http://localhost:18789/apps/xcriminal
```

---

## Part 2: Security Scanning & Vulnerability Detection

### 2.1 Dependency Vulnerability Scanning

#### Using npm audit (Built-in)
```bash
# Check for vulnerabilities
npm audit

# Fix vulnerabilities automatically
npm audit fix

# Fix in development dependencies only
npm audit fix --only=dev
```

#### Using pnpm audit
```bash
# Scan all dependencies
pnpm audit

# Scan with detailed output
pnpm audit --json > audit-report.json
```

#### Using Snyk (Cloud-based)
```bash
# Install Snyk CLI
npm install -g snyk

# Authenticate with Snyk account
snyk auth

# Test project for vulnerabilities
snyk test

# Monitor for continuous vulnerability tracking
snyk monitor

# Generate detailed report
snyk test --json > snyk-report.json
```

#### Using OWASP Dependency-Check
```bash
# Windows: Download from https://github.com/jeremylong/DependencyCheck
# Then run:
dependency-check --project "Xcriminal" --scan .

# Or using Docker:
docker run --rm -v "%cd%":/src owasp/dependency-check --scan /src
```

---

### 2.2 Code Security Analysis

#### Using ESLint with Security Plugin
```bash
# Already configured - run:
pnpm lint

# Check for security issues specifically
pnpm lint --rule "security/*"
```

#### Using SonarQube (Static Code Analysis)
```bash
# Install SonarScanner
npm install -g sonarqube-scanner

# Run analysis
sonar-scanner \
  -Dsonar.projectKey=xcriminal \
  -Dsonar.sources=src \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=<token>
```

#### Using Semgrep (Open-source SAST)
```bash
# Install
brew install semgrep  # macOS
# or pip install semgrep

# Scan for security issues
semgrep --config=p/security-audit src/

# Generate report
semgrep --config=p/security-audit src/ --json > semgrep-report.json
```

---

### 2.3 License Compliance Checking

#### Check for GPL or Problematic Licenses
```bash
# Using license-report
npx license-report --only=prod > licenses.json

# Using FOSSA
npm install -g fossa-cli
fossa analyze
fossa test
```

---

### 2.4 Malware & Suspicious Code Detection

#### Using npm's Malware Detection
```bash
# npm automatically checks during install for known malware
# Check installed packages registry history
npm view [package-name] time --json

# Verify package integrity
npm audit signatures
```

#### Manual Package Review
```bash
# Check node_modules for suspicious files
find node_modules -type f -name "*.exe" -o -name "*.bat" -o -name "*.sh" | grep -v "node_modules/.bin"

# Look for unexpected network calls
grep -r "http://" node_modules --include="*.js" | head -20
grep -r "require.*child_process" node_modules --include="*.js" | head -20
```

#### Using Retire.js (for JS Library Vulnerabilities)
```bash
# Install globally
npm install -g retire

# Scan the project
retire --jspath node_modules --colors

# Generate HTML report
retire --jspath node_modules --outputpath retire-report.html
```

---

### 2.5 Container Security (If Using Docker)

```bash
# Scan Dockerfile for issues
docker scan xcriminal:latest

# Use Trivy for container scanning
trivy image xcriminal:latest

# Generate vulnerability database
trivy image --format json xcriminal:latest > container-vulns.json
```

---

### 2.6 TypeScript Type Safety

```bash
# Run strict type checking
pnpm build

# Check for any issues
pnpm tsc --noEmit

# Validate all type definitions
pnpm tsc --strict src/
```

---

### 2.7 Test Suite Execution

```bash
# Run all tests (unit + integration)
pnpm test

# Run with coverage report (must reach 70% threshold)
pnpm test:coverage

# Run security-specific tests
pnpm test -- --grep="security"

# Run live tests (requires API keys)
XCRIMINAL_LIVE_TEST=1 pnpm test:live
```

---

## Part 3: Complete Security Audit Checklist

Create a file: `security-audit.sh`

```bash
#!/bin/bash

echo "=== XCRIMINAL SECURITY AUDIT ==="
echo ""

echo "1. Checking Node version..."
node --version

echo ""
echo "2. Running npm audit..."
npm audit --json > npm-audit.json
echo "   Report saved to npm-audit.json"

echo ""
echo "3. Running TypeScript type check..."
pnpm build > /dev/null 2>&1 && echo "   ✓ Type check passed" || echo "   ✗ Type errors found"

echo ""
echo "4. Running linter..."
pnpm lint > lint-report.txt 2>&1
LINT_RESULT=$?
if [ $LINT_RESULT -eq 0 ]; then
  echo "   ✓ Linting passed"
else
  echo "   ✗ Linting issues found (see lint-report.txt)"
fi

echo ""
echo "5. Checking for hardcoded secrets..."
if command -v detect-secrets &> /dev/null; then
  detect-secrets scan > secrets-baseline.json
  echo "   Report saved to secrets-baseline.json"
else
  echo "   ! detect-secrets not installed (optional)"
fi

echo ""
echo "6. Running test suite..."
pnpm test > test-report.txt 2>&1
TEST_RESULT=$?
if [ $TEST_RESULT -eq 0 ]; then
  echo "   ✓ All tests passed"
else
  echo "   ✗ Some tests failed (see test-report.txt)"
fi

echo ""
echo "7. Checking dependencies..."
npm ls --depth=0

echo ""
echo "=== AUDIT COMPLETE ==="
echo "Reports generated:"
echo "  - npm-audit.json"
echo "  - lint-report.txt"
echo "  - test-report.txt"
echo "  - secrets-baseline.json (if detect-secrets installed)"
```

Run it:
```bash
chmod +x security-audit.sh
./security-audit.sh
```

---

## Part 4: Environment Security

### 4.1 Secure Configuration

```bash
# Create .env file (DO NOT commit to git)
cat > .env.local << 'EOF'
# API Keys (keep these SECRET)
ANTHROPIC_API_KEY=your_key_here
OPENAI_API_KEY=your_key_here

# Gateway configuration
XCRIMINAL_GATEWAY_PORT=18789
XCRIMINAL_GATEWAY_TOKEN=$(openssl rand -hex 32)

# Disable channels if not using
XCRIMINAL_SKIP_CHANNELS=0

# Security
XCRIMINAL_RESTRICT_DM_POLICY=pairing
EOF

# Never commit .env.local
echo ".env.local" >> .gitignore
```

### 4.2 Check for Exposed Secrets

```bash
# Using detect-secrets (pre-installed)
detect-secrets scan src/ --baseline .secrets.baseline

# Check git history for leaked secrets
git log --all --format=%H | while read commit; do
  git show $commit | grep -i "api_key\|password\|token" || true
done | head -20
```

---

## Part 5: Network & Runtime Security

### 5.1 Gateway Security

```bash
# Start with authentication enabled
pnpm moltbot gateway \
  --port 18789 \
  --generate-gateway-token \
  --bind localhost  # Bind to localhost only

# Run doctor to check security
pnpm moltbot doctor --generate-gateway-token
```

### 5.2 Monitor Network Activity

```bash
# Monitor ports (macOS/Linux)
lsof -i :18789

# Check for suspicious network connections
netstat -tuln | grep 18789

# Intercept and inspect traffic (using mitmproxy)
mitmproxy --listen-port 8888
```

---

## Part 6: Automated Scanning Tools (One Command)

```bash
# Install all security tools
npm install -g npm-audit snyk retire semgrep

# Run comprehensive scan
cat > run-all-scans.sh << 'EOF'
#!/bin/bash
echo "Running comprehensive security scan..."
echo ""

echo "=== npm audit ==="
npm audit --json > report-npm-audit.json && echo "✓ Saved to report-npm-audit.json"

echo ""
echo "=== Snyk scan ==="
snyk test --json > report-snyk.json 2>&1 && echo "✓ Saved to report-snyk.json" || echo "! Snyk scan completed (check report)"

echo ""
echo "=== Retire.js ==="
retire --jspath node_modules --json > report-retire.json && echo "✓ Saved to report-retire.json"

echo ""
echo "=== Semgrep ==="
semgrep --config=p/security-audit src/ --json > report-semgrep.json 2>&1 && echo "✓ Saved to report-semgrep.json" || echo "! Semgrep completed"

echo ""
echo "All security reports generated in current directory"
ls -lh report-*.json
EOF

chmod +x run-all-scans.sh
./run-all-scans.sh
```

---

## Part 7: Verifying No Trojans/Backdoors

### Check for Common Backdoor Patterns

```bash
# Look for suspicious child_process usage
grep -r "child_process" src/ --include="*.ts" | grep -v test

# Check for eval() usage (dangerous)
grep -r "eval(" src/ --include="*.ts" | grep -v "^.*//.*eval"

# Look for suspicious network calls in production code
grep -r "http\.request\|fetch\|curl" src/ --include="*.ts" | grep -v "test\|mock"

# Check for suspicious file operations
grep -r "writeFileSync\|createWriteStream" src/ --include="*.ts" | grep -v test

# Look for crypto operations that might be stealing data
grep -r "crypto\." src/ --include="*.ts" | grep -v "crypto\.randomBytes\|crypto\.sign\|crypto\.verify"
```

### Verify Package Integrity

```bash
# Check npm package signatures
npm audit signatures

# Verify pnpm lock file hasn't been tampered
pnpm install --frozen-lockfile

# Check package.json matches lock file
npm ci --audit
```

---

## Part 8: Regular Monitoring

### Setup Continuous Security Monitoring

```bash
# Create a GitHub Actions workflow (.github/workflows/security.yml)
cat > .github/workflows/security.yml << 'EOF'
name: Security Scan

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 2 * * *'  # Daily at 2 AM

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: '22'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run npm audit
        run: npm audit --audit-level=moderate || true
      
      - name: Run Snyk
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        continue-on-error: true
      
      - name: Run linter
        run: npm run lint
      
      - name: Run tests
        run: npm test
EOF
```

---

## Part 9: Quick Health Check

```bash
# Run this to quickly verify everything is secure and working

cat > health-check.sh << 'EOF'
#!/bin/bash

echo "🔍 XCRIMINAL HEALTH CHECK"
echo ""

# Check Node version
NODE_VERSION=$(node -v)
echo "✓ Node version: $NODE_VERSION"

# Check npm dependencies are installed
if [ -d "node_modules" ]; then
  echo "✓ Dependencies installed"
else
  echo "✗ Missing node_modules - run: npm install"
  exit 1
fi

# Check for known vulnerabilities
VULNS=$(npm audit --json | grep -o '"vulnerabilities":[^}]*' | grep -o '[0-9]\+' | head -1)
if [ "$VULNS" == "0" ] || [ -z "$VULNS" ]; then
  echo "✓ No known vulnerabilities"
else
  echo "⚠ Found $VULNS vulnerabilities - run: npm audit"
fi

# Check TypeScript compilation
if pnpm build > /dev/null 2>&1; then
  echo "✓ TypeScript builds successfully"
else
  echo "✗ TypeScript compilation failed"
  exit 1
fi

# Check linting
if pnpm lint > /dev/null 2>&1; then
  echo "✓ Linting passed"
else
  echo "⚠ Some lint warnings"
fi

# Check .env is properly configured (if exists)
if [ ! -f ".env.local" ]; then
  echo "⚠ No .env.local file - some features may not work"
else
  echo "✓ Configuration file present"
fi

echo ""
echo "✅ HEALTH CHECK COMPLETE"
echo ""
echo "Next steps:"
echo "  1. pnpm install"
echo "  2. pnpm build"
echo "  3. pnpm gateway:watch"
echo "  4. Visit http://localhost:18789/apps/xcriminal"
EOF

chmod +x health-check.sh
./health-check.sh
```

---

## Summary

| Task | Command |
|------|---------|
| **Setup** | `pnpm install && pnpm build` |
| **Run** | `pnpm gateway:watch` |
| **Security Scan** | `npm audit && snyk test && pnpm lint` |
| **Tests** | `pnpm test:coverage` |
| **Type Check** | `pnpm build` |
| **View Dashboard** | `http://localhost:18789/apps/xcriminal` |
| **Full Audit** | `./security-audit.sh && ./health-check.sh` |

---

## Reporting Security Issues

If you find vulnerabilities:
1. **DO NOT** post publicly
2. Email security team with details
3. Wait for response before disclosure
4. See [SECURITY.md](SECURITY.md) for more info
