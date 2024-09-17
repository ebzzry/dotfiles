# SPDX-FileCopyrightText: 2020,2021 Jens Lechtenbörger
# SPDX-License-Identifier: CC0-1.0

DIR := ${CURDIR}

BUILDHTML := emacs --batch --load elisp/publish.el
GITTAG    := $(shell git describe --tags)
TARFILE   := emacs-reveal.tar.gz
TAROPTS   := --exclude-vcs --exclude=emacs-reveal.tar* --exclude=./tests -cvzf
TESTDIR   := $(DIR)/tests

ROBOT_FRAMEWORK    := ppodgorsek/robot-framework:latest
ROBOT_HTML_DIR     := $(TESTDIR)/public
ROBOT_REPORTS_DIR  := $(TESTDIR)/reports
ROBOT_TESTS_DIR    := $(TESTDIR)/robotframework

DEBIAN_VERSION := 10.10
DEBIAN_IMG     := registry.gitlab.com/oer/emacs-reveal/debian-emacs-tex:$(DEBIAN_VERSION)
DOCKER_LATEST  := registry.gitlab.com/oer/emacs-reveal/emacs-reveal:latest

.PHONY: all archive docker html init init-master robot-test setup tar

all: html archive

init:
	git submodule sync --recursive
	git submodule update --init --recursive

init-master:
	git checkout master
	git pull
	git submodule sync --recursive
	git submodule update --init --recursive

setup: init
	cd org-mode && make clean && make autoloads && cd $(DIR)

html: setup
	rm -rf ~/.org-timestamps
	cd $(TESTDIR) && $(BUILDHTML) && cd $(DIR)

tar:
	tar $(TAROPTS) docker/$(TARFILE) .

archive: setup tar

docker: archive
	docker build -t emacs-reveal:$(GITTAG) -f docker/emacs-reveal/Dockerfile docker

docker-dev: tar
	docker build -t emacs-reveal:$(GITTAG) -f docker/emacs-reveal/Dockerfile docker

docker-latest:
	docker build -t $(DOCKER_LATEST) -f docker/emacs-reveal/Dockerfile docker
	echo "Login and push manually, if necessary."

debian-emacs-tex:
	docker build -t $(DEBIAN_IMG) -f docker/debian-emacs-tex/Dockerfile docker
	echo "Login and push manually, if necessary."

# E.g.: BROWSER=firefox PRESENTATION=test.html?default-navigation make robot-test
robot-test:
	docker run -v $(ROBOT_REPORTS_DIR):/opt/robotframework/reports:Z -v $(ROBOT_TESTS_DIR):/opt/robotframework/tests:Z -v $(ROBOT_HTML_DIR):/robot/public -e BROWSER=${BROWSER} -e PRESENTATION=${PRESENTATION} $(ROBOT_FRAMEWORK)
