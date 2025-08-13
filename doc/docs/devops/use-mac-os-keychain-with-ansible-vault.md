---
title: "Use Mac Os Keychain With Ansible Vault"
date: 2021-12-22T20:37:30+01:00
tags:
  - keychain
  - devops
  - ansible
  - vault
draft: false
resources:
  - name: Ansible vault documentation
    href: https://docs.ansible.com/ansible/latest/user_guide/vault.html
  - name: Handling secrets in your Ansible playbooks
    href: https://www.redhat.com/sysadmin/ansible-playbooks-secrets
---

Vault passwords [can be kept](https://docs.ansible.com/ansible/latest/user_guide/vault.html#storing-passwords-in-third-party-tools-with-vault-password-client-scripts) on an external system and retrieved by a script.


https://docs.ansible.com/ansible/latest/plugins/lookup.html
https://www.middlewareinventory.com/blog/category/ansible/page/2/

| Name     | Usage                                  |
|----------|----------------------------------------|
| file     | Content of File                        |
| password | Randomly Generate a password           |
| pipe     | The output of Locally executed Command |
| env      | Environment Variable                   |
| template | Jinja2 template after evaluation       |
| csvfile  | Entry in a .csv file                   |
| dnxtxt   | DNS TXT record                         |
| redis_kv | Redis Key Lookup                       |
| etcd     | ETCD key Lookup                        |


https://stackoverflow.com/questions/50168647/multiprocessing-causes-python-to-crash-and-gives-an-error-may-have-been-in-progr
