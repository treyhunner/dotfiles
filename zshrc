# Autocompletion
fpath=(~/.zsh/completion $fpath)
zstyle ':completion:*' completer _expand _complete _ignored _correct
autoload -U compinit
compinit

# Set zsh history file length
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# Add local bin directory to PATH
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH:$HOME/.local/bin"
    export PATH
fi

export PS1="%~ \$ "

# If not running interactively, don't do anything
[ -z "$PROMPT" ] && return

# Enable color support for ls and grep
if which dircolors &> /dev/null ; then
    eval $(dircolors -b)
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# Replace git with hub if found
if which hub &> /dev/null ; then
    function git(){ hub "$@" }
fi

alias gt='cd $(git rev-parse --show-toplevel)'

# Do not wait for full input before showing output in less
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# Set virtualenvwrapper settings
if which virtualenvwrapper.sh &> /dev/null ; then
    export WORKON_HOME=$HOME/.virtualenvs
    export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3.5
    source $(which virtualenvwrapper.sh)
    #pyenv virtualenvwrapper
fi

function mkvenv() {
    mkvirtualenv --python=$(which python3.5) $1
    setvirtualenvproject $VIRTUAL_ENV $(pwd)
}

function mkvenv2() {
    mkvirtualenv $1
    setvirtualenvproject $VIRTUAL_ENV $(pwd)
}

if [ "$VIRTUALENV" != "" ] ; then
    workon "$VIRTUALENV"
fi

set -o emacs

export EDITOR=vim  # Use vim as default text editor
stty -ixon
export LC_TIME="C"  # Use 24 hour time

export NVM_DIR="/home/trey/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && nvm use &>/dev/null  # This loads nvm
export NODE_PATH=$NODE_PATH:/home/trey/.nvm/v0.10.35/lib/node_modules

# Add Cabal to path
export PATH="$HOME/.cabal/bin:$PATH"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Use local node_modules versions of packages
export PATH="./node_modules/.bin:$PATH"
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn

# Set directory colors for solarized light
eval `dircolors ~/.dotfiles/dircolors.ansi-light`
