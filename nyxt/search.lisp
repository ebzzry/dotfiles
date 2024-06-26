;;;; -*- mode: lisp -*-

(in-package #:nyxt-user)

;;; search engines
(defvar *my-search-engines*
  (list
   '("g" "https://www.google.com/search?q=~a" "https://www.google.com")
   '("gh" "https://github.com/search?q=~a" "https://github.com/")
   '("gp" "https://play.google.com/store/search?q=~a" "https://play.google.com/")
   '("b" "https://www.google.com/search?tbm=isch&q=~a" "https://www.google.com/search?tbm=isch")
   '("y" "https://www.youtube.com/results?search_query=~a" "https://youtube.com")
   '("vp" "https://eo.wikipedia.org/w/index.php?search=~a&title=Special%3ASearch&go=Go" "https://eo.wikipedia.org")
   '("vv" "https://eo.wiktionary.org/w/index.php?search=~a&title=Special%3ASearch&go=Go" "https://eo.wiktionary.org")
   '("wp" "https://en.wikipedia.org/w/index.php?search=~a&title=Special%3ASearch&go=Go" "https://en.wikipedia.org")
   '("swp" "https://simple.wikipedia.org/wiki/Special:Search?search=~a&go=Search" "https://simple.wikipedia.org")
   '("wt" "https://en.wiktionary.org/w/index.php?search=~a&title=Special%3ASearch&go=Go" "https://en.wiktionary.org")
   '("wq" "https://en.wikiquote.org/w/index.php?search=~a&title=Special%3ASearch&go=Go" "https://en.wikiquote.org")
   '("beo" "http://glosbe.com/en/eo/~a" "http://glosbe.com/en/eo/")
   '("ben" "http://glosbe.com/eo/en/~a" "http://glosbe.com/eo/en/")
   '("geo" "https://translate.google.com/#view=home&op=translate&sl=en&tl=eo&text=~a" "https://translate.google.com")
   '("gen" "https://translate.google.com/#view=home&op=translate&sl=eo&tl=en&text=~a" "https://translate.google.com")
   '("v" "http://vortaro.net/#~a" "http://vortaro.net")
   '("s" "http://bonalingvo.net/index.php/Ssv:_~a" "http://bonalingvo.net/index.php")
   '("sv" "http://www.simplavortaro.org/ser%C4%89o?s=~a" "http://www.simplavortaro.org")
   '("k" "https://komputeko.net/index_eo.php?vorto=~a" "https://komputeko.net")
   '("pmeg" "https://google.com/search?q=site:bertilow.com+~a" "https://bertilow.com")
   '("ade" "http://www.akademio-de-esperanto.org/akademia_vortaro/index.html?serchas=1&ajakso=0&hazardo=&tt=1549362782&ve=~a&vg=-&vr=jes&vp=jes&vs=jes&vm=jes&vl=jes&vf=jes&vk=jes#avtitolo" "http://www.akademio-de-esperanto.org")
   '("sp" "https://store.steampowered.com/search/?term=~a" "https://store.steampowered.com")
   '("sc" "https://steamcommunity.com/search/users/#text=~a" "https://steamcommunity.com/")
   '("clhs" "https://www.xach.com/clhs?q=~a" "https://www.xach.com/clhs")
   '("l1sp" "http://l1sp.org/search?q=~a" "http://l1sp.org")
   '("rkt" "http://docs.racket-lang.org/search/index.html?q=~a" "http://docs.racket-lang.org/search/index.html")
   '("pg" "http://www.gutenberg.org/ebooks/search/?query=~a" "http://www.gutenberg.org/ebooks/search")
   '("archive" "https://archive.org/search.php?query=~a" "https://archive.org")
   '("arxiv" "https://arxiv.org/search/?query=~a&searchtype=all&source=header" "https://arxiv.org")
   '("scholar" "https://scholar.google.com.ph/scholar?hl=en&as_sdt=0%2C5&q=~a&btnG=" "https://scholar.google.com.ph")
   '("q" "https://www.quora.com/search?q=~a" "https://www.quora.com")
   '("se" "https://stackexchange.com/search?q=~a" "https://stackexchange.com")
   '("ep" "https://emojipedia.org/search/?q=~a" "https://emojipedia.org")
   '("u" "https://unicode-search.net/unicode-namesearch.pl?term=~a&.submit=Search" "https://unicode-search.net")
   '("ud" "https://www.urbandictionary.com/define.php?term=~a" "https://www.urbandictionary.com")
   '("melpa" "https://melpa.org/#/?q=~a" "https://melpa.org")
   '("t" "https://www.thesaurus.com/misspelling?term=~a" "https://www.thesaurus.com")
   '("iframely" "http://iframely.com/debug?uri=~a" "http://iframely.com")
   '("wh" "https://wallhaven.cc/search?q=~a" "https://wallhaven.cc")
   '("r" "https://reddit.com/r/~a/new" "https://reddit.com")
   '("wn" "http://wordnetweb.princeton.edu/perl/webwn?s=~a&sub=Search+WordNet&o2=&o0=1&o8=1&o1=1&o7=&o5=&o9=&o6=&o3=&o4=&h=" "http://wordnetweb.princeton.edu")
   '("cliki" "https://cliki.net/site/search?query=~a" "https://cliki.net")
   '("ew" "https://google.com/search?q=site:emacswiki.org+~a" "https://emacswiki.org")
   '("vg" "https://app.vagrantup.com/boxes/search?utf8=%E2%9C%93&sort=downloads&provider=&q=~a" "https://app.vagrantup.com")
   '("laz" "https://www.lazada.com.ph/catalog/?q=~a&_keyori=ss&from=input" "https://www.lazada.com.ph")
   '("sg" "https://wiki.gbl.gg/w/Skullgirls/~a" "https://wiki.gbl.gg/w/Skullgirls")
   '("rt" "https://www.rottentomatoes.com/search?search=~a" "https://www.rottentomatoes.com")
   '("a" "https://www.acronymfinder.com/~/search/af.aspx?Acronym=~a&string=exact" "https://www.acronymfinder.com")
   '("fa" "https://fontawesome.com/icons?d=gallery&p=2&q=~a" "https://fontawesome.com")
   '("rc" "http://rosettacode.org/mw/index.php?title=Special%3ASearch&search={}&go=Go" "http://rosettacode.org")
   '("lg" "http://libgen.is/search.php?req=~a&lg_topic=libgen&open=0&view=simple&res=25&phrase=1&column=def" "http://libgen.is")
   '("hn" "https://hn.algolia.com/?q=~a" "https://news.ycombinator.com")
   '("o" "https://search.nixos.org/options?query=~a" "https://search.nixos.org")
   '("d" "https://duckduckgo.com/?q=~a" "https://duckduckgo.com/")))

(define-configuration buffer
    ((search-engines (mapcar (lambda (engine) (apply 'make-search-engine engine))
                             *my-search-engines*))))

