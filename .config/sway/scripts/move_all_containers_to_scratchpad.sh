#!/bin/bash
# =============================================
# Move all containers (windows) from current workspace to scratchpad
# =============================================

# Выполняем цепочку команд Sway
swaymsg "focus parent; move scratchpad"
