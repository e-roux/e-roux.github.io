# Typing

## History

PEPS:

- **Literature Overview for Type Hints** <badge-pep nr='482'></badge-pep>
- **Theory of Type Hints** <badge-pep nr='483'></badge-pep>
- **Type Hints** <badge-pep nr='484'></badge-pep> <badge-stars repo='python/typing'></badge-stars>
- **Syntax for Variable Annotations** <badge-pep nr='526'></badge-pep>
- **Protocols: Structural subtyping** <badge-pep nr='544'></badge-pep>
- **Distributing and Packaging Type Information** <badge-pep nr='561'></badge-pep>
- **Postponed Evaluation of Annotations** <badge-pep nr='563'></badge-pep>
- **Literal types** <badge-pep nr='586'></badge-pep>
- **TypedDict** <badge-pep nr='589'></badge-pep>
- **Final qualifier** <badge-pep nr='591'></badge-pep>
- **Flexible variable annotation** <badge-pep nr='593'></badge-pep>
- **Complementary syntax for unions** <badge-pep nr='604'></badge-pep>
- **Parameter specification variable** <badge-pep nr='612'></badge-pep>
- **Explicit type aliases** <badge-pep nr='613'></badge-pep>
- **Structural pattern matching** <badge-pep nr='635'></badge-pep>
- **Indexing with leyword arguments** <badge-pep nr='637'></badge-pep>
- **Variadic generics** <badge-pep nr='646'></badge-pep>
- **User-defined type guargs** <badge-pep nr='647'></badge-pep>
- **Required typed dictionary items** <badge-pep nr='655'></badge-pep>

??? Info "Nominal/Structural subtyping"

    PEP 544 does not suppress nominal subtyping (explicit declaration of base
    classes), instead propose usage of protocol classes  (static duck typing).

    === "Nominal subtyping"

        ```python
            from collections.abc import Sized, Iterable, Iterator

            class Bucket(Sized, Iterable[int]):
                ...
                def __len__(self) -> int: ...
                def __iter__(self) -> Iterator[int]: ...
        ```

    === "Structural subtyping"

        ```python
            from collections.abc import Iterator, Iterable

            class Bucket:  # Note: no base classes
                ...
                def __len__(self) -> int: ...
                def __iter__(self) -> Iterator[int]: ...
        ```

## Stubs

!!! Info
    A library [stub](https://www.python.org/dev/peps/pep-0484/#stub-files) defines a skeleton of the **public interface** of the library, including classes, variables and functions, and their types.

`typeshed` <badge-stars repo='python/typeshed'></badge-stars> is a collection of library stubs for Python, with static types. Those are distributed with and used by MyPy <badge-stars repo='python/mypy'></badge-stars> <badge-doc href='https://mypy.readthedocs.io'></badge-doc> to determine the types of standard library and third-party library functions, classes, and other definitions.

Stubs files can be generated using mypy's utility [`stugen`](https://mypy.readthedocs.io/en/stable/stubgen.html). Distribution and packaging are described in <badge-pep nr='561'></badge-pep>. And type stubs for third party packages and modules can be installed from PyPI, e.g.:

```terminal
# pip install types-<PKG>
pip install types-six types-requests
```

## Generic concrete collections

Dict
List
Set
FrozenSet
DefaultDict
OrderedDict
ChainMap
Counter
Deque

IO
TextIO
BinaryIO
Pattern
Match
Text

### Abstract Base Class



    ClassVar
    ContextManager
    Counter
    DefaultDict
    Deque
    final
    Final
    Literal
    NewType
    NoReturn
    overload (note that older versions of typing only let you use overload in stubs)
    Protocol (except on Python 3.5.0)
    runtime (except on Python 3.5.0)
    Text
    Type
    TypedDict
    TYPE_CHECKING


## Static type checker

### pytype

Pytype <badge-stars repo='google/pytype'></badge-stars> <badge-doc
href='https://google.github.io/pytype'></badge-doc>, not an official google project, checks and infers types for your Python code - without requiring type annotations


Package providing:

- <b>pydantic</b> <badge-stars repo='samuelcolvin/pydantic'></badge-stars> <badge-doc
href="https://pydantic-docs.helpmanual.io/"></badge-doc>

Link: https://www.pythonsheets.com/notes/python-typing.html
