#!/bin/sh

xinput set-prop 14 286 1

if [ -f ~/.env_variables ]; then
    . ~/.env_variables
fi

[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

exec i3
