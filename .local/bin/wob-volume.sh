#!/bin/bash
# Volume control (PipeWire) with wob overlay
# -------------------------------------------------------------------
# Installation:
#   sudo pacman -S --needed pipewire wireplumber wob
#   systemctl --user daemon-reload
#   systemctl --user enable --now wob.socket
#   [[ -z "$WAYLAND_DISPLAY" ]] && systemctl --user import-environment WAYLAND_DISPLAY
#
# Usage:
#   wob-volume [sink-up|--sink-up|sink-down|--sink-down|sink-mute|--sink-mute]
#              [source-up|--source-up|source-down|--source-down|source-mute|--source-mute]
#
# Sends current volume percentage (0 when muted) to wob via:
#   - systemd socket: $XDG_RUNTIME_DIR/wob.sock (default, recommended)
#   - legacy FIFO:    /tmp/wobpipe (if socket absent and FIFO exists)
# -------------------------------------------------------------------

WOBSOCK="${WOBSOCK:-$XDG_RUNTIME_DIR/wob.sock}"

# Fallback to legacy FIFO (tail -f /tmp/wobpipe | wob) if socket not found
[[ ! -S "$WOBSOCK" ]] && [[ -p "/tmp/wobpipe" ]] && WOBSOCK="/tmp/wobpipe"

# Send integer value to wob, ignore failures (no wob running, broken pipe, etc.)
wob_send() { echo "$1" > "$WOBSOCK" 2>/dev/null || true; }

# Get current sink volume (percentage)
sink_vol() { wpctl get-volume @DEFAULT_SINK@ | gawk '{print int($2 * 100)}'; }
# Get current source volume (percentage)
source_vol() { wpctl get-volume @DEFAULT_SOURCE@ | gawk '{print int($2 * 100)}'; }

# Check mute status
sink_muted()   { wpctl get-volume @DEFAULT_SINK@   | grep -q "MUTED"; }
source_muted() { wpctl get-volume @DEFAULT_SOURCE@ | grep -q "MUTED"; }

case "$1" in
    sink-up|--sink-up)
        wpctl set-volume @DEFAULT_SINK@ 1%+ --limit 1.0 >/dev/null 2>&1
        wob_send "$(sink_vol)"
        ;;
    sink-down|--sink-down)
        wpctl set-volume @DEFAULT_SINK@ 1%- --limit 1.0 >/dev/null 2>&1
        wob_send "$(sink_vol)"
        ;;
    sink-mute|--sink-mute)
        wpctl set-mute @DEFAULT_SINK@ toggle >/dev/null 2>&1
        sink_muted && wob_send 0 || wob_send "$(sink_vol)"
        ;;
    source-up|--source-up)
        wpctl set-volume @DEFAULT_SOURCE@ 1%+ --limit 1.0 >/dev/null 2>&1
        wob_send "$(source_vol)"
        ;;
    source-down|--source-down)
        wpctl set-volume @DEFAULT_SOURCE@ 1%- --limit 1.0 >/dev/null 2>&1
        wob_send "$(source_vol)"
        ;;
    source-mute|--source-mute)
        wpctl set-mute @DEFAULT_SOURCE@ toggle >/dev/null 2>&1
        source_muted && wob_send 0 || wob_send "$(source_vol)"
        ;;
    *)
        echo "Usage: $0 {sink-up|--sink-up|sink-down|--sink-down|sink-mute|--sink-mute|source-up|--source-up|source-down|--source-down|source-mute|--source-mute}"
        exit 1
        ;;
esac
