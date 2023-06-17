/+  p=punch, *test
|%
++  test-null
  ::
  :: Givens,
  ::
  :: a json null, named jon1 
  =/  jon1=json  
    %-  need
    %-  de-json:html
    'null'
  ::
  ::  Whens,
  ::
  ::  I use the +start arm %john with faces disabled
  ::  and remove the %tscm by stripping the first two elements of the output
  %+  expect-eq
    !>  +.+:(~(start punch:p %| %|) jon1)
  ::
  ::  Thens,
  ::
  ::  The stripped output from jon1 should be the AST of `ul`.
  !>  ;;
    hoon
  [%wing p=~[%ul]]
::
++  test-bool
  ::
  :: Givens,
  ::
  :: a json boolean, named jon1 holding the value: 'true'
  =/  jon1=json  
    %-  need
    %-  de-json:html
    'false'
  ::
  :: a json boolean, named jon2 holding the value: 'false'.
  =/  jon2=json  
    %-  need
    %-  de-json:html
    'true'
  ::
  ::  Whens,
  ::
  ::  I use the +start arm with faces disabled
  ::  and remove the %tscm by stripping the first two elements of the output
  ;:  weld
  %+  expect-eq
    !>  +.+:(~(start punch:p %| %|) jon1)
  ::
  ::  Thens,
  ::
  ::  The stripped output from jon1 should be the AST of `bo`.
  !>  ;;
    hoon
  [%wing p=~[%bo]]
  %+  expect-eq
    !>  +.+:(~(start punch:p %| %|) jon2)
  ::
  ::  and the stripped output from jon2 should also be the AST of `bo`.
  !>  ;;
    hoon
  [%wing p=~[%bo]]
  ==
::
++  test-string
  ::
  :: Givens,
  ::
  :: a json string, named jon.
  =/  jon=json
    %-  need
    %-  de-json:html
    '"abc123"'
  ::
  ::  Whens, 
  ::  I use the +start arm with faces disabled
  ::  and remove the %tscm by stripping the first two elements of the output
  %+  expect-eq
    !>  +.+:(~(start punch:p %| %|) jon)
  ::  Thens,
  ::  The stripped output should be the AST of `so`.
  !>  ;;
    hoon
  [%wing p=~[%so]]
::
++  test-number
  ::
  :: Givens,
  ::
  :: A json number, named jon1 holding an integer value.
  =/  jon1=json
    %-  need
    %-  de-json:html
    '33'
  ::
  :: A json number, named jon2 holding a decimal value.
  =/  jon2=json
    %-  need
    %-  de-json:html
    '33.33'
  ::
  :: and a json number named jon3 holding a negative decimal value.
  =/  jon3=json
    %-  need
    %-  de-json:html
    '-33.33'
  ::
  ::  When I use the +start arm with faces disabled
  ::  and remove the %tscm by stripping the first two elements of the output
  ::
  ;:  weld
  %+  expect-eq
    !>  +.+:(~(start punch:p %| %|) jon1)
  ::
  ::  Thens,
  ::  the stripped output of jon1, should be the AST of `ni`.
  !>  ;;
    hoon
  [%wing p=~[%ni]]
  %+  expect-eq
    !>  +.+:(~(start punch:p %| %|) jon2)
  ::
  ::  the stripped output of jon2 should be the AST of `ne`.
  !>  ;;
    hoon
  [%wing p=~[%ne]]
  %+  expect-eq
    !>  +.+:(~(start punch:p %| %|) jon3)
  ::
  ::  and the stripped output of jon3 should be the AST of `no`.
  !>  ;;
    hoon
  [%wing p=~[%no]]
  ==
::
++  test-mixed-array
  ::
  ::  Given a json array named `jon` consisting of 3 elements of string, number, and boolean respectively.
  =/  jon=json
    %-  need
    %-  de-json:html
    '["A", 0.5, false]'
  ::
  ::  When I use the +start arm with faces disabled,
  %+  expect-eq
    !>  +.+:(~(start punch:p %| %|) jon)
  ::
  ::  Then, the output should be the AST of (at ~[so ne bo])
  !>  ;;
    hoon
  :*  [%cncl [%wing ~[%at]] [[%clsg [[%wing ~[%so]] [[%wing ~[%ne]] ~[[%wing ~[%bo]]]]]] ~]]
  == 
