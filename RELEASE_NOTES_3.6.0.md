# Release Notes - Version 3.6.0

## 🎉 Major Release: Cross-Platform Support

**Release Date:** February 12, 2026

This is a major milestone release that brings Phantom Terminal to Linux, macOS, and Termux (Android)!

---

## 🌟 What's New

### 🌍 Multi-Platform Support

Phantom Terminal now runs on **all major platforms**:

- ✅ **Windows** (PowerShell 5.1+)
- ✅ **Linux** (Bash 4.0+)
- ✅ **macOS** (Bash/Zsh)
- ✅ **Termux** (Android mobile)

### 📦 New Files

- **`PhantomStartup.sh`** - Full-featured Bash implementation
- **`install.sh`** - Universal installer with automatic platform detection
- **`PLATFORM_SUPPORT.md`** - Comprehensive platform documentation
- **`test.sh`** - Test suite for validation

---

## ✨ Features

### Cross-Platform Parity

The Bash version includes **all** features from the PowerShell version:

- 🎬 **Cinematic Startup Animation**
  - Multi-stage animation sequence
  - Core ignition sequence
  - Security loading bars
  - Glitch reveal effects

- 🌧️ **Matrix Rain Animation**
  - Letters mode (theme-specific characters)
  - Binary mode (01010101...)
  - Multi-color rendering
  - Configurable duration

- 🎨 **Theme System**
  - Phantom theme (Purple/Cyan)
  - Unknown theme (Green/Blue)
  - Runtime theme switching
  - Gradient logo rendering

- 💻 **Smart Dashboard**
  - System information display
  - User and hostname
  - OS detection
  - Uptime tracking
  - Random quotes
  - Update notifications

- 🎯 **Custom Prompt**
  - Color-coded prompt
  - Git branch detection
  - Success/failure indicators
  - Configurable path display

- ⚙️ **Configuration System**
  - JSON-based config storage
  - Cross-platform compatible
  - Persistent settings
  - Easy editing

- 🔄 **Auto-Update**
  - Automatic update checking
  - GitHub API integration
  - Silent background updates
  - Update notifications

### Platform-Specific Optimizations

#### Termux (Android)
- ASCII fallback for better mobile compatibility
- Optimized animation timings
- Touch-friendly interface
- Reduced terminal width support

#### macOS
- Automatic Zsh detection
- Proper `.bash_profile` handling
- iTerm2 optimized
- Native Terminal.app support

#### Linux
- Multiple package manager support (apt, yum, dnf)
- Shell auto-detection (bash/zsh)
- Wide terminal emulator compatibility
- Distribution-agnostic

---

## 🚀 Installation

### Quick Install

**Windows:**
```powershell
irm https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.ps1 | iex
```

**Linux/macOS/Termux:**
```bash
curl -fsSL https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.sh | bash
```

### What the Installer Does

1. ✅ Detects your platform and shell
2. ✅ Downloads the appropriate script
3. ✅ Installs dependencies (if needed)
4. ✅ Configures your shell profile
5. ✅ Preserves existing settings on reinstall
6. ✅ Creates default configuration

---

## 📋 Commands

All platforms support the same commands:

| Command | Description |
|---------|-------------|
| `phantom-reload` | Replay startup animation |
| `phantom-theme [name]` | Switch theme (Phantom/Unknown) |
| `phantom-config` | View configuration |
| `phantom-config --edit` | Edit config file |
| `phantom-matrix` | Run matrix animation |
| `phantom-dash` | Show dashboard |
| `phantom-update` | Check for updates |
| `phantom-help` | Show all commands |

**Unknown theme users** can also use `unknown-*` prefix.

---

## ⚙️ Configuration

Same config format across all platforms:

**Location:**
- Windows: `%USERPROFILE%\.phantom-terminal\config.json`
- Linux/macOS/Termux: `~/.phantom-terminal/config.json`

**Example:**
```json
{
  "AnimationEnabled": true,
  "MatrixDuration": 2,
  "MatrixMode": "Letters",
  "SecurityLoadSteps": 8,
  "GlitchIntensity": 3,
  "ShowSystemInfo": true,
  "ShowFullPath": true,
  "GradientText": true,
  "SmartSuggestions": true,
  "Theme": "Phantom",
  "AutoCheckUpdates": true,
  "SilentUpdate": true,
  "UpdateCheckDays": 1
}
```

**Config is portable** - you can copy it between systems!

---

## 🔧 Technical Details

### Requirements by Platform

**Windows:**
- PowerShell 5.1+
- Windows 10/11

**Linux:**
- Bash 4.0+
- curl or wget
- ANSI color support
- Optional: jq (recommended)

**macOS:**
- macOS 10.15+
- Bash 4.0+ or Zsh
- curl (pre-installed)

**Termux:**
- Termux app (F-Droid recommended)
- curl or wget
- pkg package manager

### Architecture

- **PowerShell version**: 1,037 lines, optimized for Windows
- **Bash version**: 742 lines, Unix-focused
- **Universal installer**: Auto-detects platform, shell, and profile
- **Shared config format**: JSON-based, cross-platform

### Testing

- ✅ Syntax validated on all platforms
- ✅ Test suite included (`test.sh`)
- ✅ Automated function tests
- ✅ Color and symbol rendering verified

---

## 📚 Documentation

- **[README.md](README.md)** - Quick start guide
- **[PLATFORM_SUPPORT.md](PLATFORM_SUPPORT.md)** - Detailed platform docs
- **[CHANGELOG.md](CHANGELOG.md)** - Version history
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guide

---

## 🐛 Known Issues

None reported yet! This is the first cross-platform release.

If you encounter any issues:
1. Check [PLATFORM_SUPPORT.md](PLATFORM_SUPPORT.md) troubleshooting section
2. Run `test.sh` to verify installation
3. Report issues on [GitHub](https://github.com/Unknown-2829/Phanton-terminal/issues)

---

## 🙏 Credits

- **Creator**: [@unknownlll2829](https://t.me/unknownlll2829)
- **GitHub**: [Unknown-2829](https://github.com/Unknown-2829)
- **Repository**: [Phanton-terminal](https://github.com/Unknown-2829/Phanton-terminal)

---

## 🔜 What's Next

Future plans:
- CI/CD testing on all platforms
- Additional themes
- Plugin system
- Performance optimizations
- More platform-specific features

---

## 📄 License

MIT License - See [LICENSE](LICENSE) for details.

---

**Enjoy your cinematic terminal experience across all your devices! 🎬🚀**
