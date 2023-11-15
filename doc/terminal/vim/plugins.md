# Plugins

## Vim interface

### Airline

 <badge-stars repo='vim-airline/vim-airline'></badge-stars> <badge-doc href='https://github.com/vim-airline/vim-airline/blob/master/doc/airline.txt'></badge-doc> provides a status/tabline for vim.


Airline integrates with a lot of utilities and therefor has a lot of configuration variables, see doc.


??? quote "Github project README"

    ```
    +-----------------------------------------------------------------------------+
    |~                                                                            |
    |~                                                                            |
    |~                     VIM - Vi IMproved                                      |
    |~                                                                            |
    |~                       version 8.2                                          |
    |~                    by Bram Moolenaar et al.                                |
    |~           Vim is open source and freely distributable                      |
    |~                                                                            |
    |~           type :h :q<Enter>          to exit                               |
    |~           type :help<Enter> or <F1>  for on-line help                      |
    |~           type :help version8<Enter> for version info                      |
    |~                                                                            |
    |~                                                                            |
    +-----------------------------------------------------------------------------+
    | A | B |                     C                            X | Y | Z |  [...] |
    +-----------------------------------------------------------------------------+
    ```

    The statusline is the colored line at the bottom, which contains the sections
    (possibly in different colors):

    section|meaning (example)
    -------|------------------
      A    | displays the mode + additional flags like crypt/spell/paste (INSERT)
      B    | Environment status (VCS information - branch, hunk summary (master), [battery][61] level)
      C    | filename + read-only flag (~/.vim/vimrc RO)
      X    | filetype  (vim)
      Y    | file encoding[fileformat] (utf-8[unix])
      Z    | current position in the file
     [...] | additional sections (warning/errors/statistics) from external plugins (e.g. YCM, syntastic, ...)

    The information in Section Z looks like this:

    `10% ☰ 10/100 ln : 20`

    This means:
    ```
    10%     - 10 percent down the top of the file
    ☰ 10    - current line 10
    /100 ln - of 100 lines
    : 20    - current column 20
    ```

#### Commands

| Command                      | Descrption                                                                                                                   |
|------------------------------|------------------------------------------------------------------------------------------------------------------------------|
| `:AirlineTheme {theme-name}` | Displays or changes the current theme. `random` will switch to a random theme.                                               |
| `:AirlineToggleWhitespace`   | Toggles whitespace detection.                                                                                                |
| `:AirlineToggle`             | between the standard 'statusline' and airline.                                                                               |
| `:AirlineRefresh[!]`         | Refreshes all highlight groups and redraws the statusline. With the '!' attribute, skips refreshing the highlighting groups. |
| `:AirlineExtensions`         | Shows the status of all available airline extensions.  Extern means, the extensions does not come bundled with Airline.      |


####  Airline section


 | variable names                  | default content                                                               |
 |---------------------------------|-------------------------------------------------------------------------------|
 | `let g:airline_section_a`       | (mode, crypt, paste, spell, iminsert)                                         |
 | `let g:airline_section_b`       | (hunks, branch)                                                               |
 | `let g:airline_section_c`       | (bufferline or filename, readonly)                                            |
 | `let g:airline_section_gutter`  | (csv)                                                                         |
 | `let g:airline_section_x`       | (tagbar, filetype, virtualenv)                                                |
 | `let g:airline_section_y`       | (fileencoding, fileformat)                                                    |
 | `let g:airline_section_z`       | (percentage, line number, column number)                                      |
 | `let g:airline_section_error`   | (ycm_error_count, syntastic-err, eclim, languageclient_error_count)           |
 | `let g:airline_section_warning` | (ycm_warning_count, syntastic-warn, languageclient_warning_count, whitespace) |

