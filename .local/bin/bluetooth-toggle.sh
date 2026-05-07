#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════
# Скрипт для переключения состояния Bluetooth (toggle power)
# Требует bluetoothctl (BlueZ)
# Необходимо разблокировка модуля через rfkill
# sudo rfkill unblock bluetooth или sudo rfkill unblock all
# Добавить текущего пользователя в группу rfkill чтобы не вводить sudo:
# sudo usermod -aG rfkill $USER
# ══════════════════════════════════════════════════════════════════════

export SUDO_ASKPASS=/home/admin/.local/bin/fuzzel-askpass.sh

if systemctl is-active --quiet bluetooth.service; then
    if bluetoothctl show | grep -q "Powered: yes"; then
        bluetoothctl power off
    else
        rfkill unblock bluetooth && bluetoothctl power on
    fi
else
    sudo -A systemctl enable --now bluetooth.service
fi
