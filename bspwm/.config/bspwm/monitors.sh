#!/bin/sh
# Fixed multi-monitor layout (no overlap). Machine-specific: adjust
# output names, modes and positions for your setup (see `xrandr -q`).

# DP (vertical)
xrandr --output DisplayPort-0 \
    --mode 1920x1080 \
    --rotate left \
    --pos 0x0 \
    --transform none

# HDMI (32"), right of the DP
xrandr --output HDMI-A-0 \
    --mode 2560x1440 \
    --pos 1080x240 \
    --transform none

# eDP (laptop panel), below the external monitors
xrandr --output eDP \
    --mode 1920x1200 \
    --pos 1648x1680 \
    --primary \
    --transform none

