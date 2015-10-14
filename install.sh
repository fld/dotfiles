#!/bin/bash
shopt -s extglob

read -rn1 -p 'pull origin master? (Y/n): '
[[ ! $REPLY =~ ^[Nn]$ ]] && git pull origin master; echo

read -rn1 -p "WARNING: Overwrite config files in: $HOME/ (y/N): "
[[ ! $REPLY =~ ^[Yy]$ ]] && exit 0; echo

#ln -sfv ~/dotfiles/.zshrc ~
#ln -sfv ~/dotfiles/.zshrc.local ~
#that's enough of that...

for file in "$PWD"/.!(|.|git); do ln -sfv "$file" ~; done
