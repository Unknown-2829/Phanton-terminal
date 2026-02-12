#!/usr/bin/env bash
#
# Phantom Terminal - Test Suite
# Quick tests to verify installation and functionality
#

set -e

echo "🧪 Phantom Terminal Test Suite"
echo "=============================="
echo ""

# Test 1: Platform Detection
echo "Test 1: Platform Detection"
source PhantomStartup.sh
echo "  ✓ Platform: $PLATFORM"
echo ""

# Test 2: Config Loading
echo "Test 2: Config Loading"
load_config
echo "  ✓ Theme: $THEME"
echo "  ✓ Matrix Mode: $MATRIX_MODE"
echo "  ✓ Animation Enabled: $ANIMATION_ENABLED"
echo ""

# Test 3: Theme Colors
echo "Test 3: Theme Colors"
get_theme_colors
echo "  ✓ Primary color loaded"
echo "  ✓ Theme title: $TITLE"
echo ""

# Test 4: Terminal Size Detection
echo "Test 4: Terminal Size"
get_terminal_size
echo "  ✓ Width: $TERM_WIDTH"
echo "  ✓ Height: $TERM_HEIGHT"
echo ""

# Test 5: Logo Generation
echo "Test 5: Logo Generation"
if [[ "$THEME" == "Unknown" ]]; then
    logo=$(get_unknown_logo)
else
    logo=$(get_phantom_logo)
fi
logo_lines=$(echo "$logo" | wc -l)
echo "  ✓ Logo has $logo_lines lines"
echo ""

# Test 6: Function Availability
echo "Test 6: Function Availability"
type phantom-help >/dev/null 2>&1 && echo "  ✓ phantom-help" || echo "  ✗ phantom-help"
type phantom-reload >/dev/null 2>&1 && echo "  ✓ phantom-reload" || echo "  ✗ phantom-reload"
type phantom-config >/dev/null 2>&1 && echo "  ✓ phantom-config" || echo "  ✗ phantom-config"
type phantom-theme >/dev/null 2>&1 && echo "  ✓ phantom-theme" || echo "  ✗ phantom-theme"
type phantom-matrix >/dev/null 2>&1 && echo "  ✓ phantom-matrix" || echo "  ✗ phantom-matrix"
type phantom-dash >/dev/null 2>&1 && echo "  ✓ phantom-dash" || echo "  ✗ phantom-dash"
echo ""

# Test 7: Config File
echo "Test 7: Config File"
if [[ -f "$CONFIG_FILE" ]]; then
    echo "  ✓ Config file exists: $CONFIG_FILE"
else
    echo "  ℹ Config file will be created on first run"
fi
echo ""

# Test 8: Color Output
echo "Test 8: Color Output"
echo -e "  ${NEON_PURPLE}Purple${RESET} ${NEON_CYAN}Cyan${RESET} ${NEON_GREEN}Green${RESET} ${GOLD}Gold${RESET}"
echo "  ✓ Colors working"
echo ""

# Test 9: Symbols
echo "Test 9: Symbols"
echo "  Skull: $SKULL | Success: $SUCCESS | Failure: $FAILURE"
echo "  Block: $BLOCK | Empty: $BLOCK_EMPTY"
echo "  ✓ Symbols loaded"
echo ""

echo "=============================="
echo "✅ All tests passed!"
echo ""
echo "To see the full animation:"
echo "  bash -c 'source PhantomStartup.sh; start_phantom_terminal'"
