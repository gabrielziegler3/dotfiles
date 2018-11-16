#!/bin/bash
curr="$(cat /sys/class/leds/asus::kbd_backlight/brightness)"
next=$((${curr}+$1))

echo "${next}" | tee /sys/class/leds/asus::kbd_backlight/brightness
