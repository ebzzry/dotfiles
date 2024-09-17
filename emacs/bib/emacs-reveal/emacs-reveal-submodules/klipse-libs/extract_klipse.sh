#!/bin/sh
# SPDX-FileCopyrightText: 2019-2021 Jens Lechtenbörger
# SPDX-License-Identifier: CC0-1.0

if test -d klipse ;
then
    cd klipse; git pull; cd ..
else
    git clone https://github.com/viebel/klipse.git
fi

cp -rp klipse/dist/* klipse-dist
cp -p klipse/LICENSE.txt klipse-dist/LICENSE.klipse
cp -p skulpt-dist.license klipse-dist/LICENSE.skulpt
cp -p codemirror.license klipse-dist/LICENSE.codemirror

# Work around https://github.com/viebel/klipse/issues/397
if test -f klipse/docs/repo/js/skulpt.0.10.0.min.js ;
then
    cp klipse/docs/repo/js/skulpt.0.10.0.min.js klipse-dist
    cp klipse/docs/repo/js/skulpt-stdlib.0.10.0.js klipse-dist
fi
