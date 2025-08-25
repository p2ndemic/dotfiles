#!/bin/bash
# Intel Max Performance power profile script

# Set governor to performance
echo "performance" > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Set energy performance preference to performance
for preference in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
do
    echo "performance" > "$preference"
done

echo "Intel Max Performance power profile activated"
