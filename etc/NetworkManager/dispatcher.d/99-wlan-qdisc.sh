#!/bin/sh

# В WLAN драйвере для Chromebook (возможно и др. устройств) есть баг с применением дисциплин сетевых очередей (Queue disciplines) через net.core.default_qdisc
# При установке параметра через sysctl он применяется только для ethernet, игнорируя wlan
# Проверка: ip link show | grep -iE 'qdisc' или tc qdisc show
# Скрипт автоматически устанавливает дисциплину очереди `fq` для интерфейса `wlan0` при его активации (поднятии).

# Первый аргумент ($1) - имя интерфейса, второй ($2) - действие ('up' или 'down')
IFACE="$1"
ACTION="$2"

# Выполняем только для интерфейса wlan0 и только когда он поднимается ('up')
if [ "$IFACE" = "wlan0" ] && [ "$ACTION" = "up" ]; then
    # Устанавливаем qdisc = fq
    /sbin/tc qdisc replace dev "$IFACE" root fq
fi

exit 0

# Сделать исполняемым и перезапустить интерфейс:
# sudo chmod +x /etc/NetworkManager/dispatcher.d/99-wlan-qdisc.sh
