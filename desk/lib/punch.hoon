|%
++  punch
|=  jon=json 
^-  hoon
?<  .=(~ jon)
?-    -.jon
    %o
  :*  %cnhp
      [%tsgl p=[%wing p=~[%ot]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
      :-  %clsg
          %+  turn
            ~(tap by p.jon)
          |=  [k=term v=json] 
          ^-  hoon
          [%clhp [%rock %tas k] (punch v)]
  ==
::
    %a
  :*  %cncl
      p=[%tsgl p=[%wing p=~[%at]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
      :~  :-  %clsg
          %+  turn
            ^-  (list json)
            p.jon
          punch
  ==  ==
  ::
    %n
  ::  use a 'no' for now... otherwise bit manipulation
  [%tsgl p=[%wing p=~[%no]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
::
    %s
  :: my S.O
  [%tsgl p=[%wing p=~[%so]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
::
    %b
  :: Bo-chan
  [%tsgl p=[%wing p=~[%bo]] q=[%tsgl p=[%wing p=~[%dejs]] q=[%wing p=~[%format]]]]
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