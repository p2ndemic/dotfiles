#!/usr/bin/env bash
# https://codeberg.org/codedge/dotfiles/src/branch/main/scripts/swaybg/executable_rand_wallpaper.sh

# Wallpaper directory
WP_FOLDER=~/wallpaper

# Time in seconds to change wallpaper
WAIT_TIME=3599

while true; do
    PID=$(pidof swaybg)
    FILE=$(find "$WP_FOLDER" -type f -name '*.png' -o -name '*.jpg' | shuf -n1)
    swaybg -i "$FILE" -m fill &
    sleep 1
    kill "$PID"
    sleep "$WAIT_TIME"
done
