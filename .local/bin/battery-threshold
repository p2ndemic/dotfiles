#!/bin/env bash
# =============================================
# Script to set the battery charge threshold
# =============================================
# → Installation: 
# → Create file: sudo nano ~/.local/bin/battery-threshold.sh
# → Make the script executable: sudo chmod +x ~/.local/bin/battery-threshold.sh
# =============================================
# → Create systemd daemon:
# sudo nano /etc/systemd/system/battery-threshold-tuning.service
# =============================================
# → Reload systemd and enable the 'battery-threshold-tuning.service' immediately:
# sudo systemctl daemon-reload
# sudo systemctl enable --now battery-threshold-tuning.service
# =============================================
echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold
