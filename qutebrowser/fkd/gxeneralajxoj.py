#———————————————————————————————————————————————————————————————————————————————
# ĝeneralaĵoj

import socket

hostname = socket.gethostname()

c.content.pdfjs = True
c.downloads.location.prompt = True
c.auto_save.session = True
c.completion.height = "20%"
c.completion.cmd_history_max_items = -1
c.content.autoplay = False
c.tabs.background = True
c.tabs.new_position.unrelated = "next"
c.tabs.title.format = "{index}: {current_title}"
c.tabs.position = "top"
c.tabs.padding = {"bottom": 2, "left": 5, "right": 5, "top": 2}
c.tabs.select_on_remove = "next"
c.content.desktop_capture = False
c.content.geolocation = False
c.content.mouse_lock = False
c.content.persistent_storage = False
c.content.register_protocol_handler = False
c.content.tls.certificate_errors = "ask"
c.completion.open_categories = ["history", "quickmarks", "bookmarks", "searchengines"]
c.hints.chars = "aoeuidhtns"

c.window.hide_decoration = True

c.zoom.levels = ["25%", "33%", "50%", "60%", "70%", "80%", "90%", "100%",
                 "110%", "125%", "150%", "175%", "200%", "250%", "300%",
                 "400%", "500%"]

if hostname == "la-vulpo":
    c.zoom.default = "120%"
else:
    c.zoom.default = "100%"

