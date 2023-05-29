::  An autoformatter for hoon
::
::  Usage:  +desk!format (ream .^(@t %cx /=desk=/gen/format/hoon))
::
::  This operates by taking in an AST and printing it -- anything not in
::  the AST cannot be preserved.
::
::  A "printing combinator" has type +form, which is a function from our
::  current printing state to the text output and updates to our
::  printing state.  We constuct complicated structures out of these
::  functions, and then fire them lazily.
::
::  (We use some conventions here from monads elsewhere, however there's
::  no wrapped value, so this is really more like a monoid.  Don't worry
::  about it.)
::
::  Currently, the input printing state is:
::  - indent: how many layers of indentation are we in
::  - wide: true if we're currently trying wide form -- fail if we try
::          to print a new line
::  - col: the column number we're at in the current line
::
::  `indent` and `wide` follow a stack discipline, so they are not
::  output by the combinator.  Use +wide and +indent to wrap a form so
::  that that form is guaranteed to be in wide form or is indented an
::  extra layer, respectively.  Normally it's not necessary, but you can
::  also use +dedent to temporarily reduce the indentation level (eg in
::  queenside).
::
::  `col` is output by each combinator and threaded through to the next
::  one.
::
::  The combinator also produces a wall of text.  This is "in order" --
::  the first lines are before the last ones.
::
::  The main useful functions for working with combinators are:
::
::  - +draw combines two printing combinators into a single one.
::  - +lite converts a tape into a printing combinator.  +lall converts
::    a wall into a printing combinator.
::  - +line inserts a new line and enough spaces to match our
::    indentation level.
::  - +pure is the identity for +draw -- ie `(draw pure foo)` and `(draw
::    foo pure)` are always the same as `foo`.
::
::  The fundamental principle is that we go along printing until we hit
::  column 57, and then we back up and try a different format.  For
::  example, if we were trying to print in wide form, now we try tall
::  form.  If we were trying to print kingside, try queenside.
::
::  The function that sets these alternation points is +seek, which
::  takes two +forms and tries the first; if it fails, it tries the
::  second.  This theoretically has terrible asymptotics, but in
::  practice we never get that deep because we hit column 57 pretty
::  quick.
::
!:
=/  width  57
=>  |%
    +$  pose  [indent=@ud wide=_| col=@ud]
    +$  form  $-(pose (unit [=wall col=@ud]))
    ::  Identity
    ::
    ++  pure  |=(=pose ``col.pose)
    ::  Append two forms
    ::
    ++  draw
      |=  [m-b=form fun=form]
      ^-  form
      |=  =pose
      =/  b-res  (m-b pose)
      ?~  b-res
        ~
      ?:  (gte col.u.b-res width)
        ~
      =/  fun-res  (fun indent.pose wide.pose +.u.b-res)
      ?~  fun-res
        ~
      ?:  (gte col.u.fun-res width)
        ~
      :-  ~
      :_  +.u.fun-res
      =/  b-wall  (flop wall.u.b-res)
      ?~  b-wall
        wall.u.fun-res
      ?~  wall.u.fun-res
        wall.u.b-res
      %+  weld
        (flop t.b-wall)
      :-  (weld i.b-wall i.wall.u.fun-res)
      t.wall.u.fun-res
    --
