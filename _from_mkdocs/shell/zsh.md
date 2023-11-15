# Zsh

The Z-shell <span><badge-doc href="http://www.zsh.org/"> <badge-doc
href='http://zsh.sourceforge.net/Doc/Release/'></badge-doc></badge-doc> <a
href="https://github.com/topics/zsh" target="_blank"> <img
src="https://img.shields.io/badge/git-topics-blue?style=flat&logo=Github"
alt="Github topic"/> </a></span>

## Initialisation

Shell initilization performs operations depending on the execution context,
these operations can be mainly separated on *login* and *interactive* property.
An short summary can be found at [pyenv
wiki](https://github.com/pyenv/pyenv/wiki/Unix-shell-initialization).

Basically:

- *login*: e.g. when user logs in to a system with non-graphical interface or
  via SSH;
- *interactive*: shell that has a prompt and whose standard input and error are
  both connected to terminals.

If `$ZDOTDIR`, `$RCS` or `$GLOABL_RCS` are not set, Zsh performs initialiation
in the following order:

- `/etc/zsh/zshenv`
- `~/.zshenv`
- login mode:
	- `/etc/zsh/zprofile`
	- `~/.zprofile`
- interactive:
	- `/etc/zsh/zshrc`
	- `~/.zshrc`
- login mode:
	- `/etc/zsh/login`
	- `~/.zlogin`

`.zlogout` and `/etc/zsh/zshlogout` are called when exiting, not when opening.

See [this post](https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html)
for a complementary information.

## Readline capability: `ZLE`

Zsh does not use readline, instead uses an own development [Zsh Line Editor
(ZLE)](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html). Keybindings
in `inputrc` are not read, rely instead on an internal command
[`bindkey`](`terminfo`) that can be coupled to `terminfo`.

All actions in the editor are performed by
[widgets](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Widgets).

Bindings are affected to **keymaps**. The current used keymap is `main`.

Initially, there are eight keymaps:

- `emacs`  EMACS emulation
- `viins`  vi emulation - insert mode
- `vicmd`  vi emulation - command mode
- `viopp`  vi emulation - operator pending
- `visual` vi emulation - selection active
- `isearch` incremental search mode
- `command` read a command name
- `.safe`  fallback keymap

These keymaps can be accessed l

Keymap can be created and must be affected to `main` to be in use:
```bash
bindkey -N mymap viins
bindkey -A mymap main
```

New bindings are affected to the current (`main`) **keymap**.

- `bindkey -lL` shows  which  keymap is linked to `main'.
- `zle -la` list all existing keymap names in the form of bindkey commands to create or link the keymaps.

**Links**

- an [intro on widgets](https://sgeb.io/posts/2014/04/zsh-zle-custom-widgets/)

## Prompt

Prompt sequences undergo a [special form of
expansion](http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html). Some
modules make it easier to personalize the prompt.

The prompt system must be loaded (performed by extensions): `autoload -U
promptinit; promptinit`.

A theme can be applied with the `prompt` cmd.

```bash
❯ prompt <TAB>
-- prompt theme --
adam1    bigfade  elite    fire     pure     restore  zefram
adam2    clint    elite2   off      pws      suse
bart     default  fade     oliver   redhat   walters
```

Third party modules:

- <b>spaceshift</b> <badge-stars repo='denysdovhan/spaceship-prompt'></badge-stars> is a pure zsh prompt providing VCS integration, language version, job indicator and more.
- <b>starshift</b> <badge-stars repo='starship/starship'></badge-stars> is a port of spaceshift in rust.
- <b>pure</b> <badge-stars repo='sindresorhus/pure'></badge-stars> is a lighweight prompt in pure zsh.

## Parameters

??? info "Parameters set by the shell"

    | Parameter                                         | Description                                                                                                                                                                                                                                                                                                                                                                                                       |
    |---------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
    | `!` <S>                                           | The process ID of the last command started in the background with &, put into the background with the bg builtin, or spawned with coproc.                                                                                                                                                                                                                                                                         |
    | `#` <S>                                           | The number of positional parameters in decimal. Note that some confusion may occur with the syntax `$#param` which substitutes the length of param. Use `${#}` to resolve ambiguities. In particular, the sequence ‘$#-...’ in an arithmetic expression is interpreted as the length of the parameter -, q.v.                                                                                                       |
    | `ARGC` <S> <Z>                                    | Same as #.                                                                                                                                                                                                                                                                                                                                                                                                        |
    | `$` <S>                                           | The process ID of this shell. Note that this indicates the original shell started by invoking zsh; all processes forked from the shells without executing a new program, such as subshells started by (...), substitute the same value.                                                                                                                                                                           |
    | `-` <S>                                           | Flags supplied to the shell on invocation or by the set or setopt commands.                                                                                                                                                                                                                                                                                                                                       |
    | `*` <S>                                           | An array containing the positional parameters.                                                                                                                                                                                                                                                                                                                                                                    |
    | `argv` <S> <Z>                                    | Same as *. Assigning to argv changes the local positional parameters, but argv is not itself a local parameter. Deleting argv with unset in any function deletes it everywhere, although only the innermost positional parameter array is deleted (so * and @ in other scopes are not affected).                                                                                                                  |
    | `@` <S>                                           | Same as argv[@], even when argv is not set.                                                                                                                                                                                                                                                                                                                                                                       |
    | `?` <S>                                           | The exit status returned by the last command.                                                                                                                                                                                                                                                                                                                                                                     |
    | `0` <S>                                           | The name used to invoke the current shell, or as set by the -c command line option upon invocation. If the FUNCTION_ARGZERO option is set, $0 is set upon entry to a shell function to the name of the function, and upon entry to a sourced script to the name of the script, and reset to its previous value when the function or script returns.                                                               |
    | `status` <S> <Z>                                  | Same as ?.                                                                                                                                                                                                                                                                                                                                                                                                        |
    | `pipestatus` <S> <Z>                              | An array containing the exit statuses returned by all commands in the last pipeline.                                                                                                                                                                                                                                                                                                                              |
    | `_` <S>                                           | The last argument of the previous command. Also, this parameter is set in the environment of every command executed to the full pathname of the command.                                                                                                                                                                                                                                                          |
    | `CPUTYPE`                                         | The machine type (microprocessor class or machine model), as determined at run time.                                                                                                                                                                                                                                                                                                                              |
    | `EGID` <S>                                        | The effective group ID of the shell process. If you have sufficient privileges, you may change the effective group ID of the shell process by assigning to this parameter. Also (assuming sufficient privileges), you may start a single command with a different effective group ID by ‘(EGID=gid; command)’                                                                                                     |
    | `EUID` <S>                                        | The effective user ID of the shell process. If you have sufficient privileges, you may change the effective user ID of the shell process by assigning to this parameter. Also (assuming sufficient privileges), you may start a single command with a different effective user ID by ‘(EUID=uid; command)’                                                                                                        |
    | `ERRNO` <S>                                       | The value of errno (see man page errno(3)) as set by the most recently failed system call. This value is system dependent and is intended for debugging purposes. It is also useful with the zsh/system module which allows the number to be turned into a name or message.                                                                                                                                       |
    | `FUNCNEST` <S>                                    | Integer. If greater than or equal to zero, the maximum nesting depth of shell functions. When it is exceeded, an error is raised at the point where a function is called. The default value is determined when the shell is configured, but is typically 500. Increasing the value increases the danger of a runaway function recursion causing the shell to crash. Setting a negative value turns off the check. |
    | `GID` <S>                                         | The real group ID of the shell process. If you have sufficient privileges, you may change the group ID of the shell process by assigning to this parameter. Also (assuming sufficient privileges), you may start a single command under a different group ID by ‘(GID=gid; command)’                                                                                                                              |
    | `HISTCMD`                                         | The current history event number in an interactive shell, in other words the event number for the command that caused $HISTCMD to be read. If the current history event modifies the history, HISTCMD changes to the new maximum history event number.                                                                                                                                                            |
    | `HOST`                                            | The current hostname.                                                                                                                                                                                                                                                                                                                                                                                             |
    | `LINENO` <S>                                      | The line number of the current line within the current script, sourced file, or shell function being executed, whichever was started most recently. Note that in the case of shell functions the line number refers to the function as it appeared in the original definition, not necessarily as displayed by the functions builtin.                                                                             |
    | `LOGNAME`                                         | If the corresponding variable is not set in the environment of the shell, it is initialized to the login name corresponding to the current login session. This parameter is exported by default but this can be disabled using the typeset builtin. The value is set to the string returned by the man page getlogin(3) system call if that is available.                                                         |
    | `MACHTYPE`                                        | The machine type (microprocessor class or machine model), as determined at compile time.                                                                                                                                                                                                                                                                                                                          |
    | `OLDPWD`                                          | The previous working directory. This is set when the shell initializes and whenever the directory changes.                                                                                                                                                                                                                                                                                                        |
    | `OPTARG` <S>                                      | The value of the last option argument processed by the getopts command.                                                                                                                                                                                                                                                                                                                                           |
    | `OPTIND` <S>                                      | The index of the last option argument processed by the getopts command.                                                                                                                                                                                                                                                                                                                                           |
    | `OSTYPE`                                          | The operating system, as determined at compile time.                                                                                                                                                                                                                                                                                                                                                              |
    | `PPID` <S>                                        | The process ID of the parent of the shell.                                                                                                                                                                                                                                                                                                                                                                        |
    | `PWD`                                             | The present working directory. This is set when the shell initializes and whenever the directory changes.                                                                                                                                                                                                                                                                                                         |
    | `RANDOM` <S>                                      | A pseudo-random integer from 0 to 32767.
    | `SECONDS` <S>                                     | The number of seconds since shell invocation.
    | `SHLVL` <S>                                       | Incremented by one each time a new shell is started.                                                                                                                                                                                                                                                                                                                                                              |
    | `signals`                                         | An array containing the names of the signals.                                                                                                                                                                                                                                                                                                                                                                     |
    | `TRY_BLOCK_ERROR` <S>                             | In an always block, indicates whether the preceding list of code caused an error. The value is 1 to indicate an error, 0 otherwise. It may be reset, clearing the error condition. See Complex Commands                                                                                                                                                                                                           |
    | `TRY_BLOCK_INTERRUPT` <S>                         | This variable works in a similar way to `TRY_BLOCK_ERROR`, but represents the status of an interrupt from the signal SIGINT, which typically comes from the keyboard when the user types ^C. If set to 0, any such interrupt will be reset; otherwise, the interrupt is propagated after the always block.                                                                                                        |
    | `TTY`                                             | The name of the tty associated with the shell, if any.                                                                                                                                                                                                                                                                                                                                                            |
    | `TTYIDLE` <S>                                     | The idle time of the tty associated with the shell in seconds or -1 if there is no such tty.                                                                                                                                                                                                                                                                                                                      |
    | `UID <S>`                                         | The real user ID of the shell process.
    | `USERNAME` <S>                                    | The username corresponding to the real user ID of the shell process. If you have sufficient privileges, you may change the username (and also the user ID and group ID) of the shell by assigning to this parameter. Also (assuming sufficient privileges), you may start a single command under a different username (and user ID and group ID) by ‘(USERNAME=username; command)’                                |
    | `VENDOR`                                          | The vendor, as determined at compile time.                                                                                                                                                                                                                                                                                                                                                                        |
    | `zsh_eval_context` <S> <Z> (`ZSH_EVAL_CONTEXT` <S>) | An array (colon-separated list) indicating the context of shell code that is being run. See [documentation](http://zsh.sourceforge.net/Doc/Release/Parameters.html) for details.                                                                                                                                                                                                                                  |
    | `ZSH_ARGZERO`                                     | If zsh was invoked to run a script, this is the name of the script. Otherwise, it is the name used to invoke the current shell. This is the same as the value of $0 when the POSIX_ARGZERO option is set, but is always available.                                                                                                                                                                                |
    | `ZSH_EXECUTION_STRING`                            | If the shell was started with the option -c, this contains the argument passed to the option. Otherwise it is not set.                                                                                                                                                                                                                                                                                            |
    | `ZSH_NAME`                                        | Expands to the basename of the command used to invoke this instance of zsh.                                                                                                                                                                                                                                                                                                                                       |
    | `ZSH_PATCHLEVEL`                                  | The output of ‘git describe –tags –long’ for the zsh repository used to build the shell. This is most useful in order to keep track of versions of the shell during development between releases; hence most users should not use it and should instead rely on $ZSH_VERSION.                                                                                                                                     |
    | `zsh_scheduled_events`                            | See The zsh/sched Module.                                                                                                                                                                                                                                                                                                                                                                                         |
    | `ZSH_SCRIPT`                                      | If zsh was invoked to run a script, this is the name of the script, otherwise it is unset.                                                                                                                                                                                                                                                                                                                        |
    | `ZSH_SUBSHELL`                                    | Readonly integer. Initially zero, incremented each time the shell forks to create a subshell for executing code. Hence ‘(print $ZSH_SUBSHELL)’ and ‘print $(print $ZSH_SUBSHELL)’ output 1, while ‘( (print $ZSH_SUBSHELL) )’ outputs 2.                                                                                                                                                                          |
    | `ZSH_VERSION`                                     | The version number of the release of zsh.                                                                                                                                                                                                                                                                                                                                                                         |


## Data structures

### Associative arrays

Declared with `declare -A <ARRAY>` or `typeset -A <ARRAY>`

!!! danger ""
    Associative arrays can not be nested


## Functions

### Hook functions <badge-doc href="http://zsh.sourceforge.net/Doc/Release/Functions.html#Hook-Functions"></badge-doc>

It is possible to define an array that has the same name as the function with
`_functions` appended. Any element in such an array is taken as the name of a
function to execute; it is executed in the same context and with the same
arguments as the basic function.

!!! example

    ```bash
    ❯ echo $precmd_functions
    _zsh_autosuggest_start _zsh_highlight_main__precmd_hook _zshz_precmd prompt_pure_precmd

    # Show the definition of a function:
    # it is possible to use `which` or nearly identical to bash `type -f`
    ❯ whence -f _zsh_autosuggest_start
    ```


- **chpwd**: executed whenever the current working directory is changed.

- **periodic**: if the parameter PERIOD is set, this function is executed every
$PERIOD seconds, just before a prompt.

- **precmd**: executed before each prompt.

- **preexec**: executed just after a command has been read and is about to be
executed.

- **zshaddhistory**: executed when a history line has been read interactively,
but before it is executed.

- **zshexit**: executed at the point where the main shell is about to exit
normally.


??? Info "Display user configuration of hooks functions"

    <script src="https://gist.github.com/fesaille/e85f7d44fc3d9bbd453157da2e24fa55.js"></script>


## Expansion

This section is a cheatsheet on expansion, based on the manual and reads,
especially this [blog
post](https://reasoniamhere.com/2014/01/11/outrageously-useful-tips-to-master-your-z-shell/).

The examples hereunder are taken from the latest and to be run, interactive
comments must be enabled in zsh (`setopt interactive_comments`).

<script src="https://gist.github.com/fesaille/a3ec9617ef2e6e22d86382c08d46dcb3.js"></script>


The following types of expansions are performed in the indicated order in five
steps:

- **History Expansion** is performed only in interactive shells.

- **Alias Expansion** Aliases are expanded immediately.

- **Process Substitution**, **Parameter Expansion**, **Command Substitution**,
**Arithmetic Expansion**, **Brace Expansion**

These five are performed in left-to-right fashion. On each argument, any of
the five steps that are needed are performed one after the other. Hence, for
example, all the parts of parameter expansion are completed before command
substitution is started. After these expansions, all unquoted occurrences of
the characters ‘\’,‘’’ and ‘"’ are removed.

- **Filename Expansion**

If the `SH_FILE_EXPANSION` option is set, the order of expansion is
modified for compatibility with sh and ksh: filename expansion
is performed immediately after alias expansion.

- **Filename Generation**, commonly referred to as globbing, always done last.


### Filename generation (globbing)

#### [glob operators](http://zsh.sourceforge.net/Doc/Release/Expansion.html#Glob-Operators)

- `*` matches any string, including the null string.
- `?` matches any character.
- `[...]` matches any of the enclosed characters:
- ranges of characters can be specified by separating two characters by a `-` or classes as `[:alnum:]`, `[:alpha:]`, `[:ascii:]`, ..., `[:xdigit:]`
- `!` or `^` negates the class
- `<[x]-[y]>` matches any number in the range x to y, inclusive.
- `(...)` matches the enclosed pattern.
- `x|y` matches either x or y.
- `^x` matches anything except the pattern x. Requires `EXTENDED_GLOB` to be set.
- `x~y` match anything that matches the pattern x but does not match y. Requires `EXTENDED_GLOB` to be set.
- `x#` Matches zero or more occurrences of the pattern x. Requires `EXTENDED_GLOB` to be set.
- `x##` Matches one or more occurrences of the pattern x. Requires `EXTENDED_GLOB` to be set.


The precedence of the operators given above is (highest) ‘^’, ‘/’, ‘~’, ‘|’ (lowest)

  ```bash
  # list text files that end in a number from 1 to 10
  ❯ ls -l zsh_demo/**/*<1-10>.txt

  # list text files that start with the letter a
  ❯ ls -l zsh_demo/**/[a]*.txt

  # list text files that start with either ab or bc
  ❯ ls -l zsh_demo/**/(ab|bc)*.txt

  # list text files that don't start with a lower or uppercase c
  ❯ ls -l zsh_demo/**/[^cC]*.txt

  # Remove all but go.mod
  ❯ setopt extended_glob
  ❯ rm -Rf -- ^go.mod
  ```

#### [glob flag](http://zsh.sourceforge.net/Doc/Release/Expansion.html#Glob-Flags)

- `i` case insensitive.
- `l` lower case characters in the pattern match upper or lower case characters. Upper case characters behvior unchanged.
- `I` case sensitive: locally negates the effect of i or l from that point on.
- ...


#### [glob qualifiers](http://zsh.sourceforge.net/Doc/Release/Expansion.html#Glob-Qualifiers)

??? abstract "Furthers qualifiers"

    | Qualifiers      | Scope                                                                                                                         |
    | -----------     | -----------------------------------------------                                                                               |
    | /               | directories                                                                                                                   |
    | F               | ‘full’ (i.e. non-empty) directories.                                                                                          |
    | .               | plain files                                                                                                                   |
    | @               | symbolic links                                                                                                                |
    | =               | sockets                                                                                                                       |
    | p               | named pipes (FIFOs)                                                                                                           |
    | *               | executable plain files (0100 or 0010 or 0001)                                                                                 |
    | %               | device files (character or block special)                                                                                     |
    | %b              | block special files                                                                                                           |
    | %c              | character special files                                                                                                       |
    | r               | owner-readable files (0400)                                                                                                   |
    | w               | owner-writable files (0200)                                                                                                   |
    | x               | owner-executable files (0100)                                                                                                 |
    | A               | group-readable files (0040)                                                                                                   |
    | I               | group-writable files (0020)                                                                                                   |
    | E               | group-executable files (0010)                                                                                                 |
    | R               | world-readable files (0004)                                                                                                   |
    | W               | world-writable files (0002)                                                                                                   |
    | X               | world-executable files (0001)                                                                                                 |
    | s               | setuid files (04000)                                                                                                          |
    | S               | setgid files (02000)                                                                                                          |
    | t               | files with the sticky bit (01000)                                                                                             |
    | fspec           | files with access rights matching spec.                                                                                       |
    | estring +cmd    | The string will be executed as shell code.                                                                                    |
    | ddev            | files on the device dev                                                                                                       |
    | l[-\|+]ct       | files having a link count less than ct (-), greater than ct (+), or equal to ct                                               |
    | U               | files owned by the effective user ID                                                                                          |
    | G               | files owned by the effective group ID                                                                                         |
    | uid             | files owned by user ID id if that is a number.                                                                                |
    | gid             | like uid but with group IDs or names                                                                                          |
    | a[Mwhms][-\|+]n | files accessed exactly n days ago.                                                                                            |
    | m[Mwhms][-\|+]n | like the file access qualifier, except that it uses the file modification time.                                               |
    | c[Mwhms][-\|+]n | like the file access qualifier, except that it uses the file inode change time.                                               |
    | L[+\|-]n        | files less than n bytes (-), more than n bytes (+), or exactly n bytes in length.                                             |
    | ^               | negates all qualifiers following it                                                                                           |
    | -               | toggles between making the qualifiers work on symbolic links (the default) and the files they point to                        |
    | M               | sets the MARK_DIRS option for the current pattern                                                                             |
    | T               | appends a trailing qualifier mark to the filenames, analogous to the LIST_TYPES option, for the current pattern (overrides M) |
    | N               | sets the NULL_GLOB option for the current pattern                                                                             |
    | D               | sets the GLOB_DOTS option for the current pattern                                                                             |
    | n               | sets the NUMERIC_GLOB_SORT option for the current pattern                                                                     |
    | Yn              | enables short-circuit mode: the pattern will expand to at most n filenames.                                                   |


  ```bash
  # show only directories
  ❯ print -l zsh_demo/**/*(/)

  # because the expression is expanded,
  # can be used with editors, e.g. vim
  # will open a lot of files (36)
  ❯ vim zsh_demo/**/*(.)

  # show empty files
  ❯ ls -l zsh_demo/**/*(L0)

  # show files greater than 3 KB
  ❯ ls -l zsh_demo/**/*(Lk+3)

  # show files modified in the last hour
  ❯ print -l zsh_demo/**/*(mh-1)

  # sort files from most to least recently modified and show the last 3
  ❯ ls -l zsh_demo/**/*(om[1,3])

  # keep it simple
  ❯ ls -l zsh_demo/**/*(.Lm-2mh-1om[1,3])
  ```


## Completion

 <badge-doc
 href='http://zsh.sourceforge.net/Doc/Release/Completion-System.html'></badge-doc>

### Initialization

```bash
# menu-select widget, part of the zsh/complist module
# must be loaded before the call to compinit
zmodload -i zsh/complist
# Use modern completion system
autoload -U compinit
compinit
```

### Cache reset

```bash
rm -f ~/.zcompdump% compinit 
```

#### Behind the hood

Completion is provided by files named as the command name prefixed by an
underscore: `_cmd` contains the completion logic for `cmd`. The location of this
file must be in `$fpath`. Addition of a path can be done with `fpath+=<PATH TO
COMPLETION FILE>`.

When `compinit` is run, the first line of accessible files in `$fpath` is read.
Those containing one of the tags [`#compdef` or
`#autoload`](http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Autoloaded-files)
will be autoloaded.
The declaration can be done for multiple commands, function aliases can be
referenced too, e.g. `slogin` to `ssh` hereunder:

```
#compdef ssh slogin=ssh scp ssh-add ssh-agent ssh-copy-id ssh-keygen ssh-keyscan sftp
```

As an alternative, `compdef` [may be called
directly](http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Functions-4)

### Configuration

 [🔗](http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Completion-System-Configuration)

### User defined completion

Some [utility functions](http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Completion-System-Configuration)

####

Sources:

- zsh-completion how to: [🔗](https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org)

## Modules

[Modules](http://zsh.sourceforge.net/Doc/Release/Zsh-Modules.html) are loaded
with `zmodload`

??? note "ZSH modules"

    ZSH modules are loaded with the prefix `zsh/`, e.g. for `net/tcl`

    ```bash
    ❯ zmodload zsh/net/tcp
    ```

    | Modules              | Description                                                                           |
    |----------------------|---------------------------------------------------------------------------------------|
    | **attr**         | Builtins for manipulating extended attributes (xattr).                                |
    | **cap**          | Builtins for manipulating POSIX.1e (POSIX.6) capability (privilege) sets.             |
    | **clone**        | A builtin that can clone a running shell onto another terminal.                       |
    | **compctl**      | The compctl builtin for controlling completion.                                       |
    | **complete**     | The basic completion code.                                                            |
    | **complist**     | Completion listing extensions.                                                        |
    | **computil**     | A module with utility builtins needed for the shell function based completion system. |
    | **curses**       | curses windowing commands                                                             |
    | **datetime**     | Some date/time commands and parameters.                                               |
    | **deltochar**    | A ZLE function duplicating EMACS' zap-to-char.                                        |
    | **example**      | An example of how to write a module.                                                  |
    | **files**        | Some basic file manipulation commands as builtins.                                    |
    | **mapfile**      | Access to external files via a special associative array.                             |
    | **mathfunc**     | Standard scientific functions for use in mathematical evaluations.                    |
    | **net/socket**   | Manipulation of Unix domain sockets                                                   |
    | **net/tcp**      | Manipulation of TCP sockets                                                           |
    | **newuser**      | Arrange for files for new users to be installed.                                      |
    | **parameter**    | Access to internal hash tables via special associative arrays.                        |
    | **pcre**         | Interface to the PCRE library.                                                        |
    | **regex**        | Interface to the POSIX regex library.                                                 |
    | **sched**        | A builtin that provides a timed execution facility within the shell.                  |
    | **stat**         | A builtin command interface to the stat system call.                                  |
    | **system**       | A builtin interface to various low-level system features.                             |
    | **termcap**      | Interface to the termcap database.                                                    |
    | **terminfo**     | Interface to the terminfo database.                                                   |
    | **zftp**         | A builtin FTP client.                                                                 |
    | **zle**          | The Zsh Line Editor, including the bindkey and vared builtins.                        |
    | **zleparameter** | Access to internals of the Zsh Line Editor via parameters.                            |
    | **zprof**        | A module allowing profiling for shell functions.                                      |
    | **zpty**         | A builtin for starting a command in a pseudo-terminal.                                |
    | **zselect**      | Block and return when file descriptors are ready.                                     |
    | **zutil**        | Some utility builtins, e.g. the one for supporting configuration via styles.          |


### zsh/zutil

The zsh/zutil module adds some builtins:

- `zstyle` is used to define and lookup styles.
- `zformat` provides two different forms of formatting.
- `zregexparse` implements some internals of the `_regex_arguments` function
- `zparseopts` simplifies the parsing of options in positional parameters

### zsh/net/tcp


  ```bash
  # list all open file descriptors ($$ refers to the current process)
  ❯ ls -la /proc/$$/fd
  ```

  ```bash
  ❯ ztcp
  ```

??? note "File descriptors"

    Wikipedia: [🔗](https://en.wikipedia.org/wiki/File_descriptor)

    Send to  stdout of the current terminal
    ```bash
    echo "hello" >> /proc/$$/fd/2
    ```


## Plugins

- <b>zsh-z</b> <badge-stars repo='agkozak/zsh-z'></badge-stars> Jump quickly to
directories that you have visited "frecently."
- <b>zsh-autosuggestions</b> <badge-stars
repo='zsh-users/zsh-autosuggestions'></badge-stars> Fish-like autosuggestions
for zsh


## Other links

- [Adding Vi to your Zsh](https://dougblack.io/words/zsh-vi-mode.html)
- [Moving to Zsh](https://scriptingosx.com/zsh/)

Introduction à la programmation parallèle avec Open MPI et Open MP:
[🔗](https://connect.ed-diamond.com/GNU-Linux-Magazine/GLMFHS-099/Une-introduction-a-la-programmation-parallele-avec-Open-MPI-et-OpenMP)
