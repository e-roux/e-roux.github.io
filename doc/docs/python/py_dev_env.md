# Python packaging and development environment


The [Python packaging user guide](https://packaging.python.org/) <badge-doc
href='https://packaging.python.org/overview/' logo='python'> </badge-doc>
contains numerous resources, including:

- A list of [key projects](https://packaging.python.org/key_projects/)
- tutorials:

    - [installing packages](https://packaging.python.org/tutorials/installing-packages/)
    - [managing app. dependencies](https://packaging.python.org/tutorials/managing-dependencies/)
    - [packaging projects](https://packaging.python.org/tutorials/installing-packages/)
    - [creating documentation](https://packaging.python.org/tutorials/creating-documentation/)

## Packaging


### distutils

Collection of utilities from the standard library for packaging and
distributing Python packages, including compilation of native extension
modules. <badge-pep nr='632'></badge-pep> deprecates its usage, removal planed
for python 3.12.

### Setuptools

`Setuptools` <badge-stars repo='pypa/setuptools'></badge-stars> <badge-doc
href='https://setuptools.readthedocs.io/en/latest/'></badge-doc> is a collection
of enhancements to the Python `distutils`.

### `pyproject.toml`

This file, topic of <badge-pep nr='518'></badge-pep> lists the minimal
dependencies of the build system of a project in a declarative fashion.

<badge-pep nr='517'></badge-pep> add precisions on the build system interface,
by default `setuptools` <badge-doc
href='https://pip.pypa.io/en/stable/reference/pip/#build-system-interface'></badge-doc>.
In this case, and if `setup.py` is missing <badge-doc
href='https://setuptools.readthedocs.io/en/latest/setuptools.html#setup-cfg-only-projects'></badge-doc>,
setuptools emulates a dummy `setup.py` file containing only a
`setuptools.setup()` call.

<badge-pep nr='621'></badge-pep> defines stored metadata.

<badge-pep nr='631'></badge-pep> defines defined dependencies.

??? Cite "About PEP 0518"

    [distutils](https://docs.python.org/3/library/distutils.html#module-distutils)
    When Python first developed its tooling for building distributions of
    software for projects, was the chosen solution. As time went on,
    [setuptools](https://pypi.python.org/pypi/setuptools) gained popularity to
    add some features on top of distutils. Both used the concept of a setup.py
    file.

#### Tables

#### `build-system`

`[build-system]` table is used to store build-related data. Initially only one
key of the table will be valid and is mandatory for the table: `requires`.


A *build frontend* is a tool that users might run that takes arbitrary source
trees or source distributions and builds wheels from them. The actual building
is done by each source tree's *build backend*. In a command like pip wheel
some-directory/, pip is acting as a build frontend.

??? Example


    Usage with `setuptools`

      ```toml
      [build-system]
      # Minimum requirements for the build system to execute.
      requires = ["setuptools", "wheel"]
      # PEP 508 specifications.
      # This key is not mandatory as setuptools is default
      build-backend = "setuptools.build_meta"
      ```

    Usage with `poetry`

      ```toml
      [build-system]
      requires = ["poetry_core>=1.0.0"]
      build-backend = "poetry.core.masonry.api"
      ```

Tools should not require the existence of the `[build-system]` table. A
`pyproject.toml` file may be used to store configuration details other than
build-related data and thus lack a `[build-system]` table legitimately.

**Build backend interface**

In case a custom build backend interface is specified, [mandatory
hooks](https://www.python.org/dev/peps/pep-0517/#mandatory-hooks) -
`build_wheel` and `build_sdist` - must be specified. [Optional
hooks](https://www.python.org/dev/peps/pep-0517/#optional-hooks)

#### `tool`

The `[tool]` table is where any tool related to your Python project, not just
build tools, can have users specify configuration data as long as they use a
sub-table within `[tool]`, e.g. the flit tool would store its configuration in
`[tool.flit]`.

 Packaging



[Blog post](https://snarky.ca/what-the-heck-is-pyproject-toml/)






### Pip

Pip <badge-stars repo='pypa/pip'></badge-stars> <badge-doc
href="https://pip.pypa.io/en/stable"></badge-doc> is the package installer for
Python.

### Wheel

This library <badge-stars repo='pypa/wheel'></badge-stars> <badge-doc
href="https://wheel.readthedocs.io/"></badge-doc> <badge-pep
nr='427'></badge-pep> <badge-pep nr='425'></badge-pep> is the reference
implementation of the Python wheel packaging standard, as defined in PEP 427. It
has two different roles:

- A setuptools extension for building wheels that provides the bdist_wheel
  setuptools command
- A command line tool for working with wheel files

### PyOxyder

PyOxyder <badge-stars repo='indygreg/PyOxidizer'></badge-stars> <badge-doc
href='https://pyoxidizer.readthedocs.io'></badge-doc> is a utility for producing
binaries that embed Python.

It can be used in case of virtualenv with symlink to the python interpreter
(e.g. in the case of pipx)

### PyInstaller

PyInstaller <badge-stars repo='pyinstaller/pyinstaller'></badge-stars>
<badge-doc href='https://pyoxidizer.readthedocs.io'></badge-doc> bundles a
Python application and all its dependencies into a single package.

## Python version management: `pyenv`

`Pyenv` <badge-stars repo='pyenv/pyenv'></badge-stars> intercepts Python
commands using shim executables injected into your PATH, determines which Python
version has been specified by your application, and passes the commands along
to the correct Python installation.

### Installation

<badge-doc href='https://github.com/pyenv/pyenv#basic-github-checkout'>
</badge-doc>

Installation can be perfomed with a git checkout:

```terminal
git clone https://github.com/pyenv/pyenv.git ~/.opt/pyenv
```

Path to pyenv must be set in `PATH`, prompt is disabled

```terminal
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

export PYENV_ROOT=$HOME/.opt/pyenv
export PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
```

Before installing python runtimes,
[dependencies](https://github.com/pyenv/pyenv/wiki#suggested-build-environment)
must be installed. `CONFIGURE_OPTS` as well as `http_proxy` and `https_proxy`
can be passed to installation.

**Completion** can be installed for zsh from the checked-out repository.

```terminal
install -m 644 completions/pyenv.zsh ~/.zsh/completion/_pyenv
```

### Version management

Global and local python version are supported. Multiple version support can be
enabled:

  ```terminal
  # Ensure those versions will have precedence
  pyenv global 3.8.7 3.9.1 3.7.8 miniconda3-4.7.12

  python3.8 --version
  # Returns 3.8.7
  ```

Version superseed is made with:

```terminal
# set this version in .python-version
pyenv local 3.9.0
# or
export PYENV_VERSION=3.9.0
```

## Application Dependency management: `poetry`

<badge-stars repo='python-poetry/poetry'></badge-stars> <badge-doc
href="https://python-poetry.org/docs/"></badge-doc> is a tool for dependency
management and packaging.

**basic usage** <badge-doc
href='https://python-poetry.org/docs/basic-usage/'></badge-doc> :

!!! Example

    ```terminal
    # Create a new project
    poetry new <PROJECT_NAME>

    # Or init from an existing project
    poetry init

    # Add dependencies
    poetry add <DEP>

    # Install the dependencies
    poetry install

    # Run a command inside the env
    poetry run <COMMAND> <PARAMETERS>
    ```

!!! Important ""

    If already in a virtualenv, poetry will reuse it and will not create a new
    env. Linked environments can be displayed with `poetry env list`.


**Shell completion (zsh)**

```terminal
poetry completions zsh > ~/.zsh/completion/_poetry
```

#### Virtual environments

##### Pipenv

<badge-stars repo='pypa/pipenv'></badge-stars> <badge-doc href="https://pipenv-fork.readthedocs.io"></badge-doc>

[editable-dependencies](https://pipenv-fork.readthedocs.io/en/latest/basics.html#editable-dependencies-e-g-e)

```terminal
pipenv install --dev -e .
```

## Application manager: `pipx`

**pipx** <badge-stars repo='pipxproject/pipx'></badge-stars>
<badge-doc href="https://pipxproject.github.io/pipx"></badge-doc> installs and
run python applications in isolated environments.

### Update

#### Update packages: `upgrade`

```shell
pipx upgrade jupyterlab
# with injected dependencies
pipx upgrade --include-injected jupyterlab
```

#### Update python version: `reinstall`

Python version can be updated with the `reinstall` subcommand

```shell
pipx list --json \
  | jq -r '''.venvs
    | with_entries(select(.value | .metadata.python_version=="Python 3.9.2"))
    | keys
    | .[]
    '''' \
  | while read line; do
      pipx reinstall --python python3.9 $line;
    done
```
