---
title: "Connect and Configure Some Datastores"
date: 2021-12-23T06:48:29+01:00
draft: false
tags:
 - keychain
 - database
---

## Postgres

[Environment variables](https://www.postgresql.org/docs/9.1/libpq-envars.html) help configure the connection string, SSL and KRB5. Among them `PGPASSWORD` can be set to a script to pass the DB password. E.g. on a mac, using mac OS keychain:

```shell
# Be sure first to have added the password
security add-generic-password -l <KEYCHAINLABEL> -a <PGUSER> -s <PGHOSTADDR> -w <PGPASSWORD>

PGPASSWORD=$(security find-generic-password -a <PGUSER> -s <PGHOSTADDR> -w) pgcli -h <PGHOSTADDR> -U <PGUSER> -w <PGDATABASE>
```

### cli clients

{{% badge/github repo="dbcli/pgcli" %}} provides

![img](https://github.com/dbcli/pgcli/raw/master/screenshots/pgcli.gif)
