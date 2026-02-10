#!/bin/sh

# Запуск сканирования Wifi сети при поднятии интерфейса

# Первый аргумент ($1) - имя интерфейса, второй ($2) - действие ('up' или 'down')
INTERFACE="$1"
STATUS="$2"

# Выполняем только для интерфейса wlan0 и только когда он поднимается ('up')
if [[ "$INTERFACE" = "wlan0" ]] && [[ "$STATUS" = "up" ]]; then
    # Запускаем сканирование через nmcli
    nmcli device wifi rescan
fi

exit 0

# Сделать исполняемым и перезапустить интерфейс:
# sudo chmod +x /etc/NetworkManager/dispatcher.d/99-wifi-scan.sh
