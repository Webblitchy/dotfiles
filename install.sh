#!/bin/bash

cd ~/.dotfiles

# Install packages
#sudo pacman -Syu --noconfirm paru
#cat packages.lst | xargs paru -Syu --needed --noconfirm

# Copy config files (add links)
cd home
for file in .*; do 
    if [[ "$file" == "." ]] || [[ "$file" == ".." ]]; then
        continue
    fi
    ln -sf ~/.dotfiles/home/$file ~/$file
done
cd ..

for dotDir in */; do
    if [[ "$dotDir" == "home/" ]]; then
        continue
    fi
    for dir in $dotDir*; do
        if [[ -d $dir ]]; then
            dir=$dir/
        fi
        #ln -sf ~/.dotfiles/dotconfig/$dir/ ~/.config/$dir
        unescapedDir=$(echo $dir | sed "s/dot/./g" | sed "s/_/\//g")
        ln -sf ~/.dotfiles/$dir ~/$unescapedDir
    done
done

# Configure wireshark
# TODO: sudo chmod +x /usr/bin/dumpcap

# Copy specifc settings
sudo ln -sf ~/.dotfiles/logid.cfg /etc/logid.cfg # to make MXMaster3 works

# libinput gestures
#sudo gpasswd -a $USER input
#libinput-gestures-setup autostart start

# vim commands
mkdir ~/.vim/undodir 2>/dev/null
# vim add ~/.vim/coc-settings.json and fzf-theme
