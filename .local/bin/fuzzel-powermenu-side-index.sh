#!/usr/bin/env bash

# ══════════════════════════════════════════════════════════════════════════════
#  fuzzel-powermenu-side.sh
# ══════════════════════════════════════════════════════════════════════════════

# ══════════════════════════════════════════════════════════════════════════════
#  Argument Parsing
# ══════════════════════════════════════════════════════════════════════════════

VALID_ANCHORS=(top-left top top-right left center right bottom-left bottom bottom-right)

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

A fuzzel-based power menu.

Options:
  -a, --anchor ANCHOR   Window position on screen (default: center)
                        Valid values: top-left | top | top-right
                                      left | center | right
                                      bottom-left | bottom | bottom-right
  -h, --help            Show this help message and exit
EOF
}

is_valid_anchor() {
    local value="$1"
    for anchor in "${VALID_ANCHORS[@]}"; do
        [[ "$anchor" == "$value" ]] && return 0
    done
    return 1
}

# Default anchor
ANCHOR="center"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -a|--anchor)
            if [[ -z "${2-}" ]]; then
                echo "Error: --anchor requires a value." >&2
                echo "Run '$(basename "$0") --help' for usage." >&2
                exit 1
            fi
            if ! is_valid_anchor "$2"; then
                echo "Error: Invalid anchor value: '$2'" >&2
                echo "Valid values: ${VALID_ANCHORS[*]}" >&2
                exit 1
            fi
            ANCHOR="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Error: Unknown option: '$1'" >&2
            echo "Run '$(basename "$0") --help' for usage." >&2
            exit 1
            ;;
    esac
done

# ── Toggle: kill fuzzel if already running ────────────────────────────────────
pkill -x fuzzel && exit 0

# ══════════════════════════════════════════════════════════════════════════════
#  Configuration
# ══════════════════════════════════════════════════════════════════════════════

# Font used in the fuzzel window (FontConfig format)
#FONT="JetBrainsMono Nerd Font Mono:size=24"
FONT="BlexMono Nerd Font Mono:size=16"

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
        --width=11 \
        --horizontal-pad=17 \
        --vertical-pad=11 \
        --line-height=24
}

# ══════════════════════════════════════════════════════════════════════════════
#  Functions: Menu Definitions
# ══════════════════════════════════════════════════════════════════════════════

# ── Generate power menu items ─────────────────────────────────────────────────
show_power_menu() {
    local items=(
        " Lock"      # Index [0] | Alt_icon = 󰌾
        "󰗼 Logout"    # Index [1] | Alt_icon = 󰗼 | 󰗽
        "󰜉 Reboot"    # Index [2]  
        "󰐥 Shutdown"  # Index [3] | Additional option: [ 󰖔 Suspend | systemctl suspend | Index 2 ]
    )
    printf '%s\n' "${items[@]}"
}

# ══════════════════════════════════════════════════════════════════════════════
#  Main Execution: Action Handler
# ══════════════════════════════════════════════════════════════════════════════

# ── Capture selection and execute action ──────────────────────────────────────
FUZZEL_CHOICE=$(show_power_menu | fuzzel_run)

case "$FUZZEL_CHOICE" in
    0)  loginctl lock-session "$XDG_SESSION_ID"      ;;  # [0] Lock
    1)  loginctl terminate-session "$XDG_SESSION_ID" ;;  # [1] Logout
    2)  systemctl reboot                             ;;  # [2] Reboot
    3)  systemctl poweroff                           ;;  # [3] Shutdown
    *)  exit 0                                       ;;  # Cancel / Close
esac
