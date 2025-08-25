#!/bin/bash
# Script to set default INTEL P-State settings
# Balances performance with power efficiency

# Set governor
echo "powersave" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

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
