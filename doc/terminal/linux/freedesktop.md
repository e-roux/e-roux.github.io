# FreeDesktop

https://www.freedesktop.org

## Specification

[Basedir specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)

Base directories, decreasing precedence:

- `$XDG_DATA_HOME`: base directory relative to which user specific data files should be stored. Default: `$HOME/.local/share` should be used.
- `$XDG_CONFIG_HOME`: base directory relative to which user specific configuration files should be stored. Default: `$HOME/.config` should be used.
- `$XDG_DATA_DIRS`: preference-ordered set of base directories to search for data files in addition to the `$XDG_DATA_HOME` base directory. Directories should be seperated with a colon `:`.  Default to `/usr/local/share/:/usr/share/` should be used.
- `$XDG_CONFIG_DIRS`: preference-ordered set of base directories to search for configuration files in addition to the `$XDG_CONFIG_HOME` base directory. Directories in should be seperated with a colon `:`.  Default to `/etc/xdg` should be used.
- `$XDG_CACHE_HOME`: base directory relative to which user specific non-essential data files should be stored. Default equal to `$HOME/.cache` should be used.
- `$XDG_RUNTIME_DIR`: defines the base directory relative to which user-specific non-essential runtime files and other file objects (such as sockets, named pipes, ...) should be stored. More information on this on freedesktop home page.

