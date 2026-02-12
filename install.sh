#!/usr/bin/env bash
#
# Phantom Terminal - Universal Installer v3.6.0
# Cross-platform installer with automatic platform detection
# Supports: Linux, macOS, Termux (Android)
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.sh | bash
#   wget -qO- https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.sh | bash
#

set -e

# ═══════════════════════════════════════════════════════════════════════════
# COLORS
# ═══════════════════════════════════════════════════════════════════════════

E=$'\e'
PURPLE="${E}[38;5;129m"
CYAN="${E}[38;5;87m"
GREEN="${E}[38;5;118m"
BLUE="${E}[38;5;39m"
GOLD="${E}[38;5;220m"
RED="${E}[38;5;196m"
WHITE="${E}[1;37m"
GRAY="${E}[38;5;244m"
DGRAY="${E}[38;5;240m"
R="${E}[0m"

# ═══════════════════════════════════════════════════════════════════════════
# PLATFORM DETECTION
# ═══════════════════════════════════════════════════════════════════════════

detect_platform() {
    if [[ "$OSTYPE" == "linux-android"* ]] || [[ -n "$TERMUX_VERSION" ]]; then
        echo "termux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

PLATFORM=$(detect_platform)

# ═══════════════════════════════════════════════════════════════════════════
# VARIABLES
# ═══════════════════════════════════════════════════════════════════════════

REPO_URL="https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main"
CONFIG_DIR="$HOME/.phantom-terminal"
CONFIG_FILE="$CONFIG_DIR/config.json"
INSTALL_PATH="$CONFIG_DIR/PhantomStartup.sh"

# Detect shell and profile
detect_shell_profile() {
    if [[ -n "$ZSH_VERSION" ]]; then
        SHELL_TYPE="zsh"
        PROFILE="$HOME/.zshrc"
    elif [[ -n "$BASH_VERSION" ]]; then
        SHELL_TYPE="bash"
        if [[ "$PLATFORM" == "macos" ]]; then
            # macOS prefers .bash_profile
            [[ -f "$HOME/.bash_profile" ]] && PROFILE="$HOME/.bash_profile" || PROFILE="$HOME/.bashrc"
        else
            PROFILE="$HOME/.bashrc"
        fi
    else
        SHELL_TYPE="sh"
        PROFILE="$HOME/.profile"
    fi
}

detect_shell_profile

# ═══════════════════════════════════════════════════════════════════════════
# HEADER
# ═══════════════════════════════════════════════════════════════════════════

clear
echo ""
echo "${PURPLE}  ╔══════════════════════════════════════════════════════╗${R}"
echo "${PURPLE}  ║${CYAN}        PHANTOM TERMINAL INSTALLER v3.6.0          ${PURPLE}║${R}"
echo "${PURPLE}  ╚══════════════════════════════════════════════════════╝${R}"
echo ""

# Show detected platform
case "$PLATFORM" in
    termux)
        echo "  ${GREEN}[+]${WHITE} Platform: Termux (Android)${R}"
        ;;
    macos)
        echo "  ${GREEN}[+]${WHITE} Platform: macOS${R}"
        ;;
    linux)
        echo "  ${GREEN}[+]${WHITE} Platform: Linux${R}"
        ;;
    *)
        echo "  ${GOLD}[!]${WHITE} Platform: Unknown (trying generic install)${R}"
        ;;
esac

echo "  ${GREEN}[+]${WHITE} Shell: $SHELL_TYPE${R}"
echo "  ${GREEN}[+]${WHITE} Profile: $PROFILE${R}"
echo ""

# Confirmation
read -p "  ${GOLD}Continue installation? [Y/n]:${R} " confirm
confirm=${confirm:-Y}
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "  ${RED}Installation cancelled.${R}"
    exit 0
fi
echo ""

# ═══════════════════════════════════════════════════════════════════════════
# LOAD EXISTING CONFIG
# ═══════════════════════════════════════════════════════════════════════════

THEME="Phantom"
MATRIX_MODE="Letters"
SHOW_FULL_PATH=true
GRADIENT_TEXT=true
AUTO_UPDATE=true
SHOW_SYSTEM_INFO=true
SMART_SUGGESTIONS=true