=>  |%
    ::  Temporarily decrease indentation
    ::
    ++  dedent
      |=  =form
      ^-  ^form
      |=  =pose
      (form pose(indent (dec indent.pose)))
    ::  Temporarily increase indentation
    ::
    ++  indent
      |=  =form
      ^-  ^form
      |=  =pose
      (form pose(indent +(indent.pose)))
    ::  Literal wall
    ::
    ++  lall
      |=  =wall
      ^-  form
      |=  =pose
      :+  ~  wall
      ?~  wall  col.pose
      ?~  t.wall  (add col.pose (lent i.wall))
      (lent -:(flop t.wall))
    ::  Add new line, indented appropriately
    ::
    ++  line
      ^-  form
      |=  =pose
      ?:  wide.pose
        ~
      :+  ~
        ~["" (runt [(mul 2 indent.pose) ' '] "")]
      (mul indent.pose 2)
    ::  LITEral tape
    ::
    ++  lite
      |=  =tape
      ^-  form
      |=  =pose
      `[[tape ~] (add col.pose (lent tape))]
    ::  Use the first one that works
    ::
    ++  seek
      |=  [a=form b=form]
      ^-  form
      |=  =pose
      ?^  a-res=(a pose)
        a-res
      (b pose)
    ::  Require in wide form
    ::
    ++  wide
      |=  =form
      ^-  ^form
      |=  =pose
      (form pose(wide &))
    --
|%
++  p-arm
  |=  [=term =hoon]
  =/  [=tape body=form]
    ?:  ?=([%ktcl *] hoon)
      ["+$" (p-spec p.hoon)]
    ["++" (p-hoon hoon)]
  %+  draw  (lite tape)
  %+  draw  (lite "  ")
  %+  draw  (lite (trip term))
  %+  seek
    %-  wide
    %+  draw  (lite "  ")
    body
  %-  indent
  %+  draw  line
  body
::
++  p-base
  |=  =base
  %-  lite
  ?-  base
    %noun      "*"
    %cell      "^"
    %flag      "?"
    %null      "~"
    %void      "!!"
    [%atom @]  ['@' (trip p.base)]
  ==
::
++  p-brcn
  |=  [p=(unit term) q=(map term tome)]
  ?>  ?=([[%$ *] ~ ~] q)
  =/  arms=(list [=term =hoon])
    (sort ~(tap by q.q.n.q) aor)
  %+  draw  (lite "|%")
  %+  draw  line
  %+  draw
    %^  (p-join-2 ,[term hoon])  line  :(draw line (lite "::") line)
    [arms p-arm]
  %+  draw  line
  (lite "--")
::
++  p-cltr
  |=  p=(list hoon)
  ^-  form
  ?~  p
    !!
  ?~  t.p
    (p-hoon i.p)
  %+  seek
    %-  wide
    %+  draw  (lite "[")
    %+  draw  ((p-join hoon) (lite " ") p p-hoon)
    (lite "]")
  ?~  t.t.p
    (p-tall-2 ":-" (p-hoon i.p) (p-hoon i.t.p))
  ?~  t.t.t.p
    (p-tall-3 ":+" (p-hoon i.p) (p-hoon i.t.p) (p-hoon i.t.t.p))
  ?~  t.t.t.t.p
    %^  p-tall-4  ":^"  (p-hoon i.p)
    [(p-hoon i.t.p) (p-hoon i.t.t.p) (p-hoon i.t.t.t.p)]
  %+  draw  (lite ":*  ")
  %+  draw  (p-hoon i.p)
  %+  draw
    %-  indent
    %-  indent
    %+  draw  line
    ((p-join hoon) line t.p p-hoon)
  %+  draw  line
  (lite "==")
::
++  p-cncl
  |=  [p=hoon q=(list hoon)]
  ^-  form
  %+  seek
    %-  wide
    %+  draw  (lite "(")
    %+  draw  ((p-join hoon) (lite " ") [p q] p-hoon)
    (lite ")")
  ?~  q
    !!
  ?~  t.q
    (p-tall-2 "%-" (p-hoon p) (p-hoon i.q))
  ?~  t.t.q
    (p-tall-3 "%+" (p-hoon p) (p-hoon i.q) (p-hoon i.t.q))
  ?~  t.t.t.q
    (p-tall-4 "%^" (p-hoon p) (p-hoon i.q) (p-hoon i.t.q) (p-hoon i.t.t.q))
  %+  draw  (lite "%:  ")
  %+  draw  (p-hoon p)
  %+  draw
    %-  indent
    %+  draw  line
    ((p-join hoon) line q p-hoon)
  %+  draw  line
  (lite "==")
::
++  p-cnts
  |=  [p=wing q=(list (pair wing hoon))]
  ^-  form
  ?~  q
    (p-wing p)
  %+  seek
    %-  wide
    %+  draw  (p-wing p)
    %+  draw  (lite "(")
    %+  draw
      %^  (p-join (pair wing hoon))  (lite ", ")  q
      |=  [p=wing q=hoon]
      %+  draw  (p-wing p)
      %+  draw  (lite " ")
      (p-hoon q)
    (lite ")")
  %^  p-tall-n-1  "%="  (p-wing p)
  %+  turn  q
  |=  [p=wing q=hoon]
  %+  draw  (p-wing p)
  %+  seek
    %-  wide
    %+  draw  (lite "  ")
    (p-hoon q)
  %-  dedent
  %+  draw  line
  (p-hoon q)
::
::  If !!, we don't expect that parsed code can produce this (eg only
::  used in +open expansions)
::
++  p-hoon
  |=  gen=hoon
  ~+
  ^-  form
  ?:  ?=(^ -.gen)
    ?:  ?=([%rock %n %0] p.gen)
      %+  draw  (lite "`")
      (p-hoon q.gen)
    (p-cltr [p q ~]:gen)
  ~|  -.gen
  ?-    -.gen
      %$     (p-lark p.gen)
      %base  (p-base p.gen)
      %bust  (p-base p.gen)
      %dbug  ~|  p.gen  $(gen q.gen)
      %eror  !!
      %hand  !!
      %note  $(gen q.gen)  :: XX
      %fits  !!
      %knit  (p-knit +.gen)
      %leaf  !!
      %limb  !!
      %lost  !!
      %rock  (draw (lite "%") (p-sand +.gen))
      %sand  (p-sand +.gen)
      %tell
    %+  draw  (lite "<")
    %+  draw  ((p-join hoon) (lite " ") p.gen p-hoon)
    (lite ">")
  ::
      %tune  !!
      %wing  (p-wing p.gen)
      %yell
    %+  draw  (lite ">")
    %+  draw  ((p-join hoon) (lite " ") p.gen p-hoon)
    (lite "<")
  ::
      %xray  !!
      %brbc
    %+  draw  (lite "|$  [")
    %+  draw  ((p-join limb) (lite " ") sample.gen p-limb)
    %+  draw  (lite "]")
    %+  draw  line
    (p-spec body.gen)
  ::
      %brcn  (p-brcn +.gen)
      %brdt  (p-tall-1 "|." (p-hoon p.gen))
      %brhp  (p-tall-1 "|-" (p-hoon p.gen))
      %brsg  (p-rune-2 "|~" (p-spec p.gen) (p-hoon q.gen))
      %brtr  (p-rune-2 "|*" (p-spec p.gen) (p-hoon q.gen))
      %brts  (p-rune-2 "|=" (p-spec p.gen) (p-hoon q.gen))
      %clcb  (p-rune-2 ":_" (p-hoon p.gen) (p-hoon q.gen))
      %clhp  (p-cltr [p q ~]:gen)
      %clls  (p-cltr [p q r ~]:gen)
      %clkt  (p-cltr [p q r s ~]:gen)
      %clsg
    ?~  p.gen
      (lite "~")
    %+  seek
      %-  wide
      ?:  (lien `(list hoon)`p.gen |=(=hoon ?=([%sand %tas *] (canon hoon))))
        (p-path p.gen)
      %+  draw  (lite "~[")
      %+  draw  ((p-join hoon) (lite " ") p.gen p-hoon)
      (lite "]")
    (p-tall-n-0 ":~" (p-hoon i.p.gen) (turn t.p.gen p-hoon))
  ::
      %cltr  (p-cltr +.gen)
      %cncl  (p-cncl +.gen)
      %cndt  (p-rune-2 "%." (p-hoon p.gen) (p-hoon q.gen))
      %cnhp  (p-cncl [p q ~]:gen)
      %cnls  (p-cncl [p q r ~]:gen)
      %cnkt  (p-cncl [p q r s ~]:gen)
      %cnsg
    %+  seek
      %-  wide
      %+  draw  (lite "~(")
      %+  draw  (p-wing p.gen)
      %+  draw  (lite " ")
      %+  draw  (p-hoon q.gen)
      %+  draw  (lite " ")
      %+  draw  ((p-join hoon) (lite " ") r.gen p-hoon)
      (lite ")")
    (p-tall-3 "%~" (p-wing p.gen) (p-hoon q.gen) (p-cltr r.gen))
  ::
      %cnts  (p-cnts +.gen)
      %dtkt
    %+  seek
      %-  wide
      %+  draw  (lite ".^(")
      %+  draw  (p-spec p.gen)
      %+  draw  (lite " ")
      =/  can  (canon q.gen)
      ~&  can=can
      ?:  ?=([%cltr *] can)
        %+  draw  ((p-join hoon) (lite " ") p.can p-hoon)
        (lite ")")
      %+  draw  (p-hoon q.gen)
      (lite ")")
    (p-tall-n-0 ".^" (p-spec p.gen) (p-hoon q.gen) ~)
  ::
      %dtls
    %+  draw  (lite "+(")
    %+  draw  (p-hoon p.gen)
    (lite ")")
  ::
      %dtts
    %+  seek
      %-  wide
      %+  draw  (lite "=(")
      %+  draw  (p-hoon p.gen)
      %+  draw  (lite " ")
      %+  draw  (p-hoon q.gen)
      (lite ")")
    (p-tall-2 ".=" (p-hoon p.gen) (p-hoon q.gen))
  ::
      %ktcl  (draw (lite ",") (wide (p-spec p.gen)))
      %kthp
    %+  seek
      %-  wide
      %+  draw  (lite "`")
      %+  draw  (p-spec p.gen)
      %+  draw  (lite "`")
      (p-hoon q.gen)
    (p-tall-2 "^-" (p-spec p.gen) (p-hoon q.gen))
  ::
      %ktts
    %+  seek
      %-  wide
      %+  draw  (p-skin p.gen)
      %+  draw  (lite "=")
      (p-hoon q.gen)
    (p-tall-2 "^=" (p-skin p.gen) (p-hoon q.gen))
  ::
      %mccl
    %+  seek
      %-  wide
      %+  draw  (lite ":(")
      %+  draw  ((p-join hoon) (lite " ") [p.gen q.gen] p-hoon)
      (lite ")")
    (p-tall-n-1 ";:" (p-hoon p.gen) (turn q.gen p-hoon))
  ::
      %sgbr
    %+  draw  (lite "~|  ")
    %+  draw  (p-hoon p.gen)
    %+  draw  line
    (p-hoon q.gen)
  ::
      %sgpm
    %+  draw  (lite "~&  ")
    %+  draw
      ?:  =(p.gen 0)
        pure
      %+  draw
        |-  ^-  form
        ?:  =(p.gen 0)
          pure
        %+  draw  (lite ">")
        $(p.gen (dec p.gen))
      (lite "  ")
    %+  draw  (p-hoon q.gen)
    %+  draw  line
    (p-hoon r.gen)
  ::
      %tscm  (p-rune-2 "=," (p-hoon p.gen) (p-hoon q.gen))
      %tsfs  (p-tall-3 "=/" (p-skin p.gen) (p-hoon q.gen) (p-hoon r.gen))
      %tsgl
    %+  seek
      %-  wide
      %+  draw  (p-hoon p.gen)
      %+  draw  (lite ":")
      (p-hoon q.gen)
    (p-tall-2 "=<" (p-hoon p.gen) (p-hoon q.gen))
  ::
      %tshp  (p-tall-2 "=-" (p-hoon p.gen) (p-hoon q.gen))
      %tsgr  (p-rune-2 "=>" (p-hoon p.gen) (p-hoon q.gen))
      %tsls
    ?:  ?=([%wthp [[%& %2] ~] *] q.gen)
      %^  p-tall-n-1  "?-"  (p-hoon p.gen)
      %+  turn  q.q.gen
      |=  [p=spec q=hoon]
      %+  draw  (p-spec p)
      %+  seek
        %-  wide
        %+  draw  (lite "  ")
        ?:  ?=([%tsgr [%$ %3] *] q)
          (p-hoon q.q)
        (p-hoon q)
      %-  dedent
      %+  draw  line
      ?:  ?=([%tsgr [%$ %3] *] q)
        (p-hoon q.q)
      (p-hoon q)
    (p-tall-2 "=+" (p-hoon p.gen) (p-hoon q.gen))
  ::
      %tssg
    %+  draw  (lite "=~")
    %+  draw
      %-  indent
      %+  draw  line
      %^  (p-join-2 hoon)  line  :(draw (dedent line) (lite "::") line)
      [p.gen |=(=hoon (p-hoon hoon))]
    %+  draw  line
    (lite "==")
  ::
      %wtcl  (p-wut "?:" (p-hoon p.gen) q.gen r.gen)
      %wtgr
    %+  draw  (lite "?>  ")
    %+  draw  (p-hoon p.gen)
    %+  draw  line
    (p-hoon q.gen)
  ::
      %wthp
    %^  p-tall-n-1  "?-"  (p-wing p.gen)
    %+  turn  q.gen
    |=  [p=spec q=hoon]
    %+  draw  (p-spec p)
    %+  seek
      %-  wide
      %+  draw  (lite "  ")
      (p-hoon q)
    %-  dedent
    %+  draw  line
    (p-hoon q)
  ::
      %wtkt  (p-wut "?^" (p-wing p.gen) q.gen r.gen)
      %wtpt  (p-wut "?@" (p-wing p.gen) q.gen r.gen)
      %wtsg  (p-wut "?~" (p-wing p.gen) q.gen r.gen)
      %wtts  (p-rune-2 "?=" (p-spec p.gen) (p-wing q.gen))
      %wtzp
    %+  seek
      %-  wide
      %+  draw  (lite "!")
      (p-hoon p.gen)
    (p-tall-1 "?!" (p-hoon p.gen))
  ::
      %zpzp  (lite "!!")
      %zpgl  (p-rune-2 "!<" (p-spec p.gen) (p-hoon q.gen))
      *      ~&  [%missing -.gen]  pure
  ==
