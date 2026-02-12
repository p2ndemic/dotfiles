#!/bin/bash
# Управление громкостью (PipeWire) + отображение через wob

WOBSOCK="${WOBSOCK:-$XDG_RUNTIME_DIR/wob.sock}"
[ ! -S "$WOBSOCK" ] && [ -p "/tmp/wobpipe" ] && WOBSOCK="/tmp/wobpipe"

wob_send() { echo "$1" > "$WOBSOCK" 2>/dev/null || true; }

# Текущая громкость sink (в процентах)
sink_vol() { wpctl get-volume @DEFAULT_SINK@ | awk '{print int($2 * 100)}'; }
# Текущая громкость source (микрофон)
source_vol() { wpctl get-volume @DEFAULT_SOURCE@ | awk '{print int($2 * 100)}'; }

# Проверка mute
sink_muted() { wpctl get-volume @DEFAULT_SINK@ | grep -q "MUTED"; }
source_muted() { wpctl get-volume @DEFAULT_SOURCE@ | grep -q "MUTED"; }

case "$1" in
    sink-up)
        wpctl set-volume @DEFAULT_SINK@ 1%+ --limit 1.0
        wob_send "$(sink_vol)"
        ;;
    sink-down)
        wpctl set-volume @DEFAULT_SINK@ 1%- --limit 1.0
        wob_send "$(sink_vol)"
        ;;
    sink-mute)
        wpctl set-mute @DEFAULT_SINK@ toggle
        if sink_muted; then wob_send 0; else wob_send "$(sink_vol)"; fi
        ;;
    source-up)
        wpctl set-volume @DEFAULT_SOURCE@ 1%+ --limit 1.0
        wob_send "$(source_vol)"
        ;;
    source-down)
        wpctl set-volume @DEFAULT_SOURCE@ 1%- --limit 1.0
        wob_send "$(source_vol)"
        ;;
    source-mute)
        wpctl set-mute @DEFAULT_SOURCE@ toggle
        if source_muted; then wob_send 0; else wob_send "$(source_vol)"; fi
        ;;
    *)
        echo "Использование: $0 {sink-up|sink-down|sink-mute|source-up|source-down|source-mute}"
        exit 1
        ;;
esac
