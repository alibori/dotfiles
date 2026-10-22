# dotfiles

My Linux desktop config: bspwm + sxhkd + polybar, Alacritty, Zellij and Neovim. Catppuccin Mocha everywhere.

| Package     | What                                                                |
|-------------|---------------------------------------------------------------------|
| `bspwm`     | Tiling WM, multi-monitor layout (`monitors.sh`), autostart          |
| `sxhkd`     | Keybindings                                                         |
| `polybar`   | Status bar + scripts (Wi-Fi, VPN, battery, power menu, Claude usage) |
| `alacritty` | Terminal; themes from [alacritty-theme](https://github.com/alacritty/alacritty-theme) (submodule) |
| `zellij`    | Terminal multiplexer, custom layout with [zjstatus](https://github.com/dj95/zjstatus) |
| `nvim`      | Neovim config on [lazy.nvim](https://github.com/folke/lazy.nvim), PHP/Laravel focused |

## Install

Each top-level folder is a [GNU Stow](https://www.gnu.org/software/stow/) package mirroring `$HOME`.

```sh
git clone --recurse-submodules https://github.com/alibori/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow bspwm sxhkd polybar alacritty zellij nvim

# zjstatus plugin for the zellij layout (not committed)
mkdir -p ~/.config/zellij/plugins
curl -L -o ~/.config/zellij/plugins/zjstatus.wasm \
  https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm
```

Already cloned without submodules? `git submodule update --init`.

## Dependencies

bspwm, sxhkd, polybar, rofi, picom, dunst, feh, maim, alacritty, zellij, neovim, NetworkManager (`nmcli`), `jq`, `curl`, a Nerd Font.

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
- `bspwmrc` expects a picom config at `~/.config/picom/picom.conf` and a wallpaper under `~/Pictures/wallpapers/` (not in this repo).

## License

[MIT](LICENSE). Third-party themes and plugins keep their own licenses.
