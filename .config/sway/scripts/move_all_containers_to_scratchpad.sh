#!/bin/bash
# =============================================
# Move all containers (windows) from current workspace to scratchpad
# =============================================
# Скрипт находит текущий focused workspace по свойству .focused == true
# Извлекает все tiling и floating контейнеры (окна) из этого workspace (и из .nodes, и из .floating_nodes)
# Для каждого контейнера выполняет команду перемещения в scratchpad по его con_id
# =============================================

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed. Please install jq first." >&2
    exit 1
fi

# # Get all container IDs from the current focused workspace (both tiling and floating)
swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | select(.type == "workspace") | (.nodes[]?, .floating_nodes[]?) | .id' |
# For each container, execute a command to move it to the scratchpad using its ID (con_id)
while read con_id; do
    [ -n "$con_id" ] && swaymsg "[con_id=$con_id] move container to scratchpad"
done
