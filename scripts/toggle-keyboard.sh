#!/bin/sh

KB_LAYOUT=$(setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}')

if [ "$KB_LAYOUT" = "us" ]; then
	setxkbmap us -variant intl
	echo "set us intl"
elif [ "$KB_LAYOUT" = "us(intl)" ]; then
	setxkbmap us
	echo "set us"
else
	echo "This script does not support the layout" $KB_LAYOUT
fi
