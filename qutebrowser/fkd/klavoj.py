#---------------------------------------------------------------------------------------------------
# Klavoj
#---------------------------------------------------------------------------------------------------

config.unbind("q")
config.unbind("ad")
config.unbind("[[")
config.unbind("]]")
config.unbind("@")
config.unbind("co")

config.bind("a", 'open -t')
config.bind("[", 'navigate prev')
config.bind("]", 'navigate next')

config.bind(",t", 'open -t file:///home/pub/hejmo/dok/lingvoj/esperanto/tradukiloj/tuja-vortaro/index.html')
config.bind(",T", 'open -t https://tekstaro.com/')
config.bind(",r", 'open -t http://www.reta-vortaro.de/revo/')
config.bind(",g", 'open -t https://github.com')
config.bind(",h", 'open -t https://news.ycombinator.com')
config.bind(",d", 'open -t https://discord.com/app')
config.bind(",b", 'open -t https://bit.ly')

config.unbind("<Escape>", mode='insert')

config.bind("<Shift-Escape>", 'mode-leave', mode='insert')
config.bind("<Shift-Escape>", 'mode-leave', mode='hint')
config.bind("<Shift-Escape>", 'mode-leave', mode='passthrough')
config.bind("<Shift-Escape>", 'mode-leave', mode='caret')
config.bind("<Shift-Escape>", 'mode-leave', mode='register')
