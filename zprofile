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
if "$HOME/.pyenv/bin/pyenv" --version &> /dev/null ; then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
fi

# Set virtualenvwrapper settings
if pyenv virtualenvwrapper --version &> /dev/null ; then
    export WORKON_HOME=$HOME/.virtualenvs
    export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
    export VIRTUALENVWRAPPER_PYTHON=$(which python2.7)
    pyenv virtualenvwrapper_lazy
    export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
fi


alias mkvenv3="mkvirtualenv -a $PWD --python=$(which python3)"
alias mkvenv2="mkvirtualenv -a $PWD --python=$(which python2)"
