# Kerberos

**Kerberos** <badge-stars repo='krb5/krb5'></badge-stars> (mirror) <badge-doc
href='https://web.mit.edu/kerberos/krb5-latest/doc/'></badge-doc>  is a network
authentication protocol. It provides a strong authentication for client/server
applications by using secret-key cryptography.

For ticket management at the user level <badge-doc href='https://web.mit.edu/kerberos/krb5-latest/doc/user/index.html'></badge-doc> some utilities are available:

- `kinit` obtains and caches an initial ticket-granting ticket for
  principal. If principal is absent, kinit chooses an appropriate principal name
  based on existing credential cache contents or the local username of the user
  invoking kinit.

  ```terminal
  > kinit <PRINCIPAL>

  > kinit -kt <KEYTAB> <PRINCIPAL>
  ```

- `klist` lists the Kerberos principal and Kerberos tickets held in a
  credentials cache, or the keys held in a keytab file.

  ```terminal
  > klist

  > klist -k <KEYTAB>
  ```

- `kdestroy` destroys the user’s active Kerberos authorization tickets by
  overwriting and deleting the credentials cache that contains them. If the
  credentials cache is not specified, the default credentials cache is
  destroyed.

- `ktutil` invokes a command interface from which an administrator can read,
  write, or edit entries in a keytab.


Some [ environment variables
](https://web.mit.edu/kerberos/krb5-latest/doc/user/user_config/kerberos.html#environment-variables)
control KRB5 behavior, e.g.:

- `KRB5_CONFIG`, specifying  the location of the Kerberos configuration file.
  The default is `SYSCONFDIR/krb5.conf`.
- `KRB5CCNAME` holds the name for the credentials cache file, default to
  `/tmp/krb5cc_$(ud -u)`. Can be used to switch context between users.
