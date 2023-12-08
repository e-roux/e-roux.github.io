# Pytest

This cheatsheet refers to pytest version 7


## Mark

### Registering markers

``` toml
# pyproject.toml
[tool.pytest.ini_options]
markers = [ "e2e: tests that require an external connection", ]
```

```console
pytest --markers
venv ❯ pytest --markers
@pytest.mark.e2e: tests that require an external connection
...
```

For advanced usage, markers can be:

- added [based on test names](https://docs.pytest.org/en//example/markers.html#automatically-adding-markers-based-on-test-names) using [`pytest_collection_modifyitems` hook](https://docs.pytest.org/en/stable/reference/reference.html#collection-hooks).

### Marking objects

```python
import pytest

# At module level
pytestmark = [ pytest.mark.mymark1, pytest.mark.mark2]

# individual mark
@pytest.mark.mymark
@def test_that(value):
    ...
```

## Fixtures

Links:

- Pytest [Reference](https://docs.pytest.org/en/stable/reference/fixtures.html).
- Pytest [How to use fixtures](https://docs.pytest.org/en/stable/how-to/fixtures.html#how-to-fixtures)

Fixture can be shared accross multiple files in [`conftest.py`](https://docs.pytest.org/en/stable/reference/fixtures.html#conftest-py-sharing-fixtures-across-multiple-files)

Instantiation order:

- scope
- dependencies
- autouse


```python
# Fixtures can be factories
@pytest.fixture
def make_customer_record():
    def _make_customer_record(name):
        return {"name": name, "orders": []}

    return _make_customer_record

def test_customer_records(make_customer_record):
    customer_1 = make_customer_record("Lisa")`

## Can be parametrized using the request object
@pytest.fixture(params=["Lisa", "Bob"])
def team_data(request):
    team_member_data = make_customer_record(request.param)
    yield team_member_data
    print(f"{request.param} data sent")
    ... # other stuff
```




### Built-in fixtures

`````{list-table}
:header-rows: 1
:widths: 5 20

* - Name
  - Description
* - `capfd`
  - Capture, as text, output to file descriptors 1 and 2.
* - `capfdbinary`
  - Capture, as bytes, output to file descriptors 1 and 2.
* - `caplog`
  - Control logging and access log entries.
* - `capsys`
  - Capture, as text, output to sys.stdout and sys.stderr.
* - `capsysbinary`
  - Capture, as bytes, output to sys.stdout and sys.stderr.
* - `cache`
  - Store and retrieve values across pytest runs.
* - `doctest_namespace`
  - Provide a dict injected into the docstests namespace.
* - `monkeypatch`
  - Temporarily modify classes, functions, dictionaries, os.environ, and other objects.
* - `pytestconfig`
  - Access to configuration values, pluginmanager and plugin hooks.
* - `record_property`
  - Add extra properties to the test.
* - `record_testsuite_property`
  - Add extra properties to the test suite.
* - `recwarn`
  - Record warnings emitted by test functions.
* - `request`
  - Provide information on the executing test function.
* - `testdir`
  - Provide a temporary test directory to aid in running, and testing, pytest plugins.
* - `tmp_path`
  - Provide a pathlib.Path object to a temporary directory which is unique to each test function.
* - `tmp_path_factory`
  - Make session-scoped temporary directories and return pathlib.Path objects.
* - `tmpdir`
  - Provide a py.path.local object to a temporary directory which is unique to each test function; replaced by tmp_path.
* - `tmpdir_factory`
  - Make session-scoped temporary directories and return py.path.local objects; replaced by tmp_path_factory.
`````

### Execution

Fixtures can request other fixtures

Fixtures properties can be controled through attibutes:

`````{list-table}
:header-rows: 1
:widths: 5 20

* - argument
  - decription
* - scope
  - scope for which this fixture is shared;
    one of "**function**" (default), "**class**", "**module**", "**package**" or "**session**" or [dynamic scope](https://docs.pytest.org/en/stable/how-to/fixtures.html#dynamic-scope). The fixture are destroyed based on their scope.
* - ids
  - text
* - params
  - Fixture can be parametrized with the `params` argument.
    Marks with parametrized fixtures can be used by passing a `pytest.param`

`````

```python
p3 = pytest.param(2, marks=pytest.mark.skip)

@pytest.fixture(scope="module", params=[0, 1, p3], ids=["spam", "ham"])
def a(request):
    return request.param
```

## Recipes

(recipes_fixture)=
### Fixture

`````{list-table}
:header-rows: 1
:widths: 10 20

* - Use case
  - Example
* - 
  -  ```python
     p3 = pytest.param(2, marks=pytest.mark.skip)
     
     @pytest.fixture(scope="module", params=[0, 1, p3], ids=["spam", "ham"])
     def a(request):
         return request.param
     ```

`````


### Test Exceptions

```python
from contextlib import nullcontext
import pytest
from mymodule import my_function

list
    "got,is_optional,context",
    [
        (1, 2, pytest.raises(Exception)),
        (42, 1, nullcontext()),
    ],
)
def my_test_function(got: int, want: int, context: ContextManager):
    with context:
        got = my_function(got)
        assert got == is_optional

```

## Hooks

### Bootstrapping hooks

````{list-table}
:header-rows: 1
:widths: 10 20

* - Name
  - Description
* - [`pytest_load_initial_conftests`](pytapi:#pytest.hookspec.pytest_load_initial_conftests)
  - Implement the loading of initial contest files or cli options parsing
* - [`pytest_cmdline_parse`](pytapi:#pytest.hookspec.pytest_cmdline_parse)
  - Return an initialized config object, parsing the specipied args
* - [`pytest_cmdline_main`](pytapi:#pytest.hookspec.pytest_cmdline_main)
  - Called for performing the main command line action.
````

### Initialization hooks

````{list-table}
:header-rows: 1
:widths: 10 20

* - Name
  - Description
* - [`pytest_addoption`](pytapi:#pytest.hookspec.pytest_addoption)
  - Register argparse-style options and ini-style config values.
* - [`pytest_addhooks`](pytapi:#pytest.hookspec.pytest_addhooks)
  - Called at plugin registration time.
* - [`pytest_configure`](pytapi:#pytest.hookspec.pytest_configure)
  - Allow plugins and conftest files to perform initial configuration.
* - [`pytest_unconfigure`](pytapi:#pytest.hookspec.pytest_unconfigure)
  - Called before test process is exited.
* - [`pytest_sessionstart`](pytapi:#pytest.hookspec.pytest_sessionstart)
  - Called after the Session object has been created.
* - [`pytest_sessionfinish`](pytapi:#pytest.hookspec.pytest_sessionfinish)
  - Called after whole test run finished.
* - [`pytest_plugin_registered`](pytapi:#pytest.hookspec.pytest_plugin_registered)
  - A new pytest plugin got registered.
````

### Collection hooks

````{list-table}
:header-rows: 1
:widths: 10 20

* - Name
  - Description
* - [`pytest_collection`](pytapi:#pytest.hookspec.pytest_collection)
  - Perform the collection phase for the given session.
* - [`pytest_ignore_collect`](pytapi:#pytest.hookspec.pytest_ignore_collect)
  - Return True to prevent considering this path for collection.
* - [`pytest_collect_file`](pytapi:#pytest.hookspec.pytest_collect_file)
  - Create a `Collector` for the given path, or None if not relevant.
* - [`pytest_pycollect_makemodule`](pytapi:#pytest.hookspec.pytest_pycollect_makemodule)
  - Return a `pytest.Module` collector or None for the given path.
* - [`pytest_pycollect_makeitem`](pytapi:#pytest.hookspec.pytest_pycollect_makeitem)
  - Return a custom item/collector for a Python object in a module, or None.
* - [`pytest_sessionfinish`](pytapi:#pytest.hookspec.pytest_sessionfinish)
  - Called after whole test run finished.
* - [`pytest_generate_tests`](pytapi:#pytest.hookspec.pytest_generate_tests)
  - Generate (multiple) parametrized calls to a test function.
* - [`pytest_make_parametrize_id`](pytapi:#pytest.hookspec.pytest_make_parametrize_id)
  - Return a user-friendly string representation of the given...
* - [`pytest_markeval_namespace`](pytapi:#pytest.hookspec.pytest_markeval_namespace)
  - Called when for evaluating string conditions in xfail/skipif markers.
* - [`pytest_collection_modifyitems`](pytapi:#pytest.hookspec.pytest_collection_modifyitems)
  - Called after collection has been performed. 
* - [`pytest_collection_finish`](pytapi:#pytest.hookspec.pytest_collection_finish)
  - Called after collection has been performed and modified.
````

### Test running (runtest) hooks
### Reporting hooks
### Debugging/Interaction hooks
