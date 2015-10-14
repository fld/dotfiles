#emulate sh
#. ~/.profile
#emulate zsh

# launch archey or screenfetch if found
if type screenfetch > /dev/null 2>&1; then screenfetch;
elif type archey > /dev/null 2>&1; then archey; fi
