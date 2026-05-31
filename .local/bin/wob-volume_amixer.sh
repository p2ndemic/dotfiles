#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════
# wob-volume_amixer.sh — Volume control script
# ══════════════════════════════════════════════════════════════════════
# Stack: systemd · pipewire · wireplumber · wob · sound-theme-freedesktop
#
# Installation:
#   sudo pacman -S --needed pipewire pipewire-alsa wob sound-theme-freedesktop
#   systemctl daemon-reload && systemctl --user enable --now wob.socket
#   install -Dm755 wob-volume_amixer.sh ~/.local/bin/wob-volume_amixer.sh
# ══════════════════════════════════════════════════════════════════════
# Additional:
# Fallback to legacy FIFO (tail -f /tmp/wobpipe | wob) if socket not found:
# [[ ! -S "$WOBSOCK" ]] && [[ -p "/tmp/wobpipe" ]] && WOBSOCK="/tmp/wobpipe"
# ══════════════════════════════════════════════════════════════════════
# Alsa:
# ══════════════════════════════════════════════════════════════════════
# Получить текущий уровень громкости без процентов:
# ──────────────────────────────────────────────────
# amixer sget Master | awk -F'[^0-9]+' '/\[[0-9]+%\]/ { print $3; exit }'
# amixer sget Capture | awk -F'[^0-9]+' '/\[[0-9]+%\]/ { print $3; exit }'
#
# Alt:
# amixer sget Master | grep -oP -m1 '\[\K\d+(?=%\])'
# amixer sget Capture | grep -oP -m1 '\[\K\d+(?=%\])'
#
# amixer sget Master | awk -F'[^0-9]+' '/Playback/ && /%/ { print $3; exit }'
# amixer sget Capture | awk -F'[^0-9]+' '/Playback/ && /%/ { print $3; exit }'
# ──────────────────────────────────────────────────
# Получить статус mute (on/off):
# ──────────────────────────────────────────────────
# amixer sget Master | grep -q '\[on\]'
# amixer sget Capture | grep -q '\[on\]'
#
# Alt:
# amixer sget Master | awk -F'[][]' '/Playback/ && /\[(on|off)\]/ { print $4; exit }'
# amixer sget Capture | awk -F'[][]' '/Playback/ && /\[(on|off)\]/ { print $4; exit }'
#
# amixer sget Master | grep -o '\[on\]'
# amixer sget Capture | grep -o '\[on\]'
#
# amixer sget Master | grep -oP -m1 '\[\K(?:on|off)(?=\])'
# amixer sget Capture | grep -oP -m1 '\[\K(?:on|off)(?=\])'
# ──────────────────────────────────────────────────
# Увеличить громкость:
# ──────────────────────────────────────────────────
# amixer -q sset Master 5%+
# amixer -q sset Capture 5%+
# ──────────────────────────────────────────────────
# Уменьшить громкость:
# ──────────────────────────────────────────────────
# amixer -q sset Master 5%-
# amixer -q sset Capture 5%-
# ──────────────────────────────────────────────────
# Отключение/включение устройства:
# ──────────────────────────────────────────────────
# amixer -q sset Master toggle
# amixer -q sset Capture toggle
# ──────────────────────────────────────────────────
# Замеры скорости hyperfine [grep vs awk vs sed]:
# ──────────────────────────────────────────────────
#hyperfine --warmup 150 --runs 300 \
#'amixer sget Master | grep -oP -m1 "\[\K\d+(?=%\])"' \
#'amixer sget Master | awk -F"[^0-9]+" "/\[[0-9]+%\]/ { print \$3; exit }"' \
#'amixer sget Master | awk -F"[^0-9]+" "/%/ { print \$3; exit }"' \
#'amixer sget Master | sed -n "s/.*\[\([0-9]\+\)%\].*/\1/p"' \
#'amixer sget Master | awk -F"[^0-9]+" "/Front Left:/ { print \$3; exit }"'
# ══════════════════════════════════════════════════════════════════════

set -uo pipefail

# ─── Constants ────────────────────────────────────────────────────────

readonly WOBSOCK="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/wob.sock"
readonly SOUND_FILE="/usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"
readonly SINK="Master"
readonly SOURCE="Capture"
readonly VOL_STEP="5%"
#readonly VOL_LIMIT="1.0"

# ─── Usage ────────────────────────────────────────────────────────────

_usage() {
    cat <<HELP
Usage: $(basename "${0}") <command>

Speaker | Headphone (sink):
  sink-up,     --sink-up      Increase speaker volume by ${VOL_STEP}
  sink-down,   --sink-down    Decrease speaker volume by ${VOL_STEP}
  sink-mute,   --sink-mute    Toggle speaker mute

Microphone (source):
  source-up,   --source-up    Increase microphone volume by ${VOL_STEP}
  source-down, --source-down  Decrease microphone volume by ${VOL_STEP}
  source-mute, --source-mute  Toggle microphone mute

Prerequisites:
  systemctl --user enable --now wob.socket
HELP
}

# ─── Helpers ─────────────────────────────────────────────────────────

_get_sink_volume() {
    amixer sget "${SINK}"  | grep -oP -m1 '\[\K\d+(?=%\])'
}

_get_source_volume() {
    amixer sget "${SOURCE}" | grep -oP -m1 '\[\K\d+(?=%\])'
}

_is_sink_muted() {
    [[ $(amixer sget "${SINK}") == *"[off]"* ]]
}

_is_source_muted() {
    [[ $(amixer sget "${SOURCE}") == *"[off]"* ]]
}

_play_sound() {
    #[[ -f "${SOUND_FILE}" ]] || return 0
    #pkill -x pw-play 2>/dev/null || true
    pw-play "${SOUND_FILE}" 2>/dev/null &
}

_wob_send() {
    #[[ -e "${WOBSOCK}" ]] || return 0
    echo "${1}" > "${WOBSOCK}" 2>/dev/null &
}

# ─── Sink (Speaker) ──────────────────────────────────────────────────

_sink_up() {
    amixer -q sset "${SINK}" "${VOL_STEP}+"
    _wob_send "$(_get_sink_volume)"
    _play_sound
}

_sink_down() {
    amixer -q sset "${SINK}" "${VOL_STEP}-"
    _wob_send "$(_get_sink_volume)"
    _play_sound
}

_sink_mute() {
    amixer -q sset "${SINK}" toggle
    if _is_sink_muted; then
        _wob_send 0
    else
        _wob_send "$(_get_sink_volume)"
        _play_sound
    fi
}

# ─── Source (Microphone) ─────────────────────────────────────────────

_source_up() {
    amixer -q sset "${SOURCE}" "${VOL_STEP}+"
    _wob_send "$(_get_source_volume)"
    _play_sound
}

_source_down() {
    amixer -q sset "${SOURCE}" "${VOL_STEP}-"
    _wob_send "$(_get_source_volume)"
    _play_sound
}

_source_mute() {
    amixer -q sset "${SOURCE}" toggle
    if _is_source_muted; then
        _wob_send 0
    else
        _wob_send "$(_get_source_volume)"
        _play_sound
    fi
}

# ─── Entry point ─────────────────────────────────────────────────────

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
