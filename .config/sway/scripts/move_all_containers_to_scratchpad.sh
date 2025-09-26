#!/bin/bash
# =============================================
# Move all containers (windows) from current workspace to scratchpad
# =============================================
# Скрипт находит текущий focused workspace по свойству .focused == true
# Извлекает все tiling и floating контейнеры (окна) из этого workspace (и из .nodes, и из .floating_nodes)
# Для каждого контейнера выполняет команду перемещения в scratchpad по его con_id
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
$container_id = swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | select(.type == "workspace") | (.nodes[]?, .floating_nodes[]?) | .id' |
while read container_id; do
    if [ -n "$container_id" ]; then
        # Move each container to scratchpad using its ID
        swaymsg "[con_id=$container_id] move container to scratchpad"
    fi
done
