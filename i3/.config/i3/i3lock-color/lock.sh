#!/bin/sh

B='#00000000'  # blank
K='#000000ff'  # black
C='#ffffff22'  # clear ish
D='#ff00ffcc'  # default
T='#ee00eeee'  # text
W='#880000bb'  # wrong
V='#bb00bbbb'  # verifying
LB='#00ffffff'   # light blue

i3lock \
--insidevercolor=$B   \
--ringvercolor=$LB    \
\
--insidewrongcolor=$B \
--ringwrongcolor=$LB   \
\
--insidecolor=$B      \
--ringcolor=$LB       \
--linecolor=$LB        \
--separatorcolor=$LB   \
\
--verifcolor=$K      \
--wrongcolor=$K       \
--timecolor=$LB       \
--datecolor=$LB       \
--layoutcolor=$LB     \
--keyhlcolor=$K       \
--bshlcolor=$K        \
\
--clock               \
--indicator           \
--timestr="%H:%M:%S"  \
--datestr="%A, %m %Y" \
--image /home/ziegler/Pictures/Wallpapers/great-wave.jpg \
-t \
# --keylayout 2         \

# --veriftext="Drinking verification can..."
# --wrongtext="Nope!"
# --textsize=20
# --modsize=10
# --timefont=comic-sans
# --datefont=monofur
# etc
