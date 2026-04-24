#!/usr/bin/env bash
set -euo pipefail

# ══════════════════════════════════════════════════════════════════════════════
# Constants
# ══════════════════════════════════════════════════════════════════════════════
readonly PROG="labshot"
readonly LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/labshot.lock"

readonly SCREENSHOT_DIR="${XDG_SCREENSHOTS_DIR:-${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots}"
readonly SCREENSHOT_DATEFMT="%d%m%Y_%H%M%S"
readonly SCREENSHOT_TIMESTAMP="$(date +"$SCREENSHOT_DATEFMT")"
readonly SCREENSHOT_EXT="png"
readonly SCREENSHOT_FULLNAME="$SCREENSHOT_DIR/$SCREENSHOT_TIMESTAMP.$SCREENSHOT_EXT"

readonly EDITOR_BIN="${LABSHOT_EDITOR:-satty}"

# ══════════════════════════════════════════════════════════════════════════════
# Option defaults
# ══════════════════════════════════════════════════════════════════════════════
OPT_CURSOR=false
OPT_FREEZE=false
OPT_WAIT=0
OPT_EXPIRE_TIME=2000
ACTION="copysave"
MODE="screen"

# Runtime state
HYPRPICKER_PID=""
FILE=""

# ══════════════════════════════════════════════════════════════════════════════
# Usage
# ══════════════════════════════════════════════════════════════════════════════
usage() {
    cat <<EOF
Usage: $PROG [OPTIONS] (copy|save|copysave|edit) [screen|area] [FILE|-]

Actions (1st positional argument):
  copy          Copy screenshot to clipboard
  save          Save screenshot to file
  copysave      Copy and save (default)
  edit          Open screenshot in $EDITOR_BIN for annotation

Modes (2nd positional argument):
  screen        Capture full screen (default)
  area          Select an area to capture via slurp

File (3rd positional argument):
  PATH          Destination file path (for save/copysave/edit)
  -             Write to stdout (only for copy/edit)

Environment:
  LABSHOT_EDITOR          Override annotation editor (default: satty)
  XDG_SCREENSHOTS_DIR     Override screenshot save directory

Options:
  -c, --cursor            Include mouse cursor
  -f, --freeze            Freeze screen during area selection (uses hyprpicker)
  -w, --wait=SEC          Delay in seconds before capture
  -e, --expire-time=MS    Notification display time in ms (default: $OPT_EXPIRE_TIME)
  -h, --help              Show this help message and exit

Examples:
  $PROG                               # Full screen, copysave (default)
  $PROG copy area                     # Area → clipboard
  $PROG -f save area                  # Area with freeze → save
  $PROG -w 3 edit screen              # Wait 3s, screen → editor
  $PROG save area ~/Desktop/123.png   # Select area → save to specific path
  $PROG copy area -                   # Area → pipe to stdout
EOF
}

# ══════════════════════════════════════════════════════════════════════════════
# Notifications
# ══════════════════════════════════════════════════════════════════════════════
notify_save() {
    local NOTIFY_ACTION

    NOTIFY_ACTION=$(notify-send \
        -a "$PROG" \
        -i "$OUTPUT_FILE" \
        -t "$OPT_EXPIRE_TIME" \
        -A "show=Show file" \
        --wait \
        "Screenshot saved" "$OUTPUT_FILE" || true)

    if [[ "$NOTIFY_ACTION" == "show" ]]; then
        gdbus call \
            --session \
            --dest org.freedesktop.FileManager1 \
            --object-path /org/freedesktop/FileManager1 \
            --method org.freedesktop.FileManager1.ShowItems \
            "['file://$OUTPUT_FILE']" "" || true
    fi
}

notify_simple() {
    notify-send -a "$PROG" -t "$OPT_EXPIRE_TIME" "$1" || true
}

# ══════════════════════════════════════════════════════════════════════════════
# Functions: stop_freeze / start_freeze
# ══════════════════════════════════════════════════════════════════════════════
stop_freeze() {
    if [[ -n "$HYPRPICKER_PID" ]] && kill -0 "$HYPRPICKER_PID" 2>/dev/null; then
        kill "$HYPRPICKER_PID" 2>/dev/null && wait "$HYPRPICKER_PID" 2>/dev/null || true
        HYPRPICKER_PID=""
    elif pgrep -x hyprpicker >/dev/null 2>&1; then
        pkill -x hyprpicker 2>/dev/null || true
    fi
}

start_freeze() {
    stop_freeze
    # --render-inactive: freeze inactive displays
    # --no-zoom:         disable zoom lens
    # --no-fractional:   disable fractional scaling support
    hyprpicker --render-inactive --no-zoom --no-fractional &
    HYPRPICKER_PID=$!
    sleep 0.2  # allow hyprpicker to render before slurp opens
}

# ══════════════════════════════════════════════════════════════════════════════
# Trap
# ══════════════════════════════════════════════════════════════════════════════
trap 'stop_freeze' EXIT INT TERM

# ══════════════════════════════════════════════════════════════════════════════
# Flock (single instance)
# ══════════════════════════════════════════════════════════════════════════════
exec {LOCK_FD}>"$LOCK_FILE"
flock -n "$LOCK_FD" || { echo "$PROG: already running" >&2; exit 1; }

