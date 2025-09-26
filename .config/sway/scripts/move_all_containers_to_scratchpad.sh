#!/bin/bash
# =============================================
# Move all containers (windows) from current workspace to scratchpad
# =============================================
# swaymsg -t get_tree получает дерево контейнеров в формате JSON.
# jq команда:
#    .. рекурсивно обходит все узлы.
#    select(.focused? == true) выбирает узлы, у которых установлен фокус (на самом деле, фокус может быть у нескольких узлов, но мы затем фильтруем по типу workspace).
#    select(.type == "workspace") гарантирует, что мы работаем с workspace.
#    (.nodes[]?, .floating_nodes[]?) выводит каждый элемент из массивов nodes (тилинговые окна) и floating_nodes (плавающие окна) в текущем workspace.
#    .id извлекает ID каждого контейнера.
# Цикл while read container_id читает каждое значение ID (каждое на отдельной строке) и присваивает его переменной container_id.
# if [ -n "$container_id" ] проверяет, что строка не пустая.
# swaymsg "[con_id=$container_id] move container to scratchpad" перемещает контейнер с указанным ID в scratchpad
# =============================================
# .. - Recursively traverse all nodes in the JSON tree
# select(.focused? == true) - Find nodes where focused is true
# select(.type == "workspace") - Filter only workspace type nodes
# (.nodes[]?, .floating_nodes[]?) - Get both tiling and floating containers
# .id - Extract the ID property
# =============================================

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed. Please install jq first." >&2
    exit 1
fi

# Get all container IDs from the current focused workspace (both tiling and floating)
swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | select(.type == "workspace") | (.nodes[]?, .floating_nodes[]?) | .id' |
while read container_id; do
    if [ -n "$container_id" ]; then
        # Move each container to scratchpad using its ID
        swaymsg "[con_id=$container_id] move container to scratchpad"
    fi
done
