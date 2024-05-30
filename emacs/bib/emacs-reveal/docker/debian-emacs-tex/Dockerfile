# SPDX-FileCopyrightText: 2019-2021 Jens Lechtenbörger
# SPDX-License-Identifier: CC0-1.0

FROM debian:10.10-slim
LABEL maintainer="Jens Lechtenbörger"
RUN apt-get update && apt-get --no-install-recommends install -y \
    ca-certificates \
    emacs \
    git patch make curl \
    texlive-bibtex-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-latex-recommended \
    texlive-lang-german \
    texlive-pictures \
    texlive-htmlxml \
    tex4ht \
    texinfo install-info \
    biber latexmk python-pygments
