; Structure & literals colored by the Smarty layer.
; Expression contents ({$x}, {if cond}, and tag value=<expr>) are colored by
; the injected php_only layer (see injections.scm).

[
  "{"
  "}"
] @punctuation.bracket

"|" @operator

[
  "{if"
  "{elseif"
  "{else}"
  "{/if}"
  "{foreach"
  "{foreachelse}"
  "{/foreach}"
  "{block"
  "{/block}"
  "{nocache}"
  "{/nocache}"
  "{include"
  "{assign"
  "{l "
] @keyword

; {foreach $items as $k => $v} header variables
(variable) @variable

; tag parameter keys ( var= , file= , s= … )
(attribute) @property

; quoted string values in tags ( {l s='…'} , file='…' )
(string) @string

; modifier names ( |escape , |intval … )
(modifier) @function

(comment) @comment