::
::  Combine a list of forms, with a separator
::
++  p-join
  ~+
  |*  a=mold
  |=  [sep=form lit=(list a) fun=$-(a form)]
  ^-  form
  ?~  lit
    pure
  |-  ^-  form
  ?~  t.lit
    (fun i.lit)
  %+  draw  (fun i.lit)
  %+  draw  sep
  $(lit t.lit)
::  Combine a list of forms, with distinct separators for whether the
::  form fits on a single line
::
++  p-join-2
  |*  a=mold
  |=  [wide-sep=form tall-sep=form lit=(list a) fun=$-(a form)]
  ^-  form
  ?~  lit
    pure
  |-  ^-  form
  ?~  t.lit
    (fun i.lit)
  %+  draw
    ^-  form
    |=  =pose
    =/  res  ((fun i.lit) pose)
    ?~  res
      ~
    ?~  wall.u.res
      ``col.pose
    ?~  t.wall.u.res
      ((draw (lite i.wall.u.res) wide-sep) pose)
    ((draw (lall wall.u.res) tall-sep) pose)
  $(lit t.lit)
::
++  p-knit
  |=  p=(list woof)
  %+  draw  (lite "\"")
  %+  draw
    %^  (p-join woof)  pure  p
    |=  =woof
    ?@  woof
      =/  char  (~(dash us %noun) [woof ~] '"' "\{")
      (lite (swag [1 (dec (dec (lent char)))] char))
    %+  draw  (lite "\{")
    %+  draw  (p-hoon p.woof)
    (lite "}")
  (lite "\"")
