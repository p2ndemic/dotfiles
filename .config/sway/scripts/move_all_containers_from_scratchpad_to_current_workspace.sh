#!/bin/bash
# =============================================
# Move all windows from scratchpad to current workspace and make them tiled
# Перемещает все окна из скретчпада на текущий воркспейс и делает их тилинговыми
# =============================================
# swaymsg -t get_tree получает дерево контейнеров в формате JSON.
# jq команда:
#    .. рекурсивно обходит все узлы.
#    select(.name? == "__i3_scratch") выбирает workspace скретчпада (всегда называется "__i3_scratch").
#    .floating_nodes[]? перебирает все плавающие окна в скретчпаде (в скретчпаде все окна плавающие).
#    .id извлекает ID каждого контейнера.
# Цикл while read id читает каждое значение ID (каждое на отдельной строке) и присваивает его переменной id.
# swaymsg "[con_id=$container_id]" move container to workspace current, floating disable перемещает окно на текущий workspace и отключает плавающий режим.
# =============================================
# .. - Recursively traverse all nodes in the JSON tree
# select(.name? == "__i3_scratch") - Select the scratchpad workspace (always named "__i3_scratch")
# .floating_nodes[]? - Iterate through all floating windows in scratchpad
# .id - Extract the ID property
# =============================================
# =============================================
# Важно замечание про "," vs ";"
# Запятая vs точка с запятой: В командах sway запятая сохраняет критерии (в нашем случае [con_id=$id]) для следующих команд, а точка с запятой сбрасывает их. 
# Мы хотим применить обе команды к одному и тому же окну, поэтому используем запятую.
# =============================================

# Check if jq is installed / Проверяем, установлен ли jq
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed. Please install jq first." >&2
    exit 1
fi

# Get all window IDs from scratchpad workspace / Получаем все ID окон из скретчпада
# swaymsg -t get_tree получает JSON-представление дерева контейнеров Sway
# jq фильтрует и извлекает ID всех окон в скретчпаде
swaymsg -t get_tree | jq -r '.. | select(.name? == "__i3_scratch")? | .floating_nodes[]? | .id' | 
# Цикл обрабатывает каждый ID окна из скретчпада
while read container_id; do
    # Проверяем, что ID не пустой (на случай пустого скретчпада)
    if [ -n "$id" ]; then
        # Move each window to current workspace and disable floating mode
        # Перемещаем каждое окно на текущий воркспейс и отключаем плавающий режим
        # [con_id=$container_id] - критерий выбора окна по его ID
        # move container to workspace current - перемещает на текущий workspace
        # floating disable - делает окно тилинговым (не плавающим)
        swaymsg "[con_id=$container_id]" move container to workspace current, floating disable
    fi
done
