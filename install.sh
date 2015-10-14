#!/bin/bash
shopt -s extglob

git pull origin master

echo $PWD
read -rn1 -p 'WARNING: Overwrite config files in: ~ (y/N): '
[[ ! $REPLY =~ ^[Yy]$ ]] && exit 0; echo

#ln -sfv ~/dotfiles/.zshrc ~
#ln -sfv ~/dotfiles/.zshrc.local ~
#thats enough of that...
for file in "$PWD"/.!(|.|git); do ln -sfv "$file" ~; done
