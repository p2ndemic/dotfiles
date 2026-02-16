#!/bin/bash
# Brightness control (brightnessctl) with wob overlay
# -------------------------------------------------------------------
# Installation:
#   sudo pacman -S --needed brightnessctl wob
#   systemctl --user daemon-reload
#   systemctl --user enable --now wob.socket
#   [[ -z "$WAYLAND_DISPLAY" ]] && systemctl --user import-environment WAYLAND_DISPLAY
#
# Usage:
#   wob-brightness [up|--up|down|--down]
#
# Sends current brightness percentage to wob via:
#   - systemd socket: $XDG_RUNTIME_DIR/wob.sock (default, recommended)
#   - legacy FIFO:    /tmp/wobpipe (if socket absent and FIFO exists)
# -------------------------------------------------------------------

WOBSOCK="${WOBSOCK:-$XDG_RUNTIME_DIR/wob.sock}"

# Fallback to legacy FIFO (tail -f /tmp/wobpipe | wob) if socket not found
[[ ! -S "$WOBSOCK" ]] && [[ -p "/tmp/wobpipe" ]] && WOBSOCK="/tmp/wobpipe"

# Send integer value to wob, ignore failures (no wob running, broken pipe, etc.)
wob_send() { echo "$1" > "$WOBSOCK" 2>/dev/null || true; }

# Get current brightness percentage (brightnessctl auto-selects the device)
get_brightness() { brightnessctl -m | gawk -F'[,%]' '{print $4}'; } # Alternative: cut -d, -f4 | tr -d '%';

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
        echo "Usage: $0 {up|--up|down|--down}"
        exit 1
        ;;
esac
