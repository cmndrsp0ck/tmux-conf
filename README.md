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

show which-key popup (all bindings): `space`

split window horizontally: `[|, %]`

split window vertically: `[\, "]`

new window (keep current path): `c`

fuzzy session switcher: `f`

project/session picker: `alt + s`

workmux menu: `alt + w`

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

workmux toggle sidebar: `ctrl + a`

workmux dashboard: `ctrl + d`

clear workmux status: `S`

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

## Workmux and project picker

The scripts live beside `tmux.conf`. With this repo symlinked to
`~/.config/tmux`, no additional script symlinks are needed. Dependencies:
`workmux`, `git`, `fzf`, and `fd`.

The Workmux menu uses `workmux.yaml` to create one window in the current
session, starting with one shell pane. Split it using your normal bindings.
This layout applies to menu actions, not direct `workmux` shell commands.
Prompt-based creation also needs Workmux's LLM/agent setup.

Menu keys: `a` add, `b` add from a local branch, `p` add from a prompt,
`o` open, `r` remove, `c` close, `d` dashboard, `s` sidebar, `q` quit.
Close retains the worktree and branch. Remove deletes the worktree and local
branch without merging, using Workmux's confirmation.

The project picker lists existing sessions and Git repositories under
`~/workspace`, up to five directory levels deep. Override this with the
`TMUX_SESSIONIZER_PATHS` environment variable (newline-separated roots,
optionally ending in `:depth`) and `TMUX_SESSIONIZER_DEPTH` (default `1`
for roots without an explicit depth). Unlike Workmux, selecting a project
creates or switches to a session. Canceling the picker does nothing.
Results stream into the picker immediately. Discovery searches for `.git`
directories and worktree `.git` files, including ignored locations, instead
of checking every source directory with Git.

The status bar shows the active pane's Git branch, local ahead/behind counts,
stashes, conflicts, and staged/unstaged/untracked counts every five seconds.
It keeps the clock/calendar and is reapplied when the theme changes.

Reload with `prefix + r` after changing the configuration. For `alt + w` and
`alt + s`, press and release the prefix, then press Alt with the letter.

