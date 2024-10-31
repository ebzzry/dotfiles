# klavkombinoj

config.unbind("<Escape>", mode='insert')
config.unbind("q")
config.unbind("ad")
config.unbind("[[")
config.unbind("]]")
config.unbind("@")
config.unbind("co")

# config.unbind("J")
# config.unbind("K")
config.bind("K", 'tab-prev')
config.bind("J", 'tab-next')

config.bind("!", 'config-source')
config.bind("a", 'open -t')
config.bind("A", 'open -p')
config.bind("D", 'close')

config.bind("Cmd-t", 'open -p')

config.bind("[", 'tab-prev')
config.bind("]", 'tab-next')
config.bind("{", 'tab-move -')
config.bind("}", 'tab-move +')

# config.bind("<Shift-Escape>", 'mode-leave', mode='insert')
# config.bind("<Shift-Escape>", 'mode-leave', mode='hint')
# config.bind("<Shift-Escape>", 'mode-leave', mode='passthrough')
# config.bind("<Shift-Escape>", 'mode-leave', mode='caret')
# config.bind("<Shift-Escape>", 'mode-leave', mode='register')

config.bind("<Escape>", 'mode-leave', mode='insert')
config.bind("<Escape>", 'mode-leave', mode='hint')
config.bind("<Escape>", 'mode-leave', mode='passthrough')
config.bind("<Escape>", 'mode-leave', mode='caret')
config.bind("<Escape>", 'mode-leave', mode='register')

config.bind(';m', 'hint links spawn mpv {hint-url}')
config.bind(';x', 'hint links spawn /opt/homebrew/bin/firefox {hint-url}')
