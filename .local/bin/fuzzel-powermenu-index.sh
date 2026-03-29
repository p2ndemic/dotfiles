#!/usr/bin/env bash

# ══════════════════════════════════════════════════════════════════════════════
# fuzzel-powermenu.sh
# ══════════════════════════════════════════════════════════════════════════════

# ── Toggle: kill fuzzel if already running ────────────────────────────────────
pkill -x fuzzel && exit 0

# ══════════════════════════════════════════════════════════════════════════════
# Configuration
# ══════════════════════════════════════════════════════════════════════════════

# Font used in the fuzzel window (FontConfig format)
FONT="JetBrainsMono Nerd Font Mono:size=14"

# Window anchor position on screen
# Options: top-left | top | top-right | left | center | right | bottom-left | bottom | bottom-right
ANCHOR="center"

# ══════════════════════════════════════════════════════════════════════════════
# Functions: Fuzzel Wrapper
# ══════════════════════════════════════════════════════════════════════════════

# ── Run fuzzel with predefined arguments ──────────────────────────────────────
fuzzel_run() {
    fuzzel \
        --dmenu \
        --index \
        --font="$FONT" \
        --anchor="$ANCHOR" \
        --hide-prompt \
        --minimal-lines \
        --width=20 \
        --horizontal-pad=12 \
        --vertical-pad=10 \
        --line-height=24 \
        --no-exit-on-keyboard-focus-loss
}

# ══════════════════════════════════════════════════════════════════════════════
# Functions: Menu Definitions
# ══════════════════════════════════════════════════════════════════════════════

# ── Generate power menu items ─────────────────────────────────────────────────
show_power_menu() {
    local items=(
        " Lock"      # Index [0] | Alt_icon = 󰌾
        "󰗽 Logout"    # Index [1] | Alt_icon = 󰗼
        "󰖔 Suspend"   # Index [2]
        "󰜉 Reboot"    # Index [3]
        "󰐥 Shutdown"  # Index [4]
    )
    printf '%s\n' "${items[@]}"
}

# ══════════════════════════════════════════════════════════════════════════════
# Main Execution: Action Handler
# ══════════════════════════════════════════════════════════════════════════════

# ── Capture selection and execute action ──────────────────────────────────────
FUZZEL_CHOICE=$(show_power_menu | fuzzel_run)

case "$FUZZEL_CHOICE" in
    0)  loginctl lock-session "$XDG_SESSION_ID"      ;;  # [0] Lock
    1)  loginctl terminate-session "$XDG_SESSION_ID" ;;  # [1] Logout
    2)  systemctl suspend                            ;;  # [2] Suspend
    3)  systemctl reboot                             ;;  # [3] Reboot
    4)  systemctl poweroff                           ;;  # [4] Shutdown
    *)  exit 0                                       ;;  # Cancel / Close
esac
