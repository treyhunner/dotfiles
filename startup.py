try:
    from _pyrepl.simple_interact import _get_reader
    from _pyrepl.commands import Command
except ImportError:
    # Helper for Python 3.12 and below
    def _p():
        """Read a block of code from user input and run it."""
        import platform, sys, textwrap
        on_windows = platform.system() == "Windows"
        eof = "Ctrl-Z Enter" if on_windows else "Ctrl-D"
        print(f"Paste your code block and then press {eof}\n")
        exec(textwrap.dedent(sys.stdin.read()), globals())
else:
    # Hack the new Python 3.13 REPL!
    from textwrap import dedent
    reader = _get_reader()
    cmds = [
        ("self.", r"\C-s", "_self"),        # Ctrl-S inserts "self."
        ("with open(", r"\C-w", "_with"),   # Ctrl-W inserts "with open("
        ("import ", r"\C-i", "_import"),    # Ctrl-I inserts "import "
        ("print(", r"\C-p", "_print"),      # Ctrl-P inserts "print("
    ]
    for text, key, name in cmds:
        exec(dedent(f"""
            class _cmds:
                class {name}(Command):
                    def do(self): self.reader.insert({text!r})
                reader.commands[{name!r}] = {name}
                reader.bind({key!r}, {name!r})
        """))
    # Clean up all the new variables
    del _get_reader, Command, dedent, reader, cmds, text, key, name, _cmds


# Fun stuff, in case rich is installed
try:
    import rich.pretty
except ImportError:
    pass
else:
    rich.pretty.install()
    del rich
