#!/bin/bash
location="Brasilia"
weather=$(curl -s -N "wttr.in/Brasilia?T" | grep -m 1 -Eo "([0-9]+-?[0-9]+)")

echo "$location" "$weather" "°C"
