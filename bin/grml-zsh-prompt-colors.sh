#!/bin/bash
if [[ $(hostname) == "main" ]]; then
    zstyle ':prompt:grml:left:items:user' pre '%B%F{blue}'
    zstyle ':prompt:grml:left:items:at' pre '%F{white}'
    zstyle ':prompt:grml:left:items:host' pre '%F{cyan}'
    zstyle ':prompt:grml:left:items:path' pre '%B%F{cyan}'
elif [[ $(hostname) == "nas" ]]; then
    zstyle ':prompt:grml:left:items:user' pre '%B%F{green}'
    zstyle ':prompt:grml:left:items:at' pre '%F{green}'
    zstyle ':prompt:grml:left:items:host' pre '%F{red}'
    zstyle ':prompt:grml:left:items:path' pre '%B%F{blue}'
elif [[ $(hostname) == "ha" ]]; then
    zstyle ':prompt:grml:left:items:user' pre '%F{green}'
    zstyle ':prompt:grml:left:items:at' pre '%B%F{blue}'
    zstyle ':prompt:grml:left:items:host' pre '%B%F{green}'
    zstyle ':prompt:grml:left:items:path' pre '%b%F{green}'
elif [[ $(hostname) == "gateway" ]]; then
    zstyle ':prompt:grml:left:items:user' pre '%B%F{yellow}'
    zstyle ':prompt:grml:left:items:at' pre '%F{white}'
    zstyle ':prompt:grml:left:items:host' pre '%B%F{green}'
    zstyle ':prompt:grml:left:items:path' pre '%B%F{red}'
elif [[ $(hostname) == "stalux" ]]; then
    zstyle ':prompt:grml:left:items:user' pre '%B%F{blue}'
    zstyle ':prompt:grml:left:items:at' pre '%B%F{blue}'
    zstyle ':prompt:grml:left:items:host' pre '%F{blue}'
    zstyle ':prompt:grml:left:items:path' pre '%F{green}'
fi
