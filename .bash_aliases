# System functions
alias rm='rm -v'
alias mv='mv -v'
alias chown='chown -v'
alias chmod='chmod -v'
alias cp='cp -v'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -al'
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Virtual env
alias machine_learning='source ~/PyEnv/MachineLearning/bin/activate'
alias deep_learning='source ~/PyEnv/DeepLearning/bin/activate'
alias django='source ~/PyEnv/Django/bin/activate'

# Git
alias gs='git status'
alias ga='git add'
alias gco='git checkout'

# Docker
alias dps='docker ps'
alias dcbuild='docker-compose build'
alias dcup='docker-compose up'
alias dcdown='docker-compose down'

# Config
alias vimconfig='nvim ~/.config/nvim/init.vim'
alias i3config='nvim ~/.config/i3/config'
alias dunstconfig='nvim ~/.config/dunst/dunstrc'
alias polybarconfig='nvim ~/.config/polybar/config'

# Misc
alias xclip='xclip -selection clipboard'
alias pandoc='docker run --privileged --rm -u `id -u`:`id -g` -v $(pwd):/pandoc dalibo/pandocker'
