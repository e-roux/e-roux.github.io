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
---

{{% note %}} Configuration can be performed in lua instead of vimscript. Config ist located on unix like system at `~/.config/vim/{init.vim,init.lua}`

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
