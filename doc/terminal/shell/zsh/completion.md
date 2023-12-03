# Completion

## Compinit

### Initilisation

`compinit` is a shell function initializing the completion system.

```shell
❯ where compinit
compinit () {
        # undefined
        builtin autoload -XUz /usr/share/zsh/5.9/functions
}
```

```{warning}
zle menu-select widget, part of the `zsh/complist` module must be loaded
before the call to compinit 
```

```{code-block} zsh
zmodload -i zsh/complist
autoload -U compinit && compinit
```

Completion can be dumped for better startup and cached for some intensive functions:


### Dump and cache reset

```bash
rm -f ~/.zcompdump% 
compinit 
```

## Behind the hood

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


## User defined completion

Some [utility functions](http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Completion-System-Configuration)

Sources:

- zsh-completion how to: [🔗](https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org)
