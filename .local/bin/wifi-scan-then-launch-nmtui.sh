#!/bin/bash

TERMINAL_CMD=${TERMINAL:-foot}

nmcli device wifi rescan
exec "$TERMINAL_CMD" -e nmtui
