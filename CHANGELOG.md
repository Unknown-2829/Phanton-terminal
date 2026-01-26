# Changelog

All notable changes to Phantom Terminal will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.5.0] - 2026-01-26

### Added
- **Smart Installer Upgrade**: 
  - Auto-checks and installs PSReadLine 2.2+ (needed for suggestions)
  - New "Smart Suggestions" option in installer wizard
  - Handles admin/non-admin installation gracefully

---

## [3.4.1] - 2026-01-26

### Fixed
- **Auto-fix PSReadLine Version**: Automatically loads the newest installed version (fixes "Version 2.0.0" issue on Windows)

---

## [3.4.0] - 2026-01-26

### Changed
- **Smart Suggestions v2** - Simplified and reliable
  - Inline predictions as you type (theme-colored)
  - `F2` / `Ctrl+F` / `End` to accept suggestion
  - No duplicate history, faster performance
  - 100% local, no data collection

---

## [3.3.9] - 2026-01-26

### Changed
- **Tab accepts suggestion** - Press Tab to complete inline suggestion
- Theme-based suggestion colors (purple for Phantom, green for Unknown)

---

## [3.3.8] - 2026-01-26

### Changed
- **Browser-style inline suggestions** - Gray text appears as you type
- Press `RightArrow` or `End` to accept suggestion

---

## [3.3.7] - 2026-01-26

### Fixed
- Stability improvements

---

## [3.3.6] - 2026-01-26

### Changed
- UI improvements

---

## [3.3.5] - 2026-01-26

### Fixed
- Minor improvements

---

## [3.3.4] - 2026-01-26

### Fixed
- Stability improvements

---

## [3.3.3] - 2026-01-26

### Fixed
- Syntax fix for all PowerShell versions

---

## [3.3.2] - 2026-01-26

### Fixed
- Syntax compatibility fix

---

## [3.3.1] - 2026-01-26

### Fixed
- Minor internal improvements

---

## [3.3.0] - 2026-01-26

### Added
- **Smart Suggestions** - History-based command predictions (default ON)
  - ListView shows multiple suggestions as you type
  - Theme-matching colors
  - `Tab` = menu complete, `Ctrl+F` = accept suggestion
  - `Up/Down` arrows = history search
  - 100% local processing, **no data collection**

---

## [3.2.9] - 2026-01-24

### Changed
- **Compact UNKNOWN logo** - Cleaner, more readable ASCII art

---

## [3.2.8] - 2026-01-24

### Added
- **Unknown theme commands** - `unknown-help`, `unknown-reload`, etc. work for Unknown theme users
- Dashboard shows `unknown-help` instead of `phantom-help` for Unknown theme
- Updated README with new Unknown ASCII art

---

## [3.2.7] - 2026-01-24

### Changed
- **Better UNKNOWN ASCII art** - Cleaner, smoother font style with proper W letter

---

## [3.2.6] - 2026-01-24

### Fixed
- **UNKNOWN ASCII art** - Was showing "UNKOUN", now shows correct "UNKNOWN" with W
- Improved Unknown theme logo design

---

## [3.2.5] - 2026-01-24

### Changed
- **Background updates after dashboard** - Update check now runs AFTER animation finishes
- Uses PowerShell background job - doesn't slow startup
- Terminal stays fast even when checking for updates

---

## [3.2.4] - 2026-01-24

### Fixed
- **ShowSystemInfo now works** - Set to false to hide system info in dashboard
- Added ShowSystemInfo option in installer
- All config options now properly applied

---

## [3.2.3] - 2026-01-24

### Fixed
- **PowerShell 5.1 compatibility** - Config loading now works on all PS versions
- Removed `-AsHashtable` parameter (requires PS6+)
- Config properties now explicitly copied for reliability
- Using `Out-File` for consistent UTF8 encoding

---

## [3.2.2] - 2026-01-24

