<#
.SYNOPSIS
    Phantom Terminal - One-Line Installer
.DESCRIPTION
    Downloads and installs Phantom Terminal startup animation.
    Interactive theme selection with arrow keys.
    Run: irm https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.ps1 | iex
#>

$ErrorActionPreference = "Stop"
$RepoUrl = "https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main"
$InstallPath = "$HOME\PhantomStartup.ps1"
$ConfigDir = "$HOME\.phantom-terminal"
$ConfigFile = "$ConfigDir\config.json"

# Colors
$ESC = [char]27
$C = @{
    Purple = "$ESC[38;5;129m"; Cyan = "$ESC[38;5;87m"; Green = "$ESC[38;5;118m"
    Blue = "$ESC[38;5;39m"; Gold = "$ESC[38;5;220m"; Red = "$ESC[38;5;196m"
    White = "$ESC[1;37m"; Gray = "$ESC[38;5;244m"; DGray = "$ESC[38;5;240m"
    Reset = "$ESC[0m"; Bold = "$ESC[1m"; Dim = "$ESC[2m"
}

function Show-Header {
    Clear-Host
    Write-Host ""
    Write-Host "$($C.Purple)  ╔══════════════════════════════════════════════════════╗$($C.Reset)"
    Write-Host "$($C.Purple)  ║$($C.Cyan)        PHANTOM TERMINAL INSTALLER v3.1           $($C.Purple)║$($C.Reset)"
    Write-Host "$($C.Purple)  ║$($C.Gray)        github.com/Unknown-2829/Phanton-terminal  $($C.Purple)║$($C.Reset)"
    Write-Host "$($C.Purple)  ╚══════════════════════════════════════════════════════╝$($C.Reset)"
    Write-Host ""
}

function Show-ThemeSelector {
    param([int]$Selected = 0)
    
    $themes = @(
        @{
            Name = "PHANTOM"
            Color = $C.Purple
            Accent = $C.Cyan
            Desc = "Purple/Cyan neon • Ghost in the machine"
            Art = @(
                " ____  _   _    _    _   _ _____ ___  __  __ "
                "|  _ \| | | |  / \  | \ | |_   _/ _ \|  \/  |"
                "|  __/|  _  |/ ___ \| |\  | | || |_| | |  | |"
                "|_|   |_| |_/_/   \_\_| \_| |_| \___/|_|  |_|"
            )
        },
        @{
            Name = "UNKNOWN"
            Color = $C.Green
            Accent = $C.Blue
            Desc = "Green/Blue neon • Anonymous by design"
            Art = @(
                " _   _ _   _ _  ___   _  _____        ___   _ "
                "| | | | \ | | |/ / \ | |/ _ \ \      / / \ | |"
                "| |_| | |\  | . \| |\  | |_| |\ V  V /| |\  |"
                " \___/|_| \_|_|\_\_| \_|\___/  \_/\_/ |_| \_|"
            )
        }
    )
    
    Write-Host "$($C.Gold)  SELECT YOUR THEME$($C.Reset)"
    Write-Host "$($C.DGray)  Use [1] or [2] to select, [Enter] to confirm$($C.Reset)"
    Write-Host ""
    
    for ($i = 0; $i -lt $themes.Count; $i++) {
        $t = $themes[$i]
        $isSelected = ($i -eq $Selected)
        
        if ($isSelected) {
            $border = $t.Color
            $marker = "$($C.Green)>>$($C.Reset)"
        } else {
            $border = $C.DGray
            $marker = "  "
        }
        
        Write-Host ""
        Write-Host "  $marker $border╔════════════════════════════════════════════════╗$($C.Reset)"
        Write-Host "     $border║$($C.Reset)  $($t.Color)[$($i + 1)] $($t.Name)$($C.Reset)$((' ' * (38 - $t.Name.Length)))$border║$($C.Reset)"
        Write-Host "     $border╠════════════════════════════════════════════════╣$($C.Reset)"
        
        foreach ($line in $t.Art) {
            $pad = 46 - $line.Length
            if ($pad -lt 0) { $pad = 0 }
            Write-Host "     $border║$($C.Reset) $($t.Color)$line$((' ' * $pad))$border║$($C.Reset)"
        }
        
        Write-Host "     $border╠════════════════════════════════════════════════╣$($C.Reset)"
        Write-Host "     $border║$($C.Reset)  $($C.Gray)$($t.Desc)$((' ' * (44 - $t.Desc.Length)))$border║$($C.Reset)"
        Write-Host "     $border╚════════════════════════════════════════════════╝$($C.Reset)"
    }
    
    return $themes[$Selected].Name
}

# Main Installation
Show-Header

