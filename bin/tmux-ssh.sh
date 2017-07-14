#!/bin/bash

ssh_command=$(ps -t "$(tmux display -p '#{pane_tty}')" -o command= | awk '/^ssh/')
read -ra parsed_data < <(echo "$ssh_command" | perl -pe 's|^ssh\s(-l\s)?(\w+)@?\s?([[:alnum:][:punct:]]+).*$|\2 \3|g')
username="${parsed_data[0]}"
hostname="${parsed_data[1]}"

if [[ -n $hostname && -n $username ]]; then
    echo "#[fg=colour231, bg=colour24] ⛓ $username@$hostname #[fg=colour33, bg=colour24]◀"
else
    echo ""
fi