#!/bin/bash
if [[ $(hostname) == "nas" ]]; then
    #grml_prompt_pre_default[user]='%B%F{green}'
    #grml_prompt_pre_default[at]='%F{green}'
    #grml_prompt_pre_default[host]='%F{red}'
    #grml_prompt_pre_default[path]='%B%F{blue}'
    zstyle ':prompt:grml:left:items:user' pre '%B%F{green}'
    zstyle ':prompt:grml:left:items:at' pre '%F{green}'
    zstyle ':prompt:grml:left:items:host' pre '%F{red}'
    zstyle ':prompt:grml:left:items:path' pre '%B%F{blue}'
elif [[ $(hostname) == "ha" ]]; then
    #grml_prompt_pre_default[user]='%F{green}'
    #grml_prompt_pre_default[at]='%B%F{blue}'
    #grml_prompt_pre_default[host]='%F{green}'
    #grml_prompt_pre_default[path]='%B%F{blue}'
    zstyle ':prompt:grml:left:items:user' pre '%F{green}'
    zstyle ':prompt:grml:left:items:at' pre '%B%F{blue}'
    zstyle ':prompt:grml:left:items:host' pre '%F{green}'
    zstyle ':prompt:grml:left:items:path' pre '%B%F{blue}'
elif [[ $(hostname) == "gateway" ]]; then
    #grml_prompt_pre_default[user]='%B%F{yellow}'
    #grml_prompt_pre_default[at]='%F{white}'
    #grml_prompt_pre_default[host]='%B%F{green}'
    #grml_prompt_pre_default[path]='%B%F{red}'
    zstyle ':prompt:grml:left:items:user' pre '%B%F{yellow}'
    zstyle ':prompt:grml:left:items:at' pre '%F{white}'
    zstyle ':prompt:grml:left:items:host' pre '%B%F{green}'
    zstyle ':prompt:grml:left:items:path' pre '%B%F{red}'
fi
