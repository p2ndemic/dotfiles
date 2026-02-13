#!/usr/bin/env bash

TERMINAL_CMD="${TERMINAL:-foot}"

if pgrep nmtui > /dev/null 2>&1; then
    pkill nmtui
else
    nmcli device wifi rescan
    $TERMINAL_CMD -e nmtui &
fi
