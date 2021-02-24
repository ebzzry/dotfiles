var css = [
    "/* @import url(https://fonts.googleapis.com/css?family=Open+Sans); */",
    "",
    "body, #hnmain {",
    "    background-color: rgb(30, 30, 30);",
    "    color: rgb(230, 230, 230);",
    "}",
    "",
    "a, .title a {",
    "    color: rgb(200, 200, 200);",
    "}",
    "",
    "a:visited, .title a:visited {",
    "    color: rgb(180, 180, 180);",
    "}",
    "",
    ".comment-tree tr.athing, .comment .c00 {",
    "    background: rgb(60, 60, 60);",
    "    color: rgb(210, 210, 210);",
    "    font-size: 1.2em;",
    "    line-height: 1.3em",
    "}",
    ".comment .c00 a { color: rgb(210, 210, 210); }",
    ".comment .c00 a:visited { color: rgb(180, 180, 180); }",
    "",
    ".title a { ",
    "    font-family: \"Open Sans\", \"Verdana\", sans-serif;",
    "    font-size: 1.3em; ",
    "}",
    ".subtext { font-size: 0.7em; }",
    "",
    "tr.spacer {",
    "    height: 10px !important;",
    "}"
].join("\n")

if (document.domain == "news.ycombinator.com") {
    if (typeof GM_addStyle != "undefined") {
        GM_addStyle(css);
    } else if (typeof PRO_addStyle != "undefined") {
        PRO_addStyle(css);
    } else if (typeof addStyle != "undefined") {
        addStyle(css);
    } else {
        var node = document.createElement("style");
        node.type = "text/css";
        node.appendChild(document.createTextNode(css));
        var heads = document.getElementsByTagName("head");
        if (heads.length > 0) {
            heads[0].appendChild(node);
        } else {
            // no head yet, stick it whereever
            document.documentElement.appendChild(node);
        }
    }
}
