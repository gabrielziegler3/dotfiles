#!/bin/bash
# Read two samples 0.5s apart for accurate current usage
read cpu user1 nice1 sys1 idle1 rest1 < <(grep '^cpu ' /proc/stat)
sleep 0.3
read cpu user2 nice2 sys2 idle2 rest2 < <(grep '^cpu ' /proc/stat)

busy=$(( (user2 + nice2 + sys2) - (user1 + nice1 + sys1) ))
total=$(( busy + (idle2 - idle1) ))

if [ "$total" -gt 0 ]; then
    printf "%d%%\n" $(( busy * 100 / total ))
else
    echo "0%"
fi
