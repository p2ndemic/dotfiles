#!/bin/bash
# Ref: https://github.com/labwc/labwc/issues/2293

# Note: Необходимо установить wlrctl
# yay -S wlrctl

CACHE_DIR="$HOME/.cache"
CACHE_FILE="$CACHE_DIR/.labwc_show_desktop"

if wlrctl toplevel find state:unminimized >/dev/null 2>&1; then
    # Сохраняем видимые окна + добавляем фокусированное в конец
    wlrctl toplevel list state:unminimized > "$CACHE_FILE"
    wlrctl toplevel list state:focused >> "$CACHE_FILE"
    # Сворачиваем всё видимое
    wlrctl toplevel minimize state:unminimized
else
    # Восстанавливаем (если кэш есть)
    if [[ -f "$CACHE_FILE" ]]; then
        while IFS=':' read -r app_id title; do
            title="${title# }"  # убираем ведущий пробел
            wlrctl toplevel focus "app_id:${app_id}" "title:${title}"
        done < "$CACHE_FILE"
        : > "$CACHE_FILE"  # очищаем кэш
    fi
fi
