#!/bin/bash
# Управление яркостью (brightnessctl) + wob + systemd-socket
# Использование: wob-brightness --up|--down

# Установка:
# sudo pacman -S --needed wob brightnessctl
# systemctl --user daemon-reload
# systemctl --user enable --now wob.socket
# [[ -z "$WAYLAND_DISPLAY" ]] && systemctl --user import-environment WAYLAND_DISPLAY

WOBSOCK="${WOBSOCK:-$XDG_RUNTIME_DIR/wob.sock}" # systemd-сокет по умолчанию
#[[ ! -S "$WOBSOCK" ]] && [[ -p "/tmp/wobpipe" ]] && WOBSOCK="/tmp/wobpipe" # раскоментируйте для ручного варианта через mkfifo, вместо systemd-socket

wob_send() { echo "$1" > "$WOBSOCK" 2>/dev/null || true; }
# Текущая яркость в процентах
get_brightness() { brightnessctl -m | cut -d, -f4 | tr -d '%'; }

case "$1" in
    --up)
        brightnessctl set +5% >/dev/null
        wob_send "$(get_brightness)"
        ;;
    --down)
        brightnessctl set 5%- >/dev/null
        wob_send "$(get_brightness)"
        ;;
    *)
        echo "Использование: $0 {--up|--down}"
        exit 1
        ;;
esac
