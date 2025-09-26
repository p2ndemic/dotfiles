#!/bin/bash

# Получаем app_id или class активного окна типа "con"
app_to_run=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | select(.type == "con" or .type == "floating_con") | .app_id // .window_properties.class // empty')

if [ -z "$app_to_run" ]; then
    echo "Cannot determine application to launch" >&2
    exit 1
fi

# Запускаем новую копию
exec "$app_to_run"
