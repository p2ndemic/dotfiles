#!/bin/env bash
# =============================================
# Script to set default INTEL P-State settings
# Balances performance with power efficiency
# =============================================
# Ref: https://wiki.archlinux.org/title/CPU_frequency_scaling
# =============================================
# → Installation: 
# → Create a file: sudo nano ~/.local/bin/intel-pstate-default.sh
# → Make the script executable: sudo chmod +x ~/.local/bin/intel-pstate-default.sh
# =============================================
# → Create systemd daemon: sudo nano /etc/systemd/system/intel-pstate-tuning.service
# → See: https://github.com/p2ndemic/dotfiles/blob/main/etc/systemd/system/intel-pstate-tuning.service
# =============================================
# → Reload systemd and enable/start the 'intel-pstate-tuning.service' immediately:
# sudo systemctl daemon-reload
# sudo systemctl enable --now intel-pstate-tuning.service
# =============================================
# → Install thermald: sudo pacman -S thermald && systemctl enable --now thermald
# =============================================
# → Install tuned: sudo pacman -S tuned && systemctl enable --now tuned
# =============================================

# Set scaling governor
for governor in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
do
    echo "powersave" > "$governor"
done

# Set energy performance preference
for preference in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
do
    echo "balance_performance" > "$preference"
done

# Enable Turbo Boost
echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo

# Enable HWP dynamic boost if available
if [[ -f /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost ]]; then
    echo 1 > /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost
fi

# Reset performance limits to default if files exist
if [[ -f /sys/devices/system/cpu/intel_pstate/min_perf_pct ]]; then
    echo 10 > /sys/devices/system/cpu/intel_pstate/min_perf_pct
fi

if [[ -f /sys/devices/system/cpu/intel_pstate/max_perf_pct ]]; then
    echo 100 > /sys/devices/system/cpu/intel_pstate/max_perf_pct
fi

# Check and enable thermald if not active
if ! systemctl is-active --quiet thermald; then
    systemctl enable --now thermald
fi

echo "Default Intel power profile activated"
