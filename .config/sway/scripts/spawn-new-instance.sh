#!/bin/bash
# =============================================
# Launch a new instance of the application from focused window
# Запускает новую копию приложения из активного окна
# =============================================
# swaymsg -t get_tree получает дерево контейнеров в формате JSON.
# jq команда:
#    .. рекурсивно обходит все узлы.
#    select(.focused? == true) выбирает узлы, у которых установлен фокус.
#    select(.type == "con" or .type == "floating_con") фильтрует только контейнеры окон (и тилинговые и плавающие).
#    .app_id // .window_properties.class // empty извлекает app_id (для Wayland) или class (для XWayland), если оба отсутствуют - пусто.
# Переменная app_to_run сохраняет полученное значение приложения для запуска.
# Если значение пустое или "null", выводится ошибка.
# swaymsg exec "$app_to_run" запускает новое окно того же приложения.
# =============================================
# .. - Recursively traverse all nodes in the JSON tree
# select(.focused? == true) - Find nodes where focused is true
# select(.type == "con" or .type == "floating_con") - Filter only window containers
# .app_id // .window_properties.class // empty - Extract app_id or window class
# =============================================

# Check if jq is installed / Проверяем, установлен ли jq
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed. Please install jq first." >&2
    exit 1
fi

# Get app_id or class of focused window / Получаем app_id или class активного окна
# jq извлекает идентификатор приложения из focused окна:
# - Для Wayland окон использует .app_id
# - Для XWayland окон использует .window_properties.class
app_to_run=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | select(.type == "con" or .type == "floating_con") | .app_id // .window_properties.class // empty')

# Check if we successfully got the application identifier / Проверяем, удалось ли определить приложение
if [ -z "$app_to_run" ] || [ "$app_to_run" = "null" ]; then
    echo "Cannot determine application to launch" >&2
    exit 1
fi

# Launch a new instance / Запускаем новую копию приложения
# swaymsg exec запускает команду в окружении Sway
# "$app_to_run" содержит идентификатор приложения (app_id или class)
swaymsg exec "$app_to_run"
