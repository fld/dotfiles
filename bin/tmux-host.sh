#!/bin/bash
if [ "$(hostname -s)" = "main" ]; then
    echo "#[fg=colour234, bg=colour33] ⛃ $(hostname -s) #[fg=colour27, bg=colour33]$(updays.sh)d"
else
    echo "#[fg=colour234, bg=colour76] ⛃ $(hostname -s) #[fg=colour64, bg=colour76]$(updays.sh)d"
fi
