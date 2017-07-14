#!/bin/bash
shopt -s extglob # BASH Extended Globbing

packages="zsh tmux git vim curl wget autojump \\
    ctags-exuberant fonts-powerline urlview"

if ! type "$packages" &>/dev/null; then
    sudo apt install "$packages"
fi

cd ~/dotfiles || exit
echo "Pulling latest master..."
git pull origin master;echo

echo "dotfiles:"
for file in "$PWD"/.!(|.|git*); do echo "$file"; done; echo
read -rn1 -p $'WARNING: Write config files under: '"$HOME"$'/ (y/N):\n'
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ ! -L ~/.vim ]]; then
        echo "NOTE: moving old ~/.vim to ~/.vim.old"
        mv ~/.vim ~/.vim.old
    fi
    for file in "$PWD"/.!(|.|git*); do ln -sf "$file" ~; done
fi

echo -e "\\nSetting zsh as default shell.."
chsh -s "$(which zsh)"

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

exec zsh
