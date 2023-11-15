# [LSP](https://langserver.org/)

??? summary "Language Server Protocol"

    Source: [Microsoft on Github](https://microsoft.github.io/language-server-protocol/overviews/lsp/overview/)

    A language server runs as a separate process and development tools
    communicate with the server using the language protocol over JSON-RPC

    Example of server-client communication:
    ![How it works](https://microsoft.github.io/language-server-protocol/overviews/lsp/img/language-server-sequence.png)

## Implementation

### Coc.vim

<badge-stars repo='neoclide/coc.nvim'></badge-stars> <badge-doc href="https://github.com/neoclide/coc.nvim/blob/master/doc/coc.txt" message="latest" logo="github"> </badge-doc> has full support for [Language Server Protocol](https://microsoft.github.io/language-server-protocol/) completion

### LanguageClient-neovim

<badge-stars repo='autozimu/LanguageClient-neovim'></badge-stars> <badge-doc href="https://github.com/autozimu/LanguageClient-neovim/blob/next/doc/LanguageClient.txt" logo="github" message="latest"></badge-doc>

## Language specific

### go

**LSP server** <badge-stars repo="fatih/vim-go"></badge-stars> <badge-doc href='https://github.com/pangloss/vim-javascript' message=''>

### html

```
:set omnifunc=htmlcomplete#CompleteTags
```

### Javascript

- <b>vim-javascript</b> <badge-stars repo='pangloss/vim-javascript'></badge-stars> <badge-doc href='https://github.com/pangloss/vim-javascript#vim-javascript' message=''> </badge-doc>, comment stuff out
- <b>vim-polyglot</b> <badge-stars repo='sheerun/vim-polyglot'></badge-stars> <badge-doc href='https://github.com/sheerun/vim-polyglot/blob/master/README.md'></badge-doc>, collection of language packs for Vim.

Links:

- [A guide to setting up Vim for JavaScript development](https://freshman.tech/vim-javascript/)
- [JavaScript Documentation Standards](https://make.wordpress.org/core/handbook/best-practices/inline-documentation-standards/javascript/)
### Mardown md

**vim-markdown** <badge-stars repo='plasticboy/vim-markdown'></badge-stars> <badge-doc href="https://github.com/plasticboy/vim-markdown#vim-markdown"></badge-doc>, Markdown Vim Mode.

### Python

**LSP server** <badge-stars repo="palantir/python-language-server"></badge-stars>

- https://docs.python-guide.org/dev/env/
- https://www.vimfromscratch.com/articles/vim-for-python/
- https://github.com/neoclide/coc-python

**jedi-language-server**  <badge-stars repo='pappasam/jedi-language-server'></badge-stars>

### Vim

**LSP server** <badge-stars repo='iamcco/vim-language-server'></badge-stars>
let g:markdown_fenced_languages = ['vim', 'help']
This is a JS project, installation done with

```bash
yarn global add vim-language-server
```


### YAML

**LSP server** <badge-stars repo="redhat-developer/yaml-language-server"></badge-stars>
