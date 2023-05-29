|%
++  parse
|=  jon=json
%.  jon
=,  dejs:format
%-  ot
:~  [%token |=(jon=json token=%.(jon so))]
    :-  %event
    |=  jon=json
    ^=  event
    %.  jon
    %-  ot
    :~  :-  %client-msg-id
        |=(jon=json client-msg-id=%.(jon so))
        [%ts |=(jon=json ts=%.(jon so))]
        [%channel |=(jon=json channel=%.(jon so))]
        [%event-ts |=(jon=json event-ts=%.(jon so))]
        [%text |=(jon=json text=%.(jon so))]
        :-  %blocks
        |=  jon=json
        ^=  blocks
        %.  jon
        %-  at
        :~  %-  ot
            :~  :-  %block-id
                |=(jon=json block-id=%.(jon so))
                :-  %elements
                |=  jon=json
                ^=  elements
                %.  jon
                %-  at
                :~  %-  ot
                    :~  :-  %elements
                        |=  jon=json
                        ^=  elements
                        %.  jon
                        %-  at
                        :~  %-  ot
                            :~  :-  %text
                                |=  jon=json
                                text=%.(jon so)
                                :-  %type
                                |=  jon=json
                                type=%.(jon so)
                            ==
                        ==
                        :-  %type
                        |=(jon=json type=%.(jon so))
                    ==
                ==
              ::
                [%type |=(jon=json type=%.(jon so))]
            ==
        ==
      ::
        [%team |=(jon=json team=%.(jon so))]
        [%type |=(jon=json type=%.(jon so))]
        :-  %channel-type
        |=(jon=json channel-type=%.(jon so))
      ::
        [%user |=(jon=json user=%.(jon so))]
    ==
  ::
    :-  %context-enterprise-id
    |=(jon=json context-enterprise-id=%.(jon ul))
  ::
    :-  %is-ext-shared-channel
    |=(jon=json is-ext-shared-channel=%.(jon bo))
  ::
    :-  %event-context
    |=(jon=json event-context=%.(jon so))
  ::
    :-  %authorizations
    |=  jon=json
    ^=  authorizations
    %.  jon
    %-  at
    :~  %-  ot
        :~  :-  %enterprise-id
            |=(jon=json enterprise-id=%.(jon ul))
            :-  %is-enterprise-install
            |=  jon=json
            is-enterprise-install=%.(jon bo)
          ::
            [%user-id |=(jon=json user-id=%.(jon so))]
            [%is-bot |=(jon=json is-bot=%.(jon bo))]
            [%team-id |=(jon=json team-id=%.(jon so))]
        ==
    ==
  ::
    [%event-id |=(jon=json event-id=%.(jon so))]
    [%type |=(jon=json type=%.(jon so))]
    [%event-time |=(jon=json event-time=%.(jon no))]
    [%team-id |=(jon=json team-id=%.(jon so))]
    :-  %context-team-id
    |=(jon=json context-team-id=%.(jon so))
  ::
    [%api-app-id |=(jon=json api-app-id=%.(jon so))]
==
--