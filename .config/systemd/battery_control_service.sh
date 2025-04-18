# 1. Создаем директории для скриптов (если их нет)
sudo mkdir -p /usr/local/bin

# 2. Создаем скрипт static-charge-limit.sh
sudo tee /usr/local/bin/static-charge-limit.sh > /dev/null <<'EOF'
#!/bin/bash
echo 80 | tee /sys/class/power_supply/BAT0/charge_control_end_threshold
echo "auto" | tee /sys/class/power_supply/BAT0/charge_behaviour
EOF

# 3. Создаем скрипт dynamic-charge-control.sh с обработкой SIGTERM
sudo tee /usr/local/bin/dynamic-charge-control.sh > /dev/null <<'EOF'
#!/bin/bash
trap "exit 0" SIGTERM
UPPER_LIMIT=80 # Верхний лимит заряда
LOWER_LIMIT=20 # Нижний лимит заряда
CHECK_INTERVAL=120 # Интервал проверки скрипта

while true; do
    CURRENT_CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity) # Текущий уровень заряда
    CURRENT_MODE=$(cat /sys/class/power_supply/BAT0/charge_behaviour) # Текущий статус (Charging/Discharging) 

    if [ "$CURRENT_CAPACITY" -le "$LOWER_LIMIT" ] && [ "$CURRENT_MODE" != "auto" ]; then
        echo "auto" | tee /sys/class/power_supply/BAT0/charge_behaviour # Если заряд <= MIN_THRESHOLD и батарея разряжается:
    elif [ "$CURRENT_CAPACITY" -ge "$UPPER_LIMIT" ] && [ "$CURRENT_MODE" != "inhibit-charge" ]; then
        echo "inhibit-charge" | tee /sys/class/power_supply/BAT0/charge_behaviour # Если подключено питание, вернуть авторежим
    fi
    sleep $CHECK_INTERVAL
done
EOF

# 4. Создаем сервисный файл
sudo tee /etc/systemd/system/dynamic-charge-control.service > /dev/null <<'EOF'
[Unit]
Description=Dynamic Battery Charge Control
After=multi-user.target
Conflicts=shutdown.target reboot.target halt.target
Before=shutdown.target reboot.target halt.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/usr/local/bin/dynamic-charge-control.sh
ExecStop=/usr/local/bin/static-charge-limit.sh
Restart=on-failure
RestartSec=10
TimeoutStopSec=5
KillMode=control-group

[Install]
WantedBy=multi-user.target
EOF

# 5. Делаем скрипты исполняемыми
sudo chmod +ax /usr/local/bin/{static,dynamic}-charge-*.sh

# 6. Перечитываем конфигурацию systemd
sudo systemctl daemon-reload

# 7. Активируем и запускаем сервис
sudo systemctl enable --now dynamic-charge-control.service
