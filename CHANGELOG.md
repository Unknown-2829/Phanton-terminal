# Changelog

All notable changes to Phantom Terminal will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
