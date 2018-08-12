#!/bin/bash
curr="$(cat /sys/class/leds/asus::kbd_backlight/brightness)"
next=$((${curr}+$1))

echo "${next}" | sudo tee /sys/class/leds/asus::kbd_backlight/brightness
