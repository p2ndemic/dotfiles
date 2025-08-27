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

# Enable HWP dynamic boost if available.
# Controls the hardware P-States booting. Allowing intel_pstate to use iowait boosting in the active mode with HWP enabled
# This parameter may improve performance and reduce latency, but it can also cause regressions. Individual testing on each system is required.
if [[ -f /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost ]]; then
    echo 1 > /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost
fi

echo "Intel Max Performance power profile activated"
