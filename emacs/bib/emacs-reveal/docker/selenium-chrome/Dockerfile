# SPDX-FileCopyrightText: 2022 Jens Lechtenbörger
# SPDX-License-Identifier: CC0-1.0

# An image for Selenium with Chrome and Python bindings

FROM selenium/standalone-chrome:4.1.4

USER root
RUN apt-get update && apt-get install python3-distutils -y
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py
RUN python3 -m pip install selenium
COPY code/selenium-print-pdf.py /root/