/+  *camel
|%
::  blind parse json
++  start
|=  jon=json
:+  %tscm
  p=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]
(dumb jon)
::
++  dumb
|=  jon=json 
^-  hoon
?~  jon  
  [%wing p=~[%ul]]
?-    -.jon
    %o
  :*  %cnhp
      [%wing p=~[%ot]]
      :-  %clsg
          %+  turn
            ~(tap by p.jon)
          |=  [k=term v=json] 
          ^-  hoon
          ::  attach key k to (dumb v) result
          :*  %clhp
              [%rock %tas k] 
              ::  (dumb v)
              (label k (dumb v))
          ==
  ==
::
    %a
  ?~  p.jon
    :*  %cncl
        [%wing p=~[%ar]]
        q=~
    ==
  :*  %cncl
      [%wing p=~[%at]]
      :~  :-  %clsg
          %+  turn
            ^-  (list json)
            p.jon
          dumb
  ==  ==
  ::
    %n
  [%wing p=~[%no]]
::
    %s
  ::  Attempt to select the correct reparser through a series of +slaw calls
  ?^  (slaw %p p.jon)
    [%cncl p=[%wing p=~[%se]] q=[i=[%rock p=%tas q=112] t=~]]
  ?^  (slaw %da p.jon)
    [%cncl p=[%wing p=~[%se]] q=[i=[%rock p=%tas q=24.932] t=~]]
  ?^  (slaw %if p.jon)
    [%cncl p=[%wing p=~[%se]] q=[i=[%rock p=%tas q=26.217] t=~]]
  [%wing p=~[%so]]
  ::
    %b
  [%wing p=~[%bo]]
==
::  sanitizes json object keys
++  sanitize
|=  jon=json
^-  json
?~  jon  ~
?+    -.jon  jon
    %o
  :-  %o 
  ^-  (map @t json)
  %-  malt
  %+  turn
    ~(tap by p.jon)
  |=  [key=@t v=json]
    =/  k=@t  key
    ?:  ((sane %tas) k)
      :: do not transform --> recursive call
      [k (sanitize v)]
    :: transform -->  recursive call
    :: check for underscores
    =?  k  !.=(~ (find ~['_'] (trip k)))
      ^-  @t
      %+  rap  3
      %+  join
        '-'
      (rash k (more cab sym))
    =?  k  !.=(~ (find ~[' '] (trip k)))
      ^-  @t
      %+  rap  3
      %+  join
        '-'
      (rash k (more ace sym))
    =.  k
      ::  assume camel case if there is uppercase and no heps
      ?:  ?&  (lien (trip k) |=(a=@t &((gte a 'A') (lte a 'Z'))))
              .=(~ (find ~['-'] (trip k)))
          ==
        ^-  @t  (c2k (trip k))
      ::  convert all uppercase to lowercase if there is uppercase and heps
      ?:  (lien (trip k) |=(a=@t &((gte a 'A') (lte a 'Z'))))
        (crip (cass (trip k)))
      ::  Remove any remaining symbols
      =+  %-  crip
          %+  skip 
            (trip k) 
          |=  a=@t
          =+  %+  rush
                a
              ;~(pose (shim 0 47) (shim 58 64) (shim 92 96) (shim 123 127))
          ?~(- %.n %.y)
      :: If nothing is left after filtering symbols, throw an error
      ?.  .=(~ -)
        -
      ~|("Unable to sanitize {<key>}" !!)
    [k (sanitize v)]
  ::
  :: recursive call on children
    %a
  :-  %a
  %+  turn
    p.jon
  sanitize
==
::  +label
::  return a gate which attaches a face: `fac` to the result of a json parser grub 'g'
++  label
|=  [fac=term g=hoon]
^-  hoon
[ %brts
  p=[%bcts p=term=%jon q=[%like p=~[%json] q=~]]
  [ %ktts
    p=term=fac
    [ %cndt
      p=[%wing p=~[%jon]]
      q=g
    ]
  ]
]
--