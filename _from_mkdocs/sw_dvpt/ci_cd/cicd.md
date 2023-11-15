# CI/CD

- [ Continuous Integration
  ](https://en.wikipedia.org/wiki/Continuous_integration) ensure an application build and test triggered by defined changes.


Continuous Integration/Delivery

![whatis](https://about.gitlab.com/images/blogimages/cicd_pipeline_infograph.png)

## with `pre-commmit`

<badge-stars repo='pre-commit/pre-commit'></badge-stars> <badge-doc href='https://pre-commit.com/'></badge-doc> is a command line utility - `pre-commit` aliased `pc` - that can be used for automation of the creation of [git pre-commit hook](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks).

!!! Quote "What is a git pre-commit hook?"

    It's used to inspect the snapshot that’s about to be committed, to see if
    you’ve forgotten something, to make sure tests run, or to examine whatever you
    need to inspect in the code. Exiting non-zero from this hook aborts the commit.


`pre-commmit` stores its config in a yaml file `.pre-commit-config.yaml` whose root value is `repos`. A template can be generated with:

```bash
pre-commit sample-config > .pre-commit-config.yaml
```

and the script is installed with:

```bash
pre-commit install
```

Some [hooks]() are available for various purpose:

### General

Some ["built-in" hooks](https://github.com/pre-commit/pre-commit-hooks#hooks-available) are provided with pre-commit.

??? Example

	```yaml
	- repo: https://github.com/pre-commit/pre-commit-hooks
	  rev: v2.4.0
	  hooks:
		- id: end-of-file-fixer
		- id: trailing-whitespace
	```

### Code style

#### Isort

??? Example

	```yaml
	- repo: https://github.com/psf/black
	  rev: v3.3.0
	  hooks:
		- id: isort
	```

#### Black

??? Example

	```yaml
	- repo: https://github.com/psf/black
	  rev: v3.3.0
	  hooks:
		- id: black
	```

### Lint

#### yamllint

??? Example

	```yaml
	- repo: https://github.com/adrienverge/yamllint
	  rev: v1.25.0
	  hooks:
		- id: yamllint
	```

#### flake8

??? Example

	```yaml
	- repo: https://gitlab.com/pycqa/flake8
	  rev: 3.8.1
	  hooks:
		- id: flake8
		  additional_dependencies: [flake8-bugbear]
	```

### Code checker

### MyPy

??? Example

	```yaml
	- repo: https://github.com/pre-commit/mirrors-mypy
	  rev: v0.770
	  hooks:
		- id: mypy
		  exclude: ^docs/conf.py
	```
