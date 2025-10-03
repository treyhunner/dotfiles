# Trey Hunner's dotfiles

These are my configuration files for setting up Ubuntu development environments.

This repository contains shell configurations (zsh), editor settings (Neovim), terminal multiplexer config (tmux), custom utility scripts, and automated system setup.

## Highlights

**Core configurations:**
- **Shell**: zsh with custom Python virtual environment management (uv + direnv + workon)
- **Editor**: Neovim with ALE linting (ruff/flake8/black), vim-plug, CtrlP fuzzy finder, and "teaching mode" toggle
- **Terminal**: tmux with custom prefix (C-a) and session management via [tmuxstart](https://github.com/treyhunner/tmuxstart)
- **Git**: Enhanced with hub wrapper for GitHub integration

**Custom scripts** (in `bin/`):
- **,caption** - Generate VTT captions from videos using OpenAI Whisper
- **,md_urls** - Find missing markdown link anchors across files
- **,todo** - Scan markdown/RST files for TODO comments
- Python scripts use `uv run --script` with PEP 723 inline dependencies (see [lazy self-installing Python scripts](https://treyhunner.com/2024/12/lazy-self-installing-python-scripts-with-uv/))

I use a `,` prefix for most of my custom scripts so I can type `,` and hit `<TAB>` to see a list of them (I often forget the names of my scripts).

**Python workflow:**
- Create environments: `venv [name]` (uses uv, sets up direnv, registers in ~/.projects)
- Switch projects: `workon <project>` (cd to project directory)
- Auto-activation via direnv when entering project directories
- Version management with pyenv for now, though I'm starting to migrate to uv for this
- Enhanced REPL: `startup.py` customizes the Python REPL with [keyboard shortcuts](https://treyhunner.com/2024/10/adding-keyboard-shortcuts-to-the-python-repl/) and [a custom color scheme](https://treyhunner.com/2025/09/customizing-your-python-repl-color-scheme/)

Read more: [Switching from virtualenvwrapper to direnv, Starship, and uv](https://treyhunner.com/2024/10/switching-from-virtualenvwrapper-to-direnv-starship-and-uv/)

## Installation

**Prerequisites:** Ubuntu with sudo access.
The `additional_install` script installs packages and dependencies system-wide.

Clone to a permanent location and run install scripts to create symlinks and install dependencies:

```bash
git clone git://github.com/treyhunner/dotfiles.git ~/.dotfiles
cd ~/.dotfiles/
./scripts/install                    # Symlink dotfiles to $HOME
./scripts/additional_install         # Install packages and dependencies
./scripts/symlink                    # Dependent upon Dropbox directory
./scripts/restore /path/to/backup    # Optional: restore from backup
```

## Toolchain

The `additional_install` script installs:
- **CLI tools**: uv (Python), direnv (env activation), starship (prompt), just (command runner), fnm (Node manager), hub (GitHub wrapper)
- **Development**: git, tmux, zsh, nodejs, docker, pyenv, pipx
- **System utilities**: xclip, ag (silversearcher), ffmpeg
- And more

See `scripts/additional_install` for the complete list

## Workflows

### Making changes to dotfiles
1. Edit files directly in `~/.dotfiles/`
2. Changes take effect immediately (configs are symlinked)
3. For shell changes: open new terminal or `source ~/.zshrc`
4. For vim changes: restart nvim or `:source ~/.config/nvim/init.vim`

**Common edit locations:**
- Shell aliases/functions → `zshrc`
- Vim keybindings/plugins → `config/nvim/init.vim`
- Tmux keybindings → `tmux.conf`
- PATH modifications → `profile` or `zshrc`

### Creating custom scripts
1. Place in `bin/` with comma prefix (e.g., `,mycommand`)
2. For Python scripts: use `#!/usr/bin/env -S uv run --quiet --script` with PEP 723 metadata
3. Make executable: `chmod +x bin/,mycommand`
4. See `,todo`, `,caption`, `,md_urls` for examples


## Copying

To the extent possible under law, the author has dedicated all copyright and related and neighboring rights to this software to the public domain worldwide.
This software is distributed without any warranty.

You should have received a copy of the CC0 Public Domain Dedication along with this software.
If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
