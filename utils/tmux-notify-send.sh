#!/bin/bash

# Get the command that just finished from tmux
finished_command=$(tmux display-message -p '#{pane_current_command}')

# Customize the notification message
message="Tmux: $finished_command finished"

# Send the notification (replace 'icon_name' if needed)
notify-send -u normal -i terminal -t 2000 "$message"

