#!/bin/sh

# Kill running instances
killall -q polybar

# Wait until they have exited. Uses `id -u`, not $UID: $UID is a bashism and
# is empty under /bin/sh (dash).
while pgrep -u "$(id -u)" -x polybar >/dev/null; do sleep 0.5; done

# hwmon indices are not stable across reboots — resolve k10temp at launch.
POLYBAR_HWMON_CPU="$(dirname "$(grep -l '^k10temp$' /sys/class/hwmon/*/name | head -1)")/temp1_input"
export POLYBAR_HWMON_CPU

# Launch the bar
polybar main &
#polybar secondary &

