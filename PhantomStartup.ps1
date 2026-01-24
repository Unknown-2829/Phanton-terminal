<#
.SYNOPSIS
    Phantom Terminal - Advanced PowerShell Startup Animation v3.0
.DESCRIPTION
    A fast, cinematic startup animation for Windows Terminal/PowerShell.
    Features: Multi-color matrix, security loading, glitch effects, external config,
    auto-update checking, and optimized StringBuilder rendering.
.NOTES
    Creator: @unknownlll2829 (Telegram)
    GitHub: https://github.com/Unknown-2829/Phanton-terminal
    Version: 3.0.0 "PHANTOM"
.EXAMPLE
    # One-line install:
    irm https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.ps1 | iex
#>

# ═══════════════════════════════════════════════════════════════════════════
# VERSION & PATHS
# ═══════════════════════════════════════════════════════════════════════════

$Script:Version = "3.0.0"
$Script:RepoOwner = "Unknown-2829"
$Script:RepoName = "Phanton-terminal"
$Script:ConfigDir = "$env:USERPROFILE\.phantom-terminal"
$Script:ConfigFile = "$Script:ConfigDir\config.json"
$Script:CacheFile = "$Script:ConfigDir\cache.json"

# Ensure config directory exists
if (-not (Test-Path $Script:ConfigDir)) {
    New-Item -ItemType Directory -Path $Script:ConfigDir -Force | Out-Null
}

# ═══════════════════════════════════════════════════════════════════════════
# DEFAULT CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════

$Script:DefaultConfig = @{
    AnimationEnabled   = $true
    MatrixDuration     = 2
    SecurityLoadSteps  = 8
    GlitchIntensity    = 3
    ShowSystemInfo     = $true
    ShowUpdateNotice   = $true
    Theme              = "Phantom"
    UseUnicodeSymbols  = $true
    AutoCheckUpdates   = $true
    UpdateCheckDays    = 1
    UseFastRendering   = $true
}

# ═══════════════════════════════════════════════════════════════════════════
# CONFIG FILE MANAGEMENT (JSON)
# ═══════════════════════════════════════════════════════════════════════════

function Get-PhantomConfig {
    try {
        if (Test-Path $Script:ConfigFile) {
            $loadedConfig = Get-Content $Script:ConfigFile -Raw | ConvertFrom-Json -AsHashtable -ErrorAction SilentlyContinue
            if ($loadedConfig) {
                $config = $Script:DefaultConfig.Clone()
                foreach ($key in $loadedConfig.Keys) {
                    if ($config.ContainsKey($key)) {
                        $config[$key] = $loadedConfig[$key]
                    }
                }
                return $config
            }
        }
    } catch {}
    Save-PhantomConfig -Config $Script:DefaultConfig
    return $Script:DefaultConfig
}

function Save-PhantomConfig {
    param([hashtable]$Config)
    try {
        $Config | ConvertTo-Json -Depth 3 | Set-Content $Script:ConfigFile -Force -Encoding UTF8
    } catch {}
}

function Get-PhantomCache {
    try {
        if (Test-Path $Script:CacheFile) {
            return Get-Content $Script:CacheFile -Raw | ConvertFrom-Json -AsHashtable -ErrorAction SilentlyContinue
        }
    } catch {}
    return @{ LastUpdateCheck = $null; LatestVersion = $null }
}

function Save-PhantomCache {
    param([hashtable]$Cache)
    try {
        $Cache | ConvertTo-Json | Set-Content $Script:CacheFile -Force -Encoding UTF8
    } catch {}
}

$Script:Config = Get-PhantomConfig

# ═══════════════════════════════════════════════════════════════════════════
# AUTO-UPDATE CHECKER
# ═══════════════════════════════════════════════════════════════════════════

