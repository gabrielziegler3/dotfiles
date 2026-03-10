#!/bin/bash
MAX_LEN=35
SCROLL_FILE="/tmp/i3blocks-spotify-scroll"
ICON=$(printf '\uf001')

artist=$(playerctl --player=spotify metadata artist 2>/dev/null)
title=$(playerctl --player=spotify metadata title 2>/dev/null)

if [ -z "$artist" ]; then
    rm -f "$SCROLL_FILE"
    echo ""
    exit 0
fi

text="$artist — $title"

if [ ${#text} -le $MAX_LEN ]; then
    echo "<span color='#9ece6a'>$ICON</span> $text"
    rm -f "$SCROLL_FILE"
    exit 0
fi

# Pad with spaces for smooth wrap-around
padded="$text   ·   $text   ·   "
offset=$(cat "$SCROLL_FILE" 2>/dev/null || echo 0)
window=${padded:$offset:$MAX_LEN}

# Advance offset, wrap around at text + separator length
next=$(( (offset + 1) % (${#text} + 7) ))
echo "$next" > "$SCROLL_FILE"

echo "<span color='#9ece6a'>$ICON</span> $window"
