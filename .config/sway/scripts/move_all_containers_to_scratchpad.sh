#!/bin/bash
# =============================================
# Move all containers (windows) from current workspace to scratchpad
# =============================================

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed. Please install jq first."
    exit 1
fi

# Script body
swaymsg focus parent; move scratchpad;

exit 0
