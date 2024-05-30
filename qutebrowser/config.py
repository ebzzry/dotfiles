#———————————————————————————————————————————————————————————————————————————————
# config.py

import socket

hostname = socket.gethostname()

config.load_autoconfig(False)

config.source("fkd/gxeneralajxoj.py")
config.source("fkd/klavkombinoj.py")
config.source("fkd/sercxiloj.py")
config.source("fkd/etoso.py")

config.source("fkd/privataj-gxeneralajxoj.py")
config.source("fkd/privataj-klavkombinoj.py")
config.source("fkd/privataj-sercxiloj.py")

if hostname == "la-orcino":
    config.source("fkd/tiparoj-la-orcino.py")
else:
    config.source("fkd/tiparoj-la-vulpo.py")
