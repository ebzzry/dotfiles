#---------------------------------------------------------------------------------------------------
# Ĝeneralaj
#---------------------------------------------------------------------------------------------------

c.url.default_page = "~/.config/qutebrowser/index.html"
c.content.pdfjs = True
c.downloads.location.prompt = True
c.auto_save.session = True
c.scrolling.smooth = True
c.completion.height = "20%"
c.completion.cmd_history_max_items = -1
c.content.autoplay = False
c.tabs.background = True
c.tabs.new_position.unrelated = "next"
c.tabs.title.format = "{index}: {current_title}"
c.tabs.position = "top"
c.tabs.select_on_remove = "next"
c.content.desktop_capture = False
c.content.geolocation = False
c.content.mouse_lock = False
c.content.persistent_storage = False
c.content.register_protocol_handler = False
c.content.ssl_strict = True
c.completion.open_categories = ["history", "quickmarks", "bookmarks", "searchengines"]
c.zoom.default = "100%"
c.zoom.levels = ["25%", "33%", "50%", "60%", "70%", "80%", "90%", "100%", "110%", "125%", "150%", "175%", "200%", "250%", "300%", "400%", "500%"]

with config.pattern('http://gigamonkeys.com/book/') as p:
    p.content.images = False
