#!/usr/bin/env sh
set -eu

HYPROJECT="${HYPROJECT:-$HOME/.local/bin/hyproject}"
CONFIG="$HOME/.config/wofi/powermenu_config"
STYLE="$HOME/.config/wofi/pmenu_style.css"

if [ ! -x "$HYPROJECT" ]; then
  notify-send "hyproject" "Missing executable: $HYPROJECT" 2>/dev/null || true
  exit 1
fi

actions="$($HYPROJECT actions --format text)"
[ -n "$actions" ] || exit 0

labels="$(printf '%s\n' "$actions" | cut -f1)"
count="$(printf '%s\n' "$labels" | wc -l)"
height="$((13 * (2 * count + 1)))"

choice="$(printf '%s\n' "$labels" | wofi -i -d -H "$height" -c "$CONFIG" -s "$STYLE")"
[ -n "$choice" ] || exit 0

action="$(printf '%s\n' "$actions" | awk -F '\t' -v label="$choice" '$1 == label { print $2; exit }')"
[ -n "$action" ] || exit 0

$HYPROJECT run-action "$action"
