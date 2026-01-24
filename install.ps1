<#
.SYNOPSIS
    Phantom Terminal - Installer v3.2.1
.DESCRIPTION
    Interactive installer with theme and effect options.
    On reinstall: loads previous config as defaults, asks for new choices.
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
    Reset = "$ESC[0m"
}

# Load existing config if reinstalling
$existingConfig = $null
if (Test-Path $ConfigFile) {
    try {
        $existingConfig = Get-Content $ConfigFile -Raw | ConvertFrom-Json
    } catch {}
}

# Defaults (from existing config or fresh)
$defaults = @{
    Theme = if ($existingConfig.Theme) { $existingConfig.Theme } else { "Phantom" }
    MatrixMode = if ($existingConfig.MatrixMode) { $existingConfig.MatrixMode } else { "Letters" }
    ShowFullPath = if ($null -ne $existingConfig.ShowFullPath) { $existingConfig.ShowFullPath } else { $true }
    GradientText = if ($null -ne $existingConfig.GradientText) { $existingConfig.GradientText } else { $true }
    AutoCheckUpdates = if ($null -ne $existingConfig.AutoCheckUpdates) { $existingConfig.AutoCheckUpdates } else { $true }
}

function Show-Header {
    Clear-Host
    Write-Host ""
    Write-Host "$($C.Purple)  ╔══════════════════════════════════════════════════════╗$($C.Reset)"
    Write-Host "$($C.Purple)  ║$($C.Cyan)        PHANTOM TERMINAL INSTALLER v3.2.1          $($C.Purple)║$($C.Reset)"
    Write-Host "$($C.Purple)  ║$($C.Gray)        github.com/Unknown-2829/Phanton-terminal  $($C.Purple)║$($C.Reset)"
    Write-Host "$($C.Purple)  ╚══════════════════════════════════════════════════════╝$($C.Reset)"
    Write-Host ""
}

function Show-Option {
    param([string]$Num, [string]$Name, [string]$Desc, [string]$Color = $C.White, [bool]$IsDefault = $false)
    $marker = if ($IsDefault) { "$($C.Green)*$($C.Reset)" } else { " " }
    Write-Host "  $marker $Color[$Num] $Name$($C.Reset)"
    Write-Host "       $($C.Gray)$Desc$($C.Reset)"
}

# Main
Show-Header

