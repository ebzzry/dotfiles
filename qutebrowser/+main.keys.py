#———————————————————————————————————————————————————————————————————————————————
# +main.keys

config.unbind("<Escape>", mode='insert')

config.unbind("q")
config.unbind("ad")
config.unbind("[[")
config.unbind("]]")
config.unbind("@")
config.unbind("co")
config.unbind("d")
config.unbind("D")
config.unbind("s")

config.bind("!", 'config-source')

config.bind("K", 'tab-prev')
config.bind("J", 'tab-next')

config.bind("a", 'open -t')
config.bind("A", 'open -p')

config.bind("X", 'tab-close -p')
config.bind("x", 'tab-close -n')

config.bind("s", 'cmd-set-text -s :tab-select')

config.bind("[", 'tab-prev')
config.bind("]", 'tab-next')
config.bind("{", 'tab-move -')
config.bind("}", 'tab-move +')

config.bind("<Shift-Escape>", 'mode-leave', mode='insert')
config.bind("<Shift-Escape>", 'mode-leave', mode='hint')
config.bind("<Shift-Escape>", 'mode-leave', mode='passthrough')
config.bind("<Shift-Escape>", 'mode-leave', mode='caret')
config.bind("<Shift-Escape>", 'mode-leave', mode='register')

config.bind("<Escape>", 'mode-leave', mode='insert')
config.bind("<Escape>", 'mode-leave', mode='hint')
config.bind("<Escape>", 'mode-leave', mode='passthrough')
config.bind("<Escape>", 'mode-leave', mode='caret')
config.bind("<Escape>", 'mode-leave', mode='register')

config.bind('td', 'config-cycle colors.webpage.darkmode.enabled true false')

config.bind(';m', 'hint links spawn mpv {hint-url}')
config.bind(';M', 'spawn mpv {url}')
config.bind(';f', 'hint links spawn open -a firefox {hint-url}')
config.bind(';F', 'spawn open -a firefox {url}')

config.unbind('gC')
config.bind('gc', 'tab-clone')
