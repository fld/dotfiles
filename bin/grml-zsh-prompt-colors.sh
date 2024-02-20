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
    zstyle ':prompt:grml:left:items:path' pre '%F{gray}'
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
elif [[ $(hostname) == "rami" ]]; then
    zstyle ':prompt:grml:left:items:user' pre '%B%F{red}'
    zstyle ':prompt:grml:left:items:host' pre '%F{red}'
    zstyle ':prompt:grml:left:items:path' pre '%F{green}'
elif [[ $(hostname) == "acer" ]]; then
    zstyle ':prompt:grml:left:items:user' pre '%B%F{black}'
elif [[ $(hostname) =~ "rpi" ]]; then
    zstyle ':prompt:grml:left:items:user' pre '%F{red}'
    zstyle ':prompt:grml:left:items:host' pre '%F{green}'
elif [[ $(hostname) =~ "op5" ]]; then 
    zstyle ':prompt:grml:left:items:user' pre '%B%F{yellow}'
    zstyle ':prompt:grml:left:items:host' pre '%F{yellow}'
elif [[ $(hostname) == "stalux" ]]; then
    zstyle ':prompt:grml:left:items:user' pre '%B%F{blue}'
    zstyle ':prompt:grml:left:items:at' pre '%B%F{blue}'
    zstyle ':prompt:grml:left:items:host' pre '%F{blue}'
    zstyle ':prompt:grml:left:items:path' pre '%F{green}'
elif [[ -e '/etc/debian_chroot' ]]; then
    zstyle ':prompt:grml:left:items:host' pre '%F{blue}'
    zstyle ':prompt:grml:left:items:at' pre '%B%F{blue}'
fi
