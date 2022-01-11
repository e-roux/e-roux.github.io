---
title: "Static File Server"
author: Emmanuel Roux
type: "posts"
Date: 2021-12-28T11:54:18+01:00
LastMod: 2021-12-29T22:54:18+01:00
subtitle: ""
image: ""
tags:
  - webdev
  - go
  - js
draft: false
---

## Go

The [`http`](https://pkg.go.dev/net/http) package provides both client and server implementation.

### Client requests

Simple requests are implemented using pkg's `Get()`, `Head()`, `Post()`, and `PostForm()`.


```go
resp, err := http.Get("http://example.com/")
if err != nil {
      // handle error
}
defer resp.Body.Close()
body, err := io.ReadAll(resp.Body)
// ...
```

{{% badge/github repo="githubnemo/CompileDaemon" %}}
