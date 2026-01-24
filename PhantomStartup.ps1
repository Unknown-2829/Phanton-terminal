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
    # Animation Settings
    AnimationEnabled   = $true
    MatrixDuration     = 2
    SecurityLoadSteps  = 8
    GlitchIntensity    = 3
    
    # Display Settings
    ShowSystemInfo     = $true
    ShowUpdateNotice   = $true
    Theme              = "Phantom"
    UseUnicodeSymbols  = $true
    
    # Update Settings
    AutoCheckUpdates   = $true
    UpdateCheckDays    = 1
    
    # Performance
    UseFastRendering   = $true
    SkipOnSlowTerminal = $false
}

# ═══════════════════════════════════════════════════════════════════════════
# CONFIG FILE MANAGEMENT (JSON)
# ═══════════════════════════════════════════════════════════════════════════

function Get-PhantomConfig {
    <# .SYNOPSIS Load configuration from JSON file or create default #>
    try {
        if (Test-Path $Script:ConfigFile) {
            $loadedConfig = Get-Content $Script:ConfigFile -Raw | ConvertFrom-Json -AsHashtable
            # Merge with defaults (in case new settings added)
            $config = $Script:DefaultConfig.Clone()
            foreach ($key in $loadedConfig.Keys) {
                if ($config.ContainsKey($key)) {
                    $config[$key] = $loadedConfig[$key]
                }
            }
            return $config
        }
    } catch {
        Write-Verbose "Config load error: $_"
    }
    
    # Return defaults and save them
    Save-PhantomConfig -Config $Script:DefaultConfig
    return $Script:DefaultConfig
}

function Save-PhantomConfig {
    <# .SYNOPSIS Save configuration to JSON file #>
    param([hashtable]$Config)
    try {
        $Config | ConvertTo-Json -Depth 3 | Set-Content $Script:ConfigFile -Force
    } catch {
        Write-Verbose "Config save error: $_"
    }
}

function Get-PhantomCache {
    <# .SYNOPSIS Load cache data #>
    try {
        if (Test-Path $Script:CacheFile) {
            return Get-Content $Script:CacheFile -Raw | ConvertFrom-Json -AsHashtable
        }
    } catch {}
    return @{ LastUpdateCheck = $null; LatestVersion = $null }
}

function Save-PhantomCache {
    <# .SYNOPSIS Save cache data #>
    param([hashtable]$Cache)
    try {
        $Cache | ConvertTo-Json | Set-Content $Script:CacheFile -Force
    } catch {}
}

# Load config
$Script:Config = Get-PhantomConfig

# ═══════════════════════════════════════════════════════════════════════════
# AUTO-UPDATE CHECKER
# ═══════════════════════════════════════════════════════════════════════════

function Test-PhantomUpdate {
    <# .SYNOPSIS Check for updates from GitHub #>
    [CmdletBinding()]
    param([switch]$Force)
    
    if (-not $Script:Config.AutoCheckUpdates -and -not $Force) { return $null }
    
    $cache = Get-PhantomCache
    $now = Get-Date
    
    # Check if we need to check (once per configured days)
    if (-not $Force -and $cache.LastUpdateCheck) {
        try {
            $lastCheck = [DateTime]::Parse($cache.LastUpdateCheck)
            if (($now - $lastCheck).TotalDays -lt $Script:Config.UpdateCheckDays) {
                # Return cached result
                if ($cache.LatestVersion -and $cache.LatestVersion -gt $Script:Version) {
                    return $cache.LatestVersion
                }
                return $null
            }
        } catch {}
    }
    
    # Perform GitHub API check
    try {
        $apiUrl = "https://api.github.com/repos/$Script:RepoOwner/$Script:RepoName/releases/latest"
        $response = Invoke-RestMethod -Uri $apiUrl -TimeoutSec 5 -ErrorAction Stop
        $latestVersion = $response.tag_name -replace '^v', ''
        
        # Update cache
        $cache.LastUpdateCheck = $now.ToString("o")
        $cache.LatestVersion = $latestVersion
        Save-PhantomCache -Cache $cache
        
        # Compare versions
        if ($latestVersion -gt $Script:Version) {
            return $latestVersion
        }
    } catch {
        Write-Verbose "Update check failed: $_"
    }
    
    return $null
}

