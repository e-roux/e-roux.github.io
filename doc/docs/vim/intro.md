# Vim

[Cheatsheet](https://vim.rtorr.com/)

## Start

Vim can be started with several options, loading or not configuration file,
plugins or viminfo. 

This can be especially useful in case of problem at start. 

```terminal
vim -N -u NONE -U NONE -i NONE
vim -N -u NONE -U NONE 
vim -N -u ~/.vimrc --noplugin -i NONE
```

## Initialisation

`:h init` or <badge-doc href="https://vimhelp.org/starting.html#initialization" message="initialization" logo="vim"></badge-doc>

At startup, Vim checks environment variables and files and sets values
in this order:

1. Set the 'shell' and 'term' option
2. Process the arguments
3. Execute Ex commands, from environment variables and/or files
4. Load the plugin scripts.
5. Set 'shellpipe' and 'shellredir'
6. Set various less used initialization until windows open (see doc)
12. Execute startup commands

## Configuration

Vim has a number of internal variables and switches:

- [options](https://vimhelp.org/options.txt.html)   description of all options
  <badge-doc href='https://vimhelp.org/quickref.txt.html#option-list' logo='vim'></badge-doc>
- [map](https://vimhelp.org/map.txt.html)       key mapping and abbreviations
- [autocmd](https://vimhelp.org/autocmd.txt.html)  automatically executing commands on an event
- [fold](https://vimhelp.org/fold.txt.html)      hide (fold) ranges of lines
<!-- - [eval](https://vimhelp.org/eval.txt.html)      expression evaluation, conditional commands -->

When starting, vim will look in the [ runtimepath ](https://vimhelp.org/options.txt.html#%27runtimepath%27) and underlying directories for runtime files. Basicaly on unix like systems:

- $HOME/.vim,
- $VIM/vimfiles,
- $VIMRUNTIME,
- $VIM/vimfiles/after,
- $HOME/.vim/after

This is a list of some directories which will be searched for runtime files:

| File           | Description                                     |
|----------------|-------------------------------------------------|
| `filetype.vim` | filetypes by file name new-filetype             |
| `scripts.vim`  | filetypes by file contents new-filetype-scripts |
| `autoload/`    | automatically loaded scripts autoload-functions |
| `colors/`      | color scheme files                              |
| `compiler/`    | compiler files                                  |
| `ftplugin/`    | filetype plugins write-filetype-plugin          |
| `import/`      | files that are found by :import                 |
| `indent/`      | indent scripts indent-expression                |
| `pack/`        | packages :packadd                               |
| `plugin/`      | plugin scripts write-plugin                     |
| `syntax/`      | syntax files mysyntaxfile                       |


`~/.vim/syntax` contains

## Packages (Plugins)

:h packages' <badge-doc href='https://vimhelp.org/repeat.txt.html#packages' logo='vim'></badge-doc>


## Links

- [Learn vim script the hard way](https://learnvimscriptthehardway.stevelosh.com/chapters/42.html)
- [VIM cheatsheet](https://github.com/hackjutsu/vim-cheatsheet)
- [VIM script aheatsheet](https://github.com/hackjutsu/vim-cheatsheet)
