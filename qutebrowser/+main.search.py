#———————————————————————————————————————————————————————————————————————————————
# +main.search

## duckduckgo
c.url.searchengines["DEFAULT"] = "https://duck.com/?q={}&t=h_&ia=web"
c.url.searchengines["di"] = "https://duck.com/?q={}&t=h_&iax=images&ia=images"

## guglo
c.url.searchengines["g"] = "https://www.google.com/search?q={}"
c.url.searchengines["gi"] = "https://www.google.com/search?q={}&tbm=isch"
c.url.searchengines["gb"] = "https://www.google.com/search?tbm=bks&q={}"
c.url.searchengines["y"] = "https://www.youtube.com/results?search_query={}"

## vikipedio
c.url.searchengines["vp"] = "https://eo.wikipedia.org/w/index.php?search={}&title=Special%3ASearch&go=Go"
c.url.searchengines["vv"] = "https://eo.wiktionary.org/w/index.php?search={}&title=Special%3ASearch&go=Go"
c.url.searchengines["wp"] = "https://en.wikipedia.org/w/index.php?search={}&title=Special%3ASearch&go=Go"
c.url.searchengines["swp"] = "https://simple.wikipedia.org/wiki/Special:Search?search={}&go=Search"
c.url.searchengines["wt"] = "https://en.wiktionary.org/w/index.php?search={}&title=Special%3ASearch&go=Go"
c.url.searchengines["wq"] = "https://en.wikiquote.org/w/index.php?search={}&title=Special%3ASearch&go=Go"

## tradukado
c.url.searchengines["beo"] = "http://glosbe.com/en/eo/{}"
c.url.searchengines["ben"] = "http://glosbe.com/eo/en/{}"
c.url.searchengines["geo"] = "https://translate.google.com/#view=home&op=translate&sl=en&tl=eo&text={}"
c.url.searchengines["gen"] = "https://translate.google.com/#view=home&op=translate&sl=eo&tl=en&text={}"

## vortaroj
c.url.searchengines["v"] = "http://vortaro.net/#{}"
c.url.searchengines["tv"] = "http://tujavortaro.net/index.html?lingvo=en&vorto={}"
c.url.searchengines["s"] = "http://bonalingvo.net/index.php/Ssv:_{}"
c.url.searchengines["sv"] = "http://www.simplavortaro.org/ser%C4%89o?s={}"
c.url.searchengines["k"] = "https://komputeko.net/index_eo.php?vorto={}"
c.url.searchengines["pmeg"] = "https://google.com/search?q=site:bertilow.com+{}"
c.url.searchengines["ade"] = "http://www.akademio-de-esperanto.org/akademia_vortaro/index.html?serchas=1&ajakso=0&hazardo=&tt=1549362782&ve={}&vg=-&vr=jes&vp=jes&vs=jes&vm=jes&vl=jes&vf=jes&vk=jes#avtitolo"

## ludado
c.url.searchengines["sp"] = "https://store.steampowered.com/search/?term={}"
c.url.searchengines["sc"] = "https://steamcommunity.com/search/users/#text={}"

## komputado
c.url.searchengines["clhs"] = "https://www.xach.com/clhs?q={}"
c.url.searchengines["l1sp"] = "http://l1sp.org/search?q={}"
c.url.searchengines["h"] = "https://www.haskell.org/hoogle/?hoogle={}"
c.url.searchengines["hw"] = "https://wiki.haskell.org/index.php?search={}&title=Special%3ASearch&go=Go"
c.url.searchengines["rkt"] = "http://docs.racket-lang.org/search/index.html?q={}"

## libroj
c.url.searchengines["pg"] = "http://www.gutenberg.org/ebooks/search/?query={}"
c.url.searchengines["archive"] = "https://archive.org/search.php?query={}"
c.url.searchengines["arxiv"] = "https://arxiv.org/search/?query={}&searchtype=all&source=header"
c.url.searchengines["scholar"] = "https://scholar.google.com.ph/scholar?hl=en&as_sdt=0%2C5&q={}&btnG="

## demandoj
c.url.searchengines["q"] = "https://www.quora.com/search?q={}"
c.url.searchengines["se"] = "https://stackexchange.com/search?q={}"

## aliaj
c.url.searchengines["ep"] = "https://emojipedia.org/search/?q={}"
c.url.searchengines["u"] = "https://unicode-search.net/unicode-namesearch.pl?term={}&.submit=Search"
c.url.searchengines["ud"] = "https://www.urbandictionary.com/define.php?term={}"
c.url.searchengines["melpa"] = "https://melpa.org/#/?q={}"
c.url.searchengines["iframely"] = "http://iframely.com/debug?uri={}"
c.url.searchengines["wh"] = "https://wallhaven.cc/search?q={}"
c.url.searchengines["r"] = "https://reddit.com/r/{}/new"
c.url.searchengines["wn"] = "http://wordnetweb.princeton.edu/perl/webwn?s={}&sub=Search+WordNet&o2=&o0=1&o8=1&o1=1&o7=&o5=&o9=&o6=&o3=&o4=&h="
c.url.searchengines["cliki"] = "https://cliki.net/site/search?query={}"
c.url.searchengines["ew"] = "https://google.com/search?q=site:emacswiki.org+{}"
c.url.searchengines["vg"] = "https://app.vagrantup.com/boxes/search?utf8=%E2%9C%93&sort=downloads&provider=&q={}"
c.url.searchengines["rt"] = "https://www.rottentomatoes.com/search?search={}"
c.url.searchengines["af"] = "https://www.acronymfinder.com/~/search/af.aspx?Acronym={}&string=exact"
c.url.searchengines["th"] = "https://www.thesaurus.com/browse/{}"
c.url.searchengines["fa"] = "https://fontawesome.com/icons?d=gallery&p=2&q={}"
c.url.searchengines["dh"] = "https://hub.docker.com/search?q={}&type=image"
c.url.searchengines["gh"] = "https://github.com/search?q={}"
c.url.searchengines["z"] = "https://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords={}"
c.url.searchengines["rc"] = "http://rosettacode.org/mw/index.php?title=Special%3ASearch&search={}&go=Go"

## loĵbano
c.url.searchengines["s"] = "https://sisku.org/?en#{}"
c.url.searchengines["S"] = "https://la-lojban.github.io/sutysisku/lojban/index.html#seskari=cnano&sisku={}&bangu=en&versio=masno"
c.url.searchengines["j"] = "https://jboski.lojban.org/?text={}"
c.url.searchengines["J"] = "https://jbovlaste.lojban.org/lookup?Form=lookup.pl1&Strategy=*&Database=en%3C-%3Ejbo&Query={}&submit=Search"

## ebzzry
c.url.searchengines["dotfiles"] = "https://github.com/ebzzry/dotfiles/tree/main/{}"
