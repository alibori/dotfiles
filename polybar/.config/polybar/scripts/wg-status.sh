#!/bin/sh

# VPN status for polybar: shows whether any wireguard/vpn connection is up.
# Color is embedded in the output because it depends on state: polybar can't
# switch format-prefix based on what a custom/script returns.
ACTIVE=$(nmcli -t -f NAME,TYPE connection show --active \
	| awk -F: '$2=="wireguard"||$2=="vpn"{print $1}' | paste -sd, -)

# pywal palette; fallbacks keep the output valid if wal has never run.
. "$HOME/.cache/wal/colors.sh" 2>/dev/null

if [ -z "$ACTIVE" ]; then
	# No active tunnel
	printf '%%{F%s}󰦞 off%%{F-}\n' "${color8:-#6c7086}"
else
	# At least one tunnel up. Generic label so the connection name never shows
	# on screen (screenshots, screen sharing).
	printf '%%{F%s}󰦝%%{F-} %%{F%s}on%%{F-}\n' "${color2:-#a6e3a1}" "${foreground:-#cdd6f4}"
fi