::
++  p-lark
  |=  axe=axis
  %-  lite
  =/  heplus  &
  ?:  =(0 axe)  !!
  ?:  =(1 axe)  "."
  |-  ^-  tape
  ?:  =(1 axe)  ""
  =+  [now=(cap axe) lat=(mas axe)]
  :_  $(axe lat, heplus !heplus)
  ?-  [heplus now]
    [%& %2]  '-'
    [%& %3]  '+'
    [%| %2]  '<'
    [%| %3]  '>'
    *        !!
  ==
::
++  p-limb
  |=  =limb
  ?-  limb
    %$      (lite "$")
    @       (lite (trip limb))
    [%& @]  (p-lark p.limb)
    [%| *]  (lite (runt [p.limb '^'] (trip (need q.limb))))
  ==
::
++  p-path
  |=  p=(list hoon)
  ?.  ?=([* * * *] p)
    ((p-join hoon) (lite "/") p p-path-elem)
  =/  sent  [%sand %ta %'sentinel-path']
  =/  tis-1  =(sent (canon i.p))
  =/  tis-2  =(sent (canon i.t.p))
  =/  tis-3  =(sent (canon i.t.t.p))
  ?:  &(tis-1 tis-2 tis-3)
    %+  draw  (lite "%/")
    ((p-join hoon) (lite "/") t.t.t.p p-path-elem)
  %+  draw  (lite "/")
  %+  draw
    ?:  tis-1
      (lite "=")
    (p-path-elem i.p)
  %+  draw
    ?:  |(tis-1 tis-2)
      pure
    (lite "/")
  %+  draw
    ?:  tis-2
      (lite "=")
    (p-path-elem i.t.p)
  %+  draw
    ?:  ?|  &(tis-2 tis-3)
            &(tis-1 |(tis-2 tis-3))
        ==
      pure
    (lite "/")
  %+  draw
    ?:  tis-3
      (lite "=")
    (p-path-elem i.t.t.p)
  ?~  t.t.t.p
    pure
  %+  draw  (lite "/")
  ((p-join hoon) (lite "/") t.t.t.p p-path-elem)
