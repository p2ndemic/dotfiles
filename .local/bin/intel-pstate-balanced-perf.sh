#!/bin/bash
# =============================================
# Intel P-State Balanced Performance power profile script
# =============================================
# Installation: 
# Create file: sudo nano ~/.local/bin/intel-pstate-balanced-perf.sh
# Grant permissions to execute the script: sudo chmod +x ~/.local/bin/intel-pstate-balanced-perf.sh
# =============================================

# Set governor to powersave
echo "powersave" > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Set energy performance preference to performance
for preference in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
do
    echo "performance" > "$preference"
done

echo "Intel Balanced Performance power profile activated"
