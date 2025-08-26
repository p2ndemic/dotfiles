#!/bin/env bash
# =============================================
# Script to set the Battery charge threshold
# =============================================
# → Installation: 
# → Create a file: sudo nano ~/.local/bin/battery-threshold.sh
# → Make the script executable: sudo chmod +x ~/.local/bin/battery-threshold.sh
# =============================================
# → Create systemd daemon:
# sudo nano /etc/systemd/system/battery-threshold-tuning.service
# → See: https://github.com/p2ndemic/dotfiles/blob/main/etc/systemd/system/battery-threshold-tuning.service
# =============================================
# → Reload systemd and enable/start the 'battery-threshold-tuning.service' immediately:
# sudo systemctl daemon-reload
# sudo systemctl enable --now battery-threshold-tuning.service
# =============================================
echo 80 | tee /sys/class/power_supply/BAT0/charge_control_end_threshold
