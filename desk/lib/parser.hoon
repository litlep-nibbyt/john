|%
++  parse
|=  jon=json
=,  dejs:format
%.  jon
%-  ot
:~  [%label |=(jon=json label=%.(jon so))]
    :-  %restrictions
    |=  jon=json
    ^=  restrictions
    %.  jon
    (ot ~[[%reason |=(jon=json reason=%.(jon so))]])
  ::
    [%name |=(jon=json name=%.(jon so))]
    [%popularity |=(jon=json popularity=%.(jon no))]
    :-  %available-markets
    |=  jon=json
    available-markets=%.(jon (at ~[so so so]))
  ::
    :-  %tracks
    |=  jon=json
    ^=  tracks
    %.  jon
    %-  ot
    :~  [%total |=(jon=json total=%.(jon no))]
        [%offset |=(jon=json offset=%.(jon no))]
        [%limit |=(jon=json limit=%.(jon no))]
        :-  %items
        |=  jon=json
        ^=  items
        %.  jon
        %-  at
        :~  %-  ot
            :~  :-  %restrictions
                |=  jon=json
                ^=  restrictions
                %.  jon
                %-  ot
                :~  :-  %reason
                    |=(jon=json reason=%.(jon so))
                ==
                [%name |=(jon=json name=%.(jon so))]
                :-  %available-markets
                |=  jon=json
                available-markets=%.(jon (at ~[so]))
              ::
                :-  %is-local
                |=(jon=json is-local=%.(jon bo))
              ::
                :-  %explicit
                |=(jon=json explicit=%.(jon bo))
              ::
                :-  %preview-url
                |=(jon=json preview-url=%.(jon so))
              ::
                :-  %linked-from
                |=  jon=json
                ^=  linked-from
                %.  jon
                %-  ot
                :~  [%uri |=(jon=json uri=%.(jon so))]
                    :-  %external-urls
                    |=  jon=json
                    ^=  external-urls
                    %.  jon
                    %-  ot
                    :~  :-  %spotify
                        |=(jon=json spotify=%.(jon so))
                    ==
                  ::
                    [%id |=(jon=json id=%.(jon so))]
                    [%href |=(jon=json href=%.(jon so))]
                    [%type |=(jon=json type=%.(jon so))]
                ==
              ::
                [%uri |=(jon=json uri=%.(jon so))]
                :-  %track-number
                |=(jon=json track-number=%.(jon no))
              ::
                :-  %external-urls
                |=  jon=json
                ^=  external-urls
                %.  jon
                %-  ot
                :~  :-  %spotify
                    |=(jon=json spotify=%.(jon so))
                ==
              ::
                :-  %duration-ms
                |=(jon=json duration-ms=%.(jon no))
              ::
                [%id |=(jon=json id=%.(jon so))]
                :-  %is-playable
                |=(jon=json is-playable=%.(jon bo))
              ::
                [%href |=(jon=json href=%.(jon so))]
                :-  %disc-number
                |=(jon=json disc-number=%.(jon no))
              ::
                [%type |=(jon=json type=%.(jon so))]
                :-  %artists
                |=  jon=json
                ^=  artists
                %.  jon
                %-  at
                :~  %-  ot
                    :~  :-  %name
                        |=(jon=json name=%.(jon so))
                        :-  %uri
                        |=(jon=json uri=%.(jon so))
                      ::
                        :-  %external-urls
                        |=  jon=json
                        ^=  external-urls
                        %.  jon
                        %-  ot
                        :~  :-  %spotify
                            |=  jon=json
                            spotify=%.(jon so)
                        ==
                      ::
                        [%id |=(jon=json id=%.(jon so))]
                        :-  %href
                        |=(jon=json href=%.(jon so))
                      ::
                        :-  %type
                        |=(jon=json type=%.(jon so))
                    ==
                ==
            ==
        ==
      ::
        [%next |=(jon=json next=%.(jon so))]
        [%href |=(jon=json href=%.(jon so))]
        [%previous |=(jon=json previous=%.(jon so))]
    ==
  ::
    :-  %copyrights
    |=  jon=json
    ^=  copyrights
    %.  jon
    %-  at
    :~  %-  ot
        :~  [%text |=(jon=json text=%.(jon so))]
            [%type |=(jon=json type=%.(jon so))]
        ==
    ==
  ::
    [%total-tracks |=(jon=json total-tracks=%.(jon no))]
    :-  %images
    |=  jon=json
    ^=  images
    %.  jon
    %-  at
    :~  %-  ot
        :~  [%url |=(jon=json url=%.(jon so))]
            [%width |=(jon=json width=%.(jon no))]
            [%height |=(jon=json height=%.(jon no))]
        ==
    ==
  ::
    [%release-date |=(jon=json release-date=%.(jon so))]
    [%uri |=(jon=json uri=%.(jon so))]
    :-  %external-urls
    |=  jon=json
    ^=  external-urls
    %.  jon
    (ot ~[[%spotify |=(jon=json spotify=%.(jon so))]])
  ::
    [%id |=(jon=json id=%.(jon so))]
    [%href |=(jon=json href=%.(jon so))]
    [%type |=(jon=json type=%.(jon so))]
    [%album-type |=(jon=json album-type=%.(jon so))]
    :-  %external-ids
    |=  jon=json
    ^=  external-ids
    %.  jon
    %-  ot
    :~  [%ean |=(jon=json ean=%.(jon so))]
        [%isrc |=(jon=json isrc=%.(jon so))]
        [%upc |=(jon=json upc=%.(jon so))]
    ==
  ::
    :-  %artists
    |=  jon=json
    ^=  artists
    %.  jon
    %-  at
    :~  %-  ot
        :~  [%name |=(jon=json name=%.(jon so))]
            :-  %popularity
            |=(jon=json popularity=%.(jon no))
          ::
            :-  %images
            |=  jon=json
            ^=  images
            %.  jon
            %-  at
            :~  %-  ot
                :~  [%url |=(jon=json url=%.(jon so))]
                    :-  %width
                    |=(jon=json width=%.(jon no))
                  ::
                    :-  %height
                    |=(jon=json height=%.(jon no))
                ==
            ==
          ::
            [%uri |=(jon=json uri=%.(jon so))]
            :-  %external-urls
            |=  jon=json
            ^=  external-urls
            %.  jon
            %-  ot
            :~  :-  %spotify
                |=(jon=json spotify=%.(jon so))
            ==
          ::
            [%id |=(jon=json id=%.(jon so))]
            [%href |=(jon=json href=%.(jon so))]
            [%type |=(jon=json type=%.(jon so))]
            :-  %genres
            |=(jon=json genres=%.(jon (at ~[so so])))
          ::
            :-  %followers
            |=  jon=json
            ^=  followers
            %.  jon
            %-  ot
            :~  [%total |=(jon=json total=%.(jon no))]
                [%href |=(jon=json href=%.(jon so))]
            ==
        ==
    ==
  ::
    :-  %release-date-precision
    |=(jon=json release-date-precision=%.(jon so))
  ::
    [%genres |=(jon=json genres=%.(jon (at ~[so so])))]
==
--