|%
++  dumb
|=  jon=json 
^-  hoon
?~  jon  
  [%tsgl p=[%wing p=~[%ul]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
?-    -.jon
    %o
  :*  %cnhp
      [%tsgl p=[%wing p=~[%ot]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
      :-  %clsg
          %+  turn
            ~(tap by p.jon)
          |=  [k=term v=json] 
          ^-  hoon
          ::  attach key k to (dumb v) result
          :*  %clhp
              [%rock %tas k] 
              (label k (dumb v))
          ==
  ==
::
    %a
  ?~  p.jon
    :*  %cncl
        p=[%tsgl p=[%wing p=~[%ar]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
        q=~
    ==
  :*  %cncl
      p=[%tsgl p=[%wing p=~[%at]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
      :~  :-  %clsg
          %+  turn
            ^-  (list json)
            p.jon
          dumb
  ==  ==
  ::
    %n
  [%tsgl p=[%wing p=~[%no]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
::
    %s
  ::  Attempt to select the correct reparser through a series of +slaw calls
  ?^  (slaw %p p.jon)
    :*  %tsgl
        p=[%cncl p=[%wing p=~[%se]] q=[i=[%rock p=%tas q=112] t=~]]
        q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]
    ==
  :: When would we actually receive a string in @da form? probably never lol.
  ?^  (slaw %da p.jon)
    :*  %tsgl
        p=[%cncl p=[%wing p=~[%se]] q=[i=[%rock p=%tas q=24.932] t=~]]
        q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]
    ==
  ?^  (slaw %if p.jon)
    :*  %tsgl
        p=[%cncl p=[%wing p=~[%se]] q=[i=[%rock p=%tas q=26.217] t=~]]
        q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]
    ==
  [%tsgl p=[%wing p=~[%so]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
::
    %b
  [%tsgl p=[%wing p=~[%bo]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
::
   
==
::++  punch
::  Return the AST for the parser given the input JSON and expected type
::
::|=  [jon=json sur=type]
::^-  hoon
::?>  ?=(%o -.jon)
::~(tap by jon)
::==
::
::  sanitizes json object keys
++  sanitize
|=  jon=json
^-  json
?+    -.jon  jon
    %o
  :-  %o 
  ^-  (map @t json)
  %-  malt
  %+  turn
    ~(tap by p.jon)
  |=  [k=@t v=json]
    ?:  ((sane %tas) k)
      :: do not transform --> recursive call
      [k (sanitize v)]
    :: transform -->  recursive call
    :: check for underscores
    ?~  (find ~['_'] (trip k))
      [k (sanitize v)]
    =.  k
      ^-  @t
      %+  rap  3
      %+  join
        '-'
      (rash k (more cab sym))
    [k (sanitize v)]
    ::check for weird symbols?
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
    [ %cncl
      p=g
      q=[i=[%wing p=~[%jon]] t=~]
    ]
  ]
]
::
::  Produces the parser code given the type of the target noun
::  AND and example JSON
++  reverso
|=  typ=type
^-  hoon
?+    -.typ  !!
    %cell
  *hoon
  ::
    %atom
  *hoon
  ::(proc-atom typ)
  ::
    %face
  *hoon
  ::
    %fork
  *hoon
==
--