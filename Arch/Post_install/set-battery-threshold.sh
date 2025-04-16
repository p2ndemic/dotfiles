# Создать скрипт установки порога заряда
sudo tee /usr/local/bin/set-battery-threshold.sh <<'EOF'
#!/bin/bash
echo 80 | tee /sys/class/power_supply/BAT0/charge_control_end_threshold
EOF

# Дать права на выполнение
sudo chmod +x /usr/local/bin/set-battery-threshold.sh

# Создать systemd службу
sudo tee /etc/systemd/system/set-battery-threshold.service <<'EOF'
[Unit]
Description=Set battery charge threshold
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/set-battery-threshold.sh
Restart=on-failure
RestartSec=30

[Install]
WantedBy=multi-user.target
EOF

# Активировать и запустить службу
sudo systemctl enable --now set-battery-threshold.service
