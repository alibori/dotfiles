#!/bin/sh
# dmenu with pywal colors. Same args as dmenu; falls back to dmenu defaults if
# wal hasn't run. Bar bg, accent text on selection.
[ -f "$HOME/.cache/wal/colors.sh" ] && . "$HOME/.cache/wal/colors.sh"

# Single-line mode sits exactly over polybar (26pt @ 120dpi = 43px). Needs the
# lineheight patch (~/repositories/dmenu, branch lineheight); stock dmenu
# rejects -h, so only pass it when supported. Vertical lists (-l) keep normal rows.
h=
case " $* " in *" -l "*) ;; *) dmenu -h 1 -v >/dev/null 2>&1 && h='-h 43' ;; esac

# polybar only lives on eDP; dmenu -m wants its index, so look it up by name.
m=$(xrandr --listmonitors | awk '$NF == "eDP" { sub(":", "", $1); print "-m " $1 }')

# shellcheck disable=SC2086 # $h and $m are intentionally split
exec dmenu $h $m -fn 'JetBrainsMono Nerd Font:style=Bold:size=10' \
	-nb "${color0:-#222222}" -nf "${foreground:-#bbbbbb}" \
	-sb "${color0:-#222222}" -sf "${color2:-#eeeeee}" "$@"
