;; inherits: markdown
;; extends

;From MDeiml/tree-sitter-markdown & Helix

(list_item (task_list_marker_checked)) @comment (#set! "priority" 90)

[
  (list_marker_plus)
  (list_marker_minus)
  (list_marker_star)
  (list_marker_dot)
  (list_marker_parenthesis)
  (thematic_break)
] @string

[
  (task_list_marker_checked)
  (task_list_marker_unchecked)
] @task_marker

[
 (atx_h1_marker)
 (atx_h2_marker)
 (atx_h3_marker)
 (atx_h4_marker)
 (atx_h5_marker)
 (atx_h6_marker)
] @header_marker

(atx_heading) @header_content

;; concealing
((atx_h1_marker) @header_marker.h1
  (#offset! @header_marker.h1 0 0 0 0)
  (#set! conceal "󰉫 ")
)

((atx_h2_marker) @header_marker.h2
  (#offset! @header_marker.h2 0 0 0 0)
  (#set! conceal "󰉬 ")
)

((atx_h3_marker) @header_marker.h3
  (#offset! @header_marker.h3 0 0 0 0)
  (#set! conceal "󰉭 ")
)

((atx_h4_marker) @header_marker.h4
  (#offset! @header_marker.h4 0 0 0 0)
  (#set! conceal "󰉮 ")
)

((atx_h5_marker) @header_marker.h5
  (#offset! @header_marker.h5 0 0 0 0)
  (#set! conceal "󰉯 ")
)

((atx_h6_marker) @header_marker.h6
  (#offset! @header_marker.h6 0 0 0 0)
  (#set! conceal "󰉰 ")
)

((list_marker_plus) @list_marker.plus
  (#offset! @list_marker.plus 0 0 0 -1)
  (#set! conceal " ")
)
((list_marker_minus) @list_marker.minus
  (#offset! @list_marker.minus 0 0 0 -1)
  (#set! conceal "")
)

((list_marker_star) @list_marker.star
  (#offset! @list_marker.star 0 0 0 -1)
  (#set! conceal "")
)

((list_marker_dot) @list_marker.dot
  (#offset! @list_marker.dot 0 0 0 -1)
  (#set! conceal "")
)

((list_marker_parenthesis) @list_marker.parenthesis
  (#offset! @list_marker.parenthesis 0 0 0 -1)
  (#set! conceal "")
)

;; replace '[x]' with 󰄲
((task_list_marker_checked) @text.todo.checked
  (#offset! @text.todo.checked 0 -2 0 0)
  (#set! conceal "")
)

;; replace '[ ]' with 󰄱
((task_list_marker_unchecked) @text.todo.unchecked
  (#offset! @text.todo.unchecked 0 -2 0 0)
  (#set! conceal "")
)

([(minus_metadata)] @comment)
