#!/usr/bin/env bash

# ══════════════════════════════════════════════════════════════════════════════
#  fuzzel-powermenu.sh
# ══════════════════════════════════════════════════════════════════════════════

# ── Toggle: kill fuzzel if already running ────────────────────────────────────
pkill -x fuzzel && exit 0

# ══════════════════════════════════════════════════════════════════════════════
#  Configuration
# ══════════════════════════════════════════════════════════════════════════════

# ── Font used in the fuzzel window (FontConfig format) ────────────────────────
FONT="BlexMono Nerd Font Mono:size=24"

# ── Window anchor position on screen ──────────────────────────────────────────
# Options: top-left | top | top-right | left | center | right | bottom-left | bottom | bottom-right
ANCHOR="center"

# ══════════════════════════════════════════════════════════════════════════════
#  Functions: Fuzzel Wrapper
# ══════════════════════════════════════════════════════════════════════════════

# ── Run fuzzel with predefined arguments ──────────────────────────────────────
fuzzel_run() {
    fuzzel \
        --dmenu \
        --index \
        --font="$FONT" \
        --hide-prompt \
        --anchor="$ANCHOR" \
        --select-index=0 \
        --minimal-lines \
        --width=19 \
        --horizontal-pad=38 \
        --vertical-pad=15 \
        --line-height=38 \
        --selection-radius=8
}

# ══════════════════════════════════════════════════════════════════════════════
#  Functions: Menu Definitions
# ══════════════════════════════════════════════════════════════════════════════

# ── Generate power menu items ─────────────────────────────────────────────────
show_power_menu() {
    local items=(
        "     Lock    "      # Index [0] | Alt_icon = 󰌾
        "    󰗼 Logout    "    # Index [1] | Alt_icon = 󰗼 | 󰗽
        "    󰜉 Reboot    "    # Index [2]  
        "    󰐥 Shutdown    "  # Index [3] | Additional option: [ 󰖔 Suspend | systemctl suspend | Index 2 ]
    )
    printf '%s\n' "${items[@]}"
}

# ══════════════════════════════════════════════════════════════════════════════
#  Main Execution: Action Handler
# ══════════════════════════════════════════════════════════════════════════════

# ── Capture selection and execute action ──────────────────────────────────────
CHOICE=$(show_power_menu | fuzzel_run)

case "$CHOICE" in
    0)  exec loginctl lock-session "$XDG_SESSION_ID"      ;;  # [0] Lock
    1)  exec loginctl terminate-session "$XDG_SESSION_ID" ;;  # [1] Logout
    2)  exec systemctl reboot                             ;;  # [2] Reboot
    3)  exec systemctl poweroff                           ;;  # [3] Shutdown
    *)  exit 0                                            ;;  # Cancel / Close
esac
