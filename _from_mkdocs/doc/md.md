---
title: Markdown and mkdocs reference 
description: Some basic informations on markdown and mkdocs configuraiton,
usage and plugins 
---


- <b>mkdocs</b> <badge-stars repo='mkdocs/mkdocs'></badge-stars> <badge-doc href="https://www.mkdocs.org"></badge-doc>
- <b>mkdocs-material</b> <badge-stars repo='squidfunk/mkdocs-material'></badge-stars> <badge-doc href="https://squidfunk.github.io/mkdocs-material/" logo="github"></badge-doc>


<a href="https://guides.github.com/features/mastering-markdown/" target="_blank">Github guide</a>

## Comments

[comment]: <> (This is a comment, it will not be included)
[//]: <> (This is also a comment.)
[//]: # (This may be the most platform independent comment)
```
[comment]: <> (This is a comment, it will not be included)
[//]: <> (This is also a comment.)
[//]: # (This may be the most platform independent comment)
```

Source: [Stack Overflow 4823469](https://stackoverflow.com/questions/4823468)

## Extensions

### PyMdown extensions <badge-stars repo='facelessuser/pymdown-extensions'></badge-stars> <badge-doc href="https://facelessuser.github.io/pymdown-extensions/" logo="github"></badge-doc>

Collection of extensions for Python Markdown.

Arithmatex is an extension that preserves LaTeX math equations during the
Markdown conversion process so that they can be used with MathJax.

> $p(x|y) = \frac{p(y|x)p(x)}{p(y)}$, \(p(x|y) = \frac{p(y|x)p(x)}{p(y)}\).

### Admonition

[ Admonition ](https://squidfunk.github.io/mkdocs-material/extensions/admonition/) is an extension included in the standard Markdown library that makes it possible to add block-styled side content
 

!!! note
    ```
    !!! note
        For fixed block
    ```

??? note
    ```
    ??? note
        For collapsible block
    ```

Supported types:

<div class="admonition-no-margin"></div>

!!! note "note, seealso"
!!! abstract "abstract, summary, tldr"
!!! info "info, todo"
!!! tip "tip, hint, important"
!!! success "success, check, done"
!!! question "question, help, faq"
!!! warning "warning, caution, attention"
!!! failure "failure, fail, missing"
!!! danger "danger, error"
!!! bug 
!!! example
!!! quote "quote, cite"


### Content tab


=== "Unordered list"
    * Sed sagittis eleifend rutrum
    * Donec vitae suscipit est
    * Nulla tempor lobortis orci


=== "Ordered list"
    1. Sed sagittis eleifend rutrum
    2. Donec vitae suscipit est
    3. Nulla tempor lobortis orci

=== "C++"
    ``` c++
    #include <iostream>

    int main(void) {
      std::cout << "Hello world!" << std::endl;
      return 0;
    }
    ```

### Keys

> ```++ctrl+alt+del++```

++ctrl+C++

