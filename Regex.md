Regex stuff
======================

Regex should not be used for HTML, but for quick prcessing of simple documents it can work.

Match all `<br>` tags next to other tags

    (<br>)([\s]*<[^>]*>)


Negative lookahead: match all `<br>` tags followed by other tags, but not another `<br>`

    (<br>)([\s]*<(?!br)[^>]*>)

> Info: http://www.regular-expressions.info/lookaround.html


Replace all line breaks with `<br>`

    (?:\r\n|\r|\n)


