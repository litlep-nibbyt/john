|%
++  entry
|=  target=hoon
^-  hoon
?>  ?=([%ktcl *] target)
=/  s=spec  p.target
:+  %tscm
  p=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]
(proc s)
::
++  proc
|=  s=spec
|-  =*  loop  $
::  ~&  >  s
?+    s  !!
    [%bccn *]
  :: validate %bccn structure
  ?> 
    %+  levy
        `(list spec)`p.s
    |=  spic=spec
    ?>  ?=([%bccl p=*] spic)
    ?=([%leaf *] i.p.p.spic)
  ^-  hoon
  :*  %cncl
      [%wing p=~[%of]] 
      :~  :-  %clsg
          %+  turn
              `(list spec)`p.s
          |=  spic=spec
          ?>  ?=([%bccl p=*] spic)
          ?>  ?=([%leaf p=* q=*] i.p.p.spic)
          :+  %clhp
            [%rock %tas q.i.p.p.spic]
          loop(s spic)      :: recurse
  ==  ==
  ::
    [%bccl *]
    :*  %cncl
        p=[%wing p=~[%ot]]
        :~  :*  %clsg
                ^-  (list hoon)
                %+  turn 
                    ^-  (list spec)
                    ?:  ?=([%leaf *] i.p.s)
                      t.p.s
                    p.s
                |=  spic=spec
                ?:  ?=  [%base %null]  spic
                  ~|("Invalid spec: {<s>}" !!)
                loop(s spic)      :: recurse
    ==  ==  ==
  ::
    [%bcts *]
  ^-  hoon
  :+  %clhp
    [%rock p=%tas q=`*`p.s]          :: term
  loop(s q.s)     :: recurse
  ::
  ::
    [%base *]    ^-  hoon  (based p.s)
  ::
    [%leaf *]  !!
  ::
    [%make p=* q=*]
  ?>  ?=  [%wing p=*]  p.s
  ?>  .=(1 (lent `(list limb)`p.p.p.p.s))
  =/  =limb  (snag 0 `(list limb)`p.p.p.p.s)
  =/  wang=term
    ?+    limb  limb 
        [%| * q=(unit term)]  (need q.limb)
        ::
        [%& *]  !!
        ::
    ==
  ^-  hoon
  ?+    wang  ~|("{<wang>} not supported" !!)
      %term   [%wing p=~[%so]]
    ::
      %list
    :*  %cncl
        [%wing p=~[%ar]]
        :~  loop(s (snag 0 q.q.s))
    ==  ==
    ::
      %set
    :*  %cncl
        [%wing p=~[%as]]
        :~  loop(s (snag 0 q.q.s))
    ==  ==
    ::
      %unit
    :^    %cnls
        [%wing p=~[%cu]]
      :*  %brts
          [%bcts p=term=%a q=[%base %noun]]
          :^    %wtsg 
              ~[%a]
            [%bust %null]
          [%cnhp [%wing p=~[%some]] [%wing p=~[%a]]] 
      ==
    loop(s (snag 0 q.q.s))
  ==
  ::
    [%like *]   ~|("%john: we do not support the \\'{<(snag 0 p.s)>}\\' mold." !!)
==
::
++  based
|=  b=base
?-    b
    [%atom *]
  ^-  hoon
  =/  label=term  p.b
  ?+    label  ~|("{<label>} not supported!" !!)
      ?(%t %tas ~)  [%wing p=~[%so]]
  ::
      %ud  [%wing p=~[%ni]]
  ::
      %p   [%cncl p=[%wing p=~[%se]] q=[i=[%rock p=%tas q=112] t=~]]
  ::
      %ux  [%wing p=~[%nu]]
  ::
      %rd  [%wing p=~[%ne]]
  ::
      %da  [%wing p=~[%du]]
  ::
      %f   [%wing p=~[%bo]]
  ==
    %noun  !!
  ::
    %cell  !!
  ::
    %flag  [%wing p=~[%bo]]
  ::
    %void  !!
  ::
    %null  [%wing p=~[%ul]]
==
--