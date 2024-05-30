#———————————————————————————————————————————————————————————————————————————————
# ĝeneralaĵoj

# rompita ekde 202206141455
# c.scrolling.smooth = True

c.url.default_page = "~/.qutebrowser/index.html"

with config.pattern('http://gigamonkeys.com/book/') as p:
    p.content.images = False
