#emulate sh
#. ~/.profile
#emulate zsh

# Auto log-off for tty's
[[ $(tty) =~ "/dev/tty" ]] && TMOUT=3600

# launch archey or screenfetch after startup login
if [[ $(uptime) =~ "min" ]]; then
    if type screenfetch >/dev/null 2>&1; then screenfetch;
    elif type archey >/dev/null 2>&1; then archey; fi
fi
