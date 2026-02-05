<#
.SYNOPSIS
    Generates a new Qt/QML project based on the md3 library.
    
.DESCRIPTION
    This script creates a standalone project containing all necessary md3 sources,
    components, and widgets, ready to be built.

.PARAMETER ProjectName
    The name of the new project.

.PARAMETER TemplateName
    The template to use (default: basic).

.EXAMPLE
    .\scaffold.ps1 -ProjectName MyCoolApp
#>

param (
    [string]$ProjectName,
    [string]$TemplateName = "basic"
)

$ErrorActionPreference = "Stop"

function Pause-Script {
    Write-Host "Press any key to continue..." -NoNewline
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Write-Host ""
}

try {
    # --- 1. Validation & Setup ---
    Write-Host "=== MD3 Project Scaffolder ===" -ForegroundColor Cyan

    if ([string]::IsNullOrWhiteSpace($ProjectName)) {
        $ProjectName = Read-Host "Enter new project name"
    }

    if ([string]::IsNullOrWhiteSpace($ProjectName)) {
        Write-Host "Error: Project name cannot be empty." -ForegroundColor Red
        Pause-Script
        exit 1
    }

    # Paths
    $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $LibraryRoot = Split-Path -Parent $ScriptDir # md3 root
    $TemplatesDir = Join-Path $ScriptDir "templates"
    $SelectedTemplateDir = Join-Path $TemplatesDir $TemplateName
    $ProjectsBaseDir = Join-Path $ScriptDir "projects"
    $TargetDir = Join-Path $ProjectsBaseDir $ProjectName

    # Verify Source Existence
    $SrcDir = Join-Path $LibraryRoot "src"
    $ExamplesDir = Join-Path $LibraryRoot "examples"

    if (-not (Test-Path $SrcDir)) {
        throw "Source directory not found at: $SrcDir"
    }
    if (-not (Test-Path $SelectedTemplateDir)) {
        throw "Template '$TemplateName' not found at: $SelectedTemplateDir"
    }

    # Verify Target
    if (Test-Path $TargetDir) {
        Write-Host "Error: Target directory already exists: $TargetDir" -ForegroundColor Red
        Pause-Script
        exit 1
    }

    # --- 2. Creation & Copying ---
    Write-Host "Creating project '$ProjectName'..."
    New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null

    # Helper function for copying
    function Copy-Resource ($SourcePath, $DestName) {
        $DestPath = Join-Path $TargetDir $DestName
        if (Test-Path $SourcePath) {
            Write-Host "  Copying $DestName..."
            Copy-Item -Path $SourcePath -Destination $DestPath -Recurse -Force
        } else {
            Write-Host "  Warning: Source not found: $SourcePath" -ForegroundColor Yellow
        }
    }

    # Copy Core Directories
    Copy-Resource (Join-Path $SrcDir "components") "components"
    Copy-Resource (Join-Path $SrcDir "assets") "assets"
    Copy-Resource (Join-Path $SrcDir "material-color-utilities") "material-color-utilities"
    
    # Copy Widgets (from examples)
    Copy-Resource (Join-Path $ExamplesDir "widgets") "widgets"

    # Copy Core Files
    Copy-Resource (Join-Path $SrcDir "stylemanager.cpp") "stylemanager.cpp"
    Copy-Resource (Join-Path $SrcDir "stylemanager.h") "stylemanager.h"
    Copy-Resource (Join-Path $SrcDir "Theme.qml") "Theme.qml"
    
    # Copy App Icon (from examples)
    Copy-Resource (Join-Path $ExamplesDir "app_icon.rc") "app_icon.rc"
    Copy-Resource (Join-Path $ExamplesDir "app_icon.ico") "app_icon.ico"
    
    # Copy License
    Copy-Resource (Join-Path $LibraryRoot "LICENSE") "LICENSE"

    # --- 3. Main.cpp Processing ---
    Write-Host "  Processing main.cpp..."
    $MainCppSrc = Join-Path $ExamplesDir "main.cpp"
    if (Test-Path $MainCppSrc) {
        $Content = Get-Content -Path $MainCppSrc -Raw -Encoding UTF8
        # Replace module name "appmd3" with "md3" or user project name if we wanted, 
        # but the template uses "md3" uri.
        $Content = $Content -replace '"appmd3"', '"md3"'
        $Content | Set-Content -Path (Join-Path $TargetDir "main.cpp") -Encoding UTF8
    } else {
        Write-Host "  Warning: main.cpp not found in examples." -ForegroundColor Yellow
    }

    # --- 4. Template Application ---
    Write-Host "Applying template '$TemplateName'..."
    Get-ChildItem -Path $SelectedTemplateDir -Recurse | ForEach-Object {
        $RelPath = $_.FullName.Substring($SelectedTemplateDir.Length + 1)
        $DestPath = Join-Path $TargetDir $RelPath

        if ($_.PSIsContainer) {
            if (-not (Test-Path $DestPath)) {
                New-Item -ItemType Directory -Force -Path $DestPath | Out-Null
            }
        } else {
            $Content = Get-Content -Path $_.FullName -Raw -Encoding UTF8
            $Content = $Content -replace "\{\{PROJECT_NAME\}\}", $ProjectName
            $Content | Set-Content -Path $DestPath -Encoding UTF8
        }
    }

    # --- 5. Deploy Script ---
    Write-Host "Creating deploy.bat..."
    $DeployContent = @"
@echo off
setlocal
echo Deploying $ProjectName...
set "BUILD_DIR=%~dp0build"
set "DEPLOY_DIR=%~dp0deploy"
set "EXE=%BUILD_DIR%\app$ProjectName.exe"

if not exist "%EXE%" (
    echo Error: Executable not found at %EXE%
    echo Please build the project first.
    pause
    exit /b 1
)

if not exist "%DEPLOY_DIR%" mkdir "%DEPLOY_DIR%"
copy "%EXE%" "%DEPLOY_DIR%\" >nul

echo Running windeployqt...
windeployqt --qmldir . --dir "%DEPLOY_DIR%" "%DEPLOY_DIR%\app$ProjectName.exe" --compiler-runtime

echo Done. Output in deploy/
pause
"@
    $DeployContent | Set-Content -Path (Join-Path $TargetDir "deploy.bat") -Encoding UTF8

    # --- 6. Finalizing ---
    Write-Host "`nSuccess! Project created at:" -ForegroundColor Green
    Write-Host "  $TargetDir" -ForegroundColor White
    Write-Host "`nNext steps:"
    Write-Host "  1. cd scaffold/projects/$ProjectName"
    Write-Host "  2. mkdir build; cd build"
    Write-Host "  3. cmake .."
    Write-Host "  4. cmake --build ."
    Write-Host "  5. .\app$ProjectName.exe"
    
    Pause-Script

} catch {
    Write-Host "`nError Occurred:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Pause-Script
    exit 1
}
