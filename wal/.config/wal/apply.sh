#!/bin/sh
# Run by wal (`-o`) after every palette change. Pushes the new colors to the
# apps that can't pick them up on their own. Alacritty needs nothing: it
# live-reloads its imported ~/.cache/wal/colors-alacritty.toml.
#
#   wal -e -i ~/Pictures/wallpapers/forest.jpg -o ~/.config/wal/apply.sh

. "$HOME/.cache/wal/colors.sh"

# bspwm borders
bspc config focused_border_color  "$color5"
bspc config active_border_color   "$color4"
bspc config normal_border_color   "$color0"
bspc config presel_feedback_color "$color13"

# dunst 1.9 has no `dunstctl reload`: link the drop-in and restart it
mkdir -p "$HOME/.config/dunst/dunstrc.d"
ln -sf "$HOME/.cache/wal/dunst.conf" "$HOME/.config/dunst/dunstrc.d/99-wal.conf"
pkill -x dunst
dunst &

# polybar re-reads colors only on start; launch.sh kills the old bars
"$HOME/.config/polybar/launch.sh" &
