# Docutils

## Roles

### Types

Canonical Roles
    Interpreted text role by its canonical name.
    Ex: `code`, `math`, 

Generic Roles
    Simply wrap a given `node_class` around the text.
    Ex: `abbreviation`, `strong`, `superscript`

Local Roles
    Interpreted text role by its local or language-dependent name.


## API

### Modules

`languages`
: Language-specific mappings of terms.

`parsers`
: Syntax-specific input parser modules or packages.
:`docutils.parsers.rst.Parser`

`readers`
: Context-specific input handlers which understand the data
  source and manage a parser.

`transforms`
: Modules used by readers and writers to modify
  the Docutils document tree.

`utils`
: Contains the ``Reporter`` system warning class and miscellaneous
  utilities used by readers, writers, and transforms.

  utils/urischemes.py: Contains a complete mapping of known URI addressing
  scheme names to descriptions.

`utils/math`
: Contains functions for conversion of mathematical notation
  between different formats (LaTeX, MathML, text, ...).

`writers`
: Format-specific output translators.
