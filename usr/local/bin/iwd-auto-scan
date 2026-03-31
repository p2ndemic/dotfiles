#!/usr/bin/env bash

# Extract the interface name
WLAN_IFACE=$(iwctl station list | sed 's/\x1b\[[0-9;]*m//g' | awk '/connected/ {print $1}')

# Check if the interface name is NOT empty
if [ -n "$WLAN_IFACE" ]; then
    # Start scanning if the interface is found
    iwctl station "$WLAN_IFACE" scan
else
    # Exit with an error code if no interface was detected
    exit 1
fi
