/+  *mip, *pprint
|%
::
++  show-json
  |=  =vase
  (en-json:html (en-vase vase))
::
++  en-vase
  |=  [typ=type arg=*]
  ^-  json
  ?-    typ
      %void  ~&  >  'void'  !!
      %noun  ~&  >  'noun'  (en-noun arg)
    ::
      [%atom *]  ~&  >  'atom'  (en-dime p.typ ;;(@ arg))
    ::
      [%cell *]
    ~&  >  "cell {<p.typ>}, {<q.typ>}"
    =/  hed=json  $(typ p.typ, arg -.arg)
    =/  tal=json  $(typ q.typ, arg +.arg)
    ::
    ?:  ?&  !!?=([%o ^] hed)
            !!?=([%o ^] tal)
        ==
      ~&  >  'inner'
      [%o (~(uni by ?>(?=(%o -.hed) p.hed)) ?>(?=(%o -.tal) p.tal))]
    ::
    ~&  >  "outer, head: {<hed>}, tail: {<tal>}"
    ~&  >  "match: {<?=([%a *] tal)>}"
    ?~  hed  tal
    ?:  &(?=([%s @t] hed) ?=([%s @t] tal))
      ~&  >  '1'
      [%a hed tal ~]
    ?:  &(?=([%s @t] hed) !?=([%s @t] tal) !?=([%a *] tal) !=(~ tal))
      ~&  >  '2'
      [%a hed tal ~]
    ?:  &(?=([%a *] hed) ?=([%a *] tal))
      ~&  >  '3'
      [%a (weld p.hed p.tal)]
    ?:  ?=([%a *] tal)
      ~&  >  'CAT'
      [%a hed p.tal]
    ::
    ?~  tal  [%a hed ~]
      ~&  >  '4'
    [%a hed tal ~]
    ::
      [%core *]  !!
    ::
      [%face *]  [%o (malt `(list [@t json])`[;;(@t p.typ) $(typ q.typ)]~)]
    ::
      [%fork *]
    =/  tyz=(list type)  (turn ~(tap in p.typ) peel)
    ~&  >  "fork {<tyz>}, length {<(lent tyz)>}"
    =.  tyz
      %-  zing
      %+  turn  tyz
      |=  tep=type
      ^-  (list type)
      ?:(?=(%fork -.tep) ~(tap in p.tep) ~[tep])
    ::
    ?:  =(1 (lent tyz))
      ~&  >>  "one: {<(head tyz)>}"  $(typ (head tyz))
    ::  $?
    ::
    ?:  (levy tyz |=([t=type] ?=(%atom -.t)))
      ~&  >  '$?'
      =/  aura
      ::
        =/  hid  (head tyz)
        ?>(?=([%atom @ *] hid) p.hid)
      ?>  (levy tyz |=([t=type] ?>(?=([%atom * *] t) =(aura p.t))))
      (en-dime aura ;;(@ arg))
    ::  $%
    ::
    ?:  (levy tyz |=([t=type] ?=([%cell [%atom * ^] *] t)))
      ~&  >  '$%'
      =/  aura
        =/  hid  (head tyz)
        ?>(?=([%cell [%atom @ ^] *] hid) p.p.hid)
      ::
      =/  hid  (head tyz)
      =/  val  ;;(@ -.arg)
      ?>  ((sane aura) val)
      ::
      =/  tag  ?:(?=(?(%t %ta %tas) aura) val (scot aura val))
      =/  tin=type
        |-
        ^-  type
        ?~  tyz  !!
        =/  ty=type  i.tyz
        ?>  ?=([%cell [%atom @ ^] *] ty)
        ?:  =(val u.q.p.ty)  q.ty
        $(tyz t.tyz)
      %+  frond:enjs:format  tag  $(typ tin, arg +.arg)
    ::  non-$% fork of cells
    ::
    ?:  (levy tyz |=([t=type] ?=([%cell *] t)))
      ~|  cell-fork/tyz
      ~!  tyz  !!
    ::  $@
    ::
    ~&  >  '$@'
    =/  [atoms=(list type) cells=(list type)]
      (skid tyz |=([t=type] ?=(%atom -.t)))
    ?@  arg
    ~&  >  "atoms {<atoms>}"
      $(p.typ (sy atoms))
    ~&  >  "cells {<cells>}"
    $(p.typ (sy cells))
  ::
      [%hint *]  ~&  >  'hint'  $(typ q.typ)
      [%hold *]  ~&  >  'hold'  $(typ (~(play ut p.typ) q.typ))
  ==
::  +peel: recursively unwrap type
::
++  peel
  |=  [typ=type]
  =|  [cos=(unit term)]
  ^-  type
  |-   =*  loop  $
  ?+  typ  typ
    [%atom *]  ?~  cos  typ  ;;(type [%face u.cos typ])
    ::
    %void      !!
    ::
    [%cell *]
      ?^  cos
        =/  coll  [%cell loop(typ p.typ) loop(typ q.typ)]
        ;;(type [%face u.cos coll])
      [%cell loop(typ p.typ) loop(typ q.typ)]
    ::
    [%face *]
      ?~  cos  q.typ
      ?:  =(-.q.typ %hold)  loop(typ q.typ)
      loop(typ q.typ, cos ~)
    ::
    [%hint *]
      =/  =note  q.p.typ
      ?+    -.note  loop(typ q.typ)
          %made
            ?^  q.note  loop(typ q.typ)
            ::  disable for now, too slow
            loop(typ q.typ, cos ~)
      ==
    ::
    [%hold *]  loop(typ (~(play ut p.typ) q.typ))
  ==
::
++  en-noun
  |=  arg=*
  ^-  json
   ?@  arg
     %+  frond:enjs:format  ;;(@t arg)  ~
   [%a ~[$(arg -.arg) $(arg +.arg)]]
::
++  en-dime
  |=  [aura=@tas dat=@]
  ^-  json
  ?+    aura  $(aura %ud)
      %c  !!
  ::
      %$  $(aura %ui)
  ::
      %da  [%s (scot %da dat)]
      ::  [%n (time:enjs:format dat)]
  ::
      %dr  [%s (scot %dr dat)]
  ::
      %f  [%b ;;(? dat)]
  ::
      %n  ~
  ::
      %p  [%s (scot %p dat)]
  ::
      %q  [%s (scot %q dat)]
  ::
      ?(%rh %rq %rd %rs)  [%s (scot %rs dat)]
  ::
      %s  [%s dat]
  ::
     ?(%t %ta %tas)  [%s dat]
  ::
     ?(%ub %uc)  (numb:enjs:format dat)
  ::
     %ux  [%s (scot %ux dat)]
     %uv  [%s (scot %uv dat)]
  ::
     %ui  [%n `@t`(rsh [3 2] (scot %ui dat))]
     %ud  [%n (scot %ud dat)]
  ==
  --