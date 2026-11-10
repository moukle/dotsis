; extends

; `///` docs: faint slashes, then the text after them.
((comment) @comment.documentation.marker
  (#lua-match? @comment.documentation.marker "^///[^/]"))

((comment) @comment.documentation
  (#lua-match? @comment.documentation "^///[^/]")
  (#offset! @comment.documentation 0 3 0 0))