::
++  p-path-elem
  |=  =hoon
  =/  can  (canon hoon)
  ?:  ?=([%sand %ta %'sentinel-path'] can)
    (lite "=")
  ?:  ?=([%sand %ta @] can)
    (lite (trip q.can))
  ?:  ?=(?(%sand %cncl) -.can)
    (p-hoon hoon)
  :(draw (lite "[") (p-hoon hoon) (lite "]"))
::
++  p-rune-2
  |=  [rune=tape p=form q=form]
  %+  seek
    (p-wide-2 rune p q)
  (p-tall-2 rune p q)
::
++  p-sand
  |=  [p=term q=*]
  %-  lite
  ?^  q
    <q>
  ?:  =(%f p)
    ?:  =(%& q)
      "&"
    "|"
  ?:  =([%tas 0] [p q])
    "$"
  ?:  =(%t p)
    (~(dash us %noun) (trip q) '\'' ~)
  (scow p q)
::
++  p-skin
  |=  =skin
  ^-  form
  ?@  skin
    (lite (trip skin))
  ?-    -.skin
      %spec  (p-spec spec.skin)
      %name
    %+  draw  (lite (trip term.skin))
    %+  draw  (lite "=")
    (p-skin skin.skin)
  ::
      *
    ~&  [%missing-skin -.skin]
    pure
  ==
