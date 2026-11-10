#!/bin/bash

export DISPLAY="${DISPLAY:-:0}"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

BAT_PATH="/sys/class/power_supply/BAT0"
STATE=$(cat "$BAT_PATH/status")
CAPACITY=$(cat "$BAT_PATH/capacity")

LOCK="/tmp/polybar-battery-alert.lock"

if [[ "$STATE" == "Discharging" && "$CAPACITY" -le 20 ]]; then
  if [[ ! -f "$LOCK" ]]; then
    # Lock file holds the notification ID so it can be closed later.
    notify-send -p -u critical -i battery-caution \
      "Low Battery" \
      "Battery level: ${CAPACITY}%" > "$LOCK"

    # paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga 2>/dev/null || \
    # aplay /usr/share/sounds/alsa/Front_Center.wav 2>/dev/null
  fi
elif [[ -f "$LOCK" ]]; then
  # Charging (or back above threshold): dismiss the alert.
  ID=$(cat "$LOCK")
  [[ -n "$ID" ]] && dunstify -C "$ID"
  rm -f "$LOCK"
fi

