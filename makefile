SHELL := bash
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all install

DIR := $(shell basename "$(shell pwd)")

all:
	true

install:
	rm -f ~/.tmux ~/.tmux.conf
	ln -s ${PWD}/tmux/.tmux.conf ~/.tmux.conf
	ln -s ${PWD}/tmux/.tmux ~/.tmux
	rm -f ~/.zshenv ~/.zprofile
	ln -s ${PWD}/zsh/fkd/.zshenv ~/.zshenv
	ln -s ${PWD}/zsh/fkd/.zshenv ~/.zprofile
	rm -f ~/.spacemacs ~/.spacemacs.env
	ln -s ${PWD}/spacemacs/fkd/.spacemacs ~/.spacemacs
	ln -s ${PWD}/spacemacs/fkd/.spacemacs.env ~/.spacemacs.env
	rm -f ~/.sbclrc ~/.ccl-init.lisp ~/.cmucl-init.lisp ~/.mkclrc ~/.lispworks
	ln -s ${PWD}/lisp/init.lisp ~/.sbclrc
	ln -s ${PWD}/lisp/init.lisp ~/.ccl-init.lisp
	ln -s ${PWD}/lisp/init.lisp ~/.cmucl-init.lisp
	ln -s ${PWD}/lisp/init.lisp ~/.mkclrc
	ln -s ${PWD}/lisp/init.lisp ~/.lispworks
	rm -f ~/.inputrc
	ln -s ${PWD}/readline/.inputrc ~/.inputrc
	rm -f ~/.bashrc
	ln -s ${PWD}/bash/.bashrc ~/.bashrc
	rm -f ~/.vimrc
	ln -s ${PWD}/vim/.vimrc	~/.vimrc
	rm -f ~/.screenrc
	ln -s ${PWD}/screen/.screenrc ~/.screenrc
	rm -f ~/.XCompose
	ln -s ${PWD}/xcompose/.Xcompose ~/.XCompose
	rm -f ~/.lein
	ln -s ${PWD}/lein/.lein ~/.lein