Section b needs the [fugitive](https://github.com/tpope/vim-fugitive) plugin-in.


!!! info "Configuration"

    ```vim
    " the separator used on the left and right side
    let g:airline_left_sep=''
    let g:airline_right_sep=''

    " enable fzf integration
    let g:airline#extensions#fzf#enabled = 1
    " tabline activated in airline
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'
    let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
    " let g:airline_theme = 'sonokai'
    let g:airline_powerline_fonts = 1
    ```


- **echodoc.vim** <badge-stars repo='Shougo/echodoc.vim'></badge-stars> displays function signatures from completions in the command line.


## Tags

https://github.com/liuchengxu/vista.vi://github.com/liuchengxu/vista.vim


## Session

- <b>obsession</b> <badge-stars repo='tpope/vim-obsession'></badge-stars>
  continuously updates session files.
  `:mksession` command to write a file.

## File editing

- <b>vim-commentary</b> <badge-stars repo='tpope/vim-commentary'></badge-stars> <badge-doc href="https://github.com/tpope/vim-commentary"></badge-doc> comment stuff out

- <b>vim-surround</b> <badge-stars repo='tpope/vim-surround'></badge-stars> provides mapping for parentheses, brackets, quotes, XML tags, and more.


- <b>vim-multiple-cursors</b> <badge-stars repo='terryma/vim-multiple-cursors'></badge-stars> <badge-doc href="https://github.com/terryma/vim-multiple-cursors#quick-start" message="latest" logo="github"></badge-doc> is a Sublime Text style multiple selections for Vim


## Browse files: nnn

Other projects:

- <b>Ranger.vim</b> <badge-stars repo='francoiscabrol/ranger.vim'></badge-stars> <badge-doc href="https://github.com/francoiscabrol/ranger.vim#how-to-use-it"></badge-doc>, Ranger integration in vim


## search; fzf

### Commands

| Command           | Description                                                             |
|-------------------|-------------------------------------------------------------------------|
| `:Files [PATH]`   | Files (runs `$FZF_DEFAULT_COMMAND` if defined)                          |
| `:GFiles [OPTS]`  | Git files (`git ls-files`)                                              |
| `:GFiles?`        | Git files (`git status`)                                                |
| `:Buffers`        | Open buffers                                                            |
| `:Colors`         | Color schemes                                                           |
| `:Ag [PATTERN]`   | [ag][ag] search result (`ALT-A` to select all, `ALT-D` to deselect all) |
| `:Rg [PATTERN]`   | [rg][rg] search result (`ALT-A` to select all, `ALT-D` to deselect all) |
| `:Lines [QUERY]`  | Lines in loaded buffers                                                 |
| `:BLines [QUERY]` | Lines in the current buffer                                             |
| `:Tags [QUERY]`   | Tags in the project (`ctags -R`)                                        |
| `:BTags [QUERY]`  | Tags in the current buffer                                              |
| `:Marks`          | Marks                                                                   |
| `:Windows`        | Windows                                                                 |
| `:Locate PATTERN` | `locate` command output                                                 |
| `:History`        | `v:oldfiles` and open buffers                                           |
| `:History:`       | Command history                                                         |
| `:History/`       | Search history                                                          |
| `:Snippets`       | Snippets ([UltiSnips][us])                                              |
| `:Commits`        | Git commits (requires [fugitive.vim][f])                                |
| `:BCommits`       | Git commits for the current buffer                                      |
| `:Commands`       | Commands                                                                |
| `:Maps`           | Normal mode mappings                                                    |
| `:Helptags`       | Help tags <sup id="a1">[1](#helptags)</sup>                             |
| `:Filetypes`      | File types                                                              |



Other projects:

- <b>ctrlp.vim</b> <badge-stars repo='ctrlpvim/ctrlp.vim'></badge-stars> is a fuzzy file, buffer, mru, tag finder.
- <b>ack.vim</b> <badge-stars repo='mileszs/ack.vim'></badge-stars> is a plugin for the Perl module / CLI script 'ack'.

### DB

<badge-stars repo='tpope/vim-dadbod'></badge-repo>Modern database interface for Vim


[fzf]:   https://github.com/junegunn/fzf
[run]:   https://github.com/junegunn/fzf/blob/master/README-VIM.md#fzfrun
[vimrc]: https://github.com/junegunn/dotfiles/blob/master/vimrc
[ag]:    https://github.com/ggreer/the_silver_searcher
[rg]:    https://github.com/BurntSushi/ripgrep
[us]:    https://github.com/SirVer/ultisnips

## Linting: ALE

**ALE** <badge-stars repo='dense-analysis/ale'></badge-stars> supports a wide range of
[tools](https://github.com/dense-analysis/ale/blob/master/doc/ale-supported-languages-and-tools.txt)
