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

all: zsh

zsh:
	@echo Copying zsh config
	$(CPCMD) $(PWD)/zshrc $(DEST)/.zshrc