::
++  test-uniform-array
  ::
  ::  Given a json array named `jon` consisting of 3 elements, each of the string type.
  =/  jon=json  
    %-  need
    %-  de-json:html
    '["A", "B", "C"]'
  ::
  ::  When I use the +start arm inside with faces disabled,
  %+  expect-eq
    !>  +.+:(~(start punch:p %| %|) jon)
  ::
  ::  Then, the output should be the AST of (at ~[so so so])
  !>  ;;
    hoon
  :*  [%cncl [%wing ~[%at]] [[%clsg [[%wing ~[%so]] [[%wing ~[%so]] ~[[%wing ~[%so]]]]]] ~]]
  == 
::
++  test-object-simple
  ::
  ::  Given a json object named `jon` with one key holding a number,
  =/  jon=json  
    %-  need
    %-  de-json:html
    '{"key": 10}'
  ::
  ::  When I use the +start arm with faces disabled,
  %+  expect-eq
    !>  +.+:(~(start punch:p %| %|) jon)
  ::
  ::  Then, the output should be the AST of (ot ~[key+ni])
  !>  ;;
    hoon
  [%cnhp [%wing ~[%ot]] [%clsg [[%clhp [%rock %tas `*`%key] [%wing ~[%ni]]] ~]]]
::
++  test-object-in-object
  ::
  ::  Given a json object named `jon` which consists of nested objects 1 layer deep,
  =/  jon=json  
    %-  need
    %-  de-json:html
    '{"outer": {"inner": 10}}'
  ::
  ::  When I use the +start arm inside with faces disabled,
  %+  expect-eq
    !>  +.+:(~(start punch:p %| %|) jon)
  ::
  ::  Then, the output should be the AST of 
  ::  (ot ~[outer+(ot ~[inner+ni])])
  !>  ;;
    hoon
  :*  %cnhp
      [%wing ~[%ot]]
      :*  %clsg
          :~  :*  %clhp
              [%rock %tas `*`%outer]
              [%cnhp [%wing ~[%ot]] [%clsg [[%clhp [%rock %tas `*`%inner] [%wing ~[%ni]]] ~]]]
  ==  ==  ==  ==
::
++  test-array-in-object
  ::
  ::  Given a json object named `jon` with one key holding an array with three string elements,
  =/  jon=json  
    %-  need
    %-  de-json:html
    '{"outer": ["J", "G", "Ballard"]}'
  ::
  ::  When I use the +start arm with faces disabled,
  %+  expect-eq
    !>  +.+:(~(start punch:p %| %|) jon)
  ::
  ::  Then, the output should be the AST of 
  ::  (ot ~[outer+(at ~[so so so])])
  !>  ;;
    hoon
  :*  %cnhp
      [%wing ~[%ot]]
      :*  %clsg
          :~  :*  %clhp
                  [%rock %tas `*`%outer]
                  [%cncl [%wing ~[%at]] [[%clsg [[%wing ~[%so]] [[%wing ~[%so]] ~[[%wing ~[%so]]]]]] ~]]
  ==  ==  ==  ==
::
+$  stats  [name=@t hp=@ud pp=@ud speed=@rd]
++  test-parse
  ::
  ::  Given a json object named `jon` with one key holding an array with three elements,
  =/  jon=json  
    %-  need
    %-  de-json:html
    '{"outer": ["Ness", 10, 5, 5.35]}'
  ::
  ::  When I use the +start arm with faces disabled,
  ::  use +slap to evaluate the reparser on jon,
  %-  expect-success
  ::
  ::  Then, I expect the reparser to execute without crashing. 
  |.   =/  parse=hoon  (~(start punch:p %| %|) jon)
       =/  g  !<($-(json stats) (slap !>(.) parse))
       `stats`(g jon)
--