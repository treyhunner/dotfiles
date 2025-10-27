# ~/.zshrc - Interactive zsh configuration
# Sourced for interactive shells only
# See also: ~/.zshenv (all shells), ~/.zprofile (login shells)

# If not running interactively, don't do anything
[[ ! -o interactive ]] && return

setopt AUTO_PUSHD       # Push directories onto stack automatically
setopt PUSHD_MINUS      # Swap meaning of cd +1 and cd -1

# completions
: ${XDG_CACHE_HOME:=$HOME/.cache}
fpath=("$XDG_CACHE_HOME/zsh/site-functions" $fpath)   # where _uv lives (see note below)
autoload -Uz compinit
ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
compinit -C -d "$ZSH_COMPDUMP"


HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# ========================================
# Environment & Tools
# ========================================

# Disable flow control (Ctrl-S/Ctrl-Q)
stty -ixon

# Enable emacs-style keybindings (Ctrl-A, Ctrl-E, Ctrl-K, etc.)
set -o emacs

# Less pipe for better paging
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# Fast Node Manager (fnm), like nvm but doesn't slow down shell load time
FNM_PATH="/home/trey/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/trey/.local/share/fnm:$PATH"
  eval "$(fnm env)"
fi

# Local node_modules binaries
export PATH="./node_modules/.bin:$PATH"

# Solarized light color scheme
eval "$(dircolors -b ~/.dotfiles/dircolors.ansi-light)"

# Setup direnv
eval "$(direnv hook zsh)"
export DIRENV_LOG_FORMAT=

# Add uv-managed Python binaries to PATH
uv_pythons=("${(@f)$(uv python list --managed-python --only-installed --color=never \
  | awk '{print $2}' \
  | tac)}")
for python_executable in $uv_pythons; do
  python_bin_dir="${python_executable:h}"
  case ":$PATH:" in
    *":$python_bin_dir:"*) ;;
    *) PATH="$python_bin_dir:$PATH" ;;
  esac
done

# OpenAI API key for scripts
export OPENAI_API_KEY=$(cat ~/.openai)

# OpenCode binary
export PATH=/home/trey/.opencode/bin:$PATH

# Wasmer runtime
export WASMER_DIR="/home/trey/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

# ========================================
# Aliases
# ========================================

# File listing & search
alias ls='ls -1 --color=auto'
alias grep='grep --color=auto'

# Git shortcuts
alias gt='cd $(git rev-parse --show-toplevel)'

# Clipboard (X11)
alias copy='xclip -sel clipboard'
alias paste='xclip -o'

# File & format conversions
alias md2rst='pandoc --from=markdown-smart --to=rst --wrap=preserve'
alias open=xdg-open

# Development tools
alias web='python -m webbrowser'
alias cvim='vim -c "call ToggleFancyFeatures()"'
alias docker-compose='docker compose'

# Misc
alias '$'=''           # Allow copy-pasting commands with '$ ' prefix
alias lukasz="echo -n Łukasz | copy"

alias bat=batcat
alias cat=batcat
export BAT_THEME="Solarized (light)"
export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | batcat -p -lman'"

# ========================================
# Project Helper Functions (workon & venv)
# ========================================

# Projects file for workon function
PROJECTS_FILE=$HOME/.projects

# venv - Create Python virtual environment with uv and direnv
# Usage: venv [name] [uv args...]
# Requires: uv, direnv
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

    # Default to directory name
    if [[ -z "$venv_name" ]]; then
        venv_name="$dir_name"
    fi

    # Check if .envrc already exists
    if [ -f .envrc ]; then
        echo "Error: .envrc already exists" >&2
        return 1
    fi

    # Create venv using uv
    if ! uv venv --python-preference=system --seed --prompt "${uv_args[@]}" "$venv_name"; then
        echo "Error: Failed to create venv" >&2
        return 1
    fi

    # Setup direnv
    echo "layout python" > .envrc
    direnv allow

    # Register project
    echo "${venv_name} = ${PWD}" >> "$PROJECTS_FILE"
}

