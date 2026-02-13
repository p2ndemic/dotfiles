#!/bin/bash
# Управление громкостью (PipeWire) + wob + systemd-socket
# Использование: wob-volume --sink-up|--sink-down|--sink-mute|--source-up|--source-down|--source-mute

# Установка:
# sudo pacman -S --needed wob
# systemctl --user daemon-reload
# systemctl --user enable --now wob.socket
# [[ -z "$WAYLAND_DISPLAY" ]] && systemctl --user import-environment WAYLAND_DISPLAY

WOBSOCK="${WOBSOCK:-$XDG_RUNTIME_DIR/wob.sock}"   # systemd-сокет по умолчанию
#[[ ! -S "$WOBSOCK" ]] && [[ -p "/tmp/wobpipe" ]] && WOBSOCK="/tmp/wobpipe" # раскоментируйте для ручного варианта через mkfifo, вместо systemd-socket

wob_send() { echo "$1" > "$WOBSOCK" 2>/dev/null || true; }
# Текущая громкость sink (динамики|наушники)
sink_vol()   { wpctl get-volume @DEFAULT_SINK@   | gawk '{print int($2 * 100)}'; }
# Текущая громкость source (микрофон)
source_vol() { wpctl get-volume @DEFAULT_SOURCE@ | gawk '{print int($2 * 100)}'; }
# Проверка mute sink | source
sink_muted()   { wpctl get-volume @DEFAULT_SINK@   | grep -q "MUTED"; }
source_muted() { wpctl get-volume @DEFAULT_SOURCE@ | grep -q "MUTED"; }

case "$1" in
    --sink-up)
        wpctl set-volume @DEFAULT_SINK@ 1%+ --limit 1.0
        wob_send "$(sink_vol)"
        ;;
    --sink-down)
        wpctl set-volume @DEFAULT_SINK@ 1%- --limit 1.0
        wob_send "$(sink_vol)"
        ;;
    --sink-mute)
        wpctl set-mute @DEFAULT_SINK@ toggle
        sink_muted && wob_send 0 || wob_send "$(sink_vol)"
        ;;
    --source-up)
        wpctl set-volume @DEFAULT_SOURCE@ 1%+ --limit 1.0
        wob_send "$(source_vol)"
        ;;
    --source-down)
        wpctl set-volume @DEFAULT_SOURCE@ 1%- --limit 1.0
        wob_send "$(source_vol)"
        ;;
    --source-mute)
        wpctl set-mute @DEFAULT_SOURCE@ toggle
        source_muted && wob_send 0 || wob_send "$(source_vol)"
        ;;
    *)
        echo "Использование: $0 {--sink-up|--sink-down|--sink-mute|--source-up|--source-down|--source-mute}"
        exit 1
        ;;
esac
