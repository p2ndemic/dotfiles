#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════
# https://github.com/francma/wob
# ══════════════════════════════════════════════════════════════════════
# Installation:
#   sudo pacman -S --needed wob sound-theme-freedesktop
#   systemctl daemon-reload && systemctl --user enable --now wob.socket
#
# Usage:
#   wob-volume [sink-up|--sink-up|sink-down|--sink-down|sink-mute|--sink-mute]
#              [source-up|--source-up|source-down|--source-down|source-mute|--source-mute]
#
# Sends current volume percentage (0 when muted) to wob via:
#   - systemd socket: $XDG_RUNTIME_DIR/wob.sock (default, recommended)
#   - legacy FIFO:    /tmp/wobpipe (if socket absent and FIFO exists)
# ══════════════════════════════════════════════════════════════════════

# Define WOB socket
WOBSOCK="${WOBSOCK:-$XDG_RUNTIME_DIR/wob.sock}"

# Fallback to legacy FIFO (tail -f /tmp/wobpipe | wob) if socket not found:
# [[ ! -S "$WOBSOCK" ]] && [[ -p "/tmp/wobpipe" ]] && WOBSOCK="/tmp/wobpipe"

# Sound file (freedesktop theme)
SOUND_VOLUME="/usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"
# SOUND_MUTE="/path/to/file"

# Send integer value to wob
wob_send() { echo "$1" > "$WOBSOCK" 2>/dev/null || true; }

# Get current sink volume (percentage)
sink_vol() { wpctl get-volume @DEFAULT_SINK@ | sed 's/[^0-9]//g'; } #Alternative: awk '{print int($2 * 100)}'
# Get current source volume (percentage)
source_vol() { wpctl get-volume @DEFAULT_SOURCE@ | sed 's/[^0-9]//g'; } #Alternative: awk '{print int($2 * 100)}'

# Check mute status (sink|source)
sink_muted() { wpctl get-volume @DEFAULT_SINK@ | grep -q "MUTED"; }
source_muted() { wpctl get-volume @DEFAULT_SOURCE@ | grep -q "MUTED"; }

# Play volume sound: kill previous pw-play process to avoid overlapping audio
play_volume_sound() {
    #[[ -f "$1" ]] || return
    pkill -x pw-play 2>/dev/null
    pw-play "$1" 2>/dev/null &
}

# Main logic
case "$1" in
    sink-up|--sink-up)
        wpctl set-volume @DEFAULT_SINK@ 2%+ --limit 1.0
        wob_send "$(sink_vol)"
        play_volume_sound "$SOUND_VOLUME"
        ;;
    sink-down|--sink-down)
        wpctl set-volume @DEFAULT_SINK@ 2%- --limit 1.0
        wob_send "$(sink_vol)"
        play_volume_sound "$SOUND_VOLUME"
        ;;
    sink-mute|--sink-mute)
        wpctl set-mute @DEFAULT_SINK@ toggle
        sink_muted && wob_send 0 || wob_send "$(sink_vol)"
        ;;
    source-up|--source-up)
        wpctl set-volume @DEFAULT_SOURCE@ 2%+ --limit 1.0
        wob_send "$(source_vol)"
        play_volume_sound "$SOUND_VOLUME"
        ;;
    source-down|--source-down)
        wpctl set-volume @DEFAULT_SOURCE@ 2%- --limit 1.0
        wob_send "$(source_vol)"
        play_volume_sound "$SOUND_VOLUME"
        ;;
    source-mute|--source-mute)
        wpctl set-mute @DEFAULT_SOURCE@ toggle
        source_muted && wob_send 0 || wob_send "$(source_vol)"
        ;;
    *)
        echo "Usage: $0 {sink-up|sink-down|sink-mute|source-up|source-down|source-mute} (also supports -- variants)"
        exit 1
        ;;
esac
