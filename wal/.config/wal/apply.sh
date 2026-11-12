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

# nvim maps colors.json onto catppuccin in plugins/theme.lua; :WalReload in
# every running instance (default servers live in $XDG_RUNTIME_DIR).
for s in "${XDG_RUNTIME_DIR:-/tmp}"/nvim.*.0; do
    [ -S "$s" ] && nvim --server "$s" --remote-send '<Cmd>WalReload<CR>'
done >/dev/null 2>&1 &

# devnull has no live reload: rewrite the "Wal theme" colors in tui.json;
# restart devnull to see them. danger/success/warning stay as set in the app,
# wal palettes aren't reliably red/green/yellow.
python3 - <<'PY'
import json, os
p = os.path.expanduser("~/.config/dev-null-cli/tui.json")
w = json.load(open(os.path.expanduser("~/.cache/wal/colors.json")))
c, s = w["colors"], w["special"]
rgb = lambda h: [int(h[i:i+2], 16) for i in (1, 3, 5)]
def mix(a, b, t):
    return "#" + "".join(f"{round(x + (y - x) * t):02x}" for x, y in zip(rgb(a), rgb(b)))
bg, fg = s["background"], s["foreground"]
try:
    cfg = json.load(open(p))
except FileNotFoundError:
    raise SystemExit
for t in cfg.get("custom_themes", []):
    if t.get("name") == "Wal theme":
        t["colors"].update(
            shell=bg, ink=fg, muted=c["color8"],
            wash=mix(bg, fg, .08), hairline=mix(bg, fg, .14), soft=mix(bg, c["color4"], .25),
            blue=c["color4"], code=c["color3"],
            **{f"lane{i}": c[f"color{i}"] for i in range(1, 7)})
        tmp = p + ".tmp"
        with open(os.open(tmp, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600), "w") as f:
            json.dump(cfg, f, indent=2)
        os.replace(tmp, p)
PY
