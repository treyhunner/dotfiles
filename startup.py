"""
Trey's Python startup file

This file adds keyboard shortcuts to pyrepl (3.13+).
It also customizes REPL syntax highlighting (3.14+).

To use this file:

Put this in your ~/.zshenv, ~/.zshrc, ~/.bashrc, etc.:
export PYTHONSTARTUP=$HOME/.startup.py

Run this:
mkdir -p $HOME/.pyhacks
python -m pip install pyrepl-hacks --target=$HOME/.pyhacks
"""
import pathlib as _pathlib, sys as _sys
_sys.path.append(str(_pathlib.Path.home() / ".pyhacks"))

try:
    import pyrepl_hacks as _repl
except ImportError:
    pass  # We're on Python 3.12 or below
else:
    _repl.bind("Home", "home")
    _repl.bind("End", "end")
    _repl.bind("Alt+M", "move-to-indentation")
    _repl.bind("Shift+Tab", "dedent")
    _repl.bind("Alt+Down", "move-line-down")
    _repl.bind("Alt+Up", "move-line-up")
    _repl.bind_to_insert("Ctrl+N", "[2, 1, 3, 4, 7, 11, 18, 29]")
    _repl.bind_to_insert(
        "Ctrl+F",
        '["apples", "oranges", "bananas", "strawberries", "pears"]',
    )

    try:
        # Solarized Light theme to match vim
        _repl.update_theme(
            keyword="green",
            builtin="blue",
            comment="intense blue",
            string="cyan",
            number="cyan",
            definition="blue",
            soft_keyword="bold green",
            op="intense green",
            reset="reset, intense green",
        )
    except ImportError:
        pass  # We're on Python 3.13 or below

    del _repl, _pathlib, _sys  # Avoid global REPL namespace pollution
