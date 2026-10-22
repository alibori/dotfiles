#!/bin/sh
# Power menu for polybar. Uses only what is already installed:
# rofi, slock, bspc, systemctl.

case "$(printf ' Lock\n󰗽 Logout\n󰒲 Suspend\n Reboot\n⏻ Shutdown' \
        | rofi -dmenu -i -p 'power' -no-custom -lines 5)" in
	*Lock)     exec slock ;;
	*Logout)   exec bspc quit ;;
	*Suspend)  exec systemctl suspend ;;
	*Reboot)   exec systemctl reboot ;;
	*Shutdown) exec systemctl poweroff ;;
esac
