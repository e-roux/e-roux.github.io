# ZLE

(zle-hooks)=
## hooks

`zle-line-init`
    Called when a new ZLE widget is created.

`zle-line-finish`
    Called at the end of each ZLE sequence.

`zle-keymap-select`
    Called whenever the Zsh keymap changes.

`zle-pre-redraw`
    Called before the line editor redraws the command line.

`zle-line-pre-redraw`
    Called before the ZLE widget is redrawn.

`zle-line-post-redraw`
    Called after the ZLE widget is redrawn.

`zle-line-pre-cmd`
    Called before command execution.

`zle-line-preaccept`
    Called before accepting the line.

`zle-beginning-of-line`
    Called when moving the cursor to the beginning of the line.

`zle-end-of-line`
    Called when moving the cursor to the end of the line.

