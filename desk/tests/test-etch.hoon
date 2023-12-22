
/+  e=etch, *test
|%
++  test-atom
  ::
  ::  Given, input `x1`, which contains an integer
  =/  x1=@ud  5
  ::
  ::  Input `x2`, which contains a string
  =/  x2=@t  'five'
  ::
  ::  Input `x3`, which contains a loobean
  =/  x3=?  %.y
  ::
  ::  And input `x4`, which is null
  =/  x4  ~
  ::
  ::  When I run +en-vase:etch on these inputs
  ;:  weld
  %+  expect-eq
  ::
  ::  Then, the result for x1 should be a json number 5,
    !>((need (de:json:html '5')))
  !>((en-vase:e !>(x1)))
  %+  expect-eq
  ::
  ::  the result for x2 should be a json string "five",
    !>((need (de:json:html '"five"')))
  !>((en-vase:e !>(x2)))
  %+  expect-eq
  ::
  ::  and the result for x3 should be a json boolean 'true'
    !>((need (de:json:html 'true')))
  !>((en-vase:e !>(x3)))
  %+  expect-eq
  ::
  ::  and the result for x4 should be null
    !>(~)
  !>((en-vase:e !>(x4)))
  ==
::
++  test-list
  ::
  ::  Given, 
  ::  An input `x1` containing a list of loobeans,
  =/  x1=(list ?)  ~[%.y %.n %.y]
  ::  An input `x2` containing a list of cords,
  =/  x2=(list @t)  ~['fee' 'fi' 'fo']
  ::  An input `x3` containing a list of integers,
  =/  x3=(list @ud)  ~[1 2 3]
  ::
  ::  When I run +en-vase:etch on those lists
  ;:  weld
  %+  expect-eq
  ::
  ::  Then, the result for x1 should be a json array of true, false, true,
    !>((need (de:json:html '[true, false, true]')))
  !>((en-vase:e !>(x1)))
  ::
  ::  the result for x2 should be a json array of "fee", "fi", "fo",
  %+  expect-eq
    !>((need (de:json:html '["fee", "fi", "fo"]')))
  !>((en-vase:e !>(x2)))
  ::
  ::  and the result for x2 should be a json array of 1,2,3
  %+  expect-eq
    !>((need (de:json:html '[1,2,3]')))
  !>((en-vase:e !>(x3)))
  ==
::
++  test-cell
  ::
  ::  Given, 
  ::  An input `x1`,
  =/  x1=[a=@ud b=@t]  [a=1 b='value']
  ::
  ::  Another input, `x2`
  =/  x2=[a=@ud b=[@ud @ud @t]]  [a=1 b=[1 2 'last']]
  ;:  weld
  %+  expect-eq
  ::
  ::  Then, the result for x1 should be the `json` object below
    !>((need (de:json:html '{"a": 1, "b": "value"}')))
  !>((en-vase:e !>(x1)))
  %+  expect-eq
  ::
  ::  Then, the result for x2 should be the `json` object below
    !>((need (de:json:html '{"a": 1, "b": [1,2,"last"]}')))
  !>((en-vase:e !>(x2)))
  ==
::
--
