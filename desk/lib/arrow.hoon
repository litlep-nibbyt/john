|%
:: bccn forward look
++  arrow-ni
|=  target=hoon
^-  hoon
?>  ?=([%ktcl *] target)
=/  s=spec  p.target
?>  ?=([%bccn p=*] s)
?> 
  %+  levy
    `(list spec)`p.s
  |=  spic=spec
  ?>  ?=([%bccl p=*] spic)
  ::  JOIE: wtf...
  ?=([%leaf *] i.p.p.spic)
^-  hoon
:*  %cncl
    p=[%tsgl p=[%wing p=~[%of]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
    :~  :-  %clsg
        %+  turn
            `(list spec)`p.s
        |=  spic=spec
        ?>  ?=([%bccl p=*] spic)
        ?>  ?=([%leaf p=* q=*] i.p.p.spic)
        :+  %clhp
          [%rock %tas q.i.p.p.spic]
        (h-bccn spic)      :: recurse
==  ==
::
++  h-bccn
|=  s=spec
|-  =*  loop  $
~&  >  s
?+    -.s  !!
    %bccn    ~|('%john: no nested buccen support.' !!)
  ::
    %base    ^-  hoon  (based p.s)
  ::
    %bccl
  ?>  ?=([%leaf *] i.p.s)
  :*  %cncl
      p=[%tsgl p=[%wing p=~[%ot]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
      :~  :*  %clsg
              ^-  (list hoon)
              %+  turn 
                `(list spec)`t.p.s
              |=  spic=spec
              loop(s spic)      :: recurse
  ==  ==  ==
    %bcts
  ::  grab the term from the skin
  ::  recurse on spec
  ^-  hoon
  :*  %clhp
      [%rock p=%tas q=`*`p.s]          :: term
      loop(s q.s)     :: recurse
  ==
  ::
==

++  arrow
|=  target=hoon
^-  hoon
?>  ?=([%ktcl *] target)
=/  s=spec  p.target
|-  =*  loop  $
~&  >  s
?+    -.s  !!
  ::  [%bcts p=skin q=spec]
  ::  [%bcts p=term=%a q=[%base p=[%atom p=~.ud]]]
  ::  (of ~[[%a ni]])
  ::  [%bcts p=term=%a q=[%base p=[%atom p=~.ud]]]
  ::  (of ~[[]])
    %bcts
  ::  grab the term from the skin
  ::  recurse on spec
  ^-  hoon
  :*  %clhp
      [%rock p=%tas q=`*`p.s]          :: term
      loop(s q.s)     :: recurse
  ==
  ::
    %bccn
  !!
  ::  this one next
  ::  [%bccl p=[i=spec t=(list spec)]] 
  ::  (ot:dejs:format ~[[]])
    %bccl
  ?+    i.p.s
    :*  %cncl
        p=[%tsgl p=[%wing p=~[%ot]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
        :~  :*  %clsg
                ^-  (list hoon)
                %+  turn 
                    `(list spec)`p.s
                |=  spic=spec
                loop(s spic)      :: recurse
    ==  ==  ==
  ::
      [%leaf *]
    ^-  hoon
    :*  %cncl
        p=[%tsgl p=[%wing p=~[%of]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
        :~  :*  %clsg
                :~  :+  %clhp
                  [%rock %tas q.i.p.s]
                :*  %cncl
                    p=[%tsgl p=[%wing p=~[%ot]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
                    :~  :*  %clsg
                            ^-  (list hoon)
                            %+  turn 
                                t.p.s
                            |=  spic=spec
                            loop(s spic)      :: recurse
                ==
    ==  ==  ==  ==  ==  ==
  ==
  ::
  ::
    %bcwt
  !!
  ::
    %like
  !!
  ::
    %leaf
  !!
  ::
    %make
  !! 
  ::
    %base
  ?-    p.s
      [%atom *]
    ^-  hoon
    =/  label=term  p.p.s
    ?+    label  !!
        ?(%t ~)
      [%tsgl p=[%wing p=~[%so]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
    ::
        %ud
      [%tsgl p=[%wing p=~[%ni]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
    ::
        %p
      :*  %tsgl
          p=[%cncl p=[%wing p=~[%se]] q=[i=[%rock p=%tas q=112] t=~]]
          q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]
      ==
    ==
    ::
      %noun 
    !!
    ::
      %cell 
    !!
    ::
      %flag
    !!
    ::
      %void
    !!
    ::
      %null
    !!
  ==
==
++  based
|=  [b=base]
?-    b
    [%atom *]
  ^-  hoon
  =/  label=term  p.b
  ?+    label  !!
      ?(%t ~)
    [%tsgl p=[%wing p=~[%so]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
  ::
      %ud
    [%tsgl p=[%wing p=~[%ni]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
  ::
      %p
    :*  %tsgl
        p=[%cncl p=[%wing p=~[%se]] q=[i=[%rock p=%tas q=112] t=~]]
        q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]
    ==
  ==
  ::
    %noun 
  !!
  ::
    %cell 
  !!
  ::
    %flag
  !!
  ::
    %void
  !!
  ::
    %null
  !!
==
--