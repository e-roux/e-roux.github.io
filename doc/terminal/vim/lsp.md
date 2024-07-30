# Language Server Protocol

## Short intro

[LSP](https://langserver.org/)

```{eval-rst}
.. admonition:: Language Server Protocol
   :class: dropdown

   Source: `Microsoft on Github <https://microsoft.github.io/language-server-protocol/overviews/lsp/overview/>`_

   A language server runs as a separate process and development tools
   communicate with the server using the language protocol over JSON-RPC

   Example of server-client communication:
   ![How it works](https://microsoft.github.io/language-server-protocol/overviews/lsp/img/language-server-sequence.png)
```

The **Language Server Protocol (LSP)** is a standardized communication protocol
using `JSON <wiki:JSON-RPC>`_, a lightweight remote procedure call (RPC) protocol. The
protocol defines a set of standard methods for common development tasks,
including code completion, formatting, and error checking. 

JSON-RPC is **transport agnostic** operates on a **request-response model**. If
an error occurs during the execution of a procedure, the response includes an
error field with
information about the error.


## Message structure

JSON-RPC messages consist of a JSON object with specific fields. The essential fields include:

:::{eval-rst}

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
:::

## NeoVim integration

See `h:lsp.txt`.

NeoVim intergrates a LSP client, servers are third party to install.

Servers can be listed at `LSP implementation <https://microsoft.github.io/language-server-protocol/implementors/servers/>`_.

Servers can be started with 

```lua
vim.lsp.start({
  name = 'my-server-name',
  cmd = {'name-of-language-server-executable'},
  root_dir = vim.fs.dirname(vim.fs.find(
    {'setup.py', 'pyproject.toml'}, 
    { upward = true })[1]),
})
```

After a start:

- LSP client will automatically report diagnostics via `vim.diagnostic`.

  *See* `h:vim.diagnostic.config`
- It sets some buffer options if the
  language server supports it
- 'omnifunc' is set to `vim.lsp.omnifunc()`.
  using `i_CTRL-X_CTRL-O`
- 'tagfunc' is set to `vim.lsp.tagfunc()`. This enables features like
  go-to-definition, `:tjump`, and keymaps like `CTRL-]`, `CTRL-W_]`,
  `CTRL-W_}` to utilize the language server.
- 'formatexpr' is set to `vim.lsp.formatexpr()` if both 'formatprg' and
  'formatexpr' are empty. 


Other server capabilities can be added on *attach*:

```lua
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
```

## Server capabilities 

A LSP server provides information on its *capabilities*, i.e. the features it can handles. In vim, this is typically retrieved for the first client with `vim.lsp.get_active_clients()[1].server_capabilities`

Server capabilites commonly used:

- `vim.lsp.buf.hover()`
- `vim.lsp.buf.format()`
- `vim.lsp.buf.references()`
- `vim.lsp.buf.implementation()`
- `vim.lsp.buf.code_action()`


## Communication with the client


```lua
local bufnr = vim.api.nvim_get_current_buf()
-- building block for several LSP requests
local params = vim.lsp.util.make_range_params()

params.context = {
   triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
   diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
}

-- there is also a sync version: vim.lsp.buf_request_sync
vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function(error, results, context, config)
 -- results is an array of lsp.CodeAction
end)
```

Resources
---------

- `A guide to setting up Vim for JavaScript development <https://freshman.tech/vim-javascript/>`_
- `JavaScript Documentation Standards <https://make.wordpress.org/core/handbook/best-practices/inline-documentation-standards/javascript/>`_
- :ghstars:`plasticboy/vim-markdown`
- Code actions: - :ghstars:`luckasRanarison/clear-action.nvim`
