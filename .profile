export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR='nvim'
export VISUAL='nvim'
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# less and man colors
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# GPU VAAPI driver config
export LIBVA_DRIVER_NAME="radeonsi"

export PATH=/home/gabrielziegler/.local/bin${PATH:+:${PATH}}

# No accessibility
export NO_AT_BRIDGE=1

export JAVA_HOME=/usr/lib/jvm/default

# Display percentage on man document
export MANPAGER='less -s -M +Gg'
