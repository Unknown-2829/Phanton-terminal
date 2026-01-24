<#
.SYNOPSIS
    Phantom Terminal - One-Line Installer
.DESCRIPTION
    Downloads and installs Phantom Terminal startup animation.
    Run: irm https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.ps1 | iex
#>

$ErrorActionPreference = "Stop"
$RepoUrl = "https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main"
$InstallPath = "$HOME\PhantomStartup.ps1"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Phantom Terminal Installer v3.0     " -ForegroundColor Cyan  
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

try {
    # Download main script
    Write-Host "[1/3] Downloading PhantomStartup.ps1..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri "$RepoUrl/PhantomStartup.ps1" -OutFile $InstallPath -UseBasicParsing
    Write-Host "      Downloaded to: $InstallPath" -ForegroundColor Green

    # Create/update PowerShell profile
    Write-Host "[2/3] Configuring PowerShell profile..." -ForegroundColor Yellow
    
    if (!(Test-Path $PROFILE)) {
        New-Item -Path $PROFILE -ItemType File -Force | Out-Null
        Write-Host "      Created new profile" -ForegroundColor Green
    }
    
    $profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
    $sourceLine = ". `"$InstallPath`""
    
    if ($profileContent -notmatch [regex]::Escape("PhantomStartup")) {
        Add-Content $PROFILE "`n# Phantom Terminal Startup Animation"
        Add-Content $PROFILE $sourceLine
        Write-Host "      Added to profile" -ForegroundColor Green
    } else {
        Write-Host "      Already in profile (skipped)" -ForegroundColor Yellow
    }

    # Create config directory
    Write-Host "[3/3] Creating config directory..." -ForegroundColor Yellow
    $configDir = "$HOME\.phantom-terminal"
    if (!(Test-Path $configDir)) {
        New-Item -ItemType Directory -Path $configDir -Force | Out-Null
    }
    Write-Host "      Config dir: $configDir" -ForegroundColor Green

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "   Installation Complete!              " -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Restart your terminal to see the animation!" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor Yellow
    Write-Host "  phantom-help    - Show all commands"
    Write-Host "  phantom-config  - View/edit settings"
    Write-Host "  phantom-update  - Check for updates"
    Write-Host ""

} catch {
    Write-Host ""
    Write-Host "Installation failed: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Manual install:" -ForegroundColor Yellow
    Write-Host "1. Download: $RepoUrl/PhantomStartup.ps1"
    Write-Host "2. Add to profile: . `"path\to\PhantomStartup.ps1`""
    Write-Host ""
    exit 1
}
