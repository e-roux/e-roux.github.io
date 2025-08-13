# MongoDB

<img src='https://upload.wikimedia.org/wikipedia/commons/9/93/MongoDB_Logo.svg' class='titleLogo' alt='logo'/>

Notation:

- field path: `$fieldName`
- system variable: `$$UPPERCASE`
- user variable: `$$foo`

[mongod](https://docs.mongodb.com/manual/reference/program/mongod/) is the main daemon process for mongoDB. Interaction is not performed directly but through a driver. Basic flags for the cli: `--port`/`--dbpath`/`--logpath`/`--fork`. Server shutdown is performed with `db.shutdownServer` after selecting the admin db (`use admin`).

Configuration file:

## Jupyter kernel imongo

[imongo](https://github.com/fesaille/imongo)

[ipython wrapper kernel](https://ipython.readthedocs.io/en/stable/development/wrapperkernels.html)
[Jupyter messenging doc](https://jupyter-client.readthedocs.io/en/latest/messaging.html#introduction)

http://zguide.zeromq.org/page:all
