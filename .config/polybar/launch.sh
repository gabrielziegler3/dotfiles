#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# if type "xrandr"; then
#   for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#     MONITOR=$m polybar --reload topbar &
#   done
# else
#   polybar --reload topbar &
# fi

polybar -c ${HOME}/.config/polybar/config left &
polybar -c ${HOME}/.config/polybar/config center &
polybar -c ${HOME}/.config/polybar/config right &
