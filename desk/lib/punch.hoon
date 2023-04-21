|%
++  punch
|=  jon=json 
^-  hoon
?+    -.jon  !!
    %a
  :*  %cncl
      p=[%tsgl p=[%wing p=~[%at]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
      q=~[(atta jon)]
  ==
  ::
    %n
  ::  use a 'no' for now... otherwise bit manipulation
  :*  %cncl
      p=[%tsgl p=[%wing p=~[%no]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
      q=[i=[p=[%rock p=%tas q=110] q=[%sand p=%t q=`*`+.jon]] t=~]
  ==
::
    %s
  :: my S.O
  :*  %cncl
      p=[%tsgl p=[%wing p=~[%so]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
      q=[i=[p=[%rock p=%tas q=115] q=[%sand p=%t q=`*`+.jon]] t=~]
  ==
::
    %b
  :: Bo-chan
  :*  %cncl
      p=[%tsgl p=[%wing p=~[%bo]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
      q=[i=[%cltr p=[i=[%rock p=%tas q=98] t=[i=[%rock p=%f q=`*`+.json] t=~]]] t=~]
  ==
==
::
++  atta
|=  jon=json
^-  hoon
?>  ?=(%a -.jon)
:-  %clsg
^-  (list hoon)
%+  turn
  ^-  (list json)
  p.jon
|=  cel=json
  ?+  -.cel  !!
      %s
    [%tsgl p=[%wing p=~[%so]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
  ::
      %n
    [%tsgl p=[%wing p=~[%no]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
  ::
      %b
    [%tsgl p=[%wing p=~[%bo]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
  ==
--