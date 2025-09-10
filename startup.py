def _main():
    import sys
    import textwrap
    try:
        from _pyrepl.simple_interact import _get_reader
        from _pyrepl.commands import home, end, Command, EditCommand, MotionCommand
    except ImportError:
        # Helper for Python 3.12 and below
        def _p():
            """Read a block of code from user input and run it."""
            import platform
            on_windows = platform.system() == "Windows"
            eof = "Ctrl-Z Enter" if on_windows else "Ctrl-D"
            print(f"Paste your code block and then press {eof}\n")
            exec(textwrap.dedent(sys.stdin.read()), globals())
    else:
        # Hack the new Python 3.13 REPL!
        reader = _get_reader()
        cmds = {
            r"\C-n": "[2, 1, 3, 4, 7, 11, 18, 29]",
            r"\C-f": '["apples", "oranges", "bananas", "strawberries", "pears"]',
            r"\C-w": "with open(",
            r"\C-s": "self.",
            r"\C-p": "print(",
            r"\C-t": "class ",
            r"\C-m": "import ",
        }
        for _n, (key, text) in enumerate(cmds.items(), start=1):
            name = f"CustomCommand{_n}"
            exec(textwrap.dedent(f"""
                class _cmds:
                    class {name}(Command):
                        def do(self):
                            self.reader.insert({text!r})
                    reader.commands[{name!r}] = {name}
                    reader.bind({key!r}, {name!r})
            """), locals())

        class move_to_indentation(MotionCommand):
            """Move to the start of indentation for the current line."""
            def do(self):
                import re
                x, y = self.reader.pos2xy()
                lines = self.reader.get_unicode().splitlines(keepends=True)
                line = lines[y]
                if match := re.search(r"^\s+", line):
                    index = match.end()
                else:
                    index = 0
                self.reader.pos = self.reader.bol() + index

        # Bind Alt+M to move to the beginning of the indentation
        reader.commands["move-to-indentation"] = move_to_indentation
        reader.bind(r"\M-m", "move-to-indentation")

        class dedent_block(EditCommand):
            """Dedent the current code block."""
            def do(self):
                r = self.reader
                x, y = self.reader.pos2xy()
                original_text = r.get_unicode()
                dedented_text = textwrap.dedent(original_text)

                # Dedent buffer and invalidate cache
                r.buffer[:] = list(dedented_text)
                r.last_refresh_cache.invalidated = True
                r.dirty = True

                # Reposition cursor correctly
                original_lines = original_text.splitlines()
                dedented_lines = dedented_text.splitlines()
                removed_characters = sum(
                    len(old) - len(new)
                    for old, new in zip(original_lines[:y+1], dedented_lines)
                )
                r.pos -= removed_characters

        # Bind Shift+Tab to dedent
        reader.commands["dedent-block"] = dedent_block
        reader.bind(r"\e[Z", "dedent-block")

        reader.bind(r"\<home>", "home")
        reader.bind(r"\<end>", "end")

        # bind C+x C+r to subprocess.run
        class Run(Command):
            def do(self):
                from _pyrepl.commands import backward_kill_word, left
                backward_kill_word(self.reader, self.event_name, self.event).do()
                self.reader.insert("import subprocess\n")
                code = 'subprocess.run("", shell=True)'
                self.reader.insert(code)
                for _ in range(len(code) - code.index('""') - 1):
                    left(self.reader, self.event_name, self.event).do()
        reader.commands["subprocess_run"] = Run
        reader.bind(r"\C-x\C-r", "subprocess_run")

        # -i hack
        _special_chars = {r"\C": "Ctrl"}
        if sys.orig_argv[1:] == ["-i"]:  # Hack to overload -i to print keys
            print()
            for key, text in cmds.items():
                special, _, char = key.partition("-")
                special = _special_chars[special]
                print(f"{special}-{char.upper()}:", text)
            print()
            sys.exit(1)

    try:
        from _colorize import set_theme, default_theme, Syntax, ANSIColors
    except ImportError:
        pass  # Python 3.13 and below
    else:
        # Define Solarized Light colors
        solarized_light_theme = default_theme.copy_with(
            syntax=Syntax(
                keyword=ANSIColors.GREEN,
                builtin=ANSIColors.BLUE,
                comment=ANSIColors.INTENSE_BLUE,
                string=ANSIColors.CYAN,
                number=ANSIColors.CYAN,
                definition=ANSIColors.BLUE,
                soft_keyword=ANSIColors.BOLD_GREEN,
                op=ANSIColors.INTENSE_GREEN,
                reset=ANSIColors.RESET + ANSIColors.INTENSE_GREEN,
            ),
        )
        set_theme(solarized_light_theme)

    # Fun stuff, in case rich is installed
    try:
        import rich.pretty
    except ImportError:
        pass
    else:
        rich.pretty.install()

_main()
del _main
