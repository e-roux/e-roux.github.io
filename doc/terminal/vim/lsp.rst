Language Server Protocol
========================

Short intro
-----------

[LSP](https://langserver.org/)

.. admonition:: Language Server Protocol
   :class: dropdown

   Source: `Microsoft on Github <https://microsoft.github.io/language-server-protocol/overviews/lsp/overview/>`_

   A language server runs as a separate process and development tools
   communicate with the server using the language protocol over JSON-RPC

   Example of server-client communication:
   ![How it works](https://microsoft.github.io/language-server-protocol/overviews/lsp/img/language-server-sequence.png)

The **Language Server Protocol (LSP)** is a standardized communication protocol
using `JSON <wiki:JSON-RPC>`_, a lightweight remote procedure call (RPC) protocol. The
protocol defines a set of standard methods for common development tasks,
including code completion, formatting, and error checking. 

JSON-RPC is **transport agnostic** operates on a **request-response model**. If
an error occurs during the execution of a procedure, the response includes an
error field with
information about the error.


Message structure
.................

JSON-RPC messages consist of a JSON object with specific fields. The essential fields include:

.. rst-class:: directive 

.. container:: custom-container

    :jsonrpc:
        Specifies the version of the JSON-RPC protocol (e.g., "2.0").
    :method:
        Specifies the name of the remote procedure to be invoked.
    :params:
        Contains parameters to be passed to the remote procedure.
    :id:
        A unique identifier for the request, allowing the client to match requests with responses.

NeoVim integration
------------------

See :code:`h:lsp.txt`.

NeoVim intergrates a LSP client, servers are third party to install.

Servers can be listed at `LSP implementation <https://microsoft.github.io/language-server-protocol/implementors/servers/>`_.

Servers can be started with 

.. code-block:: lua

    vim.lsp.start({
      name = 'my-server-name',
      cmd = {'name-of-language-server-executable'},
      root_dir = vim.fs.dirname(vim.fs.find(
        {'setup.py', 'pyproject.toml'}, 
        { upward = true })[1]),
    })

After a start:

- LSP client will automatically report diagnostics via :code:`vim.diagnostic`.

  *See* :code:`h:vim.diagnostic.config`
- It sets some buffer options if the
  language server supports it
- 'omnifunc' is set to :code:`vim.lsp.omnifunc()`.
  using `i_CTRL-X_CTRL-O`
- 'tagfunc' is set to :code:`vim.lsp.tagfunc()`. This enables features like
  go-to-definition, :code:`:tjump`, and keymaps like `CTRL-]`, `CTRL-W_]`,
  `CTRL-W_}` to utilize the language server.
- 'formatexpr' is set to :code:`vim.lsp.formatexpr()` if both 'formatprg' and
  'formatexpr' are empty. 


Other server capabilities can be added on *attach*:

.. code-block:: lua

    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
      end,
    })
    
    -- Or to ensure the feature is set if the server supports it:
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.server_capabilities.hoverProvider then
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
        end
      end,
    })

Server capabilities 
------------------- 

A LSP server provides information on its *capabilities*, i.e. the features it can handles. In vim, this is typically retrieved for the first client with :code:`vim.lsp.get_active_clients()[1].server_capabilities`

Server capabilites commonly used:

- :code:`vim.lsp.buf.hover()`
- :code:`vim.lsp.buf.format()`
- :code:`vim.lsp.buf.references()`
- :code:`vim.lsp.buf.implementation()`
- :code:`vim.lsp.buf.code_action()`


Implementation
--------------

Coc.vim
.......

:ghstars:`neoclide/coc.nvim` <badge-doc href="https://github.com/neoclide/coc.nvim/blob/master/doc/coc.txt" message="latest" logo="github"> </badge-doc> has full support for [Language Server Protocol](https://microsoft.github.io/language-server-protocol/) completion

LanguageClient-neovim
.....................

:ghstars:`autozimu/LanguageClient-neovim` <badge-doc href="https://github.com/autozimu/LanguageClient-neovim/blob/next/doc/LanguageClient.txt" logo="github" message="latest"></badge-doc>

Language specific
-----------------

go
..

:ghstars:`fatih/vim-go` <badge-doc href='https://github.com/pangloss/vim-javascript' message=''>

html
....

```
:set omnifunc=htmlcomplete#CompleteTags
```

Javascript
..........

- <b>vim-javascript</b> :ghstars:`pangloss/vim-javascript` <badge-doc href='https://github.com/pangloss/vim-javascript#vim-javascript' message=''> </badge-doc>, comment stuff out
- <b>vim-polyglot</b> <badge-stars repo='sheerun/vim-polyglot'></badge-stars> <badge-doc href='https://github.com/sheerun/vim-polyglot/blob/master/README.md'></badge-doc>, collection of language packs for Vim.

Links:

- [A guide to setting up Vim for JavaScript development](https://freshman.tech/vim-javascript/)
- [JavaScript Documentation Standards](https://make.wordpress.org/core/handbook/best-practices/inline-documentation-standards/javascript/)

Mardown md
..........

:ghstars:`plasticboy/vim-markdown` <badge-doc href="https://github.com/plasticboy/vim-markdown#vim-markdown"></badge-doc>, Markdown Vim Mode.

Python
......

:ghstars:`palantir/python-language-server`

- https://docs.python-guide.org/dev/env/
- https://www.vimfromscratch.com/articles/vim-for-python/
- https://github.com/neoclide/coc-python

:ghstars:`pappasam/jedi-language-server`

Vim
...

.. code-block:: shell

   yarn global add vim-language-server


YAML
....

:ghstars:`redhat-developer/yaml-language-server`