function Update-PhantomTerminal {
    <# .SYNOPSIS Download and install latest version #>
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
        Write-Host "$($Script:Colors.NeonGreen)You're running the latest version (v$Script:Version)$($Script:Colors.Reset)"
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
    Blink        = "$Script:ESC[5m"
    # Neon Palette
    NeonGreen    = "$Script:ESC[38;5;118m"
    NeonPurple   = "$Script:ESC[38;5;129m"
    NeonCyan     = "$Script:ESC[38;5;87m"
    ElectricBlue = "$Script:ESC[38;5;39m"
    HotPink      = "$Script:ESC[38;5;205m"
    Gold         = "$Script:ESC[38;5;220m"
    # Danger Palette
    BloodRed     = "$Script:ESC[38;5;196m"
    DarkRed      = "$Script:ESC[38;5;88m"
    BrightRed    = "$Script:ESC[1;91m"
    # Neutral
    White        = "$Script:ESC[1;37m"
    Gray         = "$Script:ESC[38;5;244m"
    DarkGray     = "$Script:ESC[38;5;240m"
    Shadow       = "$Script:ESC[38;5;235m"
}

# ═══════════════════════════════════════════════════════════════════════════
# SYMBOLS (Unicode with ASCII fallback)
# ═══════════════════════════════════════════════════════════════════════════

$Script:Symbols = @{
    Skull       = "💀"; Fire = "🔥"; Shield = "🛡️"; Lock = "🔒"
    Key         = "🔑"; HighVoltage = "⚡"; Bomb = "💣"
    Success     = "✔"; Failure = "✖"; Warning = "⚠️"
    Prompt      = "»"; Branch = ""; Update = "🔄"
    HLine       = "═"; VLine = "║"
    TopLeft     = "╔"; TopRight = "╗"; BottomLeft = "╚"; BottomRight = "╝"
    TLeft       = "╠"; TRight = "╣"
}

