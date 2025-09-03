#———————————————————————————————————————————————————————————————————————————————
# +main.keys

import os

home=os.environ['HOME']

#———————————————————————————————————————————————————————————————————————————————
# unbind

config.unbind("<Escape>", mode='insert')
config.unbind("[[")
config.unbind("]]")
config.unbind("q")
config.unbind("ad")
config.unbind("@")
config.unbind("co")
config.unbind("d")
config.unbind("D")

#———————————————————————————————————————————————————————————————————————————————
# main

config.bind("!", 'config-source')
config.bind("K", 'tab-prev')
config.bind("J", 'tab-next')
config.bind("a", 'open -t')
config.bind("A", 'open -p')
config.bind("X", 'tab-close -p')
config.bind("x", 'tab-close -n')
config.bind("s", 'cmd-set-text -s :tab-select')

config.bind("I", 'mode-enter passthrough')

config.bind("[", 'tab-prev')
config.bind("]", 'tab-next')
config.bind("{", 'tab-move -')
config.bind("}", 'tab-move +')

#———————————————————————————————————————————————————————————————————————————————
# Escape

config.bind("<Shift-Escape>", 'mode-leave', mode='insert')
config.bind("<Shift-Escape>", 'mode-leave', mode='hint')
config.bind("<Shift-Escape>", 'mode-leave', mode='caret')
config.bind("<Shift-Escape>", 'mode-leave', mode='register')
config.bind("<Shift-Escape>", 'mode-leave', mode='passthrough')

config.bind("<Escape>", 'mode-leave', mode='insert')
config.bind("<Escape>", 'mode-leave', mode='hint')
config.bind("<Escape>", 'mode-leave', mode='caret')
config.bind("<Escape>", 'mode-leave', mode='register')
# config.bind("<Escape>", 'mode-leave', mode='passthrough')

#———————————————————————————————————————————————————————————————————————————————
# Command

config.bind("<Meta+a>", 'open -t')
config.bind("<Meta+Shift+x>", 'tab-close -p')
config.bind("<Meta+x>", 'tab-close -n')

config.bind("<Meta+[>", 'tab-prev', mode='insert')
config.bind("<Meta+]>", 'tab-next', mode='insert')
config.bind("<Meta+[>", 'tab-prev', mode='normal')
config.bind("<Meta+]>", 'tab-next', mode='normal')

config.bind("<Meta+Shift+[>", 'tab-move -', mode='insert')
config.bind("<Meta+Shift+]>", 'tab-move +', mode='insert')
config.bind("<Meta+Shift+[>", 'tab-move -', mode='normal')
config.bind("<Meta+Shift+]>", 'tab-move +', mode='normal')

config.bind("<Meta+1>", 'tab-focus 1', mode='insert')
config.bind("<Meta+2>", 'tab-focus 2', mode='insert')
config.bind("<Meta+3>", 'tab-focus 3', mode='insert')
config.bind("<Meta+4>", 'tab-focus 4', mode='insert')
config.bind("<Meta+5>", 'tab-focus 5', mode='insert')
config.bind("<Meta+6>", 'tab-focus 6', mode='insert')
config.bind("<Meta+7>", 'tab-focus 7', mode='insert')
config.bind("<Meta+8>", 'tab-focus 8', mode='insert')
config.bind("<Meta+9>", 'tab-focus 9', mode='insert')
config.bind("<Meta+0>", 'tab-focus -1', mode='insert')

config.bind("g1", 'tab-focus 1', mode='normal')
config.bind("g2", 'tab-focus 2', mode='normal')
config.bind("g3", 'tab-focus 3', mode='normal')
config.bind("g4", 'tab-focus 4', mode='normal')
config.bind("g5", 'tab-focus 5', mode='normal')
config.bind("g6", 'tab-focus 6', mode='normal')
config.bind("g7", 'tab-focus 7', mode='normal')
config.bind("g8", 'tab-focus 8', mode='normal')
config.bind("g9", 'tab-focus 9', mode='normal')
config.bind("g0", 'tab-focus -1', mode='normal')

config.bind("<Meta+1>", 'tab-focus 1', mode='normal')
config.bind("<Meta+2>", 'tab-focus 2', mode='normal')
config.bind("<Meta+3>", 'tab-focus 3', mode='normal')
config.bind("<Meta+4>", 'tab-focus 4', mode='normal')
config.bind("<Meta+5>", 'tab-focus 5', mode='normal')
config.bind("<Meta+6>", 'tab-focus 6', mode='normal')
config.bind("<Meta+7>", 'tab-focus 7', mode='normal')
config.bind("<Meta+8>", 'tab-focus 8', mode='normal')
config.bind("<Meta+9>", 'tab-focus 9', mode='normal')
config.bind("<Meta+0>", 'tab-focus -1', mode='normal')

#———————————————————————————————————————————————————————————————————————————————
# t

config.bind('td', 'config-cycle colors.webpage.darkmode.enabled true false')
config.bind('tj', 'config-cycle -p -t -u *://{url:host}/* content.javascript.enabled ;; reload')
config.bind('tc', 'config-cycle content.user_stylesheets "~/.doom.d/org.css" "~/etc/qutebrowser/css/simple.min.css" ""')

#———————————————————————————————————————————————————————————————————————————————
# ,

config.bind(',M', 'spawn mpv {url}')
config.bind(',m', 'hint links spawn mpv {hint-url}')
config.bind(',I', 'spawn iina {url}')
config.bind(',i', 'hint links spawn iina {hint-url}')
config.bind(',S', 'spawn open -a safari {url}')
config.bind(',s', 'hint links spawn open -a safari {hint-url}')
config.bind(',O', 'spawn org {url}')
config.bind(',o', 'hint links spawn org {url}')
