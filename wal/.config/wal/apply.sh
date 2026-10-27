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

# herdr uses the "terminal" theme; SIGWINCH makes the client re-read the
# palette wal just pushed. -fx skips the `.../herdr server` process.
pkill -WINCH -fx herdr

# qutebrowser reads ~/.cache/wal/colors.json in config.py. Reload each running
# instance through its own --basedir (profiles); calling qutebrowser with no
# instance running would open a new window instead.
pgrep -af 'python[0-9.]* -m qutebrowser' | while read -r _ cmd; do
    case "$cmd" in
        *--basedir\ *) b=${cmd#*--basedir }; qutebrowser --basedir "${b%% *}" :config-source ;;
        *) qutebrowser :config-source ;;
    esac
done >/dev/null 2>&1 &
