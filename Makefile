ifndef DEST
	DEST=${HOME}
endif

ifndef CMD
	CMD=cp
endif

ifndef ARGS
	ARGS=-r -n
endif

ifndef CPCMD
	CPCMD=$(CMD) $(ARGS)
endif

all: tmux screen zsh vim terminal git xmonad

tmux:
	@echo Copying tmux config
	$(CPCMD) $(PWD)/tmux.conf $(DEST)/.tmux.conf

screen:
	@echo Copying screen config
	$(CPCMD) $(PWD)/screenrc $(DEST)/.screenrc

zsh:
	@echo Copying zsh config
	$(CPCMD) $(PWD)/zshrc $(DEST)/.zshrc

vim:
	@echo Copying vim config
	git submodule update --init
	$(CPCMD) $(PWD)/vimrc $(DEST)/.vimrc
	$(CPCMD) $(PWD)/vim-files $(DEST)/.vim

terminal:
	@echo Copying gnome-terminal config
	$(CPCMD) $(PWD)/gnome-terminal $(DEST)/.gconf/apps/

git:
	@echo Copying gitignore config
	$(CPCMD) $(PWD)/gitignore $(DEST)/.gitignore

xmonad:
	@echo Copying xmonad config
	$(CPCMD) $(PWD)/xmonad $(DEST)/.xmonad
