#!/bin/sh

# Name of the dedicated session for the popup
SESSION_NAME="scratchpad"

# Get the ID of the current window client
CURRENT_CLIENT_ID=$(tmux display-message -p -F "#{client_id}")

# Check if the scratchpad session is *already attached* to the current client
# by checking for the session name on the current client.
if tmux display-message -p -F "#{session_name}" | grep -q "^$SESSION_NAME$"; then
    # 1. If we ARE attached (i.e., the popup is open), DETACH the client.
    tmux detach-client -s "$SESSION_NAME"
else
    # 2. If we are NOT attached (i.e., the popup is closed), OPEN/ATTACH the client.
    # The 'tmux new-session -A -s $SESSION_NAME' part handles creating the session
    # only if it doesn't already exist.
    tmux display-popup \
        -d '#{pane_current_path}' \
        -w 80% -h 80% -x C -y C \
        -E "tmux attach-session -t $SESSION_NAME || tmux new-session -s $SESSION_NAME"
fi
