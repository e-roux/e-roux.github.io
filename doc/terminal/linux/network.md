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


## Utils

- **mtr** <badge-stars repo="traviscross/mtr"></badge-stars> determines the address of each network hop between the machines, it sends a sequence of ICMP ECHO requests to each one to determine the quality of the link to each machine.


### Resources

**Displaying IP address on eth0 interface**
```
ifconfig eth0 | grep "inet ad" | cut -d ':' -f 2 | cut -d ' ' -f 1
```

[18 commands to monitor network bandwith on Linux server](https://www.binarytides.com/linux-commands-monitor-network/)
[Red Hat blog: Introduction to Linux interfaces for virtual networking](https://developers.redhat.com/blog/2018/10/22/introduction-to-linux-interfaces-for-virtual-networking)
