#!/usr/bin/env bash
# Print current Bluetooth audio profile as a glyph for waybar custom module.
# Output: icon + tooltip via simple text (no JSON wrapper).
set -euo pipefail

profile=$(pactl list cards 2>/dev/null | awk '
    /bluez_card/ {found=1}
    found && /Active Profile:/ {print $3; exit}
')

case "${profile:-none}" in
    a2dp-sink*)        echo "󰋋 A2DP" ;;       # headphones icon
    headset-head-unit*) echo "󰂑 HFP" ;;       # headset-with-mic icon
    off)               echo "󰟎 off" ;;
    *)                 echo "" ;;             # no BT audio device
esac
