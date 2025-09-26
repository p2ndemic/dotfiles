#!/bin/bash
# =============================================
# Move all containers (windows) from scratchpad to current workspace and make them tiling
# =============================================
# Важно замечание про "," vs ";"
# Запятая vs точка с запятой: В командах sway запятая сохраняет критерии (в нашем случае [con_id=$id]) для следующих команд, а точка с запятой сбрасывает их. 
# Мы хотим применить обе команды к одному и тому же окну, поэтому используем запятую.
# =============================================

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed. Please install jq first." >&2
    exit 1
fi

# Get all window IDs from scratchpad workspace
swaymsg -t get_tree | jq -r '.. | select(.name? == "__i3_scratch")? | .floating_nodes[]? | .id' | while read id; do
    # Move each window to current workspace and disable floating mode
    swaymsg "[con_id=$id]" move container to workspace current, floating disable
done
