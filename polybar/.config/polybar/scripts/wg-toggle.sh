#!/bin/sh
# VPN menu for polybar. Lists NetworkManager wireguard and vpn connections with
# an active (●) / inactive (○) marker; selecting one toggles it via nmcli
# (polkit, no sudo, no terminal popup).

# Private settings (OPENVPN_HOST) live in a gitignored env file; see .env.example.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/polybar/.env" ] && . "${XDG_CONFIG_HOME:-$HOME/.config}/polybar/.env"

active=$(nmcli -t -f NAME,TYPE connection show --active | awk -F: '$2=="wireguard"||$2=="vpn"{print $1}')

lines=$(nmcli -t -f NAME,TYPE connection show \
	| awk -F: '$2=="wireguard"||$2=="vpn"{print $1}' \
	| while IFS= read -r name; do
		if printf '%s\n' "$active" | grep -qxF "$name"; then
			printf '● %s\n' "$name"
		else
			printf '○ %s\n' "$name"
		fi
	done)

[ -z "$lines" ] && exit 0

choice=$(printf '%s\n' "$lines" | rofi -dmenu -i -p 'vpn' -no-custom)
[ -z "$choice" ] && exit 0

marker=${choice%% *}
name=${choice#* }

if [ "$marker" = "●" ]; then
	nmcli connection down "$name"
	# NM deactivates its own state (label flips off) but can leave the openvpn
	# client orphaned — reparented to init, root-owned, no mgmt socket — so the
	# tunnel keeps routing. Reap it. Needs a NOPASSWD sudoers rule for
	# `/usr/bin/pkill -TERM -f <OPENVPN_HOST>` in /etc/sudoers.d/.
	type=$(nmcli -t -f connection.type connection show "$name" | cut -d: -f2)
	[ "$type" = vpn ] && [ -n "$OPENVPN_HOST" ] && sudo -n /usr/bin/pkill -TERM -f "$OPENVPN_HOST" 2>/dev/null
	notify-send 'VPN' "$name disconnected"
else
	# vpn connections may need a password (password-flags 1/2) but polybar has
	# no tty, and this NM ignores `passwd-file` for openvpn. Prompt via rofi and
	# feed `nmcli --ask` through a hidden pty (script -qec) — the only method
	# that actually delivers the secret. No terminal popup, no secret on disk.
	type=$(nmcli -t -f connection.type connection show "$name" | cut -d: -f2)
	pwflags=$(nmcli -t -f vpn.data connection show "$name" \
		| grep -o 'password-flags = [0-9]' | awk '{print $NF}')
	if [ "$type" = vpn ] && { [ "$pwflags" = 1 ] || [ "$pwflags" = 2 ]; }; then
		pass=$(rofi -dmenu -password -p "$name password" < /dev/null)
		# drop stray CR / leading & trailing blanks from the rofi entry,
		# but keep spaces inside the password
		pass=$(printf '%s' "$pass" | tr -d '\r' | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//')
		[ -z "$pass" ] && exit 0
		( printf '%s\n' "$pass" \
			| script -qec "nmcli --ask connection up \"$name\"" /dev/null \
				>/dev/null 2>&1 \
			&& notify-send 'VPN' "$name connected" \
			|| notify-send 'VPN' "$name failed" ) &
	else
		nmcli connection up "$name"
	fi
fi
