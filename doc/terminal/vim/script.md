# Vim script

## Options

**Set options**: `set` or `se`

<badge-doc href="https://vimhelp.org/options.html#set-option" message="options" logo="vim"></badge-doc>



| Cmd                | Comment                                                                                            |
|--------------------|----------------------------------------------------------------------------------------------------|
| `:se[t][!]`        | show all options that differ from the default value, `!` forces printing to new line               |
| `:se[t][!] all`    | show all but terminal options, if `!`: every option is on a separate line.                         |
| `:se[t] {option}?` | show value of option                                                                               |
| `:se[t] {option}`  | Toggle option: set, switch it on.<br/> Number option: show value. <br/> String option: show value. |



## Variables

Scope:


| Scope             | Identifier | Comment                                     |
|-------------------|:----------:|---------------------------------------------|
| buffer-variable   |     b:     | Local to the current buffer.                |
| window-variable   |     w:     | Local to the current window                 |
| tabpage-variable  |     t:     | Local to the current tab page.              |
| global-variable   |     g:     | Global.                                     |
| local-variable    |     l:     | Local to a function.                        |
| script-variable   |     s:     | Local to a Vim script.                      |
| function-argument |     a:     | Function argument (only inside a function). |
| vim-variable      |     v:     | Global, predefined by Vim.                  |

## Commands

Vim doc: `:h user-commands`

!!! note ""

  ```vim
  :com[mand][!] [{attr}...] {cmd} {rep}
  ```

`-nargs`: specify that the command can take arguments.

  -nargs=0    No arguments are allowed (the default)
	-nargs=1    Exactly one argument is required, it includes spaces
	-nargs=*    Any number of arguments are allowed (0, 1, or many), separated by white space
	-nargs=?    0 or 1 arguments are allowed
	-nargs=+    Arguments must be supplied, but any number are allowed

`-complete` enables argument completion.

	-complete=arglist	file names in argument list
	-complete=augroup	autocmd groups
	-complete=buffer	buffer names
	-complete=behave	:behave suboptions
	-complete=color		color schemes
	-complete=command	Ex command (and arguments)
	-complete=compiler	compilers
	-complete=cscope	|:cscope| suboptions
	-complete=dir		directory names
	-complete=environment	environment variable names
	-complete=event		autocommand events
	-complete=expression	Vim expression
	-complete=file		file and directory names
	-complete=file_in_path	file and directory names in |'path'|
	-complete=filetype	filetype names |'filetype'|
	-complete=function	function name
	-complete=help		help subjects
	-complete=highlight	highlight groups
	-complete=history	:history suboptions
	-complete=locale	locale names (as output of locale -a)
	-complete=mapclear	buffer argument
	-complete=mapping	mapping name
	-complete=menu		menus
	-complete=messages	|:messages| suboptions
	-complete=option	options
	-complete=packadd	optional package |pack-add| names
	-complete=shellcmd	Shell command
	-complete=sign		|:sign| suboptions
	-complete=syntax	syntax file names |'syntax'|
	-complete=syntime	|:syntime| suboptions
	-complete=tag		tags
	-complete=tag_listfiles	tags, file names are shown when CTRL-D is hit
	-complete=user		user names
	-complete=var		user variables
	-complete=custom,{func} custom completion, defined via {func}
	-complete=customlist,{func} custom completion, defined via {func}


	-bang	    The command can take a ! modifier (like :q or :w)
	-bar	    The command can be followed by a "|" and another command.
		    A "|" inside the command argument is not allowed then.
		    Also checks for a " to start a comment.
	-register   The first argument to the command can be an optional
		    register name (like :del, :put, :yank).
	-buffer	    The command will only be available in the current buffer.

	-range	    Range allowed, default is current line
	-range=%    Range allowed, default is whole file (1,$)
	-range=N    A count (default N) which is specified in the line
		    number position (like |:split|); allows for zero line
		    number.
	-count=N    A count (default N) which is specified either in the line
		    number position, or as an initial argument (like |:Next|).
	-count	    acts like -count=0

Note that -range=N and -count=N are mutually exclusive - only one should be
specified.
