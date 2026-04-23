#!/bin/bash

CARD=$(pactl list cards short | grep bluez | awk '{print $2}')

if [ -z "$CARD" ]; then
    echo ""
    exit 0
fi

get_profile() {
    pactl list cards | grep -A 40 "Name: $CARD" | grep "Active Profile" | awk -F': ' '{print $2}'
}

case "${1:-status}" in
    toggle)
        if [ "$(get_profile)" = "a2dp-sink" ]; then
            pactl set-card-profile "$CARD" headset-head-unit
        else
            pactl set-card-profile "$CARD" a2dp-sink
        fi
        ;;
    status)
        if [ "$(get_profile)" = "a2dp-sink" ]; then
            echo " Audio"
        else
            echo " Mic"
        fi
        ;;
esac
