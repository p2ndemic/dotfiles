#!/bin/bash

TERMINAL_CMD=${TERMINAL:-foot}

nmcli device wifi rescan
sleep 0.5
exec "$TERMINAL_CMD" -e nmtui