function Test-PhantomUpdate {
    param([switch]$Force)
    
    if (-not $Script:Config.AutoCheckUpdates -and -not $Force) { return $null }
    
    $cache = Get-PhantomCache
    $now = Get-Date
    
    if (-not $Force -and $cache.LastUpdateCheck) {
        try {
            $lastCheck = [DateTime]::Parse($cache.LastUpdateCheck)
            if (($now - $lastCheck).TotalDays -lt $Script:Config.UpdateCheckDays) {
                if ($cache.LatestVersion -and $cache.LatestVersion -gt $Script:Version) {
                    return $cache.LatestVersion
                }
                return $null
            }
        } catch {}
    }
    
    try {
        $apiUrl = "https://api.github.com/repos/$Script:RepoOwner/$Script:RepoName/releases/latest"
        $response = Invoke-RestMethod -Uri $apiUrl -TimeoutSec 5 -ErrorAction Stop
        $latestVersion = $response.tag_name -replace '^v', ''
        
        $cache.LastUpdateCheck = $now.ToString("o")
        $cache.LatestVersion = $latestVersion
        Save-PhantomCache -Cache $cache
        
        if ($latestVersion -gt $Script:Version) {
            return $latestVersion
        }
    } catch {}
    
    return $null
}

function Update-PhantomTerminal {
    Write-Host "$($Script:Colors.NeonCyan)Checking for updates...$($Script:Colors.Reset)"
    
    $latestVersion = Test-PhantomUpdate -Force
    
    if ($latestVersion) {
        Write-Host "$($Script:Colors.Gold)New version available: v$latestVersion (current: v$Script:Version)$($Script:Colors.Reset)"
        Write-Host "$($Script:Colors.NeonGreen)Downloading update...$($Script:Colors.Reset)"
        
        try {
            $installUrl = "https://raw.githubusercontent.com/$Script:RepoOwner/$Script:RepoName/main/install.ps1"
            Invoke-Expression (Invoke-RestMethod -Uri $installUrl)
            Write-Host "$($Script:Colors.NeonGreen)Update complete! Restart your terminal.$($Script:Colors.Reset)"
        } catch {
            Write-Host "$($Script:Colors.BloodRed)Update failed: $_$($Script:Colors.Reset)"
        }
    } else {
        Write-Host "$($Script:Colors.NeonGreen)You are running the latest version (v$Script:Version)$($Script:Colors.Reset)"
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# THEME COLORS (ANSI 256 Escape Codes)
# ═══════════════════════════════════════════════════════════════════════════

$Script:ESC = [char]27

$Script:Colors = @{
    Reset        = "$Script:ESC[0m"
    Bold         = "$Script:ESC[1m"
    Dim          = "$Script:ESC[2m"
    NeonGreen    = "$Script:ESC[38;5;118m"
    NeonPurple   = "$Script:ESC[38;5;129m"
    NeonCyan     = "$Script:ESC[38;5;87m"
    ElectricBlue = "$Script:ESC[38;5;39m"
    HotPink      = "$Script:ESC[38;5;205m"
    Gold         = "$Script:ESC[38;5;220m"
    BloodRed     = "$Script:ESC[38;5;196m"
    DarkRed      = "$Script:ESC[38;5;88m"
    BrightRed    = "$Script:ESC[1;91m"
    White        = "$Script:ESC[1;37m"
    Gray         = "$Script:ESC[38;5;244m"
    DarkGray     = "$Script:ESC[38;5;240m"
    Shadow       = "$Script:ESC[38;5;235m"
}

# ═══════════════════════════════════════════════════════════════════════════
# SYMBOLS (ASCII Safe)
# ═══════════════════════════════════════════════════════════════════════════

$Script:Symbols = @{
    Skull       = "[X]"
    Fire        = "[*]"
    Shield      = "[#]"
    Lock        = "[=]"
    Key         = "[-]"
    HighVoltage = "[!]"
    Bomb        = "[O]"
    Success     = "[+]"
    Failure     = "[x]"
    Warning     = "[!]"
    Prompt      = ">"
    Branch      = "~"
    Update      = "[U]"
    HLine       = "="
    VLine       = "|"
    TopLeft     = "+"
    TopRight    = "+"
    BottomLeft  = "+"
    BottomRight = "+"
    TLeft       = "+"
    TRight      = "+"
}

# Try Unicode symbols if supported
try {
    if ($Host.UI.RawUI.OutputEncoding.EncodingName -match "Unicode|UTF") {
        $Script:Symbols = @{
            Skull       = [char]0x2620
            Fire        = [char]0x2605
            Shield      = [char]0x2591
            Lock        = [char]0x25A0
            Key         = [char]0x25CF
            HighVoltage = [char]0x26A1
            Bomb        = [char]0x25C6
            Success     = [char]0x2714
            Failure     = [char]0x2718
            Warning     = [char]0x26A0
            Prompt      = [char]0x00BB
            Branch      = [char]0x2192
            Update      = [char]0x21BB
            HLine       = [char]0x2550
            VLine       = [char]0x2551
            TopLeft     = [char]0x2554
            TopRight    = [char]0x2557
            BottomLeft  = [char]0x255A
            BottomRight = [char]0x255D
            TLeft       = [char]0x2560
            TRight      = [char]0x2563
        }
    }
} catch {}

# ═══════════════════════════════════════════════════════════════════════════
# ASCII ART
# ═══════════════════════════════════════════════════════════════════════════

$Script:LogoArt = @'
 ____  _   _    _    _   _ _____ ___  __  __ 
|  _ \| | | |  / \  | \ | |_   _/ _ \|  \/  |
| |_) | |_| | / _ \ |  \| | | || | | | |\/| |
|  __/|  _  |/ ___ \| |\  | | || |_| | |  | |
|_|   |_| |_/_/   \_\_| \_| |_| \___/|_|  |_|
'@

# ═══════════════════════════════════════════════════════════════════════════
# FAST RENDERING ENGINE (StringBuilder)
# ═══════════════════════════════════════════════════════════════════════════

function New-RenderBuffer {
    return [System.Text.StringBuilder]::new(4096)
}

function Add-ToBuffer {
    param([System.Text.StringBuilder]$Buffer, [string]$Text)
    [void]$Buffer.Append($Text)
}

function Write-Buffer {
    param([System.Text.StringBuilder]$Buffer)
    Write-Host $Buffer.ToString() -NoNewline
    [void]$Buffer.Clear()
}

function Move-CursorFast {
    param([int]$Row, [int]$Col)
    return "$Script:ESC[$Row;${Col}H"
}

# ═══════════════════════════════════════════════════════════════════════════
# UTILITY FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

function Hide-Cursor { Write-Host "$Script:ESC[?25l" -NoNewline }
function Show-Cursor { Write-Host "$Script:ESC[?25h" -NoNewline }
function Clear-TerminalScreen { Clear-Host; Write-Host "$Script:ESC[H" -NoNewline }

function Get-TerminalSize {
    try {
        return @{
            Width  = $Host.UI.RawUI.WindowSize.Width
            Height = $Host.UI.RawUI.WindowSize.Height
        }
    } catch {
        return @{ Width = 120; Height = 30 }
    }
}

function Write-Centered {
    param([string]$Text, [string]$Color = $Script:Colors.White)
    $size = Get-TerminalSize
    $cleanText = $Text -replace '\x1b\[[0-9;]*m', ''
    $padding = [Math]::Max(0, [Math]::Floor(($size.Width - $cleanText.Length) / 2))
    Write-Host "$(' ' * $padding)$Color$Text$($Script:Colors.Reset)"
}

# ═══════════════════════════════════════════════════════════════════════════
# ANIMATION ENGINE
# ═══════════════════════════════════════════════════════════════════════════

function Show-SecurityLoadingBar {
    param([string]$Description, [int]$Steps = 8, [string]$Color = $Script:Colors.NeonGreen)
    
    $buffer = New-RenderBuffer
    
    for ($i = 1; $i -le $Steps; $i++) {
        $filled = [string]::new([char]0x2588, $i)
        $empty = [string]::new([char]0x2591, ($Steps - $i))
        $percent = [Math]::Floor(($i / $Steps) * 100)
        
        [void]$buffer.Clear()
        Add-ToBuffer $buffer "`r  $($Script:Colors.Gray)$Description $($Script:Colors.DarkGray)[$Color$filled$($Script:Colors.DarkGray)$empty] $($Script:Colors.White)$($percent.ToString().PadLeft(3))%"
        Write-Buffer $buffer
        
        Start-Sleep -Milliseconds 30
    }
    
    Write-Host " $($Script:Colors.NeonGreen)$($Script:Symbols.Success)$($Script:Colors.Reset)"
}

function Show-MultiColorMatrix {
    param([int]$DurationSeconds = 2)
    
    Clear-TerminalScreen
    $size = Get-TerminalSize
    $chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    $colorList = @($Script:Colors.NeonGreen, $Script:Colors.NeonPurple, $Script:Colors.NeonCyan, $Script:Colors.ElectricBlue)
    
    $drops = New-Object int[] $size.Width
    for ($i = 0; $i -lt $size.Width; $i++) {
        $drops[$i] = (Get-Random -Minimum 0 -Maximum $size.Height)
    }
    
    $endTime = (Get-Date).AddSeconds($DurationSeconds)
    $buffer = New-RenderBuffer
    
    while ((Get-Date) -lt $endTime) {
        [void]$buffer.Clear()
        
        for ($col = 0; $col -lt [Math]::Min($size.Width, $drops.Count); $col++) {
            $char = $chars[(Get-Random -Minimum 0 -Maximum $chars.Length)]
            $color = $colorList[$col % $colorList.Length]
            $row = $drops[$col]
            
            if ($row -lt $size.Height -and $row -ge 1) {
                Add-ToBuffer $buffer (Move-CursorFast -Row $row -Col $col)
                Add-ToBuffer $buffer "$color$char"
                
                $leadPos = $row + 1
                if ($leadPos -lt $size.Height) {
                    Add-ToBuffer $buffer (Move-CursorFast -Row $leadPos -Col $col)
                    Add-ToBuffer $buffer "$($Script:Colors.White)$char"
                }
                
                $fadePos = $row - 3
                if ($fadePos -ge 1) {
                    Add-ToBuffer $buffer (Move-CursorFast -Row $fadePos -Col $col)
                    Add-ToBuffer $buffer "$($Script:Colors.Shadow)$char"
                }
            }
            
            $drops[$col]++
            if ($drops[$col] -ge $size.Height -and (Get-Random -Minimum 0 -Maximum 5) -eq 0) {
                $drops[$col] = 1
            }
        }
        
        Write-Buffer $buffer
        Start-Sleep -Milliseconds 12
    }
    
    Write-Host $Script:Colors.Reset
}

function Show-CoreIgnition {
    Clear-TerminalScreen
    $size = Get-TerminalSize
    $yPos = [Math]::Floor($size.Height / 2) - 3
    
    $statuses = @(
        @{ Text = "[CORE_INIT]"; Symbol = $Script:Symbols.HighVoltage },
        @{ Text = "[ENCRYPTION_KEYS]"; Symbol = $Script:Symbols.Key },
        @{ Text = "[FIREWALL_MATRIX]"; Symbol = $Script:Symbols.Shield },
        @{ Text = "[AUTH_BYPASS]"; Symbol = $Script:Symbols.Lock },
        @{ Text = "[SYSTEM_ARMED]"; Symbol = $Script:Symbols.Bomb }
    )
    
    $buffer = New-RenderBuffer
    
    foreach ($item in $statuses) {
        $text = "$($item.Symbol) $($item.Text)"
        $padding = [Math]::Max(0, [Math]::Floor(($size.Width - $text.Length - 2) / 2))
        
        [void]$buffer.Clear()
        Add-ToBuffer $buffer (Move-CursorFast -Row $yPos -Col 1)
        Add-ToBuffer $buffer "$(' ' * $padding)$($Script:Colors.BloodRed)$text"
        Write-Buffer $buffer
        Start-Sleep -Milliseconds 60
        
        [void]$buffer.Clear()
        Add-ToBuffer $buffer (Move-CursorFast -Row $yPos -Col 1)
        Add-ToBuffer $buffer "$(' ' * $padding)$($Script:Colors.NeonGreen)$text$($Script:Colors.Reset)"
        Write-Buffer $buffer
        Write-Host ""
        
        $yPos++
        Start-Sleep -Milliseconds 30
    }
    
    Start-Sleep -Milliseconds 150
}

function Show-GlitchReveal {
    param([string]$Art, [string]$Color = $Script:Colors.NeonGreen)
    
    Clear-TerminalScreen
    $size = Get-TerminalSize
    $lines = $Art -split "`n" | Where-Object { $_.Trim() }
    
    $maxWidth = ($lines | ForEach-Object { $_.Length } | Measure-Object -Maximum).Maximum
    $startCol = [Math]::Max(1, [Math]::Floor(($size.Width - $maxWidth) / 2))
    $startRow = [Math]::Max(2, [Math]::Floor(($size.Height - $lines.Count) / 2))
    
    $glitchChars = '!@#$%_+-=:;,.?/'
    $buffer = New-RenderBuffer
    
    for ($g = 0; $g -lt $Script:Config.GlitchIntensity; $g++) {
        [void]$buffer.Clear()
        $row = $startRow
        foreach ($line in $lines) {
            Add-ToBuffer $buffer (Move-CursorFast -Row $row -Col $startCol)
            $glitched = ""
            foreach ($char in $line.ToCharArray()) {
                if ($char -ne ' ' -and (Get-Random -Minimum 0 -Maximum 10) -lt 3) {
                    $glitched += $glitchChars[(Get-Random -Minimum 0 -Maximum $glitchChars.Length)]
                } else {
                    $glitched += $char
                }
            }
            Add-ToBuffer $buffer "$($Script:Colors.BrightRed)$glitched$($Script:Colors.Reset)"
            $row++
        }
        Write-Buffer $buffer
        Start-Sleep -Milliseconds 40
    }
    
    $row = $startRow
    foreach ($line in $lines) {
        [void]$buffer.Clear()
        Add-ToBuffer $buffer (Move-CursorFast -Row $row -Col $startCol)
        Add-ToBuffer $buffer "$Color$line$($Script:Colors.Reset)"
        Write-Buffer $buffer
        Write-Host ""
        Start-Sleep -Milliseconds 20
        $row++
    }
    
    Start-Sleep -Milliseconds 300
}

function Show-SecuritySequence {
    Clear-TerminalScreen
    Write-Host "`n"
    
    $securityItems = @(
        @{ Desc = "Initializing AES-256 Encryption"; Symbol = $Script:Symbols.Lock },
        @{ Desc = "Generating SHA-512 Hashes"; Symbol = $Script:Symbols.Key },
        @{ Desc = "Activating Firewall Matrix"; Symbol = $Script:Symbols.Shield },
        @{ Desc = "Establishing Secure Channel"; Symbol = $Script:Symbols.HighVoltage }
    )
    
    Write-Centered "$($Script:Colors.NeonPurple)$($Script:Symbols.Shield) INITIALIZING SECURITY PROTOCOLS $($Script:Symbols.Shield)$($Script:Colors.Reset)"
    Write-Host ""
    
    foreach ($item in $securityItems) {
        Show-SecurityLoadingBar -Description "$($item.Symbol) $($item.Desc)" -Steps $Script:Config.SecurityLoadSteps -Color $Script:Colors.NeonGreen
    }
    
    Start-Sleep -Milliseconds 150
}

function Show-Dashboard {
    Clear-TerminalScreen
    $size = Get-TerminalSize
    
    $user = $env:USERNAME
    $computer = $env:COMPUTERNAME
    $os = try { (Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue).Caption } catch { "Windows" }
    $datetime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $uptime = try { 
        $bootTime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
        $span = (Get-Date) - $bootTime
        "{0}d {1}h {2}m" -f $span.Days, $span.Hours, $span.Minutes
    } catch { "N/A" }
    
    $boxWidth = [Math]::Min(65, $size.Width - 4)
    $padding = [Math]::Max(0, [Math]::Floor(($size.Width - $boxWidth) / 2))
    $indent = " " * $padding
    $hLine = [string]::new([char]$Script:Symbols.HLine, ($boxWidth - 2))
    
    Write-Host ""
    Write-Host "$indent$($Script:Colors.NeonPurple)$($Script:Symbols.TopLeft)$hLine$($Script:Symbols.TopRight)$($Script:Colors.Reset)"
    
    $title = "$($Script:Symbols.Skull) PHANTOM TERMINAL v$Script:Version $($Script:Symbols.Skull)"
    $titlePad = [Math]::Max(0, $boxWidth - $title.Length - 4)
    Write-Host "$indent$($Script:Colors.NeonPurple)$($Script:Symbols.VLine) $($Script:Colors.NeonCyan)$title$(' ' * $titlePad)$($Script:Colors.NeonPurple)$($Script:Symbols.VLine)$($Script:Colors.Reset)"
    
    Write-Host "$indent$($Script:Colors.NeonPurple)$($Script:Symbols.TLeft)$hLine$($Script:Symbols.TRight)$($Script:Colors.Reset)"
    
    $infoLines = @(
        @{ Label = "Operator"; Value = $user; Color = $Script:Colors.NeonGreen },
        @{ Label = "Host"; Value = $computer; Color = $Script:Colors.Gold },
        @{ Label = "System"; Value = $os; Color = $Script:Colors.Gold },
        @{ Label = "Uptime"; Value = $uptime; Color = $Script:Colors.NeonCyan },
        @{ Label = "Time"; Value = $datetime; Color = $Script:Colors.NeonCyan }
    )
    
    foreach ($info in $infoLines) {
        $lineContent = "  $($info.Label): $($info.Color)$($info.Value)$($Script:Colors.White)"
        $cleanLen = ("  " + $info.Label + ": " + $info.Value).Length
        $rightPad = [Math]::Max(0, $boxWidth - $cleanLen - 3)
        Write-Host "$indent$($Script:Colors.NeonPurple)$($Script:Symbols.VLine)$($Script:Colors.White)$lineContent$(' ' * $rightPad)$($Script:Colors.NeonPurple)$($Script:Symbols.VLine)$($Script:Colors.Reset)"
    }
    
    Write-Host "$indent$($Script:Colors.NeonPurple)$($Script:Symbols.TLeft)$hLine$($Script:Symbols.TRight)$($Script:Colors.Reset)"
    
    $quotes = @(
        'In the shadows, we code.',
        'Access denied. Until now.',
        'The system fears what it cannot control.',
        'We are the ghosts in the machine.'
    )
    $quote = $quotes[(Get-Random -Minimum 0 -Maximum $quotes.Count)]
    $quotePad = [Math]::Max(0, $boxWidth - $quote.Length - 4)
    Write-Host "$indent$($Script:Colors.NeonPurple)$($Script:Symbols.VLine) $($Script:Colors.Gray)$quote$(' ' * $quotePad)$($Script:Colors.NeonPurple)$($Script:Symbols.VLine)$($Script:Colors.Reset)"
    
    Write-Host "$indent$($Script:Colors.NeonPurple)$($Script:Symbols.BottomLeft)$hLine$($Script:Symbols.BottomRight)$($Script:Colors.Reset)"
    Write-Host ""
    
    if ($Script:Config.ShowUpdateNotice) {
        $newVersion = Test-PhantomUpdate
        if ($newVersion) {
            Write-Host "$indent$($Script:Colors.Gold)$($Script:Symbols.Update) Update available: v$newVersion (run phantom-update)$($Script:Colors.Reset)"
        }
    }
    
    Write-Host "$indent$($Script:Colors.DarkGray)Type 'phantom-help' for commands.$($Script:Colors.Reset)"
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN STARTUP SEQUENCE
# ═══════════════════════════════════════════════════════════════════════════

function Start-PhantomTerminal {
    if (-not $Script:Config.AnimationEnabled) {
        Show-Dashboard
        return
    }
    
    try {
        Hide-Cursor
        Show-CoreIgnition
        Show-SecuritySequence
        Show-MultiColorMatrix -DurationSeconds $Script:Config.MatrixDuration
        Show-GlitchReveal -Art $Script:LogoArt -Color $Script:Colors.NeonGreen
        Show-Dashboard
    } catch {
        Write-Host "$($Script:Colors.BloodRed)$($Script:Symbols.Warning) Animation error: $_$($Script:Colors.Reset)"
        Show-Dashboard
    } finally {
        Show-Cursor
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# CUSTOM PROMPT
# ═══════════════════════════════════════════════════════════════════════════

function Set-PhantomPrompt {
    function global:prompt {
        $lastSuccess = $?
        $location = (Get-Location).Path
        $folder = Split-Path $location -Leaf
        if (-not $folder) { $folder = $location }
        
        $gitBranch = ""
        if (Test-Path .git -ErrorAction SilentlyContinue) {
            try {
                $branch = git branch --show-current 2>$null
                if ($branch) {
                    $gitBranch = " $($Script:Colors.DarkGray)on $($Script:Colors.HotPink)$($Script:Symbols.Branch) $branch$($Script:Colors.Reset)"
                }
            } catch {}
        }
        
        $statusSymbol = if ($lastSuccess) { 
            "$($Script:Colors.NeonGreen)$($Script:Symbols.Success)" 
        } else { 
            "$($Script:Colors.BloodRed)$($Script:Symbols.Failure)" 
        }
        
        $line1 = "$($Script:Colors.NeonGreen)$env:USERNAME$($Script:Colors.DarkGray)@$($Script:Colors.NeonCyan)$folder$gitBranch"
        "$line1`n$statusSymbol $($Script:Colors.NeonPurple)$($Script:Symbols.Prompt)$($Script:Colors.Reset) "
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# EXPORTED COMMANDS
# ═══════════════════════════════════════════════════════════════════════════

function global:phantom-reload {
    Start-PhantomTerminal
}

function global:phantom-help {
    Write-Host ""
    Write-Host "$($Script:Colors.NeonCyan)=== PHANTOM TERMINAL v$Script:Version ===$($Script:Colors.Reset)"
    Write-Host ""
    Write-Host "  $($Script:Colors.Gold)phantom-reload$($Script:Colors.White)  - Replay startup animation$($Script:Colors.Reset)"
    Write-Host "  $($Script:Colors.Gold)phantom-help$($Script:Colors.White)    - Show this help$($Script:Colors.Reset)"
    Write-Host "  $($Script:Colors.Gold)phantom-config$($Script:Colors.White)  - Show configuration$($Script:Colors.Reset)"
    Write-Host "  $($Script:Colors.Gold)phantom-matrix$($Script:Colors.White)  - Run matrix animation$($Script:Colors.Reset)"
    Write-Host "  $($Script:Colors.Gold)phantom-dash$($Script:Colors.White)    - Show dashboard$($Script:Colors.Reset)"
    Write-Host "  $($Script:Colors.Gold)phantom-update$($Script:Colors.White)  - Check for updates$($Script:Colors.Reset)"
    Write-Host ""
    Write-Host "$($Script:Colors.DarkGray)Config: $Script:ConfigFile$($Script:Colors.Reset)"
    Write-Host ""
}

function global:phantom-config {
    param([switch]$Edit)
    
    if ($Edit) {
        notepad $Script:ConfigFile
    } else {
        Write-Host ""
        Write-Host "$($Script:Colors.NeonCyan)Current Configuration:$($Script:Colors.Reset)"
        Write-Host "$($Script:Colors.DarkGray)File: $Script:ConfigFile$($Script:Colors.Reset)"
        Write-Host ""
        $Script:Config.GetEnumerator() | Sort-Object Name | ForEach-Object {
            Write-Host "  $($Script:Colors.Gold)$($_.Key)$($Script:Colors.White): $($_.Value)$($Script:Colors.Reset)"
        }
        Write-Host ""
        Write-Host "$($Script:Colors.DarkGray)Run: phantom-config -Edit$($Script:Colors.Reset)"
        Write-Host ""
    }
}

function global:phantom-matrix {
    Hide-Cursor
    Show-MultiColorMatrix -DurationSeconds 5
    Show-Cursor
}

function global:phantom-dash {
    Show-Dashboard
}

function global:phantom-update {
    Update-PhantomTerminal
}

# ═══════════════════════════════════════════════════════════════════════════
# ENTRY POINT
# ═══════════════════════════════════════════════════════════════════════════

Set-PhantomPrompt
Start-PhantomTerminal
