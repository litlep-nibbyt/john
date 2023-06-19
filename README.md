## %john: JSON re/parse tool kit 

Example usage is provided below. The unit tests located in `/test` might also be helpful for understanding behavior of this library.

The JSON -> noun direction relies on `~wicdev-wisryt`'s hoon autoformatter to transform `hoon` AST to code.

### Example usage (JSON -> noun) [[Video](https://youtu.be/uwjh7rOz-5I)]
When given an example JSON tape, the `+reparse` generator generates the code for the hoon reparser of that JSON. The code
can then copy and pasted into the user's app.

We start with this example JSON from the spotify API:

```
{
  "external_urls": {
    "spotify": "string"
  },
  "followers": {
    "href": "string",
    "total": 0
  },
  "genres": ["Prog rock", "Grunge"],
  "href": "string",
  "id": "string",
  "images": [
    {
      "url": "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228",
      "height": 300,
      "width": 300
    }
  ],
  "name": "string",
  "popularity": 0,
  "type": "artist",
  "uri": "string"
}
```

The generator `+reparse` takes three arguments: 

- `jon`: The json to be parsed 
- `lab`: Boolean flag which controls whether faces are attached to results in the reparser 
- `sani`: Boolean flag which controls whether or not json keys are sanitized to become valid terms. 

Generally, you want `lab` and  `sani` to be `%.y`. We want `lab` to be `%.y` because the hoon stdlib maps are not insertion ordered, thus the resulting reparser will not process the keys in the order they came in. Attaching faces makes the result legible. 

The other alternative is to set `lab` to `%.n`, take the output of `+reparse` as a guideline, and rearrange the arguments to +ot in the desired order.

Let's move on to our example. We can produce the reparser code for the earlier JSON like so:

```dojo
> =j '{  "external_urls": {    "spotify": "string"  },  "followers": {    "href": "string",    "total": 0  },  "genres": ["Prog rock", "Grunge"],  "href": "string",  "id": "string",  "images": [    {      "url": "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228",      "height": 300,      "width": 300    }  ],  "name": "string",  "popularity": 0,  "type": "artist",  "uri": "string"}'
> +john!reparse j %& %&
=,  dejs:format
  %-  ot
  :~  [%name |=(jon=json name=%.(jon so))]
      [%popularity |=(jon=json popularity=%.(jon ni))]
      :-  %images
      |=  jon=json
      ^=  images
      %.  jon
      %-  at
      :~  %-  ot
          :~  [%url |=(jon=json url=%.(jon so))]
              [%width |=(jon=json width=%.(jon ni))]
              [%height |=(jon=json height=%.(jon ni))]
          ==
      ==
    ::
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
      [%genres |=(jon=json genres=%.(jon (at ~[so so])))]
      :-  %followers
      |=  jon=json
      ^=  followers
      %.  jon
      %-  ot
      :~  [%total |=(jon=json total=%.(jon ni))]
          [%href |=(jon=json href=%.(jon so))]
      ==
  ==
```

Notice how external_urls was converted to external-urls. We store the produced parser
inside of the `parse` face and test it below. Note that since the keys have been 
sanitized, we need to rerun sanitize on the input json so that they match.

```dojo
> =p -build-file /=john=/lib/punch/hoon
> (parse (sanitize:p (need (de-json:html j))))
[ name='string'
  popularity=0
  images=[url='https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228' width=300 height=300]
  uri='string'
  external-urls=spotify='string'
  id='string'
  href='string'
  type='artist'
  genres=['Prog rock' 'Grunge']
  followers=[total=0 href='string']
]
```

### Example usage (noun -> JSON)

For the opposite direction, we use a library called `+etch` which does the conversion at runtime. The bulk of this library was written by `~rovnys-ricfer` and `~littel-wolfur`. Given a vase, `+etch` converts said vase into a `$json` representation.

```
=etch -build-file /=john=/lib/etch/hoon
> (en-vase:etch !>([a=1 b=~litlep-nibbyt]))
[%o p=[n=[p='b' q=[%s p='~litlep-nibbyt']] l=~ r=[n=[p='a' q=[%n p=~.1]] l={} r={}]]]
> (en-vase:etch !>([a=1 b=~['isle' 'of' 'dogs']]))
[ %o
  p=[n=[p='b' q=[%a p=[i=[%s p='isle'] t=[i=[%s p='of'] t=~[[%s p='dogs']]]]]] l=~ r=[n=[p='a' q=[%n p=~.1]] l={} r={}]]
]
> (en-vase:etch !>([a=~ b=100]))
[%o p=[n=[p='b' q=[%n p=~.100]] l=~ r=[n=[p='a' q=~] l={} r={}]]]
```

As you can see above, lists work fine with etch. However, etch will not produce what you expect if you use it on maps or sets:
```
> (en-vase:etch !>((malt ~[['a' 1] ['b' 2]])))
[%a p=[i=[%s p='b'] t=[i=[%n p=~.2] t=~[[%o p=[n=[p='q' q=[%n p=~.1]] l=~ r=[n=[p='p' q=[%s p='a']] l={} r={}]]]]]]]
```

Another thing to note is that nulls are dropped if you pass in a unit:
```
> (en-vase:etch !>([a=1 b=`'ni']))
[%o p=[n=[p='b' q=[%s p='ni']] l=~ r=[n=[p='a' q=[%n p=~.1]] l={} r={}]]]
```

