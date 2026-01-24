<#
.SYNOPSIS
    Phantom Terminal - One-Line Installer with Theme Selection
.DESCRIPTION
    Downloads and installs Phantom Terminal startup animation.
    Supports theme selection during install.
    Run: irm https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.ps1 | iex
#>

$ErrorActionPreference = "Stop"
$RepoUrl = "https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main"
$InstallPath = "$HOME\PhantomStartup.ps1"
$ConfigDir = "$HOME\.phantom-terminal"
$ConfigFile = "$ConfigDir\config.json"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Phantom Terminal Installer v3.1     " -ForegroundColor Cyan  
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check existing installation
$isReinstall = Test-Path $InstallPath
if ($isReinstall) {
    Write-Host "[*] Existing installation detected - cleaning..." -ForegroundColor Yellow
    Remove-Item $InstallPath -Force -ErrorAction SilentlyContinue
    
    if (Test-Path $PROFILE) {
        $content = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
        if ($content -match 'PhantomStartup') {
            ($content -split "`n" | Where-Object { $_ -notmatch 'PhantomStartup' -and $_ -notmatch 'Phantom Terminal' }) -join "`n" | Set-Content $PROFILE -Force
        }
    }
    Write-Host "    Cleaned previous version" -ForegroundColor Green
    Write-Host ""
}

# Theme Selection
Write-Host "[*] Available Themes:" -ForegroundColor Yellow
Write-Host ""
Write-Host "    [1] " -NoNewline -ForegroundColor White
Write-Host "Phantom" -NoNewline -ForegroundColor Magenta
Write-Host " - Purple/Cyan neon, ghost theme" -ForegroundColor Gray
Write-Host "    [2] " -NoNewline -ForegroundColor White
Write-Host "Unknown" -NoNewline -ForegroundColor Green
Write-Host " - Green/Blue neon, anonymous theme" -ForegroundColor Gray
Write-Host ""

$selectedTheme = "Phantom"
$choice = Read-Host "    Select theme (1 or 2) [default: 1]"

if ($choice -eq "2") {
    $selectedTheme = "Unknown"
    Write-Host "    Selected: Unknown" -ForegroundColor Green
} else {
    Write-Host "    Selected: Phantom" -ForegroundColor Magenta
}
Write-Host ""

try {
    # Download
    Write-Host "[1/3] Downloading PhantomStartup.ps1..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri "$RepoUrl/PhantomStartup.ps1" -OutFile $InstallPath -UseBasicParsing
    Write-Host "      Downloaded to: $InstallPath" -ForegroundColor Green

    # Profile
    Write-Host "[2/3] Configuring PowerShell profile..." -ForegroundColor Yellow
    if (!(Test-Path $PROFILE)) {
        New-Item -Path $PROFILE -ItemType File -Force | Out-Null
    }
    Add-Content $PROFILE ""
    Add-Content $PROFILE "# Phantom Terminal Startup Animation"
    Add-Content $PROFILE ". `"$InstallPath`""
    Write-Host "      Added to profile" -ForegroundColor Green

    # Config with selected theme
    Write-Host "[3/3] Setting up config..." -ForegroundColor Yellow
    if (!(Test-Path $ConfigDir)) {
        New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
    }
    
    # Create config with selected theme
    $config = @{
        AnimationEnabled = $true
        MatrixDuration = 2
        SecurityLoadSteps = 8
        GlitchIntensity = 3
        ShowSystemInfo = $true
        Theme = $selectedTheme
        AutoCheckUpdates = $true
        SilentUpdate = $true
        UpdateCheckDays = 1
    }
    $config | ConvertTo-Json | Set-Content $ConfigFile -Force
    Write-Host "      Theme set to: $selectedTheme" -ForegroundColor Green

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "   Installation Complete!              " -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Restart your terminal to see the animation!" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor Yellow
    Write-Host "  phantom-help     - Show all commands"
    Write-Host "  phantom-theme    - Switch theme"
    Write-Host "  phantom-config   - View/edit settings"
    Write-Host ""

} catch {
    Write-Host ""
    Write-Host "Installation failed: $_" -ForegroundColor Red
    exit 1
}
