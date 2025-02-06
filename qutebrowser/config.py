#———————————————————————————————————————————————————————————————————————————————
# config.py

import socket

hostname = socket.gethostname()

config.load_autoconfig(False)

config.source("src/main.py")
config.source("src/keys.py")
config.source("src/search.py")
config.source("src/themes.py")

config.source("src/priv.main.py")
config.source("src/priv.keys.py")
config.source("src/priv.search.py")

if hostname == "la-orcino":
    config.source("src/fonts.la-orcino.py")
else:
    config.source("src/fonts.la-vulpo.py")
