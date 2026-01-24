<#
.SYNOPSIS
    Phantom Terminal - One-Line Installer
.DESCRIPTION
    Downloads and installs Phantom Terminal startup animation.
    Handles fresh installs and reinstalls (cleans previous version).
    Run: irm https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.ps1 | iex
#>

$ErrorActionPreference = "Stop"
$RepoUrl = "https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main"
$InstallPath = "$HOME\PhantomStartup.ps1"
$ConfigDir = "$HOME\.phantom-terminal"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Phantom Terminal Installer v3.0     " -ForegroundColor Cyan  
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if already installed (reinstall mode)
$isReinstall = Test-Path $InstallPath
if ($isReinstall) {
    Write-Host "[*] Existing installation detected" -ForegroundColor Yellow
    Write-Host "[*] Cleaning previous version..." -ForegroundColor Yellow
    
    # Remove old script
    Remove-Item $InstallPath -Force -ErrorAction SilentlyContinue
    Write-Host "    Removed old script" -ForegroundColor Green
    
    # Remove old profile entries
    if (Test-Path $PROFILE) {
        $profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
        if ($profileContent -match 'PhantomStartup') {
            $newContent = ($profileContent -split "`n" | Where-Object { $_ -notmatch 'PhantomStartup' -and $_ -notmatch 'Phantom Terminal' }) -join "`n"
            $newContent | Set-Content $PROFILE -Force
            Write-Host "    Cleaned profile entries" -ForegroundColor Green
        }
    }
    
    # Optional: Keep or reset config
    if (Test-Path $ConfigDir) {
        Write-Host "    Keeping existing config (use -Clean to reset)" -ForegroundColor Gray
    }
    
    Write-Host ""
}

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
    
    # Add to profile (fresh entry)
    Add-Content $PROFILE ""
    Add-Content $PROFILE "# Phantom Terminal Startup Animation"
    Add-Content $PROFILE ". `"$InstallPath`""
    Write-Host "      Added to profile" -ForegroundColor Green

    # Create config directory
    Write-Host "[3/3] Setting up config directory..." -ForegroundColor Yellow
    if (!(Test-Path $ConfigDir)) {
        New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
        Write-Host "      Created: $ConfigDir" -ForegroundColor Green
    } else {
        Write-Host "      Config exists: $ConfigDir" -ForegroundColor Gray
    }

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    if ($isReinstall) {
        Write-Host "   Reinstall Complete!                 " -ForegroundColor Green
    } else {
        Write-Host "   Installation Complete!              " -ForegroundColor Green
    }
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
    Write-Host "2. Save to: $InstallPath"
    Write-Host "3. Add to profile: . `"$InstallPath`""
    Write-Host ""
    exit 1
}
