#!/bin/bash

# Скрипт для переключения состояния Bluetooth (toggle power)
# Требует bluetoothctl (BlueZ)
# Необходимо разблокировка модуля через rfkill
# sudo rfkill unblock bluetooth или sudo rfkill unblock all

# Проверяем текущее состояние
if bluetoothctl show | grep -q "Powered: yes"; then
    bluetoothctl power off
else
    bluetoothctl power on
fi
