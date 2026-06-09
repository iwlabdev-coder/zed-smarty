; --- HTML skeleton: only template-level and block-body text ---
(template (text) @injection.content
  (#set! injection.combined)
  (#set! injection.language "html"))

(body (text) @injection.content
  (#set! injection.combined)
  (#set! injection.language "html"))

; --- Smarty {expressions} -> always-code PHP (php_only) ---
(inline (php) @injection.content
  (#set! injection.language "smarty-php"))

(if condition: (text) @injection.content
  (#set! injection.language "smarty-php"))

; non-string tag values, e.g. value=explode('|', $name) , value=$delimiters[0]
(parameter value: (php) @injection.content
  (#set! injection.language "smarty-php"))
