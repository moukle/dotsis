; extends

((comment) @injection.content
  (#lua-match? @injection.content "^///[^/]")
  (#set! injection.language "markdown_inline"))
