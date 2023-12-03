# Kerberos

[Kerberos](wiki:Kerberos_(protocol)) is a network
authentication protocol based on ticket. It provides a strong authentication
for client/server applications by using secret-key cryptography.

From [Wikipedia](wiki:Kerberos_(protocol)) and [some python notes](http://python-notes.curiousefficiency.org/en/latest/python_kerberos.html):

## Protocol short description

Verification
: After login on the client machine, the client transform the password into the key of a symmetric cipher
The **Authentication Server (AS)** becomes the request and uses the password to decrypt the request: the user is **verified**.

User Client-based Login
: The client authenticates itself to the AS.

	- Client sends an unauthenticated request to the server
	- Server sends back a 401 response with a `WWW-Authenticate: Negotiate` header with no authentication details

Client Authentication
: forwards the username to a **key distribution center (KDC)**. The KDC
issues a **ticket-granting ticket (TGT)**, which is time stamped and encrypts
it using the **ticket-granting service's (TGS)** secret key and returns the
encrypted result to the user's workstation.


The Ticket Granting Ticket (TGT) encrypted with another secret key
- **Client Authentication**


- Client sends a new request with an `Authorization: Negotiate` header
- Server checks the `Authorization` header against the Kerberos infrastructure and either allows or denies access accordingly. If access is allowed, it should include a `WWW-Authenticate: Negotiate` header with authentication details in the reply.
- Client checks the authentication details in the reply to ensure that the request came from the server

![Kerberos](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-6-Managing_Smart_Cards-en-US/images/d314590391f06f79ad4bc8433ab5480a/kerberos.png)

## Utilities

For ticket management at the user level <badge-doc href='https://web.mit.edu/kerberos/krb5-latest/doc/user/index.html'></badge-doc> some utilities are available:

- `kinit` obtains and caches an initial ticket-granting ticket for
  principal. If principal is absent, kinit chooses an appropriate principal name
  based on existing credential cache contents or the local username of the user
  invoking kinit.

  ```shell
  > kinit <PRINCIPAL>

  > kinit -kt <KEYTAB> <PRINCIPAL>
  ```

- `klist` lists the Kerberos principal and Kerberos tickets held in a
  credentials cache, or the keys held in a keytab file.

  ```shell
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
