# Pytest

## Configuration

Three files:

- `pytest.ini`
- `tox.ini`
- `setup.cfg`
    - this part of the configuration can be put in `pyproject.toml` sections
      `[pytest]` or `[tool:pytest]`.
    - can be superseded at the cli with the flag `-o`.


## Test discovery

If no argument at cli,


## Fixture

### Documentation


```python
import pytest

@pytest.fixture
def myfixture():
    '''Declare my fixture for my test purpose'''
    return Object()

```
