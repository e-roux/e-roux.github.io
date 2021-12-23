---
title: "Hugo: content management"
date: 2021-10-29T12:20:09+02:00
categories: CMS
tags:
  - javascript
  - hugo
  - search-engine
---

## Content organisation

 Hugo supports content nested at any level, the top levels (i.e.
 `content/<DIRECTORIES>`) are special in Hugo and are considered the content
 type used to determine layouts . Example assuming using *pretty URLs*
 (`example.com/about`) instead of *ugly URLs*
 (`example.com/about.html`)<!--more-->

```shell
.
└── content
    └── about
    |   └── index.md  // <- https://example.com/about/
    ├── posts
    |   ├── firstpost.md   // <- https://example.com/posts/firstpost/
    |   ├── happy
    |   |   └── ness.md  // <- https://example.com/posts/happy/ness/
    |   └── secondpost.md  // <- https://example.com/posts/secondpost/
    └── quote
        ├── first.md       // <- https://example.com/quote/first/
        └── second.md      // <- https://example.com/quote/second/
```

### Index Pages: `_index.md`
