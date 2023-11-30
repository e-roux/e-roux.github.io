# Utils

## GNU Stow

[GNU Stow](https://www.gnu.org/software/stow/) is a symlink farm manager which
takes distinct packages of software and/or data located in separate directories
on the filesystem, and makes them appear to be installed in the same place.

The software can be used to manage dotfiles.

## GNU envsubst (Gettext package)

[GNU envsubst](https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html)
substitutes the values of environment variables.

## Directory content

### List content

- {ghstars}`ogham/exa` <badge-doc href="https://the.exa.website/"></badge-doc> is a replacement for ls written in Rust.

{ghstars}`bootandy/dust` is a rust application
printing a similar output to `du` with additional bar chart.

### File manager

- {ghstars}`jarun/nnn` <badge-doc href="https://github.com/jarun/nnn/wiki"></badge-doc> is another vi-inspired filemanager for the console, lightweight, written in C.
- {ghstars}`ranger/ranger` <badge-doc href="https://ranger.github.io"></badge-doc>, vim-inspired filemanager for the console, written in python.

    Install with `pipx install ranger-fm`

## Change directories

### Autojump

These utilities give the most visited directory for the shortest search term typed.

- {ghstars}`gsamokovarov/jump` is written in go.
- {ghstars}`wting/autojump` is written in python.
- {ghstars}`ajeetdsouza/zoxide` is written in rust.
- {ghstars}`agkozak/zsh-z` is a native zsh port of z.sh

## Finding files


### fuzzy finder

- {ghstars}`jhawthorn/fzy` is written in C, now seems 
- {ghstars}`junegunn/fzf` <badge-doc
  href="https://github.com/junegunn/fzf#table-of-contents"></badge-doc> is
  written in go

#### FZF

::::{tab-set}

:::{tab-item} Syntax

| Token     | Match type                 | Description                          |
| --------- | -------------------------- | ------------------------------------ |
| `sbtrkt`  | fuzzy-match                | Items that match `sbtrkt`            |
| `'wild`   | exact-match (quoted)       | Items that include `wild`            |
| `^music`  | prefix-exact-match         | Items that start with `music`        |
| `.mp3$`   | suffix-exact-match         | Items that end with `.mp3`           |
| `!fire`   | inverse-exact-match        | Items that do not include `fire`     |
| `!^music` | inverse-prefix-exact-match | Items that do not start with `music` |
| `!.mp3$`  | inverse-suffix-exact-match | Items that do not end with `.mp3`    |

:::

:::{tab-item} Bindings

`fzf` [provides
bindings](https://github.com/junegunn/fzf#key-bindings-for-command-line):

- <kbd>Ctrl</kbd><kbd>T</kbd> paste the selected files and directories onto the command-line
- <kbd>Ctrl</kbd><kbd>R</kbd> paste the selected command from history onto the command-line. A second press on <kbd>Ctrl</kbd><kbd>R</kbd> sorts relevant entries in chronological order
- <kbd>Alt</kbd><kbd>C</kbd> cd into the selected directory
- fuzzy competion is activated with `**`, e.g. `vim **<TAB>` completes all files
  in the cwd.

:::

::::




## Search file content 

Search can be efficiently performed by {ghstars}`ggreer/the_silver_searcher` <badge-doc href='https://geoff.greer.fm/ag/'></badge-doc> and {ghstars}`BurntSushi/ripgrep` <badge-doc logo='Markdown' href='https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md'></badge-doc>, written resp. in C and rust. `rg` tends to be one of the quickest.

**Ripgrep**

 <badge-doc href='https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md' logo='github'></badge-doc>

!!! info "Usage"

	```bash
	rg [OPTIONS] PATTERN [PATH ...]
	rg [OPTIONS] [-e PATTERN ...] [-f PATTERNFILE ...] [PATH ...]
	rg [OPTIONS] --files [PATH ...]
	rg [OPTIONS] --type-list
	command | rg [OPTIONS] PATTERN
	```

- `--type <TYPE>` where `<TYPE>` is part of the registered types, can be displayed with `rg --list-types`

### Search with substitution

In respect of [DOTADIW](https://en.wikipedia.org/wiki/Unix_philosophy#Do_One_Thing_and_Do_It_Well), `rg` does [not support](https://github.com/BurntSushi/ripgrep/issues/74) natively search and replacement. This can be achieved with a pipe.

!!! Example  "Prepare cookiecutter templates from `molecule init` outputs"

    ```bash
     rg ROLE --files-with-matches | xargs sed -e "s/ROLE/\{\{ cookiecutter.role_name \}\}/g"
    ```

Link: https://learnbyexample.github.io/substitution-with-ripgrep/

### Manual filtering: globs

!!! Example  "Exclude path 'pack' from search"

    ```bash
    rg -g '!/pack/**' g:ale
    ```

## Command information

- `which` was a csh cmd, locates a command, get aliases from `~/.cshrc` and
  assumes an interactive shell. Neither POSIX nor UNIX std.
- `type` display was a bash addition in the mid 80's, command informations.
  **UNIX std**.
- `whence` is a korn-shell addition of the mid 80's

    - `whence` as `command -v`
    - `whence -c` as `which`
    - `whence -v` as `type` or `command -V`
    - `whence -ca` as `where`

- `where` is a tcsh addition, acting like Unix's ` type -a`. Neither POSIX nor UNIX std.
- `command` runs a simple command, suppressing the shell function lookup. **POSIX std**.


Further utilities:

- `whereis` locate the binary, source and man page for a command. Neither POSIX nor UNIX std.
- `whatis` display one line manual page descriptions, renamed `type` on Unix v8. Neither POSIX nor UNIX std.
- `apropos`  search the manual pages names and decriptions, seems similar to `man -k`.

Genral check if one command is available:

> ```bash
> if command -v given-command &> /dev/null 2>&1; then
>   echo given-command is available
> else
>   echo given-command is not available
> fi
> ```

!!! note

    - these commands have various modifiers, see their help
    - `whence` equivalents are valid on `zsh`.
    - some info on post [Stackexchange
      85249](https://unix.stackexchange.com/questions/85249/why-not-use-which-what-to-use-then).


## Workflows

{ghstars}`jamesob/desk` makes it easy
to flip back and forth between different project contexts in your favorite
shell. Change directory, activate a virtualenv or rvm, load in domain-specific
aliases, environment variables, functions, arbitrary shell files, all in a
single command.

{ghstars}`direnv/direnv` augments existing
shells with a new feature that can load and unload environment variables
depending on the current directory.

{ghstars}`cea-hpc/modules`  is a tool that
simplify shell initialization and lets users easily modify their environment
during the session with modulefiles.

{ghstars}`Tarrasch/zsh-autoenv` automatically sources (known/whitelisted)
`.autoenv.zsh ` files, handles "enter" and leave" events, nesting, and stashing
of variables (overwriting and
restoring).

{ghstars}`asdf-vm/asdf` manage multiple runtime
versions with a single CLI tool, extendable via plugins.

<!-- shadowenv - uses an s-expression format to define -->
<!-- environment changes that should be executed -->

## Others

{ghstars}`nushell/nushell` is a new kind of shell, currently under heavy development.

### Style guide

[google shell style](https://google.github.io/styleguide/shellguide.html)

### Linting

{ghstars}`koalaman/shellcheck` can be used by [ALE](https://github.com/) in vim.
