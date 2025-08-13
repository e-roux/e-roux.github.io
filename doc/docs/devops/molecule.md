# Molecule

Molecule <badge-stars repo='ansible-community/molecule'></badge-stars>
<badge-doc href='https://molecule.readthedocs.io'></badge-doc>  is designed to
aid in the development and testing of Ansible roles. It provides support for:

- testing with multiple instances, operating systems and distributions;
- virtualization providers;
- test frameworks and testing scenarios.


## Installation

With [pipx]:

```terminal
pipx install ansible
pipx inject --include-apps ansible 'molecule[docker]'
```

## Role initialisation

New role are initialized with the `molecule init role` command. Configuration
can contain [environment
variables](https://molecule.readthedocs.io/en/latest/configuration.html) and is
beeing loaded from:

- project config
- local config (~/.config/molecule/config.yml)
- default config (molecule.yml)

Options can be set on the command line

```terminal
Usage: molecule init role [OPTIONS] ROLE_NAME

  Initialize a new role for use with Molecule.

Options:
  --dependency-name [galaxy]      Name of dependency to initialize. (galaxy)
  -d, --driver-name [delegated|docker]
                                  Name of driver to initialize. (delegated)
  --lint-name [yamllint]          Name of lint to initialize. (yamllint)
  --provisioner-name [ansible]    Name of provisioner to initialize. (ansible)
  --verifier-name [ansible|testinfra]
                                  Name of verifier to initialize. (ansible)
  --help                          Show this message and exit.
```

Note: default [configuration](https://molecule.readthedocs.io/en/latest/configuration.html) is defined in [`molecule.config`](https://github.com/ansible-community/molecule/blob/master/molecule/config.py)





## Role metadata

Using `molecule init role <ROLE_NAME>` <badge-doc
href='https://galaxy.ansible.com/docs/contributing/creating_role.html'
logo="ansible"></badge-doc> creates a `meta/main.yaml` file storing
role informations.

!!! danger "Role name `role_name`"

    In the past, Galaxy would apply a regex expression to the GitHub repository
    name and automatically remove ‘ansible-‘ and ‘ansible-role-‘. For example,
    if your repository name was ‘ansible-role-apache’, the role name would
    translate to ‘apache’. Galaxy no longer does this automatically. Instead,
    use the role_name setting to tell Galaxy what the role name should be.

## Scenarios

Scenarios <badge-doc
href='https://molecule.readthedocs.io/en/latest/configuration.html?#molecule.scenario.Scenario'
logo='ansible'></badge-doc> are first-class citizens and can be though as
multiple test suites.  By default, scenarios are stored organized in
directories in the `molecule` project directory. A default scenario named
`default` is mandatory.
Each scenario is configured in `molecule.yml` with top level key:

- [ `dependency` ](https://molecule.readthedocs.io/en/latest/configuration.html?#dependency): dependency manager [galaxy, gilt, shell]
- [ `driver` ](https://molecule.readthedocs.io/en/latest/configuration.html?#driver): driver for spinning-up the environment to test on [delegated, docker, podman]
- [ `lint` ](https://molecule.readthedocs.io/en/latest/configuration.html?#lint): external lint commands.
- [ `platforms` ](https://molecule.readthedocs.io/en/latest/configuration.html?#platforms): instances to be tested, and the groups to which the instances belong.
- [ `provisioner` ](https://molecule.readthedocs.io/en/latest/configuration.html?#provisioner): handles provisioning and converging the role (ansible).
- [`scenario`](https://molecule.readthedocs.io/en/latest/configuration.html?#scenario): to override the defaults actions
- [ `state` ](https://molecule.readthedocs.io/en/latest/configuration.html?#state): internal bookkeeping mechanism
- [ `verifier` ](https://molecule.readthedocs.io/en/latest/configuration.html?#verifier): test suite


The `provisioner` handles provisioning and converging the role. The only
supported provisioner is ansible itself.

### Action

Action are provisionied with ansible and following subcommands are available:

```terminal
check        Use the provisioner to perform a Dry-Run (destroy,...
cleanup      Use the provisioner to cleanup any changes made to...
converge     Use the provisioner to configure instances (dependency,...
create       Use the provisioner to start the instances.
destroy      Use the provisioner to destroy the instances.
idempotence  Use the provisioner to configure the instances and parse...
prepare      Use the provisioner to prepare the instances into a...
side-effect  Use the provisioner to perform side-effects to the instances.
syntax       Use the provisioner to syntax check the role.
```

The corresponding playbooks are stored in the files whose default names are:

- "cleanup": "cleanup.yml",
- "create": "create.yml",
- "converge": "converge.yml",
- "destroy": "destroy.yml",
- "prepare": "prepare.yml",
- "side_effect": "side_effect.yml",
- "verify": "verify.yml",


Default scenarios sequences can be displayed with:

```terminal
molecule matrix <SUBCOMMAND>
```

Defaults are:

<div id="molecule_scenario"></div>

|                     | dependency | lint | cleanup | destroy | syntax | create | prepare | converge | check | idempotence | side_effect | verify | cleanup | destroy |
| ------------------- | :--:       | :-:  | :-:     | :-:     | :-:    | :-:    | :-:     | :-:      | :-:   | :-:         | :-:         | :-:    | :-:     | :-:     |
| `create_sequence`   | ✓          |      |         |         |        | ✓      | ✓       |          |       |             |             |        |         |         |
| `check_sequence`    | ✓          |      | ✓       | ✓       |        | ✓      | ✓       | ✓        | ✓     |             |             |        |         | ✓       |
| `converge_sequence` | ✓          |      |         |         |        | ✓      | ✓       | ✓        |       |             |             |        |         |         |
| `destroy_sequence`  | ✓          |      |         |         |        |        |         |          |       |             |             |        | ✓       | ✓       |
| `test_sequence`     | ✓          | ✓    | ✓       | ✓       | ✓      | ✓      | ✓       | ✓        |       | ✓           | ✓           | ✓      | ✓       | ✓       |



## Environment variables

Configuration options may contain [environment
variables](https://molecule.readthedocs.io/en/latest/configuration.html?#molecule.interpolation.Interpolator).
There are following environment variables available in `molecule.yml`:

| Variable                           | Description                                                              |
|------------------------------------|--------------------------------------------------------------------------|
| `MOLECULE_DEBUG`                   | If debug is turned on or off                                             |
| `MOLECULE_FILE`                    | Path to molecule config file                                             |
| `MOLECULE_ENV_FILE`                | Path to molecule environment file                                        |
| `MOLECULE_STATE_FILE`              | ?                                                                        |
| `MOLECULE_INVENTORY_FILE`          | Path to generated inventory file                                         |
| `MOLECULE_EPHEMERAL_DIRECTORY`     | Path to generated directory, usually `~/.cache/molecule/<scenario-name>` |
| `MOLECULE_SCENARIO_DIRECTORY`      | Path to scenario directory                                               |
| `MOLECULE_PROJECT_DIRECTORY`       | Path to your project directory                                           |
| `MOLECULE_INSTANCE_CONFIG`         | ?                                                                        |
| `MOLECULE_DEPENDENCY_NAME`         | Dependency type name, usually 'galaxy'                                   |
| `MOLECULE_DRIVER_NAME`             | Name of the molecule scenario driver                                     |
| `MOLECULE_PROVISIONER_NAME`        | Name of the provisioner tool (usually 'ansible')                         |
| `MOLECULE_REPORT`                  | Name of HTML file where to dump execution report.                        |
| `MOLECULE_SCENARIO_NAME`           | Name of the scenario                                                     |
| `MOLECULE_VERBOSITY`               | Determine Ansible verbosity level.                                       |
| `MOLECULE_VERIFIER_NAME`           | Name of the verifier tool (usually 'ansible')                            |
| `MOLECULE_VERIFIER_TEST_DIRECTORY` | ?                                                                        |

## Links

- [ Jeff Geerling's blog ](https://www.jeffgeerling.com/blog/2018/testing-your-ansible-roles-molecule)
- [Fabian von Feilitzsch - Practical Ansible Testing with Molecule](https://www.ansible.com/hubfs//AnsibleFest%20ATL%20Slide%20Decks/Practical%20Ansible%20Testing%20with%20Molecule.pdf)

# FAQ

[ERROR! no action detected in task](https://stackoverflow.com/questions/47159193/why-does-ansible-show-error-no-action-detected-in-task-error)


[pipx]: https://pipxproject.github.io/pipx
