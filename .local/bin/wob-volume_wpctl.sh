#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════
# wob-volume_wpctl.sh — Volume control script
# ══════════════════════════════════════════════════════════════════════
# Stack: systemd · pipewire · wireplumber · wob · sound-theme-freedesktop
#
# Installation:
#   sudo pacman -S --needed wob sound-theme-freedesktop
#   systemctl daemon-reload && systemctl --user enable --now wob.socket
#   install -Dm755 wob-volume_wpctl.sh ~/.local/bin/wob-volume_wpctl.sh
# ══════════════════════════════════════════════════════════════════════

set -euo pipefail

# ─── Constants ───────────────────────────────────────────────────────────────

readonly WOBSOCK="${WOBSOCK:-${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/wob.sock}"
readonly SOUND_FILE="/usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"
readonly SINK="@DEFAULT_AUDIO_SINK@"
readonly SOURCE="@DEFAULT_AUDIO_SOURCE@"
readonly VOL_STEP="5%"
readonly VOL_LIMIT="1.0"

# ─── Usage ───────────────────────────────────────────────────────────────────

_usage() {
    cat <<HELP
Usage: $(basename "${0}") <command>

Speaker (sink):
  sink-up,     --sink-up      Increase speaker volume by ${VOL_STEP}
  sink-down,   --sink-down    Decrease speaker volume by ${VOL_STEP}
  sink-mute,   --sink-mute    Toggle speaker mute

Microphone (source):
  source-up,   --source-up    Increase microphone volume by ${VOL_STEP}
  source-down, --source-down  Decrease microphone volume by ${VOL_STEP}
  source-mute, --source-mute  Toggle microphone mute

Environment:
  WOBSOCK  Path to the WOB FIFO socket (default: \$XDG_RUNTIME_DIR/wob.sock)

Prerequisites:
  systemctl daemon-reload && systemctl --user enable --now wob.socket
HELP
}

# ─── Helpers ─────────────────────────────────────────────────────────────────

_get_sink_volume() {
    wpctl get-volume "${SINK}" | awk '{print int($2 * 100); exit}' || true
}

_get_source_volume() {
    wpctl get-volume "${SOURCE}" | awk '{print int($2 * 100); exit}' || true
}

_is_sink_muted() {
    wpctl get-volume "${SINK}" | grep -q "MUTED" || true
}

_is_source_muted() {
    wpctl get-volume "${SOURCE}" | grep -q "MUTED" || true
}

_play_sound() {
    [[ -f "${SOUND_FILE}" ]] || return 0
    #pkill -x pw-play 2>/dev/null
    pw-play "${SOUND_FILE}" &>/dev/null &
    disown "$!"
}

_wob_send() {
    [[ -e "${WOBSOCK}" ]] && echo "${1}" > "${WOBSOCK}" 2>/dev/null || true
}

# ─── Sink (Speaker) ──────────────────────────────────────────────────────────

_sink_up() {
    wpctl set-volume "${SINK}" "${VOL_STEP}+" --limit "${VOL_LIMIT}"
    _wob_send "$(_get_sink_volume)"
    _play_sound
}

_sink_down() {
    wpctl set-volume "${SINK}" "${VOL_STEP}-" --limit "${VOL_LIMIT}"
    _wob_send "$(_get_sink_volume)"
    _play_sound
}

_sink_mute() {
    wpctl set-mute "${SINK}" toggle
    if _is_sink_muted; then
        _wob_send 0
    else
        _wob_send "$(_get_sink_volume)"
    fi
}

# ─── Source (Microphone) ─────────────────────────────────────────────────────

_source_up() {
    wpctl set-volume "${SOURCE}" "${VOL_STEP}+" --limit "${VOL_LIMIT}"
    _wob_send "$(_get_source_volume)"
    _play_sound
}

_source_down() {
    wpctl set-volume "${SOURCE}" "${VOL_STEP}-" --limit "${VOL_LIMIT}"
    _wob_send "$(_get_source_volume)"
    _play_sound
}

_source_mute() {
    wpctl set-mute "${SOURCE}" toggle
    if _is_source_muted; then
        _wob_send 0
    else
        _play_sound
    fi
}

# ─── Entry point ─────────────────────────────────────────────────────────────

_main_() {
    case "${1:-}" in
        sink-up|--sink-up)
            _sink_up
            ;;
        sink-down|--sink-down)
            _sink_down
            ;;
        sink-mute|--sink-mute)
            _sink_mute
            ;;
        source-up|--source-up)
            _source_up
            ;;
        source-down|--source-down)
            _source_down
            ;;
        source-mute|--source-mute)
            _source_mute
            ;;
        -h|--help)
            _usage
            exit 0
            ;;
        *)
            printf 'Error: unknown command "%s"\n\n' "${1:-<empty>}" >&2
            _usage >&2
            exit 1
            ;;
    esac
}

_main_ "$@"
