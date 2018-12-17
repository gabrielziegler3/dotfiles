#!/bin/sh

if [ -f ~/.env_variables ]; then
    . ~/.env_variables
fi

[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

exec i3
