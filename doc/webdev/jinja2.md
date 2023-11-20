# Jinja2

## High level API

::::{tab-set}

:::{tab-item}  Environment 
(Environment)=
[`Environment`](jinapi:#jinja2.Environment)
is a central class whose instances grant access to configuration and globals:

- delimiters:
    - `block_start_string`/`block_end_string`, defaults to `{%`/`%}`
    - `variable_start_string`/`variable_end_string`, defaults to `{{`/`}}`
    - `comment_start_string`/`comment_end_string`, default to `{#`/`#}`
- prefix definition:
    - `line_statement_prefix`
    - `line_comment_prefix`
    - ...
- cache control
    - `cache_size` control the number of templates to be cached
    - `auto_reload` enables template changes on source
    - ...
- behavior:
    - `loader` sets the [loader](jinapi:#loaders)
    - `finalize` for variable expression post processing
    - `enable_async` for async functions and generators usage in templates.
- variable definition:
    - [globals](jinapi:#jinja2.Environment.globals)

```{important}
Because of its nature, `Environment` instances should only be modified if they
are not shared and if no template was loaded so far.
```

Several attributes and parameters are available, see the
[documentation](jinapi:#jinja2.Environment)

```python
from jinja2 import Environment, PackageLoader
env = Environment(
    loader=PackageLoader("yourapp"),
)

# Get a template
template = env.get_template("mytemplate.html")

# Render it
template.render(the="variables", go="here")
```
:::

:::{tab-item} Template

Normaly generated from an `Environment`, can



```python
template = Template('Hello {{ name }}!')

template.render(name='John Doe') == u'Hello John Doe!'
True

stream = template.stream(name='John Doe')

next(stream) == u'Hello John Doe!'
True

next(stream)
Traceback (most recent call last):
    ...
StopIteration
```
:::

:::{tab-item} TemplateStream

...
:::

::::

::::{tab-set}

:::{tab-item} Context

A [context](jinapi:#the-context) holds
the variables of a template: values and public names it export. It defines
various attributes:

- `parent`, a dict of read only, global variables the template looks up
- `vars`, template local variables
- `environment` whose belongs the context
- `name` of the template owning the context
- `exported_vars`
- `call` for calling a callable and passing parameters
- ...
:::

:::{tab-item} Loaders

Subclass of [ `BaseLoader`
](jinapi:#jinja2.BaseLoader), they are
responsible for loading resources such as the file system. Builtin loaders:

- `FileSystemLoader` load templates from a directory in the file system.
- `PackageLoader` load templates from a directory in a Python package.
- `DictLoader` loads a template from a Python dict mapping template names to
  template source.
- `FunctionLoader`
- ...
:::

::::


### [ Autoescaping ](jinapi:#autoescaping)

### [Utilities](jinapi:#utilities)

### [exceptions](jinapi:#exceptions)


## Templates

https://jinja.palletsprojects.com/en/stable/templates/

### Basic syntax

#### Delimiters

Defined in the [`Environment`](jinapi:#environment), theirs default:

- `{% ... %}` for Statements
- `{{ ... }}` for Expressions to print to the template output
- `{# ... #}` for Comments not included in the template output
- `#  ... ##` for Line Statements

#### Variables

Defined by the [`Context`](jinapi:#context) passed to the template. The are [leveraging
](jinapi:#variables)
python attributes and item object access, defaulting to an undefined object.

#### Filters

Enables variables modification. Can accept arguments in parentheses. [Builtin
list](jinapi:#builtin-filters)

#### Tests

Implemented with the token `is`. [Buildin
list](jinapi:#builtin-tests)

```jinja
{% if loop.index is divisibleby(3) %}
```

#### Whitespace control

Language blocks are removed when the template is rendered but whitespaces remain
in place.

Striping can be configuring at the [`Environment`](jinapi:#Environment) level with
`trim_blocks` and `lstrip_blocks`. They can also be manualy activated or
deactivated with `+` and `-` symbols at block start and end level.

```jinja
{% for item in seq -%}
    {{ item }}
{%- endfor %}
```

#### Escaping
