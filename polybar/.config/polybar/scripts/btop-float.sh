#!/usr/bin/env bash
# Toggle a floating btop terminal. Bound to polybar CPU click.
# The bspwm float/center rule for class "btop-float" lives in ~/.config/bspwm/bspwmrc.

wins=$(xdotool search --class btop-float 2>/dev/null)

if [ -n "$wins" ]; then
    # Close every match, so a stray double-click never leaks a window.
    echo "$wins" | while read -r w; do xdotool windowclose "$w"; done
else
    alacritty --class btop-float \
        -o window.dimensions.columns=85 -o window.dimensions.lines=30 \
        -e btop &
fi
