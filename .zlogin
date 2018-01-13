#emulate sh
#. ~/.profile
#emulate zsh

# launch archey or screenfetch if found
if type screenfetch timeout >/dev/null 2>&1; then timeout 1.5 screenfetch;
elif type archey timeout >/dev/null 2>&1; then timeout 1.5 archey; fi
