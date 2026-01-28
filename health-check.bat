@echo off
REM Xcriminal Health Check Script for Windows
REM Run: health-check.bat

setlocal enabledelayedexpansion
cls

echo.
echo ╔════════════════════════════════════════════╗
echo ║    XCRIMINAL BOT - HEALTH CHECK (WINDOWS)  ║
echo ╚════════════════════════════════════════════╝
echo.

set ISSUES=0

REM 1. Node Version
echo Checking System Environment
for /f "tokens=*" %%i in ('node -v 2^>nul') do set NODE_VERSION=%%i
if "%NODE_VERSION%"=="" (
    echo X Node.js not installed
    set /a ISSUES+=1
) else (
    echo √ %NODE_VERSION%
)

REM 2. Package Manager
where /q pnpm
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('pnpm -v 2^>nul') do echo √ pnpm %%i installed
) else (
    where /q npm
    if %errorlevel% equ 0 (
        for /f "tokens=*" %%i in ('npm -v 2^>nul') do echo ^ npm %%i (pnpm recommended)
    ) else (
        echo X No package manager found
        set /a ISSUES+=1
    )
)

REM 3. Dependencies
echo.
echo Checking Dependencies
if exist "node_modules" (
    echo √ Dependencies installed
) else (
    echo X node_modules not found
    echo  Run: pnpm install
    set /a ISSUES+=1
)

REM 4. Build Status
echo.
echo Checking Project Build
if exist "dist" (
    echo √ Build output exists
    
    call pnpm build >nul 2>&1
    if %errorlevel% equ 0 (
        echo √ Build succeeds without errors
    ) else (
        echo ^ Build has errors
        set /a ISSUES+=1
    )
) else (
    echo ^ dist/ directory not built yet
    echo  Run: pnpm build
)

REM 5. Configuration
echo.
echo Checking Configuration
if exist "package.json" (
    echo √ package.json found
    
    for /f "tokens=*" %%i in ('findstr "xcriminal" package.json ^| findstr "name"') do echo √ Package: xcriminal
) else (
    echo X package.json not found
    set /a ISSUES+=1
)

if exist ".env.local" (
    echo √ .env.local configured
) else (
    echo ^ .env.local not found
    echo  Create: copy .env.example .env.local
)

REM 6. Git Configuration
echo.
echo Checking Git Security
if exist ".git" (
    echo √ Git repository initialized
    
    find /c "node_modules" .gitignore >nul 2>&1
    if %errorlevel% equ 0 (
        echo √ node_modules ignored
    ) else (
        echo ^ node_modules might be tracked
        set /a ISSUES+=1
    )
    
    find /c ".env" .gitignore >nul 2>&1
    if %errorlevel% equ 0 (
        echo √ .env files ignored
    ) else (
        echo ^ .env files might be exposed
        set /a ISSUES+=1
    )
) else (
    echo ^ Not a git repository
)

REM 7. Security
echo.
echo Checking Security
call npm audit --audit-level=critical >nul 2>&1
if %errorlevel% equ 0 (
    echo √ No critical vulnerabilities
) else (
    echo ^ npm audit detected issues
    echo  Run: npm audit fix
)

REM 8. Linting
echo.
echo Checking Code Quality
call pnpm lint >nul 2>&1
if %errorlevel% equ 0 (
    echo √ ESLint checks passed
) else (
    echo ^ Linting warnings detected
    echo  Run: pnpm lint
)

REM 9. Tests
echo.
echo Checking Tests
call pnpm test >nul 2>&1
if %errorlevel% equ 0 (
    echo √ All tests pass
) else (
    echo ^ Some tests failing
    echo  Run: pnpm test for details
)

REM 10. Port Check
echo.
echo Checking Gateway Port
netstat -ano ^| find ":18789" >nul 2>&1
if %errorlevel% equ 0 (
    echo ^ Port 18789 appears to be in use
) else (
    echo √ Port 18789 is available
)

REM Summary
echo.
echo ╔════════════════════════════════════════════╗
echo ║          HEALTH CHECK SUMMARY              ║
echo ╚════════════════════════════════════════════╝
echo.

if %ISSUES% equ 0 (
    echo √ System is healthy and ready to use!
    echo.
    echo Quick start commands:
    echo   1. Start gateway:
    echo      pnpm gateway:watch
    echo.
    echo   2. In another terminal, test it:
    echo      pnpm moltbot agent --message "Hello"
    echo.
    echo   3. Open web dashboard:
    echo      http://localhost:18789/apps/xcriminal
    echo.
    echo   4. Run security audit:
    echo      security-audit.bat
) else (
    echo ^ Found %ISSUES% issue(s) to fix
    echo.
    echo Recommended actions:
    if not exist "node_modules" echo   → pnpm install
    if not exist "dist" echo   → pnpm build
    if not exist ".env.local" echo   → copy .env.example .env.local
)

echo.
echo Time: %date% %time%
echo.

exit /b %ISSUES%
