# AGENTS.md

For AI coding agents working in this dotfiles repository.

## Context

- Personal dotfiles for Ubuntu development environment (zsh, Neovim, tmux, Python tooling)
- Uses symlinks from `~/.dotfiles/` to `$HOME` for all configs
- Assumes Ubuntu with sudo access

## Key Paths

- **Shell**: `zshrc`, `profile`, `zprofile` - zsh primary shell
- **Editor**: `config/nvim/init.vim` - Neovim config with vim-plug, ALE linting
- **Tmux**: `tmux.conf` - Uses C-a prefix (not C-b), TPM plugins
- **Git**: `gitconfig`, `gitignore`
- **Python**: `startup.py` - PYTHONSTARTUP file for interactive sessions
- **Scripts**: `bin/` - Custom utilities (comma-prefixed for personal tools)

## Automation

- `./scripts/install` - Creates symlinks from this repo to `$HOME`
- `./scripts/additional_install` - Installs system packages and CLI tools (uv, direnv, starship, just, fnm, hub, pyenv, docker, etc.)
- `bin/` scripts use `#!/usr/bin/env -S uv run --quiet --script` with PEP 723 inline dependencies
- Key tools: **uv** (Python pkg mgr), **direnv** (env activation), **starship** (prompt), **just** (command runner), **fnm** (Node mgr)

## Python Workflow

- **Create venv**: `venv [name]` - Uses uv, creates `.envrc`, registers in `~/.projects`
- **Switch project**: `workon <project>` - cd to directory from `~/.projects` mapping
- **Auto-activation**: direnv triggers on cd to directories with `.envrc`
- **Version mgmt**: pyenv controls Python versions, default in `pyenv/version`
- **Virtual envs**: Located in project dirs (not centralized), activated via direnv
- See `zshrc:61-145` for `venv` and `workon` function implementations

## Editor & Tmux

**Neovim** (`config/nvim/init.vim`):
- Leader: SPACE, Local leader: \
- Save: ENTER, Clear search: SPACE-SPACE
- Toggle teaching mode: Shift-H (disables linting, spellcheck, status line)
- Plugins: ALE (ruff/flake8/black), CtrlP (fuzzy find with ag), vim-fugitive, vim-gitgutter, vim-surround
- Python host: `~/.virtualenvs/neovim/bin/python`

**Tmux** (`tmux.conf`):
- Prefix: C-a (not default C-b)
- Session mgmt: `tmuxstart` command for creating/attaching sessions
- Window/pane indexing starts at 1

## Edit/Test Playbooks

**Test config changes:**
- Shell: Open new terminal or `source ~/.zshrc`
- Neovim: Restart nvim or `:source ~/.config/nvim/init.vim`
- Tmux: `tmux source ~/.tmux.conf` or restart session

**Edit common settings:**
- Shell aliases/functions → `zshrc`
- Vim keybindings/plugins → `config/nvim/init.vim`
- Tmux keybindings → `tmux.conf`
- PATH → `profile` (POSIX) or `zshrc` (zsh-specific)

**Create custom script:**
- Place in `bin/,scriptname` (comma prefix convention)
- Use `#!/usr/bin/env -S uv run --quiet --script` for Python
- Add PEP 723 metadata block for dependencies
- Make executable: `chmod +x`
- Examples: `bin/,todo`, `bin/,caption`, `bin/,md_urls`
