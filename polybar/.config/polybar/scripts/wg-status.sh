#!/bin/sh

# VPN status for polybar: shows whether any wireguard/vpn connection is up.
# Color is embedded in the output because it depends on state: polybar can't
# switch format-prefix based on what a custom/script returns.
ACTIVE=$(nmcli -t -f NAME,TYPE connection show --active \
	| awk -F: '$2=="wireguard"||$2=="vpn"{print $1}' | paste -sd, -)

if [ -z "$ACTIVE" ]; then
	# No active tunnel
	printf '%%{F#6c7086}󰦞 off%%{F-}\n'
else
	# At least one tunnel up. Generic label so the connection name never shows
	# on screen (screenshots, screen sharing).
	printf '%%{F#a6e3a1}󰦝%%{F-} %%{F#cdd6f4}on%%{F-}\n'
fi
