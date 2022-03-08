---
title: "Pkg Management"
author: Emmanuel Roux
type: "posts"
date: 2022-02-07T22:18:37+01:00
subtitle: ""
image: ""
tags: []
draft: true
---

## `packaging`

[`packaging`](https://packaging.pypa.io/en/latest/index.html) is implementing the [PyPA specification](https://packaging.python.org/en/latest/specifications/) and provide several aspects.

### Version handling

```python
from packaging.version import Version, parse
>>> v1 = parse("1.0a5")
>>> v2 = Version("1.0")
>>> v1
<Version('1.0a5')>
>>> v2
<Version('1.0')>
>>> v1 < v2
True
```
hl


## Package version management

[`setuptools_scm`](https://github.com/pypa/setuptools_scm) extract Python package versions from `git` or `hg` metadata instead of declaring them as the version argument or in a SCM managed file.

```toml
# pyproject.toml
[build-system]
requires = [
  "setuptools>=45",
  "setuptools_scm[toml]>=6.2"
  ]

[tool.setuptools_scm]
write_to = "pkg/_version.py"
```
