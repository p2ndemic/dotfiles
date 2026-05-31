#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════
# https://github.com/francma/wob
# ══════════════════════════════════════════════════════════════════════
# Installation:
#   sudo pacman -S --needed brightnessctl wob
#   systemctl daemon-reload && systemctl --user enable --now wob.socket
#
# Usage:
#   wob-brightness [up|--up|down|--down]
# ══════════════════════════════════════════════════════════════════════

# Define WOB socket
readonly WOBSOCK="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/wob.sock"

# Send integer value to wob
wob_send() { echo "$1" > "$WOBSOCK" 2>/dev/null || true; }

# Get current brightness percentage (brightnessctl auto-selects the device)
get_brightness() { brightnessctl -m | awk -F'[,%]' '{print $4}'; }

# Main logic
case "$1" in
    up|--up)
        brightnessctl set +5% >/dev/null 2>&1
        wob_send "$(get_brightness)"
        ;;
    down|--down)
        brightnessctl set 5%- >/dev/null 2>&1
        wob_send "$(get_brightness)"
        ;;
    *)
        echo "Usage: $(basename "${0}") {up|--up|down|--down}"
        exit 1
        ;;
esac
