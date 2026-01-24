# 🔮 Phantom Terminal

<p align="center">
  <img src="https://img.shields.io/badge/version-3.0.0-purple?style=for-the-badge" alt="Version">
  <img src="https://img.shields.io/badge/PowerShell-5.1%2B-blue?style=for-the-badge&logo=powershell" alt="PowerShell">
  <img src="https://img.shields.io/badge/Windows-10%2F11-0078D6?style=for-the-badge&logo=windows" alt="Windows">
  <img src="https://img.shields.io/github/license/Unknown-2829/Phanton-terminal?style=for-the-badge" alt="License">
</p>

<p align="center">
  <b>A cinematic startup animation for Windows Terminal / PowerShell</b><br>
  Multi-color matrix rain • Security loading • Glitch effects • Custom dashboard
</p>

---

## ⚡ One-Line Install

```powershell
irm https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.ps1 | iex
```

That's it! Restart your terminal and enjoy.

---

## 📸 Preview

```
 ██████╗ ██╗  ██╗ █████╗ ███╗   ██╗████████╗ ██████╗ ███╗   ███╗
 ██╔══██╗██║  ██║██╔══██╗████╗  ██║╚══██╔══╝██╔═══██╗████╗ ████║
 ██████╔╝███████║███████║██╔██╗ ██║   ██║   ██║   ██║██╔████╔██║
 ██╔═══╝ ██╔══██║██╔══██║██║╚██╗██║   ██║   ██║   ██║██║╚██╔╝██║
 ██║     ██║  ██║██║  ██║██║ ╚████║   ██║   ╚██████╔╝██║ ╚═╝ ██║
 ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝
```

---

## ✨ Features

- **🎬 Cinematic Startup** - Multi-stage animation sequence
- **🌧️ Matrix Rain** - Multi-color falling characters (green/purple/cyan/blue)
- **🔐 Security Loading** - Animated progress bars with glitch effects
- **💀 Glitch Reveal** - Logo appears with glitch animation
- **📊 System Dashboard** - Shows user, host, uptime, and more
- **⚡ Fast Rendering** - Optimized with StringBuilder for speed
- **📁 External Config** - JSON configuration file for easy customization
- **🔄 Auto-Update** - Checks GitHub for new versions

---

## 🛠️ Commands

| Command | Description |
|---------|-------------|
| `phantom-reload` | Replay startup animation |
| `phantom-help` | Show all commands |
| `phantom-config` | View configuration |
| `phantom-config -Edit` | Edit config in notepad |
| `phantom-matrix` | Run matrix animation |
| `phantom-dash` | Show dashboard |
| `phantom-update` | Check for updates |

---

## ⚙️ Configuration

Config file location: `~\.phantom-terminal\config.json`

```json
{
  "AnimationEnabled": true,
  "MatrixDuration": 2,
  "SecurityLoadSteps": 8,
  "GlitchIntensity": 3,
  "ShowSystemInfo": true,
  "ShowUpdateNotice": true,
  "UseUnicodeSymbols": true,
  "AutoCheckUpdates": true,
  "UpdateCheckDays": 1
}
```

### Settings Explained

| Setting | Default | Description |
|---------|---------|-------------|
| `AnimationEnabled` | `true` | Enable/disable all animations |
| `MatrixDuration` | `2` | Matrix rain duration in seconds |
| `SecurityLoadSteps` | `8` | Number of steps in loading bars |
| `GlitchIntensity` | `3` | Number of glitch iterations |
| `ShowUpdateNotice` | `true` | Show update notification on dashboard |
| `AutoCheckUpdates` | `true` | Auto-check for updates |

---

## 📦 Manual Installation

1. **Download the script:**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/PhantomStartup.ps1" -OutFile "$HOME\PhantomStartup.ps1"
```

2. **Add to PowerShell profile:**
```powershell
if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -Force }
Add-Content $PROFILE "`n. `"$HOME\PhantomStartup.ps1`""
```

3. **Restart terminal**

---

## 🗑️ Uninstall

```powershell
# Remove from profile
(Get-Content $PROFILE) -notmatch 'PhantomStartup' | Set-Content $PROFILE

# Delete files
Remove-Item "$HOME\PhantomStartup.ps1" -Force -ErrorAction SilentlyContinue
Remove-Item "$HOME\.phantom-terminal" -Recurse -Force -ErrorAction SilentlyContinue
```

---

## 📄 License

MIT License - feel free to modify and share!

---

## 👤 Author

**@unknownlll2829** (Telegram)

GitHub: [@Unknown-2829](https://github.com/Unknown-2829)
