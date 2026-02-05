@echo off
setlocal EnableDelayedExpansion

echo ==========================================
echo      Deploying md3 (appmd3.exe)
echo ==========================================

:: 1. Configuration
set "QT_BIN_DIR=C:\Qt\6.9.1\mingw_64\bin"
set "PROJECT_ROOT=%~dp0"

set "DEPLOY_DIR=%PROJECT_ROOT%deploy"
set "EXE_NAME=appmd3.exe"

:: 2. Checks
if not exist "%QT_BIN_DIR%\windeployqt.exe" (
    echo [ERROR] windeployqt.exe not found in %QT_BIN_DIR%
    echo Please check your Qt installation path.
    pause
    exit /b 1
)

:: Auto-detect Build Directory
set "BUILD_TYPE="
set "BUILD_DIR="

:: Check user argument first
if not "%~1"=="" (
    set "TRY_TYPE=%~1"
    set "TRY_DIR=%PROJECT_ROOT%build\Desktop_Qt_6_9_1_MinGW_64_bit-!TRY_TYPE!"
    if exist "!TRY_DIR!\%EXE_NAME%" (
        set "BUILD_TYPE=!TRY_TYPE!"
        set "BUILD_DIR=!TRY_DIR!"
    )
)

:: If not found yet, auto-detect
if "%BUILD_TYPE%"=="" (
    for %%T in (Release MinSizeRel RelWithDebInfo Debug) do (
        set "CHECK_DIR=%PROJECT_ROOT%build\Desktop_Qt_6_9_1_MinGW_64_bit-%%T"
        if exist "!CHECK_DIR!\%EXE_NAME%" (
            set "BUILD_TYPE=%%T"
            set "BUILD_DIR=!CHECK_DIR!"
            goto :BuildFound
        )
    )
)

:BuildFound
if "%BUILD_TYPE%"=="" (
    echo [ERROR] No compiled executable found in standard build directories.
    echo Searched in: %PROJECT_ROOT%build\Desktop_Qt_6_9_1_MinGW_64_bit-*
    echo Please build the project first.
    pause
    exit /b 1
)

echo [INFO] Target Build: %BUILD_TYPE%
echo [INFO] Source Dir:   %BUILD_DIR%

:: 3. Prepare Deploy Directory
echo [INFO] Cleaning deploy directory...
if exist "%DEPLOY_DIR%" rmdir /s /q "%DEPLOY_DIR%"
mkdir "%DEPLOY_DIR%"

:: 4. Copy Executable
echo [INFO] Copying executable...
copy "%BUILD_DIR%\%EXE_NAME%" "%DEPLOY_DIR%\" >nul
if %errorlevel% neq 0 (
    echo [ERROR] Failed to copy executable.
    pause
    exit /b 1
)

:: 5. Run windeployqt
echo [INFO] Running windeployqt...
:: Add Qt bin to PATH temporarily for this session
set "PATH=%QT_BIN_DIR%;%PATH%"

:: --qmldir points to the source code where QML files are (to scan for imports)
:: --dir points to where to put the DLLs (target dir)
:: --compiler-runtime deploys runtime libraries (libgcc, etc.)
windeployqt --qmldir "%PROJECT_ROOT%." --dir "%DEPLOY_DIR%" "%DEPLOY_DIR%\%EXE_NAME%" --compiler-runtime

if %errorlevel% neq 0 (
    echo [ERROR] windeployqt failed.
    pause
    exit /b 1
)

echo.
echo ==========================================
echo      Deployment Complete!
echo      Folder: %DEPLOY_DIR%
echo ==========================================
echo.
pause
