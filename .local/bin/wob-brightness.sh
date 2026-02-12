#!/bin/bash
# Управление яркостью (brightnessctl) + отображение через wob

WOBSOCK="${WOBSOCK:-$XDG_RUNTIME_DIR/wob.sock}"
[ ! -S "$WOBSOCK" ] && [ -p "/tmp/wobpipe" ] && WOBSOCK="/tmp/wobpipe"

wob_send() { echo "$1" > "$WOBSOCK" 2>/dev/null || true; }

# Текущая яркость в процентах (brightnessctl сам выбирает устройство)
get_brightness() { brightnessctl -m | cut -d, -f4 | tr -d '%'; }

case "$1" in
    up)
        brightnessctl set +5% >/dev/null
        wob_send "$(get_brightness)"
        ;;
    down)
        brightnessctl set 5%- >/dev/null
        wob_send "$(get_brightness)"
        ;;
    *)
        echo "Использование: $0 {up|down}"
        exit 1
        ;;
esac
