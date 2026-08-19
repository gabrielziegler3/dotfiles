#!/usr/bin/env bash
# Toggle the connected Bluetooth headset between:
#   A2DP               high-fidelity playback, no headset microphone
#   HFP mSBC           microphone + playback, lower-fidelity mono playback
#
# mSBC is selected explicitly instead of the generic HFP profile because
# Pixel Buds Pro's LC3-SWB profile has been unreliable on this system.
set -u

card=$(pactl list cards short | awk '$2 ~ /^bluez_card\./ {print $2; exit}')

notify() {
    command -v notify-send >/dev/null 2>&1 && notify-send -i audio-headset-bluetooth "Bluetooth" "$1"
}

if [[ -z "${card:-}" ]]; then
    notify "No connected Bluetooth audio device."
    exit 1
fi

profile() {
    pactl list cards 2>/dev/null | awk -v card="$card" '
        $1 == "Name:" && $2 == card { inside=1; next }
        inside && $1 == "Active" && $2 == "Profile:" { print $3; exit }
        inside && $1 == "Card" { exit }
    '
}

set_profile() {
    local target="$1"
    local i
    for i in 1 2 3 4 5; do
        if pactl set-card-profile "$card" "$target" >/dev/null 2>&1; then
            sleep 1
            [[ "$(profile)" == "$target"* ]] && return 0
        fi
        sleep 1
    done
    return 1
}

set_default_bt_devices() {
    local id="${card#bluez_card.}"
    local sink="bluez_output.${id}.1"
    local source="bluez_input.${id}.0"
    pactl set-default-sink "$sink" >/dev/null 2>&1 || true
    pactl set-default-source "$source" >/dev/null 2>&1 || true
}

set_default_non_bt_source() {
    local source
    source=$(pactl list short sources | awk '$2 ~ /^alsa_input\./ {print $2; exit}')
    [[ -z "$source" ]] || pactl set-default-source "$source" >/dev/null 2>&1 || true
}

current=$(profile)
id="${card#bluez_card.}"
mac=${id//_/:}

if [[ "$current" == a2dp-sink* ]]; then
    # Explicit mSBC is more reliable than the default LC3-SWB HFP profile.
    if set_profile headset-head-unit-msbc; then
        set_default_bt_devices
        notify "Mic + Audio (HFP mSBC)"
    elif set_profile headset-head-unit-cvsd; then
        set_default_bt_devices
        notify "Mic + Audio (HFP CVSD fallback)"
    else
        notify "Could not enable Bluetooth microphone."
        exit 1
    fi
else
    # Try the normal profile transition first. Reconnect only if PipeWire/
    # BlueZ has left the headset's SCO transport in a bad state.
    switched=0
    if set_profile a2dp-sink; then
        switched=1
    else
        bluetoothctl disconnect "$mac" >/dev/null 2>&1 || true
        sleep 2
        bluetoothctl connect "$mac" >/dev/null 2>&1 || true
        for _ in 1 2 3 4 5 6 7 8; do
            if set_profile a2dp-sink; then
                switched=1
                break
            fi
            sleep 1
        done
    fi

    if [[ "$switched" -eq 1 ]]; then
        set_default_bt_devices
        set_default_non_bt_source
        notify "Hi-Fi Audio (A2DP)"
    else
        notify "Could not restore Bluetooth high-fidelity audio."
        exit 1
    fi
fi
