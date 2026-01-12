# tmux.conf

Simple tmux.conf with some simplified bindings, useful plugins, and theme.

## tmux-zoxide.sh Script

The `tmux-zoxide.sh` script provides quick directory navigation with automatic tmux session creation. Copy or symlink it to `~/.local/bin/t`:

```bash
ln -s $(pwd)/tmux-zoxide.sh ~/.local/bin/t
```

Then run `t` to cd into a directory (using zoxide) and automatically create/attach a tmux session named after the directory's basename.

**Dependencies:** `zoxide`, `fzf`

## Key Bindings

prefix: `ctrl + Space`

all key bindings are preceded by the prefix:

reload config: `r`

save session(s): `ctrl + s`

load saved sessions: `ctrl + r`

resize panes: `alt + [h, j, k, l]`

join window back as pane: `[j, J]`

next window: `n`

previous window: `p`

swap window ordering: `[<, >]`

swap panes: `[{, }]`

last pane: `;`

next pane: `o`

enable synchronize panes: `ctrl + x`

disable synchronize panes: `alt + x`

disable pane: `alt + d`

enable pane: `alt + e`

scratchpad toggle: `ctrl + t`

pet vertical split: `ctrl + f`

compile/build prompt: `alt + B`

re-run last compile: `alt + R`

kill compile pane: `alt + K`

select text in copy-mode: `v`

yank text in copy-mode: `y`

paste yanked text: `ctrl + p`

suspend session: `F12` (no prefix needed)

mouse support enabled
Vi keys for copy-mode

history set to 200k

