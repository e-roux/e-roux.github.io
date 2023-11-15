# Network

## Basics

The [OSI (Open Systems Interconnection)](https://en.wikipedia.org/wiki/OSI_model) uses seven layers,
- physical layer (layer 1)
- network layer (layer 3)
- transport layer (layer 4)
- application layer (layer 7)


### SASL/GSSAPI

#### SASL: *Simple Authentification and Security Layer*

Framework  authentication and data security in Internet protocols. It decouples authentication mechanisms from application protocols:

- developpers can implement different authentication mechanisms
- clients and servers can negociate a mutulaly acceptable exchange mechanism

#### GSSAPI: *Generic Secutrity Services Application Program Interface*

### Kerberos

From [Wikipedia](https://en.wikipedia.org/wiki/Kerberos_(protocol)) and [some python notes](http://python-notes.curiousefficiency.org/en/latest/python_kerberos.html):

- After login on the client machine, the client transform the password into the key of a symmetric cipher
The AS becomes the request and uses the password to decrypt the request: the user is **verified**.

- **User Client-based Login**

	The client authenticates itself to the **Authentication Server (AS)**:

	- Client sends an unauthenticated request to the server
	- Server sends back a 401 response with a `WWW-Authenticate: Negotiate` header with no authentication details

- **Client Authentication**
		which forwards the username to a **key distribution center (KDC)**. The KDC
issues a **ticket-granting ticket (TGT)**, which is time stamped and encrypts
it using the **ticket-granting service's (TGS)** secret key and returns the
encrypted result to the user's workstation.


The Ticket Granting Ticket (TGT) encrypted with another secret key
- **Client Authentication**


- Client sends a new request with an `Authorization: Negotiate` header
- Server checks the `Authorization` header against the Kerberos infrastructure and either allows or denies access accordingly. If access is allowed, it should include a `WWW-Authenticate: Negotiate` header with authentication details in the reply.
- Client checks the authentication details in the reply to ensure that the request came from the server



![Kerberos](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-6-Managing_Smart_Cards-en-US/images/d314590391f06f79ad4bc8433ab5480a/kerberos.png)


#### `kinit` and `klist`




## Utils

- **mtr** <badge-stars repo="traviscross/mtr"></badge-stars> determines the address of each network hop between the machines, it sends a sequence of ICMP ECHO requests to each one to determine the quality of the link to each machine.


### Resources

**Displaying IP address on eth0 interface**
```
ifconfig eth0 | grep "inet ad" | cut -d ':' -f 2 | cut -d ' ' -f 1
```

[18 commands to monitor network bandwith on Linux server](https://www.binarytides.com/linux-commands-monitor-network/)
[Red Hat blog: Introduction to Linux interfaces for virtual networking](https://developers.redhat.com/blog/2018/10/22/introduction-to-linux-interfaces-for-virtual-networking)
