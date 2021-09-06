# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/wittano/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
# ZSH_THEME="avit"
ZSH_THEME="af-magic"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git
         branch
         colorize
         colored-man-pages
         docker
         docker-compose
         python
         tmux
         vi-mode
        )

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='emacs'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

EDITOR=vim
PATH=$PATH:$HOME/.local/bin:$HOME/.cargo/bin
VISUAL=$EDITOR
SERVER_IP="192.168.1.160"

# Aliases

# Debian/Ubuntu base
if [ -n "$(command -v apt)" ]; then
    alias ai="sudo apt install"
    alias au="sudo apt update && sudo apt upgrade"
    alias ar="sudo apt remove"
	alias ara="sudo apt autoremove"
    alias ap="sudo apt purge"
    alias as="apt search"
fi

# Void linux
if [ -n "$(command -v xbps-install)" ]; then
    alias xq='xbps-query -R'
    alias xi='sudo xbps-install -S'
    alias xiu='sudo xbps-install -Su'
    alias xr='sudo xbps-remove'
    alias xro='sudo xbps-remove -Oo'
fi

# Config shotcuts
alias bc="$EDITOR ~/.config/bspwm/bspwmrc"
alias kc="$EDITOR ~/.config/sxhkd/sxhkdrc"
alias zc="$EDITOR ~/.zshrc"
alias oc="$EDITOR ~/.oh-my-zsh"

# YADM alias
alias yaa="yadm add"
alias yac="yadm commit"
alias yas="yadm status"
alias yapush="yadm push origin main"
alias yapull="yadm pull origin main"

# Programming
alias py='python3'
alias npm='pnpm'
alias vi="nvim"

# Server
alias sl="ssh wittano@${SERVER_IP}"
alias re='sudo sshfs -o allow_other wittanosftp@192.168.10.160:/ /mnt/remote'

# Utils
alias cl="sudo poweroff"
alias xc='xprop | grep CLASS'
alias yta='youtube-dl -x --audio-format mp3 -o "%(title)s.%(ext)s" --prefer-ffmpeg'
alias red='redshift -l 51.2181945:22.5546776'
alias cld='bash $HOME/project/bash/cleanDocker.sh'
alias ra='ranger'