::
++  p-spec
  |=  =spec
  ^-  form
  ~+
  ?-    -.spec
      %base  (p-base p.spec)
      %dbug  $(spec q.spec)
      :: %gist  $(spec q.spec)  :: XX
      %leaf  (draw (lite "%") (p-sand +.spec))
      %like  ((p-join wing) (lite ":") +.spec p-wing)
      %loop  (draw (lite "/") (lite (trip p.spec)))
      %made  !!
      %make
    %+  draw  (lite "(")
    %+  draw  (p-hoon p.spec)
    %+  draw  (lite " ")
    %+  draw  ((p-join ^spec) (lite " ") q.spec p-spec)
    (lite ")")
  ::
      %name  $(spec q.spec)
      %bccb
    %+  seek
      %-  wide
      %+  draw  (lite "_")
      (p-hoon p.spec)
    (p-tall-1 "$_" (p-hoon p.spec))
  ::
      %bccl
    ?~  t.p.spec
      (p-spec i.p.spec)
    %+  seek
      %-  wide
      %+  draw  (lite "[")
      %+  draw  ((p-join ^spec) (lite " ") p.spec p-spec)
      (lite "]")
    (p-tall-n-0 "$:" (p-spec i.p.spec) (turn t.p.spec p-spec))
  ::
      %bchp  (p-rune-2 "$-" (p-spec p.spec) (p-spec q.spec))
      %bcts
    %-  wide
    %+  draw
      ?:  =(`p.spec ~(autoname ax q.spec))
        pure
      (p-skin p.spec)
    %+  draw  (lite "=")
    (p-spec q.spec)
  ::
      %bcwt
    %+  seek
      %-  wide
      %+  draw  (lite "?(")
      %+  draw  ((p-join ^spec) (lite " ") p.spec p-spec)
      (lite ")")
    (p-tall-n-0 "$?" (p-spec i.p.spec) (turn t.p.spec p-spec))
  ::
      *      ~&  [%missing-spec -.spec]  pure
  ==
::
++  p-tall-1
  |=  [rune=tape p=form]
  ^-  form
  %+  draw  (lite rune)
  %+  draw  line
  p
::
++  p-tall-2
  |=  [rune=tape p=form q=form]
  ^-  form
  %+  draw  (lite rune)
  %+  draw  (lite "  ")
  %+  draw  (indent (indent p))
  %+  draw  line
  q
::
++  p-tall-3
  |=  [rune=tape p=form q=form r=form]
  ^-  form
  %+  draw  (lite rune)
  %+  draw  (lite "  ")
  %+  seek
    %+  draw  (wide p)
    %+  draw  (lite "  ")
    %+  draw  (wide q)
    %+  draw  line
    r
  %+  draw  p
  %+  draw
    %-  indent
    %+  draw  line
    q
  %+  draw  line
  r
::
++  p-tall-4
  |=  [rune=tape p=form q=form r=form s=form]
  ^-  form
  %+  draw  (lite rune)
  %+  draw  (lite "  ")
  %+  seek
    %+  draw  (wide p)
    %+  draw  (lite "  ")
    %+  draw  (wide q)
    %+  seek
      %+  draw  (lite "  ")
      %+  draw  (wide r)
      %+  draw  line
      s
    %+  draw
      %-  indent
      %+  draw  line
      r
    %+  draw  line
    s
  %+  draw  (lite "  ")
  %+  draw  p
  %+  draw
    %-  indent
    %+  draw  (indent q)
    r
  s
::
++  p-tall-n-0
  |=  [rune=tape p=(lest form)]
  ^-  form
  %+  draw  (lite rune)
  %+  draw  (lite "  ")
  %+  draw
    %-  indent
    %-  indent
    %+  draw  i.p
    ?~  t.p
      pure
    %+  draw  line
    %^  (p-join-2 form)  line
      :(draw (dedent line) (lite "::") line)
    [t.p |=(form +<)]
  %+  draw  line
  (lite "==")
::
++  p-tall-n-1
  |=  [rune=tape p=form q=(list form)]
  ^-  form
  %+  seek
    %+  draw  (lite rune)
    %+  draw  (lite "  ")
    %+  draw  p
    %+  draw
      %-  indent
      %+  draw  line
      ((p-join form) line q wide)
    %+  draw  line
    (lite "==")
  %+  draw  (lite rune)
  %+  draw  (lite "    ")
  %+  draw  p
  %+  draw
    %-  indent
    %-  indent
    %+  draw  line
    %^  (p-join-2 form)  line
      :(draw (dedent (dedent line)) (lite "::") line)
    [q |=(form +<)]
  %+  draw  line
  (lite "==")
::
++  p-wide-2
  |=  [rune=tape p=form q=form]
  ^-  form
  %-  wide
  %+  draw  (lite rune)
  %+  draw  (lite "(")
  %+  draw  p
  %+  draw  (lite " ")
  %+  draw  q
  (lite ")")
::
++  p-wing
  |=  =wing
  ((p-join limb) (lite ".") wing p-limb)
::  TODO: should allow wide form?
::
++  p-wut
  |=  [rune=tape p=form q=hoon r=hoon]
  ^-  form
  %+  draw  (lite rune)
  %+  draw  (lite "  ")
  %+  draw  p
  %+  draw
    %-  indent
    %+  draw  line
    (p-hoon q)
  %+  draw  line
  (p-hoon r)
::  Skim past irrelevant hoons
::
++  canon
  |=  gen=hoon
  ^-  hoon
  ?-  -.gen
    %dbug  $(gen q.gen)
    %note  $(gen q.gen)
    *      gen
  ==
--
