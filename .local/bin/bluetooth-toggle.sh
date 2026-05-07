#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════
# Скрипт для переключения состояния Bluetooth (toggle power)
# Требует bluetoothctl (BlueZ)
# Необходимо разблокировка модуля через rfkill
# sudo rfkill unblock bluetooth или sudo rfkill unblock all
# Добавить текущего пользователя в группу rfkill чтобы не вводить sudo:
# sudo usermod -aG rfkill $USER
# ══════════════════════════════════════════════════════════════════════

set -e

export SUDO_ASKPASS="$HOME/.local/bin/fuzzel-askpass.sh"

is_active() {
    systemctl is-active --quiet bluetooth.service
}

is_powered() {
    bluetoothctl show | grep -q "PowerState: on"
}

power_on() {
    rfkill unblock bluetooth && bluetoothctl power on >/dev/null 2>&1
}

power_off() {
    bluetoothctl power off >/dev/null 2>&1
}

start_service() {
    sudo -A systemctl enable --now bluetooth.service
}

stop_service() {
    sudo -A systemctl disable --now bluetooth.service
}

# If the service is not active
if ! is_active; then
    echo "Bluetooth service inactive -> starting"
    start_service
    sleep 1
    power_on
    exit 0
fi

# If the service is active
if is_active; then
    # If Bluetooth is ON -> turn it OFF
    if is_powered; then
        echo "Bluetooth ON -> turning OFF + stopping service"
        power_off
        sleep 0.1
        stop_service
    else
        # If Bluetooth is OFF -> turn it ON
        echo "Bluetooth OFF -> turning ON"
        power_on
    fi
fi
