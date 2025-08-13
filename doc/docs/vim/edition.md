
# Editing

| Operation | ...entire line | ...to eol      | entire word | ...to eow      | ... to begin of next word |
|-----------|----------------|----------------|-------------|----------------|---------------------------|
| Change    | `cc`           | `C` ( or `c$`) | `ciw`/`caw` | `cw` (or `ce`) |                           |
| Delete    | `dd`           | `D` ( or `d$`) | `diw`/`daw` | `de`           | `dw`                      |

## Registers

There are 10 types of `:h registers`:

1. The unnamed register `""`
2. 10 numbered registers `"0` to `"9` filled with text from the last 10 yank and
   delete commands.
3. The small delete register `"-` from commands that delete less than a line.
4. 26 named registers `"a` to `"z` or `"A` to `"Z`
5. Three read-only registers:

    - `":`, most recent command,
    - `".`,
    - `"%`, name of the current file)

6. Alternate buffer register `"#`
7. The expression register `"=`:
8. The selection and drop registers (:

    - `"*`, contains the `PRIMARY` selection which is available on Linux when
      users select some data.
    - `"+`, contains the `CLIPBOARD` select, available on active requests of
      copy.  To use the `PRIMARY` selection too, `set
      clipboard^=unnamed,unnamedplus`
    - `"~` registers the dropped text from the last drag'n'drop operation.


9. The black hole register `"_`
10. Last search pattern register `"/`


Insertion of register in command mode in triggerd by <kbd>C-r</kbd>.

## Selection

`:h text-objects` or <badge-doc
href="https://vimhelp.org/motion.txt.html#text-objects" message="terminal"
logo="vim"></badge-doc> operate in visual mode and consists ot two characters:
<kbd>i</kbd> and <kbd>a</kbd> and correspond to an inner resp. outer selection.

## Comment
Comment line (via plugin vim-commentary): <kbd>gcc</kbd> in normal mode,
<kbd>gc</kbd> in visual mode

Surroung element while editing

## Completion

### `complete`

Completion is set up by the `complete` options, a list of location used for
completion lookup.

The default is ".,w,b,u,t,i", which means to scan:
    1. the current buffer
    2. buffers in other windows
    3. other loaded buffers
    4. unloaded buffers
    5. tags
    6. included files

See `h: 535`

### `completeopt`

The completion menu appearance is controlled by `completeopt` (`ofu`)

### `ins-completion`

Completion in insert mode `h: ins-completion` is activated with <kbd>C-x</kbd>
and triggers a sub-mode `h: i_CTRL-X`.

|     | Desc                                       | Key               |
|-----|--------------------------------------------|-------------------|
| 1.  | Whole lines                                | <kbd>CTRL-L</kbd> |
| 2.  | keywords in the current file               | <kbd>CTRL-N</kbd> |
| 3.  | keywords in 'dictionary'                   | <kbd>CTRL-K</kbd> |
| 4.  | keywords in 'thesaurus', thesaurus-style   | <kbd>CTRL-T</kbd> |
| 5.  | keywords in the current and included files | <kbd>CTRL-I</kbd> |
| 6.  | tags                                       | <kbd>CTRL-]</kbd> |
| 7.  | file names                                 | <kbd>CTRL-F</kbd> |
| 8.  | definitions or macros                      | <kbd>CTRL-D</kbd> |
| 9.  | Vim command-line                           | <kbd>CTRL-V</kbd> |
| 10. | User defined completion                    | <kbd>CTRL-U</kbd> |
| 11. | omni completion                            | <kbd>CTRL-O</kbd> |
| 12. | Spelling suggestions                       | <kbd>s</kbd>      |
| 13. | keywords in 'complete'                     | CTRL-N / CTRL-P   |

### `omnifunc`

Omni completion supports filetype-specific completion. Ex:

`omnifunc=htmlcomplete#CompleteTags`


function! InputTarget()
  let c = getchar()
  echo c
endfunction

function! Codify()
  let selection = getpos('.')
  echo string(selection) . "Yo"
  " Get selection
  " Length == 1   (normal mode)
  " -> expand selection to zone delimited by space
  " Length >= 1   (visual mode)
  " -> get selection and introduce ` around selection
endfunction

## Syntax

### Keywords

The generic form for defining syntaxing is:

```vim
    syntax keyword {group} {keyword} ...
```

The correspoding hightlighting is set with `hightlight`

!!! Example

    ```vim
        syntax keyword xType int long char
        highlight link xType Type
    ```

### Matches

Syntax can match ordinary identifiers:

```vim
    syntax match xIdentifier /\<\l\+\>/
```
`Keywords` have a high precedence over matches.

### Regions

Region can be defined with a `start` and `end` parameter, optional `skip`:

```vim
    syntax region xString start=/"/ end=/"/
    syntax region xString start=/"/ skip=/\\"/ end=/"/
```

### Clusters

A cluster is a collection of syntax groups.

!!! Example

    ```vim
        " Instead of manualy defining elements contained in match
        syntax match xFor /^for.*/ contains=xNumber,xIdent
        syntax match xIf /^if.*/ contains=xNumber,xIdent
        syntax match xWhile /^while.*/ contains=xNumber,xIdent

        " One can define a cluster
        syntax cluster xState contains=xNumber,xIdent

        " And later reuse it
        syntax match xFor /^for.*/ contains=@xState
        syntax match xIf /^if.*/ contains=@xState
        syntax match xWhile /^while.*/ contains=@xState

        " Add and remove to a cluster
        syntax cluster xState add=xString
        syntax cluster xState remove=xString
    ```

## Folding

<badge-doc href="https://vimhelp.org/usr_28.txt.html" logo="vim"
message="usr_28"></badge-doc>

**Types of Folding**:

|  Type  | Description                                  |
|:------:|:---------------------------------------------|
| manual | folds are created manually and remain in RAM |
| indent | lines with equal indent form a fold          |
|  expr  | vim scripts give identation of a line        |
| marker | based on specific characters                 |
| syntax | syntax highlightung items specify folds      |
|  diff  | fold test that is not changed                |

The command zc will close a fold (if the cursor is in an open fold), and zo will
open a fold (if the cursor is in a closed fold). It's easier to just use za
which will toggle the current fold (close it if it was open, or open it if it
was closed).

The commands zc (close), zo (open), and za (toggle) operate on one level of
folding, at the cursor. The commands zC, zO and zA are similar, but operate on
all folding levels (for example, the cursor line may be in an open fold, which
is inside another open fold; typing zC would close all folds at the cursor).

The command zr reduces folding by opening one more level of folds throughout the
whole buffer (the cursor position is not relevant). Use zR to open all folds.

The command zm gives more folding by closing one more level of folds throughout
the whole buffer. Use zM to close all folds.

Source: https://vim.fandom.com/wiki/Folding

Folding principel:

- folds at defined per level: ```:set foldlevel=<LEVEL>``` and adjacent lines
  are fold grouped by level value
- to fold level at start ``` :set foldlevelstart=<LEVEL>```

## Macros

### Editing a macro

From [vim.fandom.com](https://vim.fandom.com/wiki/Macros#Editing_a_macro):

- Type `:let @a='i`
- Press `Ctrl-R Ctrl-R` a to insert the current contents of register a (type
  Ctrl-R twice to insert the register exactly).
- Edit the text as required.
- Append an apostrophe `'` to finish the command, and press Enter.
- Enter `:reg` a to view the new value in the register.
- Type `@a` to execute the contents of register `a`.

Note the caveat above about macros which end in `<CR>` or `<NL>`.

## Linting

- **ale** <badge-stars repo="dense-analysis/ale"></badge-stars>