if [[ -f "$CONFIG_FILE" ]]; then
    echo "  ${GOLD}[*]${GRAY} Reinstalling (your settings are preserved)...${R}"

    # Try to load existing config with jq if available
    if command -v jq &> /dev/null; then
        THEME=$(jq -r '.Theme // "Phantom"' "$CONFIG_FILE" 2>/dev/null || echo "Phantom")
        MATRIX_MODE=$(jq -r '.MatrixMode // "Letters"' "$CONFIG_FILE" 2>/dev/null || echo "Letters")
        SHOW_FULL_PATH=$(jq -r '.ShowFullPath // true' "$CONFIG_FILE" 2>/dev/null || echo "true")
        GRADIENT_TEXT=$(jq -r '.GradientText // true' "$CONFIG_FILE" 2>/dev/null || echo "true")
        AUTO_UPDATE=$(jq -r '.AutoCheckUpdates // true' "$CONFIG_FILE" 2>/dev/null || echo "true")
        SHOW_SYSTEM_INFO=$(jq -r '.ShowSystemInfo // true' "$CONFIG_FILE" 2>/dev/null || echo "true")
        SMART_SUGGESTIONS=$(jq -r '.SmartSuggestions // true' "$CONFIG_FILE" 2>/dev/null || echo "true")
    else
        # Parse manually if jq not available
        THEME=$(grep -o '"Theme"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" 2>/dev/null | sed 's/.*: *"\([^"]*\)".*/\1/' || echo "Phantom")
        MATRIX_MODE=$(grep -o '"MatrixMode"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" 2>/dev/null | sed 's/.*: *"\([^"]*\)".*/\1/' || echo "Letters")
    fi

    # Clean previous profile entries
    if [[ -f "$PROFILE" ]]; then
        sed -i.bak '/PhantomStartup\|Phantom Terminal/d' "$PROFILE" 2>/dev/null || true
    fi

    echo "  ${GREEN}[+]${WHITE} Ready${R}"
    echo ""
fi

# ═══════════════════════════════════════════════════════════════════════════
# INSTALLATION WIZARD
# ═══════════════════════════════════════════════════════════════════════════

# Theme
echo "  ${GOLD}[1] THEME${R}"
d1="1"
[[ "$THEME" == "Unknown" ]] && d1="2"
echo "  ${PURPLE}[1] Phantom${R}  ${GREEN}[2] Unknown${R}  ${DGRAY}(current: $THEME)${R}"
read -p "  Choice [Enter=$d1]: " choice
choice=${choice:-$d1}
[[ "$choice" == "2" ]] && THEME="Unknown" || THEME="Phantom"
echo "  ${GREEN}→ $THEME${R}"
echo ""

# Matrix Mode
echo "  ${GOLD}[2] MATRIX RAIN${R}"
d2="1"
[[ "$MATRIX_MODE" == "Binary" ]] && d2="2"
echo "  ${CYAN}[1] Letters${R}  ${GREEN}[2] Binary${R}  ${DGRAY}(current: $MATRIX_MODE)${R}"
read -p "  Choice [Enter=$d2]: " choice
choice=${choice:-$d2}
[[ "$choice" == "2" ]] && MATRIX_MODE="Binary" || MATRIX_MODE="Letters"
echo "  ${GREEN}→ $MATRIX_MODE${R}"
echo ""

# Prompt Path
echo "  ${GOLD}[3] PROMPT PATH${R}"
d3="1"
[[ "$SHOW_FULL_PATH" == "false" ]] && d3="2"
echo "  ${CYAN}[1] Full path${R}  ${BLUE}[2] Folder only${R}  ${DGRAY}(current: $([ "$SHOW_FULL_PATH" == "true" ] && echo "Full" || echo "Folder"))${R}"
read -p "  Choice [Enter=$d3]: " choice
choice=${choice:-$d3}
[[ "$choice" == "2" ]] && SHOW_FULL_PATH=false || SHOW_FULL_PATH=true
echo "  ${GREEN}→ $([ "$SHOW_FULL_PATH" == "true" ] && echo "Full path" || echo "Folder only")${R}"
echo ""

# Options
echo "  ${GOLD}[4] OPTIONS${R}"

dS="Y"
[[ "$SHOW_SYSTEM_INFO" == "false" ]] && dS="n"
read -p "  Show system info? [Y/n, Enter=$dS]: " choice
choice=${choice:-$dS}
[[ "$choice" =~ ^[Nn]$ ]] && SHOW_SYSTEM_INFO=false || SHOW_SYSTEM_INFO=true

dG="Y"
[[ "$GRADIENT_TEXT" == "false" ]] && dG="n"
read -p "  Gradient logo? [Y/n, Enter=$dG]: " choice
choice=${choice:-$dG}
[[ "$choice" =~ ^[Nn]$ ]] && GRADIENT_TEXT=false || GRADIENT_TEXT=true

dA="Y"
[[ "$AUTO_UPDATE" == "false" ]] && dA="n"
read -p "  Auto-update? [Y/n, Enter=$dA]: " choice
choice=${choice:-$dA}
[[ "$choice" =~ ^[Nn]$ ]] && AUTO_UPDATE=false || AUTO_UPDATE=true

echo ""

# ═══════════════════════════════════════════════════════════════════════════
# INSTALL
# ═══════════════════════════════════════════════════════════════════════════

echo "  ${GOLD}═══ INSTALLING ═══${R}"
echo ""

# Check dependencies
echo "  ${CYAN}[1/4]${WHITE} Checking dependencies...${R}"

missing_deps=()
command -v curl &> /dev/null || missing_deps+=("curl")
command -v git &> /dev/null || missing_deps+=("git")