# Clean previous script (keep config!)
$isReinstall = Test-Path $InstallPath
if ($isReinstall) {
    Write-Host "  $($C.Gold)[*]$($C.Gray) Reinstalling (keeping your preferences as defaults)...$($C.Reset)"
    Remove-Item $InstallPath -Force -ErrorAction SilentlyContinue
    if (Test-Path $PROFILE) {
        $content = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
        if ($content -match 'PhantomStartup') {
            ($content -split "`n" | Where-Object { $_ -notmatch 'PhantomStartup' -and $_ -notmatch 'Phantom Terminal' }) -join "`n" | Set-Content $PROFILE -Force
        }
    }
    Write-Host "  $($C.Green)[+]$($C.White) Ready for reinstall$($C.Reset)"
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════
# OPTION 1: Theme Selection
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "  $($C.Gold)═══ STEP 1: SELECT THEME ═══$($C.Reset)"
Write-Host ""
Show-Option -Num "1" -Name "PHANTOM" -Desc "Purple/Cyan neon" -Color $C.Purple -IsDefault ($defaults.Theme -eq "Phantom")
Write-Host ""
Show-Option -Num "2" -Name "UNKNOWN" -Desc "Green/Blue neon" -Color $C.Green -IsDefault ($defaults.Theme -eq "Unknown")
Write-Host ""
$defaultThemeNum = if ($defaults.Theme -eq "Unknown") { "2" } else { "1" }
Write-Host "  $($C.White)Choice $($C.Gray)[1/2, Enter=$defaultThemeNum]$($C.White): $($C.Reset)" -NoNewline
$themeChoice = Read-Host
if (-not $themeChoice) { $themeChoice = $defaultThemeNum }
$selectedTheme = if ($themeChoice -eq "2") { "Unknown" } else { "Phantom" }
Write-Host "  $($C.Green)[+]$($C.White) Theme: $selectedTheme$($C.Reset)"
Write-Host ""

# ═══════════════════════════════════════════════════════════════════════════
# OPTION 2: Matrix Mode
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "  $($C.Gold)═══ STEP 2: MATRIX RAIN MODE ═══$($C.Reset)"
Write-Host ""
Show-Option -Num "1" -Name "Letters" -Desc "Classic (ABCDEF...)" -Color $C.Cyan -IsDefault ($defaults.MatrixMode -eq "Letters")
Write-Host ""
Show-Option -Num "2" -Name "Binary" -Desc "Binary (0101...)" -Color $C.Green -IsDefault ($defaults.MatrixMode -eq "Binary")
Write-Host ""
$defaultMatrixNum = if ($defaults.MatrixMode -eq "Binary") { "2" } else { "1" }
Write-Host "  $($C.White)Choice $($C.Gray)[1/2, Enter=$defaultMatrixNum]$($C.White): $($C.Reset)" -NoNewline
$matrixChoice = Read-Host
if (-not $matrixChoice) { $matrixChoice = $defaultMatrixNum }
$matrixMode = if ($matrixChoice -eq "2") { "Binary" } else { "Letters" }
Write-Host "  $($C.Green)[+]$($C.White) Matrix: $matrixMode$($C.Reset)"
Write-Host ""

# ═══════════════════════════════════════════════════════════════════════════
# OPTION 3: Path Display
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "  $($C.Gold)═══ STEP 3: PROMPT PATH DISPLAY ═══$($C.Reset)"
Write-Host ""
Show-Option -Num "1" -Name "Full Path" -Desc "C:\Users\Name\Projects" -Color $C.Cyan -IsDefault $defaults.ShowFullPath
Write-Host ""
Show-Option -Num "2" -Name "Folder Only" -Desc "Projects" -Color $C.Blue -IsDefault (-not $defaults.ShowFullPath)
Write-Host ""
$defaultPathNum = if ($defaults.ShowFullPath) { "1" } else { "2" }
Write-Host "  $($C.White)Choice $($C.Gray)[1/2, Enter=$defaultPathNum]$($C.White): $($C.Reset)" -NoNewline
$pathChoice = Read-Host
if (-not $pathChoice) { $pathChoice = $defaultPathNum }
$showFullPath = $pathChoice -ne "2"
Write-Host "  $($C.Green)[+]$($C.White) Path: $(if ($showFullPath) { 'Full' } else { 'Folder only' })$($C.Reset)"
Write-Host ""

# ═══════════════════════════════════════════════════════════════════════════
# OPTION 4: Gradient & Auto-update
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "  $($C.Gold)═══ STEP 4: OPTIONS ═══$($C.Reset)"
Write-Host ""

# Gradient
$gradientDefault = if ($defaults.GradientText) { "Y" } else { "n" }
Write-Host "  $($C.White)Gradient colors for logo? $($C.Gray)[Y/n, Enter=$gradientDefault]$($C.White): $($C.Reset)" -NoNewline
$gradientChoice = Read-Host
if (-not $gradientChoice) { $gradientChoice = $gradientDefault }
$gradientText = $gradientChoice -ne "n" -and $gradientChoice -ne "N"
Write-Host "  $($C.Green)[+]$($C.White) Gradient: $(if ($gradientText) { 'Enabled' } else { 'Disabled' })$($C.Reset)"

# Auto Update
$autoDefault = if ($defaults.AutoCheckUpdates) { "Y" } else { "n" }
Write-Host "  $($C.White)Enable auto-update? $($C.Gray)[Y/n, Enter=$autoDefault]$($C.White): $($C.Reset)" -NoNewline
$autoUpdateChoice = Read-Host
if (-not $autoUpdateChoice) { $autoUpdateChoice = $autoDefault }
$autoUpdate = $autoUpdateChoice -ne "n" -and $autoUpdateChoice -ne "N"
Write-Host "  $($C.Green)[+]$($C.White) Auto-update: $(if ($autoUpdate) { 'Enabled' } else { 'Disabled' })$($C.Reset)"
Write-Host ""

# ═══════════════════════════════════════════════════════════════════════════
# INSTALLATION
# ═══════════════════════════════════════════════════════════════════════════

Show-Header
Write-Host "  $($C.Gold)═══ INSTALLING ═══$($C.Reset)"
Write-Host ""

try {
    # Download
    Write-Host "  $($C.Cyan)[1/3]$($C.White) Downloading script...$($C.Reset)"
    Invoke-WebRequest -Uri "$RepoUrl/PhantomStartup.ps1" -OutFile $InstallPath -UseBasicParsing
    Write-Host "  $($C.Green)[+]$($C.White) Downloaded$($C.Reset)"

    # Profile
    Write-Host "  $($C.Cyan)[2/3]$($C.White) Configuring profile...$($C.Reset)"
    if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -ItemType File -Force | Out-Null }
    Add-Content $PROFILE "`n# Phantom Terminal`n. `"$InstallPath`""
    Write-Host "  $($C.Green)[+]$($C.White) Profile updated$($C.Reset)"

    # Config
    Write-Host "  $($C.Cyan)[3/3]$($C.White) Saving configuration...$($C.Reset)"
    if (!(Test-Path $ConfigDir)) { New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null }
    
    @{
        AnimationEnabled = $true
        MatrixDuration = 2
        MatrixMode = $matrixMode
        SecurityLoadSteps = 8
        GlitchIntensity = 3
        ShowSystemInfo = $true
        ShowFullPath = $showFullPath
        GradientText = $gradientText
        Theme = $selectedTheme
        AutoCheckUpdates = $autoUpdate
        SilentUpdate = $true
        UpdateCheckDays = 1
    } | ConvertTo-Json | Set-Content $ConfigFile -Force
    Write-Host "  $($C.Green)[+]$($C.White) Config saved$($C.Reset)"

    Write-Host ""
    Write-Host "  $($C.Green)╔════════════════════════════════════════════════╗$($C.Reset)"
    Write-Host "  $($C.Green)║$($C.White)         INSTALLATION COMPLETE!              $($C.Green)║$($C.Reset)"
    Write-Host "  $($C.Green)╚════════════════════════════════════════════════╝$($C.Reset)"
    Write-Host ""
    Write-Host "  $($C.Cyan)Restart your terminal to see the animation!$($C.Reset)"
    Write-Host ""
    Write-Host "  $($C.Gold)Your Settings:$($C.Reset)"
    Write-Host "    Theme: $selectedTheme | Matrix: $matrixMode | Path: $(if ($showFullPath) {'Full'} else {'Folder'})"
    Write-Host ""
    Write-Host "  $($C.Gold)Commands:$($C.Reset)"
    Write-Host "    $($C.White)phantom-help$($C.Gray)   - All commands$($C.Reset)"
    Write-Host "    $($C.White)phantom-theme$($C.Gray)  - Change theme$($C.Reset)"
    Write-Host "    $($C.White)phantom-config$($C.Gray) - Edit all settings$($C.Reset)"
    Write-Host ""

} catch {
    Write-Host "  $($C.Red)[x] Failed: $_$($C.Reset)"
    exit 1
}
