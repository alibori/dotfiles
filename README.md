# dotfiles

My Linux desktop config: bspwm + sxhkd + polybar, Alacritty, Zellij and Neovim. Colors follow pywal.

| Package     | What                                                                |
|-------------|---------------------------------------------------------------------|
| `bspwm`     | Tiling WM, multi-monitor layout (`monitors.sh`), autostart          |
| `wal`       | pywal templates (polybar, dunst, rofi) + `apply.sh` hook that pushes each new palette to running apps |
| `sxhkd`     | Keybindings                                                         |
| `polybar`   | Status bar + scripts (Wi-Fi, VPN, battery, power menu, Claude usage) |
| `alacritty` | Terminal; colors follow pywal (imports `~/.cache/wal/colors-alacritty.toml`) |
| `picom`     | Compositor: transparency, dual_kawase blur, rounded corners, shadows |
| `zellij`    | Terminal multiplexer, custom layout with [zjstatus](https://github.com/dj95/zjstatus) |
| `herdr`     | [Herdr](https://herdr.dev) agent workspace; `terminal` theme follows pywal |
| `nvim`      | Neovim config on [lazy.nvim](https://github.com/folke/lazy.nvim), PHP/Laravel focused; catppuccin recolored from pywal |
| `starship`  | Prompt; palette names mapped to ANSI so colors follow pywal         |
| `rofi`      | Launcher; `wal` theme imports `~/.cache/wal/colors-rofi.rasi` (template in `wal`) |

## Install

Each top-level folder is a [GNU Stow](https://www.gnu.org/software/stow/) package mirroring `$HOME`.

```sh
git clone https://github.com/alibori/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow wal bspwm sxhkd polybar alacritty zellij nvim picom herdr qutebrowser starship rofi

# zjstatus plugin for the zellij layout (not committed)
mkdir -p ~/.config/zellij/plugins
curl -L -o ~/.config/zellij/plugins/zjstatus.wasm \
  https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm
```

## Dependencies

bspwm, sxhkd, polybar, rofi, picom, dunst, feh, maim, alacritty, zellij, neovim, starship, NetworkManager (`nmcli`), `jq`, `curl`, a Nerd Font.

## Local / private config

Private values are kept out of git in `polybar/.config/polybar/.env`:

```sh
cp polybar/.config/polybar/.env.example polybar/.config/polybar/.env
```

| Variable       | Used by                 | Purpose                                              |
|----------------|-------------------------|------------------------------------------------------|
| `OPENVPN_HOST` | `scripts/wg-toggle.sh`  | Kill orphaned openvpn client on disconnect (optional) |

## Notes

- `bspwm/monitors.sh` is tied to my monitor setup; edit outputs/modes for yours.
- `bspwmrc` expects a wallpaper under `~/Pictures/wallpapers/` (not in this repo).

## License

[MIT](LICENSE). Third-party themes and plugins keep their own licenses.
