#!/bin/env bash
# =============================================
# Intel P-State Balanced Performance power profile script
# =============================================
# → Installation: 
# → Create a file: sudo nano ~/.local/bin/intel-pstate-balanced-perf.sh
# → Make the script executable: sudo chmod +x ~/.local/bin/intel-pstate-balanced-perf.sh
# =============================================

# Set scaling governor to powersave
for governor in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
do
    echo "powersave" > "$governor"
done

# Set energy performance preference to performance
for preference in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
do
    echo "performance" > "$preference"
done

echo "Intel Balanced Performance power profile activated"
