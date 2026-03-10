#!/bin/bash
# Cycle through wallpapers randomly using feh (no pywal)
WALLPAPER_DIR="${1:-$HOME/Pictures/Wallpapers}"
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name '*.jpg' -o -name '*.jpeg' -o -name '*.png' -o -name '*.webp' \) | shuf -n 1)

if [ -n "$WALLPAPER" ]; then
    feh --bg-fill "$WALLPAPER"
fi
