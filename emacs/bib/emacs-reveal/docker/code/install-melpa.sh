#!/bin/sh
# SPDX-FileCopyrightText: 2019,2021 Jens Lechtenbörger
# SPDX-License-Identifier: CC0-1.0

if test -z "$1"
then
    echo "Supply name of MELPA package as argument!"
    echo "If optional second argument is \"stable\", install from MELPA stable."
    exit 1
fi

if [ "$2" = "stable" ];
then
    emacs --batch --load /tmp/manage-packages.el \
          --eval="(mp-install-stable-pkgs '($1) \"/tmp/archives\")"
else
    emacs --batch --load /tmp/manage-packages.el \
          --eval="(mp-install-pkgs '($1) \"/tmp/archives\")"
fi
