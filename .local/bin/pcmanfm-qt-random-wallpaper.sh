#!/usr/bin/env bash

# Укажите полный путь к папке с вашими обоями
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Ищем случайный файл (картинку) в этой папке
RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Запускаем pcmanfm-qt со случайной картинкой
# exec используется, чтобы процесс скрипта заменился процессом pcmanfm-qt
exec pcmanfm-qt --desktop --wallpaper-mode fit --set-wallpaper "$RANDOM_WALLPAPER"
