@echo off
REM Xcriminal Security Audit Script for Windows
REM Run: security-audit.bat

setlocal enabledelayedexpansion

cls
echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║  XCRIMINAL BOT - SECURITY AUDIT FOR WINDOWS               ║
echo ║  %date% %time%                              ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

set CRITICAL_ISSUES=0
set HIGH_ISSUES=0
set MEDIUM_ISSUES=0

REM 1. Check Node Version
echo [1/10] Checking Node.js Version
for /f "tokens=*" %%i in ('node -v 2^>nul') do set NODE_VERSION=%%i
if "%NODE_VERSION%"=="" (
    echo X Node.js not found
    set CRITICAL_ISSUES=1
    goto error
)
echo √ Node.js %NODE_VERSION%

REM 2. Check npm/pnpm
echo.
echo [2/10] Checking Package Manager
where /q pnpm
if %errorlevel% equ 0 (
    echo √ pnpm is installed
) else (
    where /q npm
    if %errorlevel% equ 0 (
        echo ^ npm is installed (pnpm recommended)
    ) else (
        echo X No package manager found
        set CRITICAL_ISSUES=1
        goto error
    )
)

REM 3. Check Dependencies
echo.
echo [3/10] Checking Dependencies
if exist "node_modules" (
    echo √ Dependencies installed
) else (
    echo X node_modules not found
    echo  Run: pnpm install
    set CRITICAL_ISSUES=1
    goto error
)

REM 4. npm audit
echo.
echo [4/10] Running npm audit
call npm audit --audit-level=critical >nul 2>&1
if %errorlevel% equ 0 (
    echo √ No critical vulnerabilities
) else (
    echo ^ Vulnerabilities detected
    call npm audit --json > npm-audit-report.json
    echo  Report: npm-audit-report.json
    set HIGH_ISSUES=1
)

REM 5. TypeScript Build
echo.
echo [5/10] TypeScript Compilation
if exist "dist" (
    echo √ Build directory exists
) else (
    echo ^ Build needed
)

if exist "pnpm-lock.yaml" (
    call pnpm build >nul 2>&1
) else (
    call npm run build >nul 2>&1
)

if %errorlevel% equ 0 (
    echo √ TypeScript compiles successfully
) else (
    echo X TypeScript compilation failed
    set CRITICAL_ISSUES=1
)

REM 6. Package integrity
echo.
echo [6/10] Checking Package Integrity
if exist "node_modules" (
    echo √ Packages installed
) else (
    echo X Missing node_modules
    set CRITICAL_ISSUES=1
)

REM 7. Configuration
echo.
echo [7/10] Configuration Security
if exist ".env.local" (
    echo √ .env.local exists
) else (
    echo ^ .env.local not found
    echo  Create: copy .env.example .env.local
)

if exist ".gitignore" (
    find /c ".env" .gitignore >nul 2>&1
    if %errorlevel% equ 0 (
        echo √ .env files in .gitignore
    ) else (
        echo ^ .env files might be exposed
        set MEDIUM_ISSUES=1
    )
)

REM 8. Check for suspicious files
echo.
echo [8/10] Scanning for Suspicious Files
setlocal enabledelayedexpansion
set SUSPICIOUS=0

for /r "node_modules" %%f in (*.exe, *.bat, *.vbs) do (
    echo ^ Found suspicious file: %%f
    set /a SUSPICIOUS+=1
)

if !SUSPICIOUS! equ 0 (
    echo √ No suspicious executables detected
) else (
    echo X Found !SUSPICIOUS! suspicious files
    set /a CRITICAL_ISSUES+=1
)
endlocal

REM 9. Git Check
echo.
echo [9/10] Git Security Check
if exist ".git" (
    echo √ Git repository found
    
    find /c "node_modules" .gitignore >nul 2>&1
    if %errorlevel% equ 0 (
        echo √ node_modules in .gitignore
    ) else (
        echo ^ node_modules not ignored
    )
) else (
    echo ^ Not a git repository
)

REM 10. Port Check
echo.
echo [10/10] Port Availability
netstat -ano ^| find ":18789" >nul 2>&1
if %errorlevel% equ 0 (
    echo ^ Port 18789 appears to be in use
    set MEDIUM_ISSUES=1
) else (
    echo √ Port 18789 is available
)

REM Summary
echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║                   AUDIT SUMMARY                            ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

if %CRITICAL_ISSUES% gtr 0 (
    echo CRITICAL ISSUES: %CRITICAL_ISSUES%
)

if %HIGH_ISSUES% gtr 0 (
    echo HIGH ISSUES: %HIGH_ISSUES%
)

if %MEDIUM_ISSUES% gtr 0 (
    echo MEDIUM ISSUES: %MEDIUM_ISSUES%
)

set /a TOTAL_ISSUES=%CRITICAL_ISSUES%+%HIGH_ISSUES%+%MEDIUM_ISSUES%

if %TOTAL_ISSUES% equ 0 (
    echo.
    echo √ ALL SECURITY CHECKS PASSED!
    echo.
    echo Next steps:
    echo   → pnpm build
    echo   → pnpm gateway:watch
    echo   → Visit http://localhost:18789/apps/xcriminal
) else (
    echo.
    echo ^ ISSUES FOUND - Review and fix before deployment
    echo.
    echo Reports generated:
    if exist "npm-audit-report.json" echo   • npm-audit-report.json
)

echo.
echo Time: %date% %time%
echo.

exit /b %TOTAL_ISSUES%

:error
echo.
echo FATAL ERROR - Cannot continue
exit /b 1
