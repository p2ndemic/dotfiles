#!/bin/bash
# =============================================
# Intel P-State Max Performance power profile script
# =============================================
# → Installation: 
# → Create file: sudo nano ~/.local/bin/intel-pstate-max-perf.sh
# → Make the script executable: sudo chmod +x ~/.local/bin/intel-pstate-max-perf.sh
# =============================================

# Set scaling governor to performance
for governor in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
do
    echo "performance" > "$governor"
done

# Set energy performance preference to performance
for preference in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
do
    echo "performance" > "$preference"
done

echo "Intel Max Performance power profile activated"
