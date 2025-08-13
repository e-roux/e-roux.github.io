---
title: "Testing"
author: Emmanuel Roux
date: 2022-04-05T10:43:35+02:00
subtitle: ""
tags:
  - vim
---

## `vim-test`

**vim-test** provides a wrapping of common test runners. These commands can be applied to different contexts, runs with various *strategies* and test results are then displayed in various location.

**vim-ultest** provides further test results visualization.


### Context

5 commands provide a test execution context:

- `:TestNearest` runs the test nearest to the cursor
- `:TestFile` runs the whole test file
- `:TestSuite` runs the whole test suite
- `:TestLast` runs the latest test
- `:TestVisit` runs the latest visited test (and run).

### Strategies

[Strategies](https://github.com/vim-test/vim-test#strategies) controls the way tests will be run and how the results will be displayed.

### Runners

Default runners are configured per language in `g:test#default_runners` a `Dict[str, List]`. Custom runners can be added in `g:test#runners` or `g:test#custom_runners`.
