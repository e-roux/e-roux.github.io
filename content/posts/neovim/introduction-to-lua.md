---
title: "Neovim · Introduction To Lua"
author: Emmanuel Roux
type: "posts"
date: 2022-01-10T21:27:18+01:00
subtitle: ""
image: ""
tags:
  - neovim
  - lua
draft: false
resources:
  - name: Getting started using Lua in Neovim
    href: https://github.com/nanotee/nvim-lua-guide
  - name: Introducing LuaJIT
    href: https://staff.fnwi.uva.nl/h.vandermeer/docs/lua/luajit/luajit_intro.html
  - name: Reference
    href: https://www.lua.org/manual/5.4/
---

{{% note %}} Configuration can be performed in lua instead of vimscript. Config
ist located on unix like system at `~/.config/vim/{init.vim,init.lua}`

See `h: config`
{{% /note %}}

### Types

Lua is a dynamically typed language, with eight basic types:

#### `nil`

Used in case of non value, e.g. at global variable initialisation.

#### `Boolean`
#### `number`
#### `string`
#### `userdata`
#### `function`
#### `thread`
#### `table`

## Control flow

```lua
`if` *condition* `then`
  -- *statement*
-- [`else if` *condition* `then` statement | `else` *statement*]
`end`
```


`for` *key, value in pairs(_G) do
  print(key, value)
end

## Metatable and Metamethods




## Basic functions

See the [documentation comprehensive list](https://www.lua.org/manual/5.4/manual.html#6.1)

## Standard Library

The Lua standard library contains:

- [**coroutine**](https://www.lua.org/manual/5.4/manual.html#6.2) provides operations to manipulate [coroutines](https://www.lua.org/manual/5.4/manual.html#2.6), accessible inside the table `coroutine`;
- [**debug**](https://www.lua.org/manual/5.4/manual.html#6.10) hence its name provide debug facilities, table [`debug`](https://www.lua.org/manual/5.4/manual.html#4.7)
- [**io**](https://www.lua.org/manual/5.4/manual.html#6.8) supplies:

    - implicit file handles, table `io`;
    - metamethods `__gc` and `__close`;
    - three predefined file handles: `io.stdin`, `io.stdout`, and `io.stderr`.


- [**math**](https://www.lua.org/manual/5.4/manual.html#6.7) provides mathematical functions in the table `math`;
- [**os**](https://www.lua.org/manual/5.4/manual.html#6.9) provides general os interaction - date and time, environment variables, file system operations, ... - through the table `os`;
- [**package**](https://www.lua.org/manual/5.4/manual.html#6.3) provides one function [`require`](https://www.lua.org/manual/5.4/manual.html#pdf-require), all other operations are accessible in the table `package`;
- [**string**](https://www.lua.org/manual/5.4/manual.html#6.4) has:

    - generic functions for string manipulation through the table `string`
    - a metatable for strings where the `__index` field points to the `string` table.

- [**table**](https://www.lua.org/manual/5.4/manual.html#6.6) provides all its functions inside the table `table` for table manipulation;
- [**utf8**](https://www.lua.org/manual/5.4/manual.html#6.5) privides basic support for UTF-8 encoding, table `utf8`.
