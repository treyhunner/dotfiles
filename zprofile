# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Add local bin directory to PATH
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$PATH:$HOME/.local/bin"
    export PATH
fi

# Setup pyenv
export PYENV_ROOT="$HOME/.pyenv"
if "$PYENV_ROOT/bin/pyenv" --version &> /dev/null ; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
fi
