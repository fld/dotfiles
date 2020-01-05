#!/bin/bash
shopt -s extglob # BASH Extended Globbing

dotrepo='https://github.com/fld/dotfiles'
gw_host_default='gateway'

# Sudo check
# TODO: support no-sudo
if ! sudo -v; then
    echo "Adding $USER to sudoers via su:"
    su -c "usermod -aG sudo $USER"
    echo "Joining sudo group.. Please re-run ./install.sh"
    newgrp sudo
fi

# Check if apt-cacher-ng is available at gateways port 3142
gw_host="$(ip route show default | grep -m1 "default via" | cut -d ' '  -f3)"
gw_host=${gw_host:-$gw_host_default}
if ping -c 1 "$gw_host" &> /dev/null; then
    type nc &> /dev/null || sudo apt install nc
    timeout 1 nc "$gw_host" 3142 &> /dev/null
    if [[ $? -eq 124 ]]; then
        if [[ -f /etc/apt/apt.conf.d/000apt-cacher-ng-proxy ]]; then
            echo "Installing 000apt-cacher-ng-proxy.."
            sudo cp ~/dotfiles/etc/apt/apt.conf.d/000apt-cacher-ng-proxy "/etc/apt/apt.conf.d/000apt-cacher-ng-proxy"
        fi
    fi
fi

# Install needed packages via apt
# TODO: list what the system has
sudo apt install zsh tmux screen git vim curl wget sed gawk grep \
    autojump exuberant-ctags urlview

# Get latest dotfiles
[[ -d ~/dotfiles ]] || git clone "$dotrepo"
cd ~/dotfiles || exit 1
echo "Pulling latest origin/master..."
git pull origin master;echo

# Ask to install mysources.list as sources.list (if wordcount-Δ >20)
slwc=$(wc -w /etc/apt/sources.list | cut -d' ' -f1)
mslwc=$(wc -w ~/dotfiles/etc/apt/sources.list.d/mysources.list | cut -d' ' -f1)
msldst='/etc/apt/sources.list' #msldst='/etc/apt/sources.list.d/mysources.list'
if [[ $(( slwc - mslwc )) -gt 20 || $(( mslwc - slwc )) -gt 20 ]]; then
    read -rn1 -p $'Install mysources.list to '"$msldst"$' ?\n'
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo cp "$msldst" "${msldst}.bak" &&
        sudo cp ~/dotfiles/etc/apt/sources.list.d/mysources.list "$msldst" &&
        sudo vim "$msldst"
        sudo apt update
    fi
fi

# Install dotfiles
echo "Installing dotfiles:"
for file in "$PWD"/.!(|.|git*); do echo "$file"; done; echo
read -rn1 -p $'WARNING: Write config files under: '"$HOME"$'/ (y/N):\n'
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ -e ~/.vim && ! -L ~/.vim ]]; then
        echo "NOTE: moving old ~/.vim to ~/.vim.old"
        mv ~/.vim ~/.vim.old
    fi
    for file in "$PWD"/.!(|.|git*); do ln -sf "$file" ~; done
fi

# Install vim-plug
read -rn1 -p $'Install Vim plugins? (Y/n):\n'
[[ $REPLY =~ ^[Nn]$ ]] && exec zsh

echo "Updating/cleaning Vim plugins:"
vim -E -s <<-EOF
    :source ~/.vimrc
    :PlugInstall
    :PlugClean
    :qa
EOF
reset

# Change default shell
echo -e "\\nSetting zsh as default shell.."
chsh -s "$(command -v zsh)"
exec zsh
