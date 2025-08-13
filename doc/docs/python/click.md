# Click

Click <badge-stars repo='pallets/click'></badge-stars> <badge-doc href='https://click.palletsprojects.com/en/7.x/#documentation'></badge-doc> is a Python package for creating command line interfaces in a composable way with as little code as necessary.

## Decorator based functionality

## Commands and groups

A hierarchy of command and subcommands can be achieved with `@click.command` and `@click.group`. Both decorates a function and use it as callback. When using a function as group and latter on an other as command, the last one will be decorated with the first one that inherits from `click`. 

??? Example

	```python
	import click

	@click.group()
	@click.version_option()
	def acl():
		"""Asam Command Line."""
		...


	@acl.group()
	def mdf():
		"""Manages mdf and is called with `acl mdf`"""
		...


	@mdf.group()
	def create():
		"""Create mdf and is called with `acl mdf create`"""
		...
	```



## Parameters

[**parameters**](https://click.palletsprojects.com/en/7.x/api/#parameters) are of two types:

- **options**, usually optional passed with or without value as flags, e.g. *--debug*: `@click.option('--debug/--no-debug', default=False)`<br/>
- **arguments**: are positional parameters to a command, generally provide fewer features than options but can have infinite nargs and are required by default. Ex: `@click.argument("x", type=float)`

## API

### Decorators

`click`.command(*name=None, cls=None, \*\*attrs*)<br/>
 `click`.group(*name=None, \*\*attrs*)<br/>
`click`.argument(*\*param_decls, \*\*attrs*)<br/>
`click`.option(*\*param_decls, \*\*attrs*)<br/>
`click`.password_option(*\*param_decls, \*\*attrs*)<br/>
`click`.confirmation_option(*\*param_decls, \*\*attrs*)<br/>
`click`.version_option(*version=None, \*param_decls, \*\*attrs*)<br/>
`click`.help_option(*\*param_decls, \*\*attrs*)<br/>
`click`.pass_context(*f*)<br/>
`click`.pass_obj(*f*)<br/>
`click`.make_pass_decorator(*object_type, ensure=False*)<br/>

### Utilities

`click`.echo(*message=None, file=None, nl=True, err=False, color=None*)<br/>
`click`.echo_via_pager(*text_or_generator, color=None*)<br/>
`click`.prompt(*text, default=None, hide_input=False, confirmation_prompt=False, type=None, value_proc=None, prompt_suffix=': ', show_default=True, err=False, show_choices=True*)<br/>
`click`.confirm(*text, default=False, abort=False, prompt_suffix=': ', show_default=True, err=False*)<br/>
`click`.progressbar(*iterable=None, length=None, label=None, show_eta=True, show_percent=None, show_pos=False, item_show_func=None, fill_char='#', empty_char='-', bar_template='%(label*) [%(bar)s] %(info)s', info_sep=' ', width=36, file=None, color=None)¶<br/>
`click`.clear()<br/>
`click`.style(*text, fg=None, bg=None, bold=None, dim=None, underline=None, blink=None, reverse=None, reset=True*)<br/>
`click`.unstyle(*text*)<br/>
`click`.secho(*message=None, file=None, nl=True, err=False, color=None, \*\*styles*)<br/>
`click`.edit(*text=None, editor=None, env=None, require_save=True, extension='.txt', filename=None*)<br/>
`click`.launch(*url, wait=False, locate=False*)<br/>
`click`.getchar(*echo=False*)<br/>
`click`.pause(*info='Press any key to continue ...', err=False*)<br/>
`click`.get_terminal_size()<br/>
`click`.get_binary_stream(*name*)<br/>
`click`.get_text_stream(*name, encoding=None, errors='strict'*)
`click`.open_file(*filename, mode='r', encoding=None, errors='strict', lazy=False, atomic=False*)<br/>
`click`.get_app_dir(*app_name, roaming=True, force_posix=False*)<br/>
`click`.format_filename(*filename, shorten=False*)<br/>

