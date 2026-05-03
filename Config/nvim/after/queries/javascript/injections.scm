;; extends

(call_expression
  function: [
    (identifier) @func_name
    (member_expression
      property: (property_identifier) @func_name)
  ]
  arguments: (arguments
    (string
      (string_fragment) @injection.content))
  (#match? @func_name "^(query|execute|run)$")
  (#set! injection.language "sql"))

([
  (string_fragment) @injection.content
  (#set! injection.language "sql")
  (#any-lua-match? @injection.content "^%s*[Ss][Ee][Ll][Ee][Cc][Tt]%s+.+[Ff][Rr][Oo][Mm]")
  (#set! injection.include-children)
])

([
  (string_fragment) @injection.content
  (#set! injection.language "sql")
  (#any-lua-match? @injection.content "^%s*[Ww][Ii][Tt][Hh]%s+.*[Aa][Ss].*")
  (#set! injection.include-children)
])

([
  (string_fragment) @injection.content
  (#set! injection.language "sql")
  (#any-lua-match? @injection.content "^%s*[Uu][Pp][Ss][Ee][Rr][Tt]%s+[Ii][Nn][Tt][Oo]%s+.*")
  (#set! injection.include-children)
])

([
  (string_fragment) @injection.content
  (#set! injection.language "sql")
  (#any-lua-match? @injection.content "^%s*[Ee][Xx][Pp][Ll][Aa][Ii][Nn]")
  (#set! injection.include-children)
])

([
  (string_fragment) @injection.content
  (#set! injection.language "sql")
  (#any-lua-match? @injection.content "^%s*[Aa][Ll][Tt][Ee][Rr]%s+[Tt][Aa][Bb][Ll][Ee]%s+.*")
  (#set! injection.include-children)
])

([
  (string_fragment) @injection.content
  (#set! injection.language "sql")
  (#any-lua-match? @injection.content "^%s*[Tt][Rr][Uu][Nn][Cc][Aa][Tt][Ee]%s+[Tt][Aa][Bb][Ll][Ee]%s+.*")
  (#set! injection.include-children)
])

([
  (string_fragment) @injection.content
  (#set! injection.language "sql")
  (#any-lua-match? @injection.content "^%s*[Dd][Rr][Oo][Pp]%s+[Tt][Aa][Bb][Ll][Ee]%s+.*")
  (#set! injection.include-children)
])

([
  (string_fragment) @injection.content
  (#set! injection.language "sql")
  (#any-lua-match? @injection.content "^%s*[Ii][Nn][Ss][Ee][Rr][Tt]%s+[Ii][Nn][Tt][Oo]")
  (#set! injection.include-children)
])

([
  (string_fragment) @injection.content
  (#set! injection.language "sql")
  (#any-lua-match? @injection.content "^%s*[Cc][Rr][Ee][Aa][Tt][Ee]%s+[Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]")
  (#set! injection.include-children)
])

([
  (string_fragment) @injection.content
  (#set! injection.language "sql")
  (#any-lua-match? @injection.content "^%s*[Cc][Rr][Ee][Aa][Tt][Ee]%s+[Ii][Nn][Dd][Ee][Xx]")
  (#set! injection.include-children)
])

([
  (string_fragment) @injection.content
  (#set! injection.language "sql")
  (#any-lua-match? @injection.content "^%s*[Dd][Rr][Oo][Pp]%s+[Ii][Nn][Dd][Ee][Xx]")
  (#set! injection.include-children)
])

([
  (string_fragment) @injection.content
  (#set! injection.language "sql")
  (#any-lua-match? @injection.content "^%s*[Uu][Pp][Dd][Aa][Tt][Ee]%s+.+[Ss][Ee][Tt]")
  (#set! injection.include-children)
])

([
  (string_fragment) @injection.content
  (#set! injection.language "sql")
  (#any-lua-match? @injection.content "^%s*[Dd][Ee][Ll][Ee][Tt][Ee]%s+[Ff][Rr][Oo][Mm]")
  (#set! injection.include-children)
])

([
  (string_fragment) @injection.content
  (#set! injection.language "sql")
  (#any-lua-match? @injection.content "^%s*[Cc][Rr][Ee][Aa][Tt][Ee]%s+[Tt][Aa][Bb][Ll][Ee]")
  (#set! injection.include-children)
])

([
  (string_fragment) @injection.content
  (#set! injection.language "sql")
  (#any-lua-match? @injection.content "^%s*[Cc][Rr][Ee][Aa][Tt][Ee]%s+[Uu][Ss][Ee][Rr]")
  (#set! injection.include-children)
])
