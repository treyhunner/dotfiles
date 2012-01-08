# Trey Hunner's dotfiles

These are my configuration files.  I use these files when configuring my
account on a new system.

## Installation

These files can be installed with [GNU make][].  For example, to install my
screen configuration file use:

    make screen

To install all configuration files use:

    make

The default command used to install configuration files is `cp -r -n`.  This
command copies files recursively and does not overwtrite existing files.  To
change the command used to install configuration files pass `CMD` and/or `ARGS`
parameters to `make`.  For example, this will install install the screen
configuration file and overwrite existing files:

    make ARGS=-r screen

[GNU make]: http://www.gnu.org/software/make/
