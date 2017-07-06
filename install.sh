#!/bin/bash
shopt -s extglob # BASH Extended Globbing

if ! type zsh tmux git vim curl autojump &>/dev/null; then
    sudo apt-get install zsh tmux git vim curl autojump
fi

cd ~/dotfiles
echo "Pulling latest master..."
git pull origin master;echo

echo "dotfiles:"
for file in "$PWD"/.!(|.|git*); do echo "$file"; done
read -rn1 -p $'WARNING: Write config files under: '"$HOME"$'/ (y/N):\n'
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ ! -L ~/.vim ]]; then
        echo "NOTE: moving old ~/.vim to ~/.vim.old"
        mv ~/.vim ~/.vim.old
    fi
    for file in "$PWD"/.!(|.|git*); do ln -sfv "$file" ~; done
fi

echo -e "\nSetting zsh as default.."
chsh -s "$(which zsh)"

read -rn1 -p $'Install Vim plugins? (Y/n):\n'
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo "Updating/cleaning Vim plugins:"
    vim -E -s <<-EOF
        :source ~/.vimrc
        :PlugInstall
        :PlugClean
        :qa
    EOF
    reset
fi

exec zsh
