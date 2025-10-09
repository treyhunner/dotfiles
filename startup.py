"""
Trey's Python startup file

This file adds keyboard shortcuts to the 3.13+ pyrepl.
It also customizes REPL syntax highlighting in 3.14+.

To use this file:

Put this in ~/.zshenv or ~/.zshrc:
export PYTHONSTARTUP=$HOME/.startup.py

Run this:
mkdir -p $HOME/.pyhacks
python -m pip install pyrepl-hacks --target=$HOME/.pyhacks
"""


def _main():
    try:
        _pyrepl_hacks()
    except ImportError:
        pass  # Python 3.12 or below or pyrepl_hacks isn't in ~/.pyhacks

    # Fun stuff, in case rich is installed
    try:
        import rich.pretty
    except ImportError:
        pass
    else:
        rich.pretty.install()


def _pyrepl_hacks():
    """Customizations powered by pyrepl-hacks."""
    from pathlib import Path
    import sys
    sys.path.append(str(Path.home() / ".pyhacks"))
    import pyrepl_hacks as repl  # Raises ImportError on 3.12 & below

    repl.bind("Alt+M", "move-to-indentation")
    repl.bind("Shift+Tab", "dedent")
    repl.bind("Alt+Down", "move-line-down")
    repl.bind("Alt+Up", "move-line-up")
    repl.bind("Shift+Home", "home")
    repl.bind("Shift+End", "end")

    repl.bind_to_insert("Ctrl+N", "[2, 1, 3, 4, 7, 11, 18, 29]")
    repl.bind_to_insert("Ctrl+F", '["apples", "oranges", "bananas", "strawberries", "pears"]')
    repl.bind_to_insert("Ctrl+W", 'with open(')
    repl.bind_to_insert("Ctrl+S", 'self.')
    repl.bind_to_insert("Ctrl+P", 'print(')
    repl.bind_to_insert("Ctrl+T", 'class ')
    repl.bind_to_insert("Ctrl+M", 'import ')

    @repl.bind(r"Ctrl+X Ctrl+R", with_event=True)
    def subprocess_run(reader, event_name, event):
        reader.insert("import subprocess\n")
        code = 'subprocess.run("", shell=True)'
        reader.insert(code)
        for _ in range(len(code) - code.index('""') - 1):
            repl.commands.left(reader, event_name, event)

    try:
        repl.update_theme(
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


# Kick it all off
_main()

# Delete the global variables we defined
del _main, _pyrepl_hacks
