#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════
# https://github.com/francma/wob
# ══════════════════════════════════════════════════════════════════════
# Installation:
#   sudo pacman -S --needed brightnessctl wob
#   systemctl daemon-reload && systemctl --user enable --now wob.socket
# ══════════════════════════════════════════════════════════════════════
#!/usr/bin/env bash
set -uo pipefail

# ─── Constants ────────────────────────────────────────────────────────
readonly WOBSOCK="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/wob.sock"
readonly BRIGHTNESS_STEP="5"

# ─── Usage ────────────────────────────────────────────────────────────
_usage() {
    cat <<HELP
Usage: $(basename "${0}") <command>
Brightness:
  up,   --up    Increase brightness by ${BRIGHTNESS_STEP}%
  down, --down  Decrease brightness by ${BRIGHTNESS_STEP}%
Prerequisites:
  systemctl --user enable --now wob.socket
HELP
}

# ─── Helpers ──────────────────────────────────────────────────────────
_get_brightness() {
    brightnessctl -m | awk -F'[,%]' '{print $4; exit}'
}

_wob_send() {
    echo "${1}" > "${WOBSOCK}" 2>/dev/null &
}

# ─── Brightness ───────────────────────────────────────────────────────
_brightness_up() {
    brightnessctl set +"${BRIGHTNESS_STEP}%" >/dev/null 2>&1
    _wob_send "$(_get_brightness)"
}

_brightness_down() {
    brightnessctl set "${BRIGHTNESS_STEP}%"- >/dev/null 2>&1
    _wob_send "$(_get_brightness)"
}

# ─── Entry point ──────────────────────────────────────────────────────
_main_() {
    case "${1:-}" in
        up|--up)
            _brightness_up
            ;;
        down|--down)
            _brightness_down
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
