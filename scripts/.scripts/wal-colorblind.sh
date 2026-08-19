#!/bin/bash
# Wrapper around pywal that pins red/cyan ANSI colors for colorblind-friendly diffs
# Used by i3 keybinding (mod+n) and startup

# Run pywal normally
wal -i "$@"

# After pywal sets colors, override red and cyan with high-contrast values
# These are critical for diff readability with Claude Code's dark-daltonized theme
#
# color1  (red)    - deletions/changes
# color9  (bright red) - deletions/changes
# color6  (cyan)   - additions
# color14 (bright cyan) - additions

printf '\033]4;1;#ff6b6b\033\\'   # red
printf '\033]4;9;#ff8a8a\033\\'   # bright red
printf '\033]4;2;#d5ff80\033\\'   # green
printf '\033]4;10;#e6ff99\033\\'  # bright green
printf '\033]4;3;#ffdb80\033\\'   # yellow
printf '\033]4;11;#ffe099\033\\'  # bright yellow
printf '\033]4;4;#73bfff\033\\'   # blue
printf '\033]4;12;#99d1ff\033\\'  # bright blue
printf '\033]4;5;#e0ccff\033\\'   # magenta
printf '\033]4;13;#d4a8ff\033\\'  # bright magenta
printf '\033]4;6;#7fdbff\033\\'   # cyan / light blue
printf '\033]4;14;#a8e8ff\033\\'  # bright cyan / light blue
printf '\033]4;8;#b0b5ba\033\\'   # bright black (comments/dim text)
printf '\033]10;#e6e1cf\033\\'    # foreground
