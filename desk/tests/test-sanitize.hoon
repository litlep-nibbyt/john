/+  p=punch, *test
|%
++  test-sanitize-caps
  ::
  ::  Givens,
  ::  A json, {"Aardvark": 11}, with a single key-value pair.
  ::  Only the first letter of the key is capitalized
  ::
  =/  jon=json
    %-  need
    %-  de:json:html
    '{"Aardvark": 11}'
  ::
  ::  Whens,
  ::  I call +sanitize and pull out the key and assign it a face `c`,
  =/  c=@t  
    %+  snag
      0
    =+  (sanitize:p jon)
    ?>  ?=([%o *] -)
    ~(tap in ~(key by p:-))
  ::
  ::  Thens,
  ::  The key should be in all lower case
  ::
  %+  expect-eq
    !>('aardvark')
  !>(c)
::
++  test-sanitize-camel
  ::
  ::  Givens,
  ::  A json object, {"AardVark": 11} which contains a single key value pair.
  ::  The key has capital letters interspered in it. We call this "camel-case"
  ::
  =/  jon=json
    %-  need
    %-  de:json:html
    '{"AardVark": 11}'
  ::
  ::  Whens,
  ::  I call +sanitize and pull out the key and assign it a face `c`,
  =/  c=@t  
    %+  snag
      0
    =+  (sanitize:p jon)
    ?>  ?=([%o *] -)
    ~(tap in ~(key by p:-))
  ::
  ::  Thens,
  ::  The resulting key is now in kebab-case 
  ::
  %+  expect-eq
    !>('aard-vark')
  !>(c)
::
++  test-sanitize-symbols
  ::
  ::  Givens,
  ::  A json object, '{"@@rdv-@rk$%.": 11}' which contains a single key value pair.
  ::  The key has what we casymbols interspered in it. We define illegal symbols as
  ::  ASCII codes 0-44, 58-64, 92-96, 123-127.
  ::
  =/  jon=json
    %-  need
    %-  de:json:html
    '{"@@rdv-@rk$%.": 11}'
  ::
  ::  Whens,
  ::  I call +sanitize and pull out the key and assign it a face `c`,
  =/  c=@t  
    %+  snag
      0
    =+  (sanitize:p jon)
    ?>  ?=([%o *] -)
    ~(tap in ~(key by p:-))
  ::
  ::  Then,
  ::  The resulting key is the input key, minus the symbols.
  ::  Note that we only remove ASCII codes 0-44, 58-64, 92-96, 123-127
  ::  Thus, heps and dots remain. 
  ::
  %+  expect-eq
    !>('rdv-rk.')
  !>(c)
::
++  test-sanitize-cab
  ::
  ::  Givens,
  ::  A json object, {"aard_vark_apts": 11} which contains a single key value pair.
  ::  The key is interspersed with cabs ("_").
  ::
  =/  jon=json
    %-  need
    %-  de:json:html
    '{"aard_vark_apts": 11}'
  ::
  ::  Whens,
  ::  I call +sanitize and pull out the key and assign it a face `c`,
  =/  c=@t  
    %+  snag
      0
    =+  (sanitize:p jon)
    ?>  ?=([%o *] -)
    ~(tap in ~(key by p:-))
  ::
  ::  Then,
  ::  The resulting key is the input key, with the cabs ("_") replaced with heps ("-")
  ::
  %+  expect-eq
    !>('aard-vark-apts')
  !>(c)
::
++  test-sanitize-ace
  ::
  ::  Givens,
  ::  A json object, {"aard_vark_apts": 11} which contains a single key value pair.
  ::  The key is interspersed with aces (" ").
  ::
  =/  jon=json
    %-  need
    %-  de:json:html
    '{"aard vark apts": 11}'
  ::
  ::  When,
  ::  I call +sanitize and pull out the key and assign it a face `c`,
  =/  c=@t  
    %+  snag
      0
    =+  (sanitize:p jon)
    ?>  ?=([%o *] -)
    ~(tap in ~(key by p:-))
  ::
  ::  Thens,
  ::  The resulting key is the input key, with the aces (" ") replaced with heps ("-")
  ::
  %+  expect-eq
    !>('aard-vark-apts')
  !>(c)
++  test-sanitize-fail
  ::
  ::  Given,
  ::  A json object, {"@#$#$%@^&+": 11} which contains a single key value pair.
  ::  The key consists only of what we define as illegal symbols: ASCII codes 0-44, 58-64, 92-96, 123-127.
  ::
  =/  jon=json
    %-  need
    %-  de:json:html
    '{"@#$#$%@^&+": 11}'
  ::
  ::  Thens, +sanitize will fail
  ::
  %-  expect-fail
  |.((sanitize:p jon))
--