### Changed
- **Performance optimizations** - Faster config loading and installer
- **Theme-colored help** - `phantom-help` now shows in gold color
- **Reliable config save** - Using Out-File for better persistence
- **Updated README** - New features and themes documented

### Fixed
- Config sometimes forgetting choices on reinstall
- Installer now properly loads all previous settings

---

## [3.2.1] - 2026-01-24

### Changed
- Quote now displays inside the dashboard box (like previous version)
- Removed CPU/RAM bars (cleaner dashboard)
- Removed typing effect (faster loading)
- Simplified installer options

---

## [3.2.0] - 2026-01-24

### Added
- **Binary Rain Mode** - Choose between Letters or Binary (01) matrix rain
- **CPU/RAM Usage Bars** - Real-time system stats in dashboard
- **Typing Effect** - Character-by-character reveal for quotes
- **Gradient Logo** - Multi-color gradient for logo display
- **Extended Quotes** - 8 quotes per theme, theme-specific content
- **Theme-Specific Matrix** - Different characters per theme

### Changed
- **Fully Automatic Updates** - Downloads silently, shows "Reopen to apply"
- **Installer Overhaul** - Step-by-step options for all features
- Themes now have taglines, gradient colors, and custom matrix chars

### Fixed
- Auto-update now works reliably with proper caching
- Update notification shows correct status

---

## [3.1.1] - 2026-01-24

### Added
- **ShowFullPath option** - Choose full path or folder name in prompt
- Path display selection during installation

### Fixed
- Theme now persists correctly across terminal restarts
- Case-insensitive theme matching (unknown/Unknown both work)
- Improved installer theme selection UI with ASCII art preview

---

## [3.1.0] - 2026-01-24

### Added
- **Theme System** - Switch between Phantom and Unknown themes
- **Unknown Theme** - Green/Blue neon with anonymous styling
- **phantom-theme command** - Easy theme switching
- **Silent Auto-Update** - Background update check without disturbance
- **Theme selection during install** - Choose theme at installation

### Changed
- Auto-update now runs silently in background using PowerShell jobs
- Dashboard shows current theme
- Colors and logos adapt to selected theme

---

## [3.0.1] - 2026-01-24

### Fixed
- Fixed encoding issues with emojis causing parse errors
- Fixed special characters in strings (ampersand, brackets)
- Improved ASCII-safe symbols with Unicode fallback

### Changed
- Installer now detects existing installation and cleans properly
- Installer removes old profile entries before adding new
- Simpler ASCII logo for better compatibility

---

## [3.0.0] - 2026-01-24

### Added
- 🚀 **StringBuilder Fast Rendering** - Optimized rendering using StringBuilder for smoother animations
- 📁 **External JSON Config** - Configuration stored in `~\.phantom-terminal\config.json`
- 🔄 **Auto-Update Checker** - Checks GitHub for new versions automatically
- 📦 **One-Line Installer** - Simple `irm | iex` installation
- 🎮 **New Commands** - `phantom-update`, `phantom-config -Edit`

### Changed
- Renamed all commands from `unknown-*` to `phantom-*`
- Improved matrix animation performance
- Better Unicode symbol handling with ASCII fallback

### Fixed
- Terminal size detection on various Windows configurations
- ANSI escape code compatibility

## [2.0.0] - 2026-01-20

### Added
- Multi-color matrix rain animation
- Security loading bars with glitch effects
- Core ignition sequence
- Glitch reveal animation
- System dashboard with uptime
- Custom colored prompt with git branch detection

### Changed
- Complete rewrite from bash to PowerShell
- Optimized for Windows Terminal

## [1.0.0] - 2026-01-15

### Added
- Initial PowerShell port
- Basic matrix animation
- Simple dashboard

---

[3.0.0]: https://github.com/Unknown-2829/Phanton-terminal/releases/tag/v3.0.0
[2.0.0]: https://github.com/Unknown-2829/Phanton-terminal/releases/tag/v2.0.0
[1.0.0]: https://github.com/Unknown-2829/Phanton-terminal/releases/tag/v1.0.0
