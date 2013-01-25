# Autocompletion
zstyle ':completion:*' completer _expand _complete _ignored _correct
autoload -U compinit
compinit

# Set zsh history file length
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# Add local bin directory to PATH
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
    export PATH
fi

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

# Source Ruby Version Manager if available
[ -s "$HOME/.rvm/scripts/rvm" ] && source "$HOME/.rvm/scripts/rvm"

# Use git status for prompt if git-prompt installed
if [ -s "$HOME/.zsh/git-prompt/zshrc.sh" ] ; then
    source "$HOME/.zsh/git-prompt/zshrc.sh"

    git_status() {
        GIT_STATUS=$(git_super_status)
        if [ -n "$GIT_STATUS" ]; then
            STATUS='%1~'$GIT_STATUS
        else
            STATUS='%3~'
        fi
        echo "$STATUS"
    }

    # Set prompt
    PROMPT='%m:$(git_status)%# '
else
    PROMPT='%m:%3~%# '
fi

# Set virtualenvwrapper settings
if which virtualenvwrapper.sh &> /dev/null ; then
    export WORKON_HOME=$HOME/.virtualenvs
    source $(which virtualenvwrapper.sh)
    export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
fi

if [ "$VIRTUALENV" != "" ] ; then
    workon "$VIRTUALENV"
fi

set -o emacs

export EDITOR=vim  # Use vim as default text editor
stty -ixon