# workon - Switch to project directory from ~/.projects
# Usage: workon <project>
workon() {
    local project_name="$1"
    local project_dir

    if [[ ! -f "$PROJECTS_FILE" ]]; then
        echo "Error: $PROJECTS_FILE not found" >&2
        return 1
    fi

    project_dir=$(grep -E "^$project_name\s*=" "$PROJECTS_FILE" | sed 's/^[^=]*=\s*//')

    if [[ -z "$project_dir" ]]; then
        echo "Error: Project '$project_name' not found in $PROJECTS_FILE" >&2
        return 1
    fi

    if [[ ! -d "$project_dir" ]]; then
        echo "Error: Directory $project_dir does not exist" >&2
        return 1
    fi

    cd "$project_dir"
}

# Legacy virtualenvwrapper support for tmux sessions
if [[ -d "$HOME/.virtualenvs" && "$VIRTUALENV" != "" ]]; then
    export WORKON_HOME=$HOME/.virtualenvs
    export VIRTUALENVWRAPPER_PYTHON=$HOME/.local/pipx/venvs/virtualenvwrapper/bin/python
    source virtualenvwrapper_lazy.sh
    . "$WORKON_HOME/$VIRTUALENV/bin/activate"
fi

# ========================================
# Completion Functions
# ========================================

# Completion for workon
_complete_workon() {
    projects=(${(f)"$(cat $PROJECTS_FILE | cut -f -1 -d ' ')"})
    _arguments '*:projects:($projects)'
}
compdef _complete_workon workon

# Completion for just
_just() {
    local -a recipes
    if [[ -f justfile ]]; then
        recipes=(${(z)$(just --summary 2>/dev/null)})
        _describe 'recipe' recipes
    fi
}
compdef _just just

# Setup autocompletion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
# NOTE: ZSH_COMPDUMP will be reassigned below to a separate compdump folder.

# ========================================
# Prompt
# ========================================

eval "$(starship init zsh)"

# ========================================
# # tmpvenv command for throwaway venvs
# ========================================

# Usage: tmpvenv [-p 3.12] [requests]
tmpvenv() {
  emulate -L zsh
  set -u

  # Parse: optional -p/--python VERSION ; then optional packages
  local py=""
  local -a pkgs=()
  while (( $# )); do
    case "$1" in
      -p|--python) py=$2; shift 2 ;;
      --) shift; break ;;  # stop option parsing
      *) pkgs+=("$1"); shift ;;
    esac
  done

  command -v uv >/dev/null || { print -ru2 "uv not found"; return 127; }

  # Create a unique temp dir
  local dir
  dir=$(mktemp -d -t tmpvenv.XXXXXXXX) || { print -ru2 "mktemp failed"; return 1; }

  # Create the venv with uv
  local -a venv_args=(--seed)
  [[ -n $py ]] && venv_args+=(--python "$py")
  venv_args+=("$dir")
  uv venv --quiet "${venv_args[@]}" || { rmdir "$dir"; return 1; }

  # Pre-install packages *into this venv specifically*
  if (( ${#pkgs[@]} )); then
    uv pip install --python "$dir/bin/python" "${pkgs[@]}"
  fi

  # Minimal ZDOTDIR so the child shell auto-activates & aliases deactivate->exit
  local zd="$dir/_zdotdir"
  mkdir -p "$zd" || { rm -rf "$dir"; return 1; }
  cat > "$zd/.zshrc" <<'EOS'
[[ -f "$HOME/.zshrc" ]] && source "$HOME/.zshrc"  # Keep user's config
source "$TMPVENV_DIR/bin/activate"  # Activate the temp venv
alias deactivate='exit'  # 'deactivate' ends the shell so cleanup runs
print -P "Activated temp venv at:%f %F{cyan}$TMPVENV_DIR%f"
print -P "Type %F{green}deactivate%f or %F{green}exit%f to deactivate and delete it."
EOS

  # Launch child interactive zsh that reads our tiny .zshrc
  TMPVENV_DIR="$dir" ZDOTDIR="$zd" zsh -i
  local ec=$?

  # Cleanup after child shell closes
  [[ -d $dir ]] && rm -rf -- "$dir"
  return $ec
}
