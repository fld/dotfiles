#!/bin/bash
shopt -s extglob # BASH Extended Globbing

if ! type zsh tmux git vim curl &>/dev/null; then
    sudo apt-get install zsh tmux git vim curl
fi

echo "Pulling latest master..."
git pull origin master
echo

echo "dotfiles:"
for file in "$PWD"/.!(|.|git*); do echo "$file"; done
read -rn1 -p "WARNING: Write config files under: $HOME/ (y/N): "
[[ ! $REPLY =~ ^[Yy]$ ]] && exit 0; echo
echo "moving old .vim/ to .vim.old/"
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
exec zsh
