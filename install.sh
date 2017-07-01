#!/bin/bash
shopt -s extglob # BASH Extended Globbing

if ! type zsh tmux git vim &>/dev/null; then
    echo "sudo apt-get install zsh tmux git vim"
    exit 1
fi

echo "Updating repos..."
git pull origin master
git submodule init
git submodule update
echo

echo "dotfiles found:"
for file in "$PWD"/.!(|.|git*); do echo "$file"; done
read -rn1 -p "WARNING: Write config files under: $HOME/ (y/N): "
[[ ! $REPLY =~ ^[Yy]$ ]] && exit 0; echo
mv -i ~/.vim ~/.vim.old
for file in "$PWD"/.!(|.|git*); do ln -sfv "$file" ~; done

echo "Setting zsh as default."
chsh -s "$(which zsh)"

read -rn1 -p "Install Vim plugins? (Y/n): "
[[ $REPLY =~ ^[Nn]$ ]] && exit 0; echo

echo "Updating/cleaning Vim plugins:"
vim -E -s <<-EOF
    :source ~/.vimrc
    :PlugInstall
    :PlugClean
    :qa
EOF
reset
zsh
