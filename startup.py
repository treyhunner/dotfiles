import sys
if sys.prefix != sys.base_prefix:  # In virtual environment
    type(exit).__repr__ = exit  # Both "exit()" and "exit" exit
del sys


def _p():
    """Read a block of code from user input and run it."""
    import sys
    import textwrap
    exec(textwrap.dedent(sys.stdin.read()), globals())

try:
    import rich.pretty
except ImportError:
    pass
else:
    rich.pretty.install()
    del rich
