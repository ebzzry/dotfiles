#!/bin/sh
# SPDX-FileCopyrightText: 2021 Jens Lechtenbörger
# SPDX-License-Identifier: CC0-1.0

VERSION="5.63.1"
LIBS="htmlmixed javascript python xml"

for lib in $LIBS; do
    curl -o codemirror/${lib}/${lib}.min.js -L https://cdnjs.cloudflare.com/ajax/libs/codemirror/${VERSION}/mode/${lib}/${lib}.min.js
done
