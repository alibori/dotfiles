#!/usr/bin/env bash
# Claude Code plan-limit usage for two accounts (personal / work).
#   claude-usage.sh   toggle rofi popup with both accounts
#
# Reads each account's OAuth token from its .credentials.json and never
# refreshes it: rotating the refresh token here would log Claude Code out.
# An expired token just shows "exp" until Claude Code is run on that account.
# The /api/oauth/usage endpoint is undocumented (it is what /usage calls).

declare -A DIRS=([personal]="$HOME/.claude" [work]="$HOME/.claude-work")
CACHE="${XDG_RUNTIME_DIR:-/tmp}/claude-usage"
mkdir -p "$CACHE"

# fetch <name>: refresh cache if older than 5 min. Status in $CACHE/<name>.err.
fetch() {
    local f="$CACHE/$1.json" creds="${DIRS[$1]}/.credentials.json" tok exp
    [ -n "$(find "$f" -mmin -5 2>/dev/null)" ] && return
    tok=$(jq -r '.claudeAiOauth.accessToken // empty' "$creds" 2>/dev/null)
    exp=$(jq -r '.claudeAiOauth.expiresAt // 0' "$creds" 2>/dev/null)
    if [ -z "$tok" ]; then echo "?" > "$CACHE/$1.err"; return; fi
    if [ "${exp:-0}" -le "$(date +%s%3N)" ]; then echo "exp" > "$CACHE/$1.err"; return; fi
    if curl -sf --max-time 5 -o "$f.tmp" \
        -H "Authorization: Bearer $tok" -H "anthropic-beta: oauth-2025-04-20" \
        https://api.anthropic.com/api/oauth/usage && jq -e .limits "$f.tmp" >/dev/null; then
        mv "$f.tmp" "$f"; rm -f "$CACHE/$1.err"
    else
        rm -f "$f.tmp"; echo "?" > "$CACHE/$1.err"
    fi
}

# bar <pct> <width>
bar() {
    local n=$(( ($1 * $2 + 50) / 100 )) s=""
    (( n > $2 )) && n=$2
    for ((i = 0; i < $2; i++)); do (( i < n )) && s+="▰" || s+="▱"; done
    printf '%s' "$s"
}

# rows <name>: "label<TAB>pct<TAB>resets_at" per limit
rows() {
    jq -r '.limits[] | [
        (if .kind == "session" then "5h session"
         elif .kind == "weekly_all" then "Week"
         else "Week " + (.scope.model.display_name // .kind) end),
        (.percent | floor), (.resets_at // "")] | @tsv' "$CACHE/$1.json" 2>/dev/null
}

pkill -x rofi && exit
for name in personal work; do
    fetch "$name"
    echo "── ${name^} ──"
    if [ -s "$CACHE/$name.err" ]; then
        echo "unavailable ($(cat "$CACHE/$name.err")): run claude on this account"
        continue
    fi
    rows "$name" | while IFS=$'\t' read -r label pct reset; do
        [ -n "$reset" ] && reset="resets $(date -d "$reset" '+%a %H:%M')"
        printf '%-14s %s %3s%%  %s\n' "$label" "$(bar "$pct" 20)" "$pct" "$reset"
    done
done | rofi -dmenu -no-custom -theme-str 'window {width: 44em;} mainbox {children: [listview];} listview {lines: 8;}' >/dev/null
