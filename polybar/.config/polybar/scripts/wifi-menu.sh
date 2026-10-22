#!/bin/sh
# Wi-Fi menu for polybar. Lists nearby SSIDs with an active (●) marker and
# signal strength; selecting one connects via nmcli (polkit, no sudo, no terminal).

list=$(nmcli -t -f IN-USE,SIGNAL,SECURITY,SSID device wifi list --rescan auto)

# nmcli -t escapes ':' inside SSIDs as '\:', so plain field splitting breaks on
# them. SSID goes last in -f and is recovered by stripping the first 3 fields.
# One SSID can have several BSS rows and the in-use one is not always the
# strongest, so keep the best signal but OR the in-use flag across all of them.
lines=$(printf '%s\n' "$list" | awk -F: '
  { ssid = $0; sub(/^[^:]*:[^:]*:[^:]*:/, "", ssid); gsub(/\\:/, ":", ssid) }
  ssid == "" { next }
  !(ssid in sig) { order[++n] = ssid; sig[ssid] = $2 }
  $2 + 0 > sig[ssid] + 0 { sig[ssid] = $2 }
  $1 == "*" { use[ssid] = 1 }
  END { for (i = 1; i <= n; i++) {
          s = order[i]
          printf "%s %3s%% %s\n", (use[s] ? "●" : "○"), sig[s], s
        } }
')

[ -z "$lines" ] && exit 0

choice=$(printf '%s\n' "$lines" | rofi -dmenu -i -p 'wifi' -no-custom)
[ -z "$choice" ] && exit 0

marker=${choice%% *}
ssid=$(printf '%s' "$choice" | sed 's/^[^ ]* *[^ ]* //')

# already connected → nothing to do (connect-only menu)
[ "$marker" = "●" ] && exit 0

secured=$(printf '%s\n' "$list" | awk -F: -v s="$ssid" '
  { t = $0; sub(/^[^:]*:[^:]*:[^:]*:/, "", t); gsub(/\\:/, ":", t) }
  t == s && $3 != "" { print 1; exit }')

(
	# Try without a password first: this reuses a saved profile when one exists,
	# whatever it is named (NM names them "SSID", "SSID 1", ...), so there is no
	# profile list to match against. Only prompt if that fails on a secured net.
	if ! nmcli device wifi connect "$ssid" > /dev/null 2>&1; then
		[ -z "$secured" ] && { notify-send 'Wi-Fi' "$ssid failed"; exit 1; }
		pass=$(rofi -dmenu -password -p "$ssid password" < /dev/null)
		pass=$(printf '%s' "$pass" | tr -d '\r')
		[ -z "$pass" ] && exit 0
		nmcli device wifi connect "$ssid" password "$pass" > /dev/null 2>&1 \
			|| { notify-send 'Wi-Fi' "$ssid failed"; exit 1; }
	fi
	notify-send 'Wi-Fi' "$ssid connected"
) &