# Fallback to ASCII if Unicode disabled
if (-not $Script:Config.UseUnicodeSymbols) {
    $Script:Symbols = @{
        Skull = "[X]"; Fire = "[*]"; Shield = "[#]"; Lock = "[=]"
        Key = "[-]"; HighVoltage = "[!]"; Bomb = "[O]"
        Success = "[+]"; Failure = "[x]"; Warning = "[!]"
        Prompt = ">"; Branch = "~"; Update = "[U]"
        HLine = "="; VLine = "|"
        TopLeft = "+"; TopRight = "+"; BottomLeft = "+"; BottomRight = "+"
        TLeft = "+"; TRight = "+"
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# ASCII ART
# ═══════════════════════════════════════════════════════════════════════════

$Script:LogoArt = @"
 ██████╗ ██╗  ██╗ █████╗ ███╗   ██╗████████╗ ██████╗ ███╗   ███╗
 ██╔══██╗██║  ██║██╔══██╗████╗  ██║╚══██╔══╝██╔═══██╗████╗ ████║
 ██████╔╝███████║███████║██╔██╗ ██║   ██║   ██║   ██║██╔████╔██║
 ██╔═══╝ ██╔══██║██╔══██║██║╚██╗██║   ██║   ██║   ██║██║╚██╔╝██║
 ██║     ██║  ██║██║  ██║██║ ╚████║   ██║   ╚██████╔╝██║ ╚═╝ ██║
 ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝
"@

# ═══════════════════════════════════════════════════════════════════════════
# FAST RENDERING ENGINE (StringBuilder)
# ═══════════════════════════════════════════════════════════════════════════

function New-RenderBuffer {
    <# .SYNOPSIS Create a new StringBuilder for fast rendering #>
    return [System.Text.StringBuilder]::new(4096)
}

function Add-ToBuffer {
    <# .SYNOPSIS Append text to render buffer #>
    param([System.Text.StringBuilder]$Buffer, [string]$Text)
    [void]$Buffer.Append($Text)
}

function Write-Buffer {
    <# .SYNOPSIS Flush buffer to console in one operation #>
    param([System.Text.StringBuilder]$Buffer)
    Write-Host $Buffer.ToString() -NoNewline
    [void]$Buffer.Clear()
}

function Move-CursorFast {
    <# .SYNOPSIS Return ANSI cursor move sequence #>
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
# ANIMATION ENGINE (Optimized with StringBuilder)
# ═══════════════════════════════════════════════════════════════════════════

function Show-SecurityLoadingBar {
    param([string]$Description, [int]$Steps = 8, [string]$Color = $Script:Colors.NeonGreen)
    
    $buffer = New-RenderBuffer
    
    for ($i = 1; $i -le $Steps; $i++) {
        $filled = "█" * $i
        $empty = "░" * ($Steps - $i)
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
    $chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%&*<>{}[]"
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
                # Main character
                Add-ToBuffer $buffer (Move-CursorFast -Row $row -Col $col)
                Add-ToBuffer $buffer "$color$char"
                
                # Leading white character
                $leadPos = $row + 1
                if ($leadPos -lt $size.Height) {
                    Add-ToBuffer $buffer (Move-CursorFast -Row $leadPos -Col $col)
                    Add-ToBuffer $buffer "$($Script:Colors.White)$char"
                }
                
                # Fade trail
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
        
        # Flash red
        [void]$buffer.Clear()
        Add-ToBuffer $buffer (Move-CursorFast -Row $yPos -Col 1)
        Add-ToBuffer $buffer "$(' ' * $padding)$($Script:Colors.BloodRed)$text"
        Write-Buffer $buffer
        Start-Sleep -Milliseconds 60
        
        # Flash green
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
    
    $glitchChars = "!@#$%^&*()_+-=[]{}|;:',.<>?/~``"
    $buffer = New-RenderBuffer
    
    # Glitch phase
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
    
    # Final reveal
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
    
    # Get system info
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
    $hLine = $Script:Symbols.HLine * ($boxWidth - 2)
    
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
        '"In the shadows, we code." - Unknown',
        '"Access denied. Until now." - Anonymous',
        '"The system fears what it cannot control."',
        '"We are the ghosts in the machine."'
    )
    $quote = $quotes[(Get-Random -Minimum 0 -Maximum $quotes.Count)]
    $quotePad = [Math]::Max(0, $boxWidth - $quote.Length - 4)
    Write-Host "$indent$($Script:Colors.NeonPurple)$($Script:Symbols.VLine) $($Script:Colors.Gray)$quote$(' ' * $quotePad)$($Script:Colors.NeonPurple)$($Script:Symbols.VLine)$($Script:Colors.Reset)"
    
    Write-Host "$indent$($Script:Colors.NeonPurple)$($Script:Symbols.BottomLeft)$hLine$($Script:Symbols.BottomRight)$($Script:Colors.Reset)"
    Write-Host ""
    
    # Check for updates
    if ($Script:Config.ShowUpdateNotice) {
        $newVersion = Test-PhantomUpdate
        if ($newVersion) {
            Write-Host "$indent$($Script:Colors.Gold)$($Script:Symbols.Update) Update available: v$newVersion (run 'phantom-update')$($Script:Colors.Reset)"
        }
    }
    
    Write-Host "$indent$($Script:Colors.DarkGray)Type '$($Script:Colors.Gold)phantom-help$($Script:Colors.DarkGray)' for commands.$($Script:Colors.Reset)"
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
    <# .SYNOPSIS Replay startup animation #>
    Start-PhantomTerminal
}

function global:phantom-help {
    <# .SYNOPSIS Show help #>
    Write-Host ""
    Write-Host "$($Script:Colors.NeonCyan)=== PHANTOM TERMINAL v$Script:Version ===$($Script:Colors.Reset)"
    Write-Host ""
    Write-Host "  $($Script:Colors.Gold)phantom-reload$($Script:Colors.White)  - Replay startup animation$($Script:Colors.Reset)"
    Write-Host "  $($Script:Colors.Gold)phantom-help$($Script:Colors.White)    - Show this help$($Script:Colors.Reset)"
    Write-Host "  $($Script:Colors.Gold)phantom-config$($Script:Colors.White)  - Show/edit configuration$($Script:Colors.Reset)"
    Write-Host "  $($Script:Colors.Gold)phantom-matrix$($Script:Colors.White)  - Run matrix animation$($Script:Colors.Reset)"
    Write-Host "  $($Script:Colors.Gold)phantom-dash$($Script:Colors.White)    - Show dashboard$($Script:Colors.Reset)"
    Write-Host "  $($Script:Colors.Gold)phantom-update$($Script:Colors.White)  - Check for updates$($Script:Colors.Reset)"
    Write-Host ""
    Write-Host "$($Script:Colors.DarkGray)Config file: $Script:ConfigFile$($Script:Colors.Reset)"
    Write-Host ""
}

function global:phantom-config {
    <# .SYNOPSIS Show or edit configuration #>
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
        Write-Host "$($Script:Colors.DarkGray)Run 'phantom-config -Edit' to edit in notepad$($Script:Colors.Reset)"
        Write-Host ""
    }
}

function global:phantom-matrix {
    <# .SYNOPSIS Run matrix animation #>
    Hide-Cursor
    Show-MultiColorMatrix -DurationSeconds 5
    Show-Cursor
}

function global:phantom-dash {
    <# .SYNOPSIS Show dashboard #>
    Show-Dashboard
}

function global:phantom-update {
    <# .SYNOPSIS Check and install updates #>
    Update-PhantomTerminal
}

# ═══════════════════════════════════════════════════════════════════════════
# ENTRY POINT
# ═══════════════════════════════════════════════════════════════════════════

Set-PhantomPrompt
Start-PhantomTerminal