# Clean previous
$isReinstall = Test-Path $InstallPath
if ($isReinstall) {
    Write-Host "  $($C.Gold)[*]$($C.Gray) Removing previous installation...$($C.Reset)"
    Remove-Item $InstallPath -Force -ErrorAction SilentlyContinue
    if (Test-Path $PROFILE) {
        $content = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
        if ($content -match 'PhantomStartup') {
            ($content -split "`n" | Where-Object { $_ -notmatch 'PhantomStartup' -and $_ -notmatch 'Phantom Terminal' }) -join "`n" | Set-Content $PROFILE -Force
        }
    }
    Write-Host "  $($C.Green)[+]$($C.White) Cleaned$($C.Reset)"
    Write-Host ""
}

# Theme Selection
$selected = 0
Show-ThemeSelector -Selected $selected

Write-Host ""
Write-Host "  $($C.White)Your choice $($C.Gray)[1/2]$($C.White): $($C.Reset)" -NoNewline
$input = Read-Host

if ($input -eq "2") {
    $selected = 1
}

$selectedTheme = if ($selected -eq 0) { "Phantom" } else { "Unknown" }

# Path Display Option
Write-Host ""
Write-Host "  $($C.Gold)PROMPT PATH DISPLAY$($C.Reset)"
Write-Host "  $($C.Gray)[1] Full path   (C:\Users\Name\Projects)$($C.Reset)"
Write-Host "  $($C.Gray)[2] Folder only (Projects)$($C.Reset)"
Write-Host ""
Write-Host "  $($C.White)Your choice $($C.Gray)[1/2]$($C.White): $($C.Reset)" -NoNewline
$pathChoice = Read-Host

$showFullPath = $true
if ($pathChoice -eq "2") {
    $showFullPath = $false
    Write-Host "  $($C.Green)[+]$($C.White) Path display: $($C.Cyan)Folder only$($C.Reset)"
} else {
    Write-Host "  $($C.Green)[+]$($C.White) Path display: $($C.Cyan)Full path$($C.Reset)"
}

Show-Header
if ($selected -eq 0) {
    Write-Host "  $($C.Green)[+]$($C.White) Theme: $($C.Purple)PHANTOM$($C.Reset)"
} else {
    Write-Host "  $($C.Green)[+]$($C.White) Theme: $($C.Green)UNKNOWN$($C.Reset)"
}
Write-Host "  $($C.Green)[+]$($C.White) Path: $(if ($showFullPath) { 'Full path' } else { 'Folder only' })$($C.Reset)"
Write-Host ""

try {
    # Download
    Write-Host "  $($C.Gold)[1/3]$($C.White) Downloading script...$($C.Reset)"
    Invoke-WebRequest -Uri "$RepoUrl/PhantomStartup.ps1" -OutFile $InstallPath -UseBasicParsing
    Write-Host "  $($C.Green)[+]$($C.White) Downloaded to $($C.Gray)$InstallPath$($C.Reset)"

    # Profile
    Write-Host "  $($C.Gold)[2/3]$($C.White) Configuring profile...$($C.Reset)"
    if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -ItemType File -Force | Out-Null }
    Add-Content $PROFILE "`n# Phantom Terminal`n. `"$InstallPath`""
    Write-Host "  $($C.Green)[+]$($C.White) Profile updated$($C.Reset)"

    # Config
    Write-Host "  $($C.Gold)[3/3]$($C.White) Saving configuration...$($C.Reset)"
    if (!(Test-Path $ConfigDir)) { New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null }
    
    @{
        AnimationEnabled = $true; MatrixDuration = 2; SecurityLoadSteps = 8
        GlitchIntensity = 3; ShowSystemInfo = $true; Theme = $selectedTheme
        ShowFullPath = $showFullPath
        AutoCheckUpdates = $true; SilentUpdate = $true; UpdateCheckDays = 1
    } | ConvertTo-Json | Set-Content $ConfigFile -Force
    Write-Host "  $($C.Green)[+]$($C.White) Config saved$($C.Reset)"

    Write-Host ""
    Write-Host "  $($C.Green)╔════════════════════════════════════════════════╗$($C.Reset)"
    Write-Host "  $($C.Green)║$($C.White)         INSTALLATION COMPLETE!              $($C.Green)║$($C.Reset)"
    Write-Host "  $($C.Green)╚════════════════════════════════════════════════╝$($C.Reset)"
    Write-Host ""
    Write-Host "  $($C.Cyan)Restart your terminal to see the animation!$($C.Reset)"
    Write-Host ""
    Write-Host "  $($C.Gold)Commands:$($C.Reset)"
    Write-Host "    $($C.White)phantom-help$($C.Gray)   - All commands$($C.Reset)"
    Write-Host "    $($C.White)phantom-theme$($C.Gray)  - Change theme$($C.Reset)"
    Write-Host "    $($C.White)phantom-reload$($C.Gray) - Replay animation$($C.Reset)"
    Write-Host ""

} catch {
    Write-Host "  $($C.Red)[x] Failed: $_$($C.Reset)"
    exit 1
}
