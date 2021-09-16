# This repository is deprecated

Please use latest version from [SourceHut](https://git.sr.ht/~pepe/trolley)

# Trolley 

General router for Janet programming language. The main idea is the path and
action to which it resolves with params as defined in routes.

## Routes

We define routes as a struct with keys which contain path with optional  params
definition and values which contain actions to which the path resolves.

Example: 

```
{"/" root
 "/home" home
 "/people/:id" people}
```

## Compiling routes 

You can compile routes' configuration from the previous part to routing table where
keys contain PEG for matching route and values contains action it resolves.
This function is mostly for internal or advanced usage of this lib.

Example:

```
(import trolley)
(trolley/compile-routes 
  {"/" root
   "/home" home
   "/people/:id" people})
=> @{<core/peg 0x559E29164210> :root <core/peg 0x559E29159180> :home}
```

Id of `core/peg` differs on your machine.

## Router

This function returns routing function from routes definition, which then can be
used to match the path and returns action and table with parameters.

Example:

```
(import trolley)
(def match 
  (trolley/router {"/" root "/home" home "/people/:id" people})) 
(match "/people/3")
=> (people @{:id "3"})
```

## Resolver 

This function returns resolving function from routes definition, which then can
be used to resolve url path for the action and parameters.

Example:

```
(import trolley)
(def path-for
  (trolley/resolver {"/" root "/home" home "/people/:id" people})) 
(path-for people @{:id "3"})
=> "/people/3"
```
