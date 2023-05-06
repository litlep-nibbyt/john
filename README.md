## %john: JSON auto-reparser (WIP)

### Example usage (JSON -> noun)

The `+dumb` arm takes a JSON sample and outputs the AST of the reparser (`hoon` type). The `+format` generator takes this AST and output the code in the form of a cord.

Currently, it's dumb as a rock. I'm working on better type inference

```
> =punch -build-file /=john=/lib/punch/hoon
> sample
[ %o
    p
  [   n
    [ p='results'
        q
      [ %a
          p
        [   i
          [ %o
              p
            [ n=[p='name' q=[%s p='stench']]
              l=[n=[p='url' q=[%s p='https://pokeapi.co/api/v2/ability/1/']] l={} r={}]
              r=~
            ]
          ]
          t=~
        ]
      ]
    ]
      l
    [ n=[p='previous' q=~]
      l={}
      r={[p='next' q=[%s p='https://pokeapi.co/api/v2/ability/?limit=20&offset=20']]}
    ]
    r=[n=[p='count' q=[%n p=~.248]] l={} r={}]
  ]
]
> +john!format (dumb:punch sample)
%-  ot:dejs:format
:~  [%count no:dejs:format]
    :-  %results
    %-  at:dejs:format
    :~  %-  ot:dejs:format
    ~[[%name so:dejs:format] [%url so:dejs:format]]

    ==
  ::
    [%next so:dejs:format]
    [%previous ul:dejs:format]
==
```
