#!/bin/bash
shopt -s extglob # BASH Extended Globbing

git pull origin master
git submodule init
git submodule update

read -rn1 -p "WARNING: Write config files under: $HOME/ (y/N): "
[[ ! $REPLY =~ ^[Yy]$ ]] && exit 0; echo

# Set zsh as default shell
chsh -s "$(which zsh)"

# Link dotfiles to ~
for file in "$PWD"/.!(|.|git*); do ln -sfv "$file" ~; done

read -rn1 -p "Install Vim plugins? (Y/n): "
[[ $REPLY =~ ^[Nn]$ ]] && exit 0; echo

echo "Updating/cleaning Vim plugins:"
vim -E -s <<-EOF
    :source ~/.vimrc
    :PlugInstall
    :PlugClean
    :qa
EOF
