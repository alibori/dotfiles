#!/bin/sh
# Power menu for polybar. Uses only what is already installed:
# dmenu (~/.config/dmenu/dmenu.sh), slock, bspc, systemctl.

case "$(printf ' Lock\n󰗽 Logout\n󰒲 Suspend\n Reboot\n⏻ Shutdown' \
        | "$HOME/.config/dmenu/dmenu.sh" -i -p 'power' -l 5)" in
	*Lock)     exec slock ;;
	*Logout)   exec bspc quit ;;
	*Suspend)  exec systemctl suspend ;;
	*Reboot)   exec systemctl reboot ;;
	*Shutdown) exec systemctl poweroff ;;
esac
