# AGENTS.md

## What this repo is

A personal tmux configuration (dotfiles-style repo), not a compiled/tested software project. There is no build system, no test suite, no linter, and no package manifest. The repo consists of:

- `tmux.conf` — the main tmux configuration file (options, key bindings, plugin declarations).
- `tmux-scratchpad-toggle.sh` — toggles a popup "scratchpad" tmux session, bound to `C-t`.
- `tmux-shell-cmd` — broadcasts a shell command to every pane in every tmux session/window (used for things like restarting a dev server everywhere).
- `tmux-zoxide.sh` — a `t` script for jumping to/creating tmux sessions via zoxide + fzf, meant to be symlinked to `~/.local/bin/t`.
- `README.md` — human-facing docs, mainly a key-binding cheat sheet. **Keep it in sync whenever a binding is added, changed, or removed in `tmux.conf`.**
- `plugins/` — third-party tmux plugins cloned by the plugin manager (see below). **This directory is gitignored (`.gitignore` has `plugins/`) and must never be committed to.** It exists locally but is not part of this repo's tracked history.

## How the config is actually loaded

- The live tmux config lives at `${HOME}/.config/tmux/tmux.conf`. `tmux.conf` in this repo is presumably symlinked there (check before assuming edits take effect — there's no symlink-creation logic in this repo itself).
- Reload binding: `prefix + r` runs `source-file ${HOME}/.config/tmux/tmux.conf` — i.e. it reloads from the **symlink target**, not from wherever this repo happens to be checked out, so edits must land in the linked file.
- Plugin manager: **`tpack`** (a tpm-compatible fork; `tpm` is also present in `plugins/` but `tpack` is the one referenced at the bottom of `tmux.conf`: `run '${HOME}/.config/tmux/plugins/tpm/tpm'`). Note the path says `tpm` even though the declared plugin is `tmuxpack/tpack` — this is intentional/expected for tpack's tpm-compatible install layout, not a bug to "fix".
- Plugins are declared via `set -g @plugin '...'` lines and installed/updated interactively inside tmux (prefix + `I` to install, prefix + `U` to update — standard tpm/tpack key bindings, not defined in this file). Do not attempt to install plugins by running shell commands against `plugins/` directly; that directory's contents are managed by the plugin manager at runtime.
- Several plugins are commented out (`# set -g @plugin ...`) — these represent deliberately disabled options, not stale cruft. Don't delete commented-out plugin/config lines when editing; they document past experimentation and easy re-enable paths (see git history — many commits are exactly toggling these).

## Key structural conventions in `tmux.conf`

- Prefix is remapped from default `C-b` to `C-Space`.
- Sections are separated by comment headers (e.g. `# Plugins section`). New plugins go in the plugins block near the bottom; new key bindings/options go near related existing bindings, not appended at the end.
- Every custom key binding should have a `-N 'Description'` annotation where practical (used by `tmux-which-key` for popup labels) — follow this pattern for new bindings, e.g.:
  ```
  bind -r -N 'Split window horizontally' '|' split-window -h -c "#{pane_current_path}"
  ```
- Plugin-specific options (`set -g @plugin_option ...`) are grouped directly below/above the corresponding `set -g @plugin '...'` line, not in a separate global options block.
- Theme switching is handled via `client-dark-theme` / `client-light-theme` hooks that both set `@theme_variant` and re-run `plugins/vanzi/vanzi-theme.tmux`. If adding new themeable options, wire them through this hook pattern rather than a one-off `if-shell`.
- All absolute paths inside `tmux.conf` use `${HOME}` (not a literal home path, and not bare `~`) for portability — e.g. `run-shell '${HOME}/.local/bin/tmux-scratchpad-toggle.sh'`. Follow this convention for any new path added to the config; don't hardcode a username's home directory or introduce bare `~` in new lines.

## Shell scripts

- All are POSIX/bash scripts with no build step; edit and use directly (`chmod +x` if permissions are lost).
- `tmux-shell-cmd` supports `--kill` to kill any foreground child process (e.g. nvim, docker compose) in every pane before sending the new command, and requires interactive `y` confirmation unless `AUTO_KILL=1` is set. It assumes vi-mode keybindings in every pane shell (sends `C-[` then `i` implicitly via escape-then-command — see comments in the script) — this is intentional for vi-mode shells and not a bug.
- `tmux-zoxide.sh` behaves differently depending on whether it's invoked from inside or outside an active tmux client (`$TMUX` env var check) — when outside tmux it uses `fzf`, when inside it uses `fzf-tmux -p`. Preserve this branching if modifying.
- Session names derived from directory basenames have spaces and dots replaced with underscores (`tr ' ' '_' | tr '.' '_'`) since tmux session names can't contain those characters reliably.

## Testing / verification

There are no automated tests. To verify changes:
- Syntax-check `tmux.conf` without affecting a running session: `tmux -f tmux.conf -L test-socket new-session -d && tmux -L test-socket kill-server` (or similar) — there's no existing script for this, but it's the standard tmux way to validate config syntax.
- Shell scripts can be checked with `bash -n <script>` for syntax and, if available, `shellcheck <script>` for lint (not currently run in CI — there is no CI in this repo).
- For live testing, reload with prefix + `r` inside an actual tmux session and observe the "Reloaded!" message / behavior.

## Git conventions

Commit messages follow Conventional Commits style seen in `git log`, e.g. `feat(tmux): add which-key plugin`, `fix(tmux): correct tpm initialization path`, `chore(tmux): ...`, `docs(tmux): ...`. Scope is almost always `(tmux)`. Follow this style for new commits.