if [[ ${#missing_deps[@]} -gt 0 ]]; then
    echo "  ${GOLD}[!]${WHITE} Missing dependencies: ${missing_deps[*]}${R}"

    if [[ "$PLATFORM" == "termux" ]]; then
        echo "  ${GRAY}Installing with pkg...${R}"
        pkg install -y "${missing_deps[@]}" 2>/dev/null || echo "  ${RED}[!] Failed to install some dependencies${R}"
    elif [[ "$PLATFORM" == "macos" ]]; then
        if command -v brew &> /dev/null; then
            echo "  ${GRAY}Installing with Homebrew...${R}"
            brew install "${missing_deps[@]}" 2>/dev/null || echo "  ${RED}[!] Failed to install some dependencies${R}"
        else
            echo "  ${GOLD}[!] Please install: ${missing_deps[*]}${R}"
        fi
    elif [[ "$PLATFORM" == "linux" ]]; then
        if command -v apt-get &> /dev/null; then
            echo "  ${GRAY}Installing with apt-get...${R}"
            sudo apt-get update -qq && sudo apt-get install -y "${missing_deps[@]}" 2>/dev/null || echo "  ${RED}[!] Failed to install some dependencies${R}"
        elif command -v yum &> /dev/null; then
            echo "  ${GRAY}Installing with yum...${R}"
            sudo yum install -y "${missing_deps[@]}" 2>/dev/null || echo "  ${RED}[!] Failed to install some dependencies${R}"
        else
            echo "  ${GOLD}[!] Please install: ${missing_deps[*]}${R}"
        fi
    fi
fi

# Install jq if not present (optional, for better config parsing)
if ! command -v jq &> /dev/null; then
    echo "  ${GRAY}[i] jq not found (optional, but recommended)${R}"
    if [[ "$PLATFORM" == "termux" ]]; then
        pkg install -y jq 2>/dev/null || true
    fi
fi

echo "  ${GREEN}[+] Dependencies checked${R}"

# Download
echo "  ${CYAN}[2/4]${WHITE} Downloading...${R}"
mkdir -p "$CONFIG_DIR"

if ! curl -fsSL "$REPO_URL/PhantomStartup.sh" -o "$INSTALL_PATH"; then
    echo "  ${RED}[x] Download failed${R}"
    exit 1
fi

chmod +x "$INSTALL_PATH"
echo "  ${GREEN}[+] Downloaded${R}"

# Profile
echo "  ${CYAN}[3/4]${WHITE} Updating profile ($PROFILE)...${R}"

# Create profile if it doesn't exist
touch "$PROFILE"

# Add to profile
cat >> "$PROFILE" <<EOF

# Phantom Terminal
if [ -f "$INSTALL_PATH" ]; then
    source "$INSTALL_PATH"
fi
EOF

echo "  ${GREEN}[+] Profile updated${R}"

# Config
echo "  ${CYAN}[4/4]${WHITE} Saving config...${R}"

cat > "$CONFIG_FILE" <<EOF
{
  "AnimationEnabled": true,
  "MatrixDuration": 2,
  "MatrixMode": "$MATRIX_MODE",
  "SecurityLoadSteps": 8,
  "GlitchIntensity": 3,
  "ShowSystemInfo": $SHOW_SYSTEM_INFO,
  "ShowFullPath": $SHOW_FULL_PATH,
  "GradientText": $GRADIENT_TEXT,
  "SmartSuggestions": $SMART_SUGGESTIONS,
  "Theme": "$THEME",
  "AutoCheckUpdates": $AUTO_UPDATE,
  "SilentUpdate": true,
  "UpdateCheckDays": 1
}
EOF

echo "  ${GREEN}[+] Config saved${R}"
echo ""

# ═══════════════════════════════════════════════════════════════════════════
# SUCCESS
# ═══════════════════════════════════════════════════════════════════════════

echo "  ${GREEN}╔════════════════════════════════════════════════╗${R}"
echo "  ${GREEN}║${WHITE}         INSTALLATION COMPLETE!              ${GREEN}║${R}"
echo "  ${GREEN}╚════════════════════════════════════════════════╝${R}"
echo ""
echo "  ${CYAN}Restart your terminal or run:${R}"
echo "  ${WHITE}source $PROFILE${R}"
echo ""
echo "  ${GOLD}Settings:${WHITE} $THEME | $MATRIX_MODE | $([ "$SHOW_FULL_PATH" == "true" ] && echo "Full" || echo "Folder")${R}"
echo "  ${GOLD}Commands:${WHITE} ${GOLD}phantom-help${GRAY} | ${GOLD}phantom-theme${GRAY} | ${GOLD}phantom-config${R}"
echo ""

# Platform-specific notes
case "$PLATFORM" in
    termux)
        echo "  ${CYAN}[Termux] Optimized for mobile display${R}"
        echo "  ${GRAY}Consider using Hacker's Keyboard for better experience${R}"
        echo ""
        ;;
    macos)
        echo "  ${CYAN}[macOS] Works best with iTerm2 or Terminal.app${R}"
        echo ""
        ;;
esac
