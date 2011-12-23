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

all: screen zsh vim

screen:
	@echo Copying screen config
	$(CPCMD) $(PWD)/screenrc $(DEST)/.screenrc

zsh:
	@echo Copying zsh config
	$(CPCMD) $(PWD)/zshrc $(DEST)/.zshrc

vim:
	@echo Copying vim config
	$(CPCMD) $(PWD)/vimrc $(DEST)/.vimrc
