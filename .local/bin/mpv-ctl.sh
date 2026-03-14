#!/usr/bin/env bash
# ~/.local/bin/mpv-ctl.sh

MPV_SOCKET="/tmp/mpv-socket"

mpv_send() {
    echo "$1" | socat - "$MPV_SOCKET" >/dev/null 2>&1
}

case "$1" in
    play-pause|--play-pause)
        mpv_send '{"command": ["cycle", "pause"]}'
        ;;
    next|--next)
        mpv_send '{"command": ["playlist-next"]}'
        ;;
    prev|--prev)
        mpv_send '{"command": ["playlist-prev"]}'
        ;;
    *)
        echo "Usage: mpv-ctl.sh {play-pause|next|prev} or --{play-pause|next|prev}" >&2
        exit 1
        ;;
esac