# ══════════════════════════════════════════════════════════════════════════════
# Argument parsing
# ══════════════════════════════════════════════════════════════════════════════
POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        -c|--cursor)
            OPT_CURSOR=true
            shift
            ;;
        -f|--freeze)
            OPT_FREEZE=true
            shift
            ;;
        -w|--wait)
            if [[ $# -lt 2 ]]; then
                echo "$PROG: missing value for $1" >&2
                exit 1
            fi
            OPT_WAIT="$2"
            shift 2
            ;;
        --wait=*)
            OPT_WAIT="${1#--wait=}"
            shift
            ;;
        -e|--expire-time)
            if [[ $# -lt 2 ]]; then
                echo "$PROG: missing value for $1" >&2
                exit 1
            fi
            OPT_EXPIRE_TIME="$2"
            shift 2
            ;;
        --expire-time=*)
            OPT_EXPIRE_TIME="${1#--expire-time=}"
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --)
            shift
            POSITIONAL_ARGS+=("$@")
            break
            ;;
        -*)
            echo "$PROG: unknown option: '$1'" >&2
            exit 1
            ;;
        *)
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

# Restore positional parameters
set -- "${POSITIONAL_ARGS[@]}"

# Set positional arguments if provided
[[ $# -ge 1 ]] && ACTION="$1"
[[ $# -ge 2 ]] && MODE="$2"
[[ $# -ge 3 ]] && FILE="$3"

# Validate positional arguments
case "$ACTION" in
    copy|save|copysave|edit) ;;
    *) echo "$PROG: invalid action: '$ACTION' (expected: copy | save | copysave | edit)" >&2; exit 1 ;;
esac

case "$MODE" in
    screen|area) ;;
    *) echo "$PROG: invalid mode: '$MODE' (expected: screen | area)" >&2; exit 1 ;;
esac

# ══════════════════════════════════════════════════════════════════════════════
# Output file and directory
# ══════════════════════════════════════════════════════════════════════════════
OUTPUT_FILE="${FILE:-$SCREENSHOT_FULLNAME}"

if [[ "$ACTION" != "copy" && "$FILE" != "-" ]]; then
    mkdir -p "$(dirname "$OUTPUT_FILE")" || {
        echo "$PROG: cannot create directory: $(dirname "$OUTPUT_FILE")" >&2
        exit 1
    }
fi

# ══════════════════════════════════════════════════════════════════════════════
# Wait (sleep if OPT_WAIT > 0)
# ══════════════════════════════════════════════════════════════════════════════
(( OPT_WAIT > 0 )) && sleep "$OPT_WAIT"

# ══════════════════════════════════════════════════════════════════════════════
# Freeze + Area selection
# ══════════════════════════════════════════════════════════════════════════════
GEOM=""
if [[ "$MODE" == "area" ]]; then
    [[ "$OPT_FREEZE" == true ]] && start_freeze

    GEOM=$(slurp) || { notify_simple "Cancelled"; exit 0; }
    [[ -z "$GEOM" ]] && { notify_simple "Cancelled"; exit 0; }

    [[ "$OPT_FREEZE" == true ]] && stop_freeze
fi

# ══════════════════════════════════════════════════════════════════════════════
# Capture + Action 
# ══════════════════════════════════════════════════════════════════════════════
GRIM_ARGS=(-t png -l 0)
[[ "$OPT_CURSOR" == true ]] && GRIM_ARGS+=("-c")
# [[ "$MODE" == "area" ]] && GRIM_OPTS+=(-g "$GEOM")

case "$MODE" in
    screen)
        case "$ACTION" in
            copy)
                grim "${GRIM_ARGS[@]}" - | wl-copy --type image/png
                notify_simple "Copied to clipboard"
                ;;
            save)
                grim "${GRIM_ARGS[@]}" "$OUTPUT_FILE"
                notify_save
                ;;
            copysave)
                grim "${GRIM_ARGS[@]}" "$OUTPUT_FILE"
                wl-copy --type image/png < "$OUTPUT_FILE"
                notify_save
                ;;
            edit)
                grim "${GRIM_ARGS[@]}" - | "$EDITOR_BIN" --output-filename "$OUTPUT_FILE" --filename -
                ;;
        esac
        ;;

    area)
        case "$ACTION" in
            copy)
                grim "${GRIM_ARGS[@]}" -g "$GEOM" - | wl-copy --type image/png
                notify_simple "Copied to clipboard"
                ;;
            save)
                grim "${GRIM_ARGS[@]}" -g "$GEOM" "$OUTPUT_FILE"
                notify_save
                ;;
            copysave)
                grim "${GRIM_ARGS[@]}" -g "$GEOM" "$OUTPUT_FILE"
                wl-copy --type image/png < "$OUTPUT_FILE"
                notify_save
                ;;
            edit)
                grim "${GRIM_ARGS[@]}" -g "$GEOM" - | "$EDITOR_BIN" --output-filename "$OUTPUT_FILE" --filename -
                ;;
        esac
        ;;
esac
