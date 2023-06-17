/+  *camel, hoon-format
=<
|%
++  punch
  |_  [lab=? sani=?]
  ::
  ::  +to-hoon: calls the hoon-format library on the result of +start
  ++  to-hoon
    |=  c=cord
    =/  jon=json  (need (de-json:html c))
    wall:(need ((p-hoon:hoon-format (start jon)) 0 | 0))
  ::
  ::  +start: calls +dumb, appends %tscm to top of AST for brevity
  ++  start
  |=  jon=json
  =?  jon  sani
    (sanitize jon)
  :+  %tscm
    p=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]
  (dumb jon)
  ::
  ::  +dumb: blind parse json
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
                ?:  lab
                  (label k (dumb v))
                (dumb v)
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
    ?^  (slaw %ud p.jon)
      [%wing p=~[%ni]]
    ?:  ?&  ?=(^ (fand ["."] (trip p.jon)))
            .=(~ (fand ["-"] (trip p.jon)))   
        ==
      [%wing p=~[%ne]]
    [%wing p=~[%no]]
  ::
      %s
    ::
    ::  Attempt to select the correct reparser through a series of +slaw calls
    ?^  (slaw %p p.jon)
      [%cncl p=[%wing p=~[%se]] q=[i=[%rock p=%tas q=112] t=~]]
    ?^  (slaw %da p.jon)
      [%cncl p=[%wing p=~[%se]] q=[i=[%rock p=%tas q=24.932] t=~]]
    [%wing p=~[%so]]
    ::
      %b
    [%wing p=~[%bo]]
  ==
  --
--
|%
::  sanitizes json object keys
++  sanitize
  |=  jon=json
  ^-  json
  ?~  jon  ~
  ?+    -.jon  jon
    ::
    :: recursive call on children
      %a
    :-  %a
    %+  turn
      p.jon
    sanitize
    ::
      %o
    :-  %o 
    ^-  (map @t json)
    %-  malt
    %+  turn
      ~(tap by p.jon)
    |=  [key=@t v=json]
      =/  k=@t  key
      ?:  ((sane %tas) k)
        ::
        :: If valid term, do not transform.
        [k (sanitize v)]
      :: Otherwise, transform
      ::
      :: Step 1: Check for cabs and aces, replace with heps
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
        ::
        ::  Step 2: Check for camel case
        ::  assume camel case if there is uppercase and no heps
        ?:  ?&  (lien (trip k) |=(a=@t &((gte a 'A') (lte a 'Z'))))
                .=(~ (find ~['-'] (trip k)))
            ==
          ^-  @t  (c2k (trip k))
        ::
        ::  Step 3: Convert all uppercase to lowercase.
        ?:  (lien (trip k) |=(a=@t &((gte a 'A') (lte a 'Z'))))
          (crip (cass (trip k)))
        ::
        ::  Step 4: Remove any remaining symbols
        =+  %-  crip
            %+  skip 
              (trip k) 
            |=  a=@t
            =+  %+  rush
                  a
                ;~(pose (shim 0 44) (shim 58 64) (shim 92 96) (shim 123 127))
            ?~(- %.n %.y)
        ::
        :: Finally, if nothing is left after filtering symbols, throw an error
        ?.  .=(~ -)
          -
        ~|("Unable to sanitize {<key>}" !!)
      [k (sanitize v)]
  ==
  ::
  ::  +label
  ::  return a gate which attaches a face: `fac` to the result of a json parser grub 'g'
  ++  label
  |=  [fac=term g=hoon]
  ^-  hoon
  :+  %brts
    :*  %bcts
        term=%jon
        [%like ~[%json] ~]
    ==
  :*  %ktts
      term=fac
      :+  %cndt
        [%wing ~[%jon]]
      g
  ==
--
