#!/bin/bash
shopt -s extglob # BASH Extended Globbing

dotrepo='https://github.com/fld/dotfiles'

# Check&install if apt-cacher-ng is available at gateway:3142
if ping -c 1 gateway &> /dev/null; then
    type nc || sudo apt install nc
    timeout 1 nc gateway 3142 &> /dev/null
    if [[ $? -eq 124 ]]; then
        [[ -f /etc/apt/apt.conf.d/000apt-cacher-ng-proxy ]] ||
            sudo cp ~/dotfiles/etc/apt/apt.conf.d/000apt-cacher-ng-proxy "/etc/apt/apt.conf.d/000apt-cacher-ng-proxy"
    fi
fi

# Install needed packages via apt & sudo
sudo apt install zsh tmux screen git vim curl wget sed gawk grep \
    autojump exuberant-ctags urlview

# Get latest dotfiles
[[ -d ~/dotfiles ]] || git clone "$dotrepo"
cd ~/dotfiles || exit 1
echo "Pulling latest origin/master..."
git pull origin master;echo

# Install mysources.list via sudo
slwc=$(wc -w /etc/apt/sources.list | cut -d' ' -f1) # Wordcounts compared
mslwc=$(wc -w ~/dotfiles/etc/apt/sources.list.d/mysources.list | cut -d' ' -f1)
msldst='/etc/apt/sources.list' #msldst='/etc/apt/sources.list.d/mysources.list'
if [[ $(( slwc - mslwc )) -gt 20 || $(( mslwc - slwc )) -gt 20 ]]; then
    read -rn1 -p $'Install mysources.list to '"$msldst"$' ?\n'
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo cp "$msldst" "${msldst}.bak"
        sudo cp ~/dotfiles/etc/apt/sources.list.d/mysources.list "$msldst"
        sudo vim "$msldst"
        sudo apt update
    fi
fi

# Install dotfiles
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

# Change default shell
echo -e "\\nSetting zsh as default shell.."
chsh -s "$(which zsh)"

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

exec zsh
