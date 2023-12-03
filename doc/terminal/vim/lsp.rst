Language Server Protocol
========================


Short intro
-----------

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

.. code-block:: lua

    :lua =vim.lsp.get_active_clients()[1].server_capabilities

Server capabilites commonly used:

- :code:`vim.lsp.buf.hover()`
- :code:`vim.lsp.buf.format()`
- :code:`vim.lsp.buf.references()`
- :code:`vim.lsp.buf.implementation()`
- :code:`vim.lsp.buf.code_action()`
