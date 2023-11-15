# Make

<badge-doc href='https://www.gnu.org/software/make/manual'></badge-doc>

## Wildcard characters

`*`, `?` and `[...]`

## Variables

Variables are case sensitive, may contain function and variable references,
which are expanded when the line is read to find the actual variable name to
use.

### Variables definition

Variables can be declated through various operators:

- with `=`, they are called *recursively expanded*, i.e. lazily evaluated with
  the specificity of being always re-evaluated.
- with `:=` or `::=`, they are *simply expanded*. The righthand side is expanded
  immediately upon reading the line.
- `?=` is the *conditional variable assignment operator*. Assignement is
  performed only is the variables does not have a value.
- `+=` is used to append to a variable. This one is created if it does not
  exist.

### Automatic variables

[Most important variables](https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html#Automatic-Variables)

| Variable | Description                                                                                                                                                                                |
|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| $@       | File name of the target of the rule.                                                                                                                                                       |
| $%       | Target member name, when the target is an archive member. For example, if the target is foo.a(bar.o) then ‘$%’ is bar.o and ‘$@’ is foo.a. Empty when the target is not an archive member. |
| $<       | Name of the first prerequisite.                                                                                                                                                            |
| $?       | Names of all the prerequisites that are newer than the target, with spaces between them.                                                                                                   |
| $^       | Names of all the prerequisites, with spaces between them.                                                                                                                                  |
| $+       | Like ‘$^’, but prerequisites listed more than once are duplicated in the order they were listed in the makefile.                                                                           |
| $\|      | Names of all the order-only prerequisites, with spaces between them.                                                                                                                       |
| $\*       | Stem with which an implicit rule matches.                                                                                                                                                  |

Each of those variables has complementary directory or file portion, e.g. for
the target:

| Variable | Description                                                                         |
|----------|-------------------------------------------------------------------------------------|
| ‘$(@D)’  | The directory part of the file name of the target, with the trailing slash removed. |
| ‘$(@F)’  | The file-within-directory part of the file name of the target.                      |

### "Macros"

Variables can contain one liner expressions, for more complex sequences, a
variable can use the sequence `define`...`enddef`.

```make
define two-lines
echo foo
echo $(bar)
endef
```

### Expansion

Expansion is only made immediately when the variable is declare with `=`.

## Links

 https://makefiletutorial.com

Introduction à Makefile

https://gl.developpez.com/tutoriel/outil/makefile/

Splitting Recipe Lines

https://www.gnu.org/software/make/manual/html_node/Splitting-Recipe-Lines.html
