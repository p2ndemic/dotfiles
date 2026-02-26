#!/usr/bin/env bash

set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Проверка наличия директории
if [[ ! -d "$WALLPAPER_DIR" ]]; then
    echo "Directory $WALLPAPER_DIR does not exist."
    exit 1
fi

# Получаем случайную картинку
RANDOM_WALLPAPER="$(find "$WALLPAPER_DIR" -type f | shuf -n 1)"

if [[ -z "$RANDOM_WALLPAPER" ]]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Значения по умолчанию
MODE_PC="zoom"
MODE_SWAY="fill"

USE_PCMANFM=false
USE_SWAY=false

# --- Парсинг аргументов ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p|--pcmanfm-qt)
            USE_PCMANFM=true
            shift
            ;;
        -s|--swaybg)
            USE_SWAY=true
            shift
            ;;
        --wallpaper-mode)
            if [[ -n "${2:-}" ]]; then
                MODE_PC="$2"
                shift 2
            else
                echo "Missing argument for --wallpaper-mode"
                exit 1
            fi
            ;;
        -m|--mode)
            if [[ -n "${2:-}" ]]; then
                MODE_SWAY="$2"
                shift 2
            else
                echo "Missing argument for -m|--mode"
                exit 1
            fi
            ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
done

# Проверка выбора приложения
if [[ "$USE_PCMANFM" = false && "$USE_SWAY" = false ]]; then
    echo "You must specify either -p|--pcmanfm-qt or -s|--swaybg"
    exit 1
fi

if [[ "$USE_PCMANFM" = true && "$USE_SWAY" = true ]]; then
    echo "Choose only one: pcmanfm-qt OR swaybg"
    exit 1
fi

# --- Установка обоев ---

if [[ "$USE_PCMANFM" = true ]]; then
    pcmanfm-qt --set-wallpaper "$RANDOM_WALLPAPER" --wallpaper-mode "$MODE_PC"
    echo "Wallpaper set via pcmanfm-qt: $RANDOM_WALLPAPER (mode: $MODE_PC)"
fi

if [[ "$USE_SWAY" = true ]]; then
    pkill swaybg 2>/dev/null || true
    swaybg -i "$RANDOM_WALLPAPER" -m "$MODE_SWAY" &
    echo "Wallpaper set via swaybg: $RANDOM_WALLPAPER (mode: $MODE_SWAY)"
fi
