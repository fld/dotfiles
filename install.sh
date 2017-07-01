#!/bin/bash
shopt -s extglob # BASH Extended Globbing

read -rn1 -p 'git pull origin master? (Y/n): '
[[ ! $REPLY =~ ^[Nn]$ ]] && git pull origin master; echo

read -rn1 -p "WARNING: Overwrite config files under: $HOME/ (y/N): "
[[ ! $REPLY =~ ^[Yy]$ ]] && exit 0; echo

# Set zsh as default shell
chsh -s "$(which zsh)"

# Link dotfiles to ~
for file in "$PWD"/.!(|.|git); do ln -sfv "$file" ~; done

echo "Updating/cleaning Vim plugins:"
vim -E -s <<-EOF
    :source ~/.vimrc
    :PlugInstall
    :PlugClean
    :qa
EOF