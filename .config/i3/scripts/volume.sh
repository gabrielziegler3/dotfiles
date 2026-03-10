#!/bin/bash
mute=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | grep -c yes)
vol=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -oP '\d+%' | head -1)

if [ "$mute" -eq 1 ]; then
    echo "MUTE"
else
    echo "${vol:-??}"
fi
