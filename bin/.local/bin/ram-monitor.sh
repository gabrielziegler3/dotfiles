#!/bin/bash
# Monitors available RAM and sends a desktop notification when it drops below threshold.
# Runs in a loop, checking every 10 seconds.

WARN_THRESHOLD=15   # percentage of total RAM available
CRIT_THRESHOLD=8    # critical percentage

NOTIFIED_WARN=0
NOTIFIED_CRIT=0
TOTAL_KB=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)

while true; do
    AVAIL_KB=$(awk '/^MemAvailable:/ {print $2}' /proc/meminfo)
    PCT_AVAIL=$(( AVAIL_KB * 100 / TOTAL_KB ))

    if (( PCT_AVAIL <= CRIT_THRESHOLD )); then
        if (( NOTIFIED_CRIT == 0 )); then
            notify-send -u critical "RAM Critical!" \
                "Only ${PCT_AVAIL}% RAM available ($(( AVAIL_KB / 1024 )) MB). Close some applications!"
            NOTIFIED_CRIT=1
        fi
    elif (( PCT_AVAIL <= WARN_THRESHOLD )); then
        NOTIFIED_CRIT=0
        if (( NOTIFIED_WARN == 0 )); then
            notify-send -u normal "RAM Warning" \
                "${PCT_AVAIL}% RAM available ($(( AVAIL_KB / 1024 )) MB)"
            NOTIFIED_WARN=1
        fi
    else
        NOTIFIED_WARN=0
        NOTIFIED_CRIT=0
    fi

    sleep 10
done
