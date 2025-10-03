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
alias md2rst="pandoc --from=markdown-smart --to=rst --wrap=preserve"

# Do not wait for full input before showing output in less
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# some names I prefer to correctly accent
alias lukasz="echo -n Łukasz | copy"

alias docker-compose="docker compose"  # In case I continue to type docker-compose
alias web='python -m webbrowser'
alias open=xdg-open
alias cvim='vim -c "call ToggleFancyFeatures()"'

# Setup python-launcher to use startup file
export PYTHONSTARTUP=$HOME/.startup.py

PROJECTS_FILE=$HOME/.projects

venv() {
    local venv_name
    local dir_name=$(basename "$PWD")
    local uv_args=()

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -*)
                uv_args+=("$1")
                if [[ "$2" != -* && -n "$2" ]]; then
                    uv_args+=("$2")
                    shift
                fi
                ;;
            *)
                venv_name="$1"
                ;;
        esac
        shift
    done

    # If no venv_name was provided, use the directory name
    if [[ -z "$venv_name" ]]; then
        venv_name="$dir_name"
    fi

    # Check if .envrc already exists
    if [ -f .envrc ]; then
        echo "Error: .envrc already exists" >&2
        return 1
    fi

    # Create venv using uv with parsed arguments
    if ! uv venv --python-preference=system --seed --prompt "${uv_args[@]}" "$venv_name"; then
        echo "Error: Failed to create venv" >&2
        return 1
    fi

    # Create .envrc
    echo "layout python" > .envrc

    # Append to ~/.projects
    echo "${venv_name} = ${PWD}" >> "$PROJECTS_FILE"

    # Allow direnv to immediately activate the virtual environment
    direnv allow
}

workon() {
    local project_name="$1"
    local project_dir

    # Check for projects config file
    if [[ ! -f "$PROJECTS_FILE" ]]; then
        echo "Error: $PROJECTS_FILE not found" >&2
        return 1
    fi

    # Get the project directory for the given project name
    project_dir=$(grep -E "^$project_name\s*=" "$PROJECTS_FILE" | sed 's/^[^=]*=\s*//')

    # Ensure a project directory was found
    if [[ -z "$project_dir" ]]; then
        echo "Error: Project '$project_name' not found in $PROJECTS_FILE" >&2
        return 1
    fi

    # Ensure the project directory exists
    if [[ ! -d "$project_dir" ]]; then
        echo "Error: Directory $project_dir does not exist" >&2
        return 1
    fi

    # Change directories
    cd "$project_dir"
}

# Completion for workon:
_complete_workon() {
    projects=(${(f)"$(cat $PROJECTS_FILE | cut -f -1 -d ' ')"})
    _arguments '*:projects:($projects)'
}

compdef _complete_workon workon

# Use virtualenvwrapper only for tmux sessions that set VIRTUALENV env variable
if [[ -d "$HOME/.virtualenvs" && "$VIRTUALENV" != "" ]]; then
    export WORKON_HOME=$HOME/.virtualenvs
    export VIRTUALENVWRAPPER_PYTHON=$HOME/.local/pipx/venvs/virtualenvwrapper/bin/python

    source virtualenvwrapper_lazy.sh
    # Seems slightly faster than "workon $VIRTUALENV"
    . "$WORKON_HOME/$VIRTUALENV/bin/activate"
fi

# Completion for just
_justfile_comp() {
    if [[ -f "justfile" ]]; then
        local opts
        opts="`just --summary`"
        reply=(${(s: :)opts})
    fi
}

# Use function for first arg, filename completion for subsequent args
compctl -K _justfile_comp -x 'p[2,-1]' -f -- just

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

# Add all uv-managed Python tool bins to PATH
uv_pythons=("${(@f)$(uv python list --managed-python --only-installed --color=never \
  | awk '{print $2}' \
  | tac)}")
for python_executable in $uv_pythons; do
  python_bin_dir="${python_executable:h}"  # :h is zsh's dirname modifier
  case ":$PATH:" in
    *":$python_bin_dir:"*) ;;  # Already in PATH
    *) PATH="$python_bin_dir:$PATH" ;; # Not yet in PATH
  esac
done

export OPENAI_API_KEY=$(cat ~/.openai)

# opencode
export PATH=/home/trey/.opencode/bin:$PATH

# Wasmer
export WASMER_DIR="/home/trey/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"
