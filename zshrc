# Allow directory stacks
setopt AUTO_PUSHD       # Push the old directory onto a stack
setopt PUSHD_MINUS      # Swap the directory stack ordering

# Autocompletion
fpath=(~/.zsh/completion $fpath)
zstyle ':completion:*' completer _expand _complete _ignored _correct
autoload -U bashcompinit
bashcompinit
autoload -U compinit
compinit

# Set zsh history file length
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

export PS1="%~ \$ "

# If not running interactively, don't do anything
[ -z "$PROMPT" ] && return

# Enable color support for ls and grep
if which dircolors &> /dev/null ; then
    eval $(dircolors -b)
    alias ls='ls -1 --color=auto'
    alias grep='grep --color=auto'
else
    alias ls='ls -1'
fi

# Replace git with hub if found
if which hub &> /dev/null ; then
    function git(){ hub "$@" }
fi

alias gt='cd $(git rev-parse --show-toplevel)'
alias '$'=''  # Copy-pasting commands with '$ ' in front still works

# copy & paste commands
alias "copy=xclip -sel clipboard"
alias "paste=xclip -o"

# Do not wait for full input before showing output in less
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# Setup python-launcher to use pyenv default version
export PY_PYTHON=$(head -n 1 $(pyenv root)/version | cut -d "." -f 1,2)

alias mkvenv3='mkvirtualenv -a $PWD --python=python$PY_PYTHON'
alias mkvenv2='mkvirtualenv -a $PWD --python=$(which python2)'
alias mshell='docker-compose exec --user="$(id -u):$(id -g)" django python manage.py shell'
function mrun(){
    cat "$@" | docker exec --user="$(id -u):$(id -g)" -i $(docker-compose ps -q django) python manage.py shell
}
alias mtest='docker-compose exec test pytest'
alias mexec='docker-compose exec django'
alias mmanage='docker-compose exec --user="$(id -u):$(id -g)" django python manage.py'
alias web='python -m webbrowser'
alias open=xdg-open
alias cvim='vim -c "call ToggleFancyFeatures()"'

# Setup python-launcher to use startup file
alias py='PYTHONSTARTUP="$HOME/.startup.py" py'

# Set virtualenvwrapper settings
if [ -d "$HOME/.virtualenvs" ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    export VIRTUALENVWRAPPER_PYTHON=$HOME/.local/pipx/venvs/virtualenvwrapper/bin/python
    source virtualenvwrapper_lazy.sh
    #export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
fi

if [ "$VIRTUAL_ENV" != "" ]; then
    . "$VIRTUAL_ENV/bin/activate"
else
    if [ "$VIRTUALENV" != "" ] ; then
        # Seems slightly faster than "workon $VIRTUALENV"
        . "$WORKON_HOME/$VIRTUALENV/bin/activate"
    fi
fi

set -o emacs

export EDITOR=vim  # Use vim as default text editor
stty -ixon
export LC_TIME="C"  # Use 24 hour time

export NODE_PATH=$NODE_PATH:/home/trey/.nvm/v0.10.35/lib/node_modules

# Use fnm, which is like nvm but doesn't slow cause a slow shell load time
FNM_PATH="/home/trey/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/trey/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

# Add Cabal to path
export PATH="$HOME/.cabal/bin:$PATH"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Use local node_modules versions of packages
export PATH="./node_modules/.bin:$PATH"
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn

# Set directory colors for solarized light
eval `dircolors ~/.dotfiles/dircolors.ansi-light`

# Setup direnv
eval "$(direnv hook zsh)"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

setopt PROMPT_SUBST

# Add direnv-activated venv to prompt
show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV_PROMPT" && -n "$DIRENV_DIR" ]]; then
    echo "($(basename $VIRTUAL_ENV_PROMPT)) "
  fi
}
PS1='$(show_virtual_env)'$PS1

export DIRENV_LOG_FORMAT=

eval "$(starship init zsh)"
