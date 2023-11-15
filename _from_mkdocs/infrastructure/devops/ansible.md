# Ansible

<img src='https://upload.wikimedia.org/wikipedia/commons/2/24/Ansible_logo.svg' class='titleLogo' alt='logo'/>

Global configuration is in `/etc/ansible`

By default, Ansible will try to use native OpenSSH for remote communication when
possible. This enables
[ControlPersist](https://man.openbsd.org/ssh_config.5#ControlPersist)[^1],
Kerberos, and options in `~/.ssh/config` such as Jump Host setup.

## Variables

Variable names should be letters, numbers, and underscores. Variables should
always start with a letter. YAML also supports dictionaries which [map keys to
values](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#creating-valid-variable-names).

Variables can be defined in:

- inventories
- playbooks

and later be used in playbooks using the Jinja2 templating system.

### [Ansible Facts](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variables-discovered-from-systems-facts): system variables

As well as with the `ansible_facts` variable, facts are variables discovered
from systems.

```console
$ ansible localhost -m setup
127.0.0.1 | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            ...
    "changed": false
}

$ ansible localhost -m setup -a "filter=*arch*"
127.0.0.1 | SUCCESS => {
    "ansible_facts": {
        "ansible_architecture": "x86_64",
        "ansible_userspace_architecture": "x86_64"
    },
    "changed": false
}
```

## Playbooks

The goal of a playbook is to map a group of hosts to some well defined roles,
represented by things ansible calls tasks.
[Basic elements](https://docs.ansible.com/ansible/latest/reference_appendices/playbooks_keywords.html)

### Task

A task is in its simple form triggers the executing of a module, with specific
arguments. Tasks can be [condionally executed]( https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html),
[looped](https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html).
Logical grouping of tasks can be organised in
[`blocks`](https://docs.ansible.com/ansible/latest/user_guide/playbooks_blocks.html).
[Variables](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html)
can be used in arguments to modules. Modules should be idempotent and changes
trigger
[`handlers`](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html#handlers-running-operations-on-change).

### Handlers

 Modules can relay when they have made a change on the remote system: `notify`.

### loops

`loop` is prefered over `with_*` (not deprecated)

[Best practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

Run a [*playbook*](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html) and load password stored in vault

```bash
ansible-playbook --ask-vault-pass --extra-vars '@/etc/ansible/vault.yml' oh-my-zsh.yml
```

Specifying an inventory file

```console
ansible-playbook -i inventories/hosts --ask-vault-pass --extra-vars '@/etc/ansible/vault.yml' oh-my-zsh.yml
```

## Inventory

Variables can be [assigned](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#assigning-a-variable-to-one-machine-host-variables) to hosts

```console
[atlanta]
host1 http_port=80 maxRequestsPerChild=808
host2 http_port=303 maxRequestsPerChild=909
```

## Roles

[Roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) are ways of automatically loading certain vars_files, tasks, and handlers based on a known file structure. Grouping content by roles also allows easy sharing of roles with other users.

A role is distributed as directory structure and contains at least one of the following directory, containing itself a `main.yml` that will be added to the playbook.

- `tasks` - contains the main list of tasks to be executed by the role.
- `handlers` - contains handlers, which may be used by this role or even anywhere - outside this role.
- `defaults` - default variables for the role (see Using Variables for more - information).
- `vars` - other variables for the role (see Using Variables for more information).
- `files` - contains files which can be deployed via this role.
- `templates` - contains templates which can be deployed via this role.
- `meta` - defines some meta data for this role. See below for more details.

### Role dependencies

 <https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html#role-dependencies>

### List roles

The command `ansible-galaxy list -p roles` outputs list of roles in the roles directory and warnings about missing directories

### Import and include role in playbooks

The module [`import_role`](https://docs.ansible.com/ansible/latest/modules/import_role_module.html) and [`include_role`](https://docs.ansible.com/ansible/latest/modules/include_role_module.html). On import, keywords, loops and conditionals will only be applied to the imported tasks, not to this statement itself.

### Install multiples roles

```console
ansible-galaxy install -r requirements.yml
```

`requirements.yml` specification can be found in the official [documentation](https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html#installing-multiple-roles-from-a-file).

## Debug

[Print variables](https://gryzli.info/2017/12/21/ansible-debug-print-variables)

Print all variables in debug mode (flag `-vvvv`)

```yaml
- name: "Ansible | List all known variables and facts"
  debug:
    var: hostvars[inventory_hostname]
```

## Ansible-galaxy




Get the number of distribution (`platforms` key in metadata)

```console
$ curl  https://galaxy.ansible.com/api/v1/platforms/ | jq '.results | group_by(.name)[] | {key: .[0].name, length: length}'
```
## Notes

[^1]: Note on this in [post](https://www.quora.com/What-is-the-controlpersist-feature-Unix)
