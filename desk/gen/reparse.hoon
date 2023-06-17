/+  p=punch, hoon-format
:-  %say
|=  [^ [jon=@t lab=? sani=? ~] *]
:-  %tang
=/  parse=hoon  
  %-  ~(start punch:p lab sani) 
  (need (de-json:html jon))
(flop (turn wall:(need ((p-hoon:hoon-format parse) 0 | 0)) |=(=tape leaf+tape)))