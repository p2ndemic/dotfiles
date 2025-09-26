#!/bin/bash

# Получаем app_id или class focused окна
app_to_run=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | select(.type == "con") | .app_id // .window_properties.class // empty')

if [ -z "$app_to_run" ] || [ "$app_to_run" = "null" ]; then
    echo "Cannot determine application to launch"
    exit 1
fi

# Запускаем новую копию
exec $app_to_run
