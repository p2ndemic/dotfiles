#!/bin/bash

nmcli device wifi rescan
sleep 0.5
$TERM -e nmtui
