#!/bin/bash

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed. Please install jq first." >&2
    exit 1
fi

# Получаем app_id или class активного (focused) окна
app_to_run=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | select(.type == "con" or .type == "floating_con") | .app_id // .window_properties.class // empty')

if [ -z "$app_to_run" ] || [ "$app_to_run" = "null" ]; then
    echo "Cannot determine application to launch" >&2
    exit 1
fi

# Запускаем новую копию
swaymsg exec "$app_to_run"

exit 0
