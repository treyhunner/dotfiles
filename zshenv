# ~/.zshenv - sourced for ALL zsh shells (interactive and non-interactive)
# Keep this minimal - only cheap, unconditional exports

# Basic PATH additions for scripts
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/.dotfiles/bin" ] ; then
    PATH="$HOME/.dotfiles/bin:$PATH"
fi

# Essential environment variables
export EDITOR=vim
export LC_TIME="C"  # Use 24 hour time
export PYTHONSTARTUP=$HOME/.startup.py
